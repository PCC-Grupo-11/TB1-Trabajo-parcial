/* MODELO INICIAL - PROMELA */
// IMPORTANTE: SOLO MODELA LA CONCURRENCIA
// DIVIDE LA CONCURRENCIA EN DOS FASES:
    // Reader() y Workers() trabajando en simultaneo
    // Detectores concurrentes trabajando en simultaneo

/* CONSTANTES GLOBALES */
#define N_WORKERS 3
#define N_RECORDS 1000000
#define N_BUFFER 80

/* CANALES */
/*
    records guarda:
    { user , target , type , text }
*/
chan records = [N_RECORDS] of { int,int,int,int };

/* canal para finalizar workers */
chan done = [N_WORKERS] of { int };

/* canales de deteccion */
chan usersCh   = [1] of { int };
chan targetsCh = [1] of { int };
chan pairsCh   = [1] of { int };
chan typesCh   = [1] of { int };
chan textsCh   = [1] of { int };

/* RECURSOS COMPARTIDOS */

/* simulacion de mutex */
bool mutex = false;

/* contadores globales */
int UserConts[3];
int TargetConts[3];
int PairConts[3];
int TypeConts[3];
int TextConts[3];

/* READER */
//Simula lectura concurrente del CSV

proctype Reader() {

    int i = 0;

    do
    :: i < N_BUFFER ->

        // Generar numeros aleatorios que simulan datos
        /*
            Simulacion de datos:

            user  -> 0 a 9
            target -> 0 a 13
            type -> 0 a 16
            text -> 0 a 20
        */

        records!
            (i % 10),
            (i % 14),
            (i % 17),
            (i % 21);
        i++

    :: else ->
        break
    od;

    /* flag de finalizacion */
    i = 0;

    // Generar N_WORKERS señales de finalizacion
    //  hace saber a cada worker cuando ya finalizó el Reader
    do
    :: i < N_WORKERS ->

        /*
            -1 significa:
            "ya no hay mas registros"
        */

        records!-1,-1,-1,-1;
        i++

    :: else ->
        break
    od
}

/* WORKER POOL */
proctype Worker(byte id) {

    int userKey;
    int targetKey;
    int typeKey;
    int textKey;

    do
    :: records?userKey,targetKey,typeKey,textKey ->

        /* Revisar flag de finalizacion */
        if
        :: userKey == -1 ->
            // si detecta una señal de fin, el worker finaliza
            break

        :: else ->

            atomic {

                /* entrada seccion critica */
                mutex == false ->
                mutex = true;

                /* REGLAS DE DETECCION DE ANOMALIAS */
                // Son condiciones que simulan la detección de un dato anómalo.

                // Si user = 0 -> aumenta UserConts
                if
                :: userKey == 0 ->
                    UserConts[0]++
                :: else ->
                    skip
                fi;

                // Si target = 0 -> aumenta TargetConts
                if
                :: targetKey == 0 ->
                    TargetConts[0]++
                :: else ->
                    skip
                fi;

                // Si user == target -> aumenta PairConts 
                if
                :: userKey == targetKey ->
                    PairConts[0]++
                :: else ->
                    skip
                fi;

                // Si type = 0 -> aumenta TypeConts
                if
                :: typeKey == 0 ->
                    TypeConts[0]++
                :: else ->
                    skip
                fi;

                // Si text = 0 -> aumenta TextConts
                if
                :: textKey == 0 ->
                    TextConts[0]++
                :: else ->
                    skip
                fi;

                /* salida seccion critica */
                mutex = false;
            }
        fi
    od;

    done!id
}

/* DETECTORES CONCURRENTES */
proctype DetectUsers() {

    int anomalous = 0;

    if
    :: UserConts[0] > 1 ->
        anomalous = 1
    :: else ->
        skip
    fi;

    usersCh!anomalous
}

proctype DetectTargets() {

    int anomalous = 0;

    if
    :: TargetConts[0] > 1 ->
        anomalous = 1
    :: else ->
        skip
    fi;

    targetsCh!anomalous
}

proctype DetectPairs() {

    int anomalous = 0;

    if
    :: PairConts[0] > 1 ->
        anomalous = 1
    :: else ->
        skip
    fi;

    pairsCh!anomalous
}

proctype DetectTypes() {

    int anomalous = 0;

    if
    :: TypeConts[0] > 1 ->
        anomalous = 1
    :: else ->
        skip
    fi;

    typesCh!anomalous
}

proctype DetectTexts() {

    int anomalous = 0;

    if
    :: TextConts[0] > 1 ->
        anomalous = 1
    :: else ->
        skip
    fi;

    textsCh!anomalous
}

/* ========================= */
/* AGGREGATOR                */
/* ========================= */

proctype Aggregator() {

    int us;
    int ta;
    int pa;
    int ty;
    int tx;

    usersCh?us;
    targetsCh?ta;
    pairsCh?pa;
    typesCh?ty;
    textsCh?tx;

    /*
        Aquí podrían:
        - imprimirse resultados
        - guardarse
        - calcular métricas
        - etc.
    */
}

/* INIT */
init {

    byte i = 0;

    /* Reader */
    run Reader();

    /* Worker Pool */
    do
    :: i < N_WORKERS ->
        run Worker(i);
        i++
    :: else ->
        break
    od;

    /* esperar finalizacion */
    byte j = 0;
    byte k;

    do
    :: j < N_WORKERS ->

        done?k;
        j++

    :: else ->
        break
    od;

    /* detecciones concurrentes */
    run DetectUsers();
    run DetectTargets();
    run DetectPairs();
    run DetectTypes();
    run DetectTexts();

    /* agregador */
    run Aggregator();
}