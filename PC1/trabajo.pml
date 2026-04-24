/* Valores fijos (reducidos para verificacion formal en Spin) */
#define N_WORKERS 2
#define N_SHARDS  2
#define MAX_JOBS  4

/* Buffers compactos para reducir espacio de estados en Spin */
#define JOBS_CAP  N_WORKERS
#define RES_CAP   N_WORKERS
#define RPC_CAP   1

/* Dominios discretos para estado por clave (abstraccion del modelo) */
#define USER_KEYS 2
#define HASH_KEYS 2

/* Sentinela de cierre en canal jobs */
#define END_USER -1
#define END_HASH -1

/* Reader -> Workers: {user_id, msg_hash} */
chan jobs = [JOBS_CAP] of { short, short };

/* Workers -> Aggregator: {flag} */
chan results = [RES_CAP] of { byte };

/* Consultas a shards */
chan user_req[N_SHARDS]  = [RPC_CAP] of { byte, short };
chan hash_req[N_SHARDS]  = [RPC_CAP] of { byte, short };

/* Respuestas de shards */
/* user_resp: {reviews_6h, flagged_6h} */
chan user_resp[N_SHARDS] = [RPC_CAP] of { byte, byte };
/* hash_resp: {count_6h} */
chan hash_resp[N_SHARDS] = [RPC_CAP] of { byte };

/* Aplicacion de updates */
chan user_apply[N_SHARDS] = [RPC_CAP] of { short, byte }; /* {user_id, flag} */
chan hash_apply[N_SHARDS] = [RPC_CAP] of { short };       /* {msg_hash} */

/* Senal de cierre para shards */
chan user_stop[N_SHARDS] = [N_WORKERS] of { byte };
chan hash_stop[N_SHARDS] = [N_WORKERS] of { byte };

/* Reader: genera jobs y luego envia sentinelas para terminar workers */
proctype Reader() {
    short i = 0;
    do
    :: i < MAX_JOBS ->
        jobs!i, (i % HASH_KEYS);
        i++
    :: else -> break
    od;

    i = 0;
    do
    :: i < N_WORKERS ->
        jobs!END_USER, END_HASH;
        i++
    :: else -> break
    od
}

/* UserShard: owner del estado por usuario (por shard) */
proctype UserShard(byte id) {
    short user_id;
    byte worker;
    byte stop_count = 0;
    byte key;
    byte flag;

    byte reviews_6h[USER_KEYS];
    byte flagged_6h[USER_KEYS];

    do
    :: user_req[id]?worker, user_id ->
        key = user_id % USER_KEYS;
        user_resp[id]!reviews_6h[key], flagged_6h[key]

    :: user_apply[id]?user_id, flag ->
        key = user_id % USER_KEYS;
        reviews_6h[key] = reviews_6h[key] + 1;
        if
        :: flag == 1 -> flagged_6h[key] = flagged_6h[key] + 1
        :: else -> skip
        fi

    :: user_stop[id]?worker ->
        stop_count++;
        if
        :: stop_count == N_WORKERS -> break
        :: else -> skip
        fi
    od
}

/* HashShard: owner del estado por hash (por shard) */
proctype HashShard(byte id) {
    short hash;
    byte worker;
    byte stop_count = 0;
    byte key;

    byte count_6h[HASH_KEYS];

    do
    :: hash_req[id]?worker, hash ->
        key = hash % HASH_KEYS;
        hash_resp[id]!count_6h[key]

    :: hash_apply[id]?hash ->
        key = hash % HASH_KEYS;
        count_6h[key] = count_6h[key] + 1

    :: hash_stop[id]?worker ->
        stop_count++;
        if
        :: stop_count == N_WORKERS -> break
        :: else -> skip
        fi
    od
}

/* DecisionWorker: consulta snapshot, decide y luego aplica updates */
proctype DecisionWorker(byte id) {
    short user_id;
    short hash;
    byte reviews;
    byte flagged;
    byte freq;
    byte shard_u;
    byte shard_h;
    byte flag;
    byte s;

    do
    :: jobs?user_id, hash ->
        if
        :: (user_id == END_USER && hash == END_HASH) ->
            s = 0;
            do
            :: s < N_SHARDS ->
                user_stop[s]!id;
                hash_stop[s]!id;
                s++
            :: else -> break
            od;
            break

        :: else ->
            shard_u = user_id % N_SHARDS;
            shard_h = hash % N_SHARDS;

            user_req[shard_u]!id, user_id;
            user_resp[shard_u]?reviews, flagged;

            hash_req[shard_h]!id, hash;
            hash_resp[shard_h]?freq;

            /* Regla simplificada: hash repetido o usuario muy activo+flaggeado */
            if
            :: (freq >= 2) -> flag = 1
            :: (reviews >= 2 && flagged >= 1) -> flag = 1
            :: else -> flag = 0
            fi;

            user_apply[shard_u]!user_id, flag;
            hash_apply[shard_h]!hash;

            results!flag
        fi
    od
}

/* Aggregator: consume exactamente MAX_JOBS resultados y valida invariante */
proctype Aggregator() {
    byte processed = 0;
    byte flagged = 0;
    byte f;

    do
    :: processed < MAX_JOBS ->
        results?f;
        processed++;
        flagged = flagged + f;
        assert(flagged <= processed)
    :: else -> break
    od;

    assert(processed == MAX_JOBS)
}

init {
    atomic {
        byte i = 0;

        run Reader();

        do
        :: i < N_WORKERS ->
            run DecisionWorker(i);
            i++
        :: else -> break
        od;

        i = 0;
        do
        :: i < N_SHARDS ->
            run UserShard(i);
            run HashShard(i);
            i++
        :: else -> break
        od;

        run Aggregator();
    }
}
