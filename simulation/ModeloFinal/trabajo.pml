/* MODELO PROMELA - DETECCION CONCURRENTE DE ANOMALIAS */

/* CONSTANTES GLOBALES */
#define N_WORKERS 2
#define N_BUFFER 10
#define END_FLAG 255
#define TAMANO 10

/* Umbrales de anomalía */
#define USER_THRESHOLD    1
#define TARGET_THRESHOLD  1
#define PAIR_THRESHOLD    1
#define TYPE_THRESHOLD    1
#define TEXT_THRESHOLD    1


/* CANALES */
/*
    records guarda:
    { user , target , type , text }
*/

chan records = [N_BUFFER] of { byte,byte,byte,byte };

/* Finalización workers */
chan done = [N_WORKERS] of { byte };

/* Canales de detección */
chan usersCh   = [TAMANO] of { byte };
chan targetsCh = [TAMANO] of { byte };
chan pairsCh   = [TAMANO] of { byte };
chan typesCh   = [TAMANO] of { byte };
chan textsCh   = [TAMANO] of { byte };


/* RECURSOS COMPARTIDOS */

/* Simulación mutex */
bool mutex = false;

/* Contadores globales */
byte UserConts[TAMANO];
byte TargetConts[TAMANO];
byte PairConts[TAMANO];
byte TypeConts[TAMANO];
byte TextConts[TAMANO];


/* READER */
// Simula lectura concurrente del CSV
proctype Reader() {

    byte i = 0;

    do
    :: i < N_BUFFER ->

        // Generar valores de simulacion para cada tipo de dato
        /*
            Datos simulados:

            user   -> [0, ... ,6]
            target -> [0, ... ,10]
            type   -> [0, ... ,15]
            text   -> [0, ... ,20]
        */

        records!
            (i % 2),
            (i % 4),
            (i % 6),
            (i % 8);

        i++

    :: else ->
        break
    od;

    /* Flag de finalización */
    i = 0;

    do
    :: i < N_WORKERS ->

        // Genera N_WORKERS señales de finalizacion
        // Una señal para cada worker. Indica a cada worker que ya acabó el Reader.
        // -1 significa: no hay más registros

        records!END_FLAG, END_FLAG, END_FLAG, END_FLAG;
        i++
    :: else ->
        break
    od
}


/* WORKER POOL */
proctype Worker(byte id) {

    byte userKey;
    byte targetKey;
    byte typeKey;
    byte textKey;
    byte pairIndex;

    do
    :: records?userKey,targetKey,typeKey,textKey ->

        /* Revisar señal de finalización */
        if
        :: userKey == END_FLAG ->
            // si se detecta la señal de fin, se cierra el worker
            break

        :: else ->
            atomic {
                /* Entrada sección crítica */
                mutex == false ->
                mutex = true;

                // Simulación de: map[string]int
                UserConts[userKey]++;
                TargetConts[targetKey]++;
                TypeConts[typeKey]++;
                TextConts[textKey]++;

                // Simulación pairKey(user,target)
                pairIndex = (userKey + targetKey) % TAMANO;
                PairConts[pairIndex]++;

                /* Salida sección crítica */
                mutex = false;
            }
        fi
    od;

    done!id
}


/* DETECTORES CONCURRENTES */

/*
    Cada detector:
    - recorre todos los índices
    - identifica anomalías
    - envía el índice anómalo
*/

/* DETECTOR - USERS */
proctype DetectUsers() {
    byte i = 0;
    do
    :: i < TAMANO ->
        // enviar los indices que superan el umbral de anomalias
        if
        :: UserConts[i] > USER_THRESHOLD ->
            usersCh!i
        :: else ->
            skip
        fi;
        i++

    :: else ->
        break
    od;

    /* flag - fin detección */
    usersCh!END_FLAG
}

/* DETECTOR - TARGETS */
proctype DetectTargets() {
    byte i = 0;
    do
    :: i < TAMANO ->
        // enviar los indices que superan el umbral de anomalias
        if
        :: TargetConts[i] > TARGET_THRESHOLD ->
            targetsCh!i
        :: else ->
            skip
        fi;
        i++
    :: else ->
        break
    od;
    targetsCh!END_FLAG // flag - fin de deteccion
}

/* DETECTOR - PAIRS */

proctype DetectPairs() {
    byte i = 0;
    do
    :: i < TAMANO ->
        // enviar los indices que superan el umbral de anomalias
        if
        :: PairConts[i] > PAIR_THRESHOLD ->
            pairsCh!i
        :: else ->
            skip
        fi;
        i++
    :: else ->
        break
    od;
    pairsCh!END_FLAG // flag - fin de deteccion
}

/* DETECTOR - TYPES */
proctype DetectTypes() {
    byte i = 0;
    do
    :: i < TAMANO ->
        // enviar los indices que superan el umbral de anomalias
        if
        :: TypeConts[i] > TYPE_THRESHOLD ->
            typesCh!i
        :: else ->
            skip
        fi;
        i++
    :: else ->
        break
    od;
    typesCh!END_FLAG // flag - fin de deteccion
}

/* DETECTOR - TEXTS */
proctype DetectTexts() {
    byte i = 0;
    do
    :: i < TAMANO ->
        // enviar los indices que superan el umbral de anomalias
        if
        :: TextConts[i] > TEXT_THRESHOLD ->
            textsCh!i
        :: else ->
            skip
        fi;
        i++
    :: else ->
        break
    od;
    textsCh!END_FLAG // flag - fin de deteccion
}


/* AGGREGATOR */

/*
    Recibe índices anómalos
    detectados por cada detector
*/
proctype Aggregator() {

    byte value;

    /* USERS */
    do
    :: usersCh?value ->
        if
        :: value == END_FLAG ->
            break // ya no hay mas registros en canal
        :: else ->
            printf("Anomalia USER detectada en indice: %d\n", value)
        fi
    od;

    /* TARGETS */
    do
    :: targetsCh?value ->
        if
        :: value == END_FLAG ->
            break // ya no hay mas registros en canal
        :: else ->
            printf("Anomalia TARGET detectada en indice: %d\n", value)
        fi
    od;

    /* PAIRS */
    do
    :: pairsCh?value ->
        if
        :: value == END_FLAG ->
            break // ya no hay mas registros en canal
        :: else ->
            printf("Anomalia PAIR detectada en indice: %d\n", value)
        fi
    od;

    /* TYPES */
    do
    :: typesCh?value ->
        if
        :: value == END_FLAG ->
            break // ya no hay mas registros en canal
        :: else ->
            printf("Anomalia TYPE detectada en indice: %d\n", value)
        fi
    od;

    /* TEXTS */
    do
    :: textsCh?value ->
        if
        :: value == END_FLAG ->
            break // ya no hay mas registros en canal
        :: else ->
            printf("Anomalia TEXT detectada en indice: %d\n", value)
        fi
    od
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

    /* Esperar workers */
    byte j = 0;
    byte k;

    do
    :: j < N_WORKERS ->
        done?k;
        j++
    :: else ->
        break
    od;

    /* Detectores concurrentes */
    run DetectUsers();
    run DetectTargets();
    run DetectPairs();
    run DetectTypes();
    run DetectTexts();

    /* Aggregator */
    run Aggregator();
}