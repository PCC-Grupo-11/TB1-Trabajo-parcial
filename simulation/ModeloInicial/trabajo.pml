/* MODELO INICIAL - PROMELA */
// IMPORTANTE: SOLO MODELA LA CONCURRENCIA
// DIVIDE LA CONCURRENCIA EN DOS FASES:
    // Reader() y Workers() trabajando en simultaneo (lectura y procesamiento)
    // Cuatro goroutines de deteccion de anomalías trabajando en simultaneo

// Constantes globales
#define N_WORKERS 3 // cant workers
#define MAX_RECORDS 50   // max tamaño buffer

// Canal buffer - guardar registrados leidos
chan records = [MAX_RECORDS] of { int,int,int };

// canal - finalizar workers
chan done = [N_WORKERS] of { int };

// Canal - resultados de deteccion de anomalias
chan usersCh   = [1] of { int };
chan targetsCh = [1] of { int };
chan pairsCh   = [1] of { int };
chan typesCh   = [1] of { int };

// RECURSOS GLOBALES COMPARTIDOS

bool mutex = false; // bool para simular exclusion mutua

// contadores
int UserConts[3];   // guarda veces que se repite el denunciante
int TargetConts[3]; // guarda veces que se repite el denunciado
int PairConts[3];   // guarda veces que se repite el par denunciante-denunciado
int TypeConts[3];   // guarda veces que se repite el tipo de denuncia

// READER - Lector del CSV
// Simula 1 goroutine
proctype Reader(){
    int i = 0;

    // simulacion de lectura - registros = MAX_RECORDS para simulacion
    do
    :: i < MAX_RECORDS ->
        // como parte de la simulacion, se generan datos
        // y se almacenan en el canal de RECORDS (simular lectura)
        records! (i%3), ((i+1)%3), ((i+2)%3);
        i++;
    :: else ->
        break;
    od;

    // señal de fin - ya no hay mas registros
    // detener workers
    i = 0;
    do
    :: i < N_WORKERS ->
        records!-1, -1, -1;
        i++
    :: else ->
        break
    od;

}

// WORKER POOL - Procesadores de registros
// simula N_WORKERS goroutines
proctype Worker(byte id){
    int userKey;    // almacen de user (denunciante)
    int targetKey;  // almacen de target (denunciado)
    int typeKey;    // almacen de type (tipo denuncia)

    do
    :: records?userKey, targetKey, typeKey ->
        if
        :: userKey == -1 ->
            break;
        :: else ->
            atomic {
                //exclusion mutua
                // entrada a Seccion Critica
                mutex == false ->
                mutex = true;

                // acceso a variables compartidas
                // acá solo se simula el aumento del contador
                // en el codigo final debe considerar condiciones en los contadores
                UserConts[userKey]++;
                TargetConts[targetKey]++;
                PairConts[userKey]++;
                TypeConts[typeKey]++;

                // Salida de seccion critica
                mutex = false;
            }
        fi;
    od;

    done!id
}


// DETECCION CONCURRENTE
// Goroutine por cada contador - tipo de deteccion

// Goroutine - Deteccion Users anomalos
proctype DetectUsers(){
    int anomalous = 0;

    // Para simulacion, se analiza solo el primer valor de la lista
    // si se repite mas de 1 vez, se considera anomalo
    if
    :: UserConts[0] > 1 -> anomalous = 1
    :: else -> skip
    fi;

    usersCh!anomalous
}

// Goroutine - Deteccion Targets anomalos
proctype DetectTargets() {
    int anomalous = 0;

    // Para simulacion, se analiza solo el primer valor de la lista
    // si se repite mas de 1 vez, se considera anomalo
    if
    :: TargetConts[0] > 1 -> anomalous = 1
    :: else -> skip
    fi;

    targetsCh!anomalous
}

// Goroutine - Deteccion Pares anomalos
proctype DetectPairs() {
    int anomalous = 0;
    
    // Para simulacion, se analiza solo el primer valor de la lista
    // si se repite mas de 1 vez, se considera anomalo
    if
    :: PairConts[0] > 1 -> anomalous = 1
    :: else -> skip
    fi;

    pairsCh!anomalous
}


proctype DetectTypes() {
    int anomalous = 0;
    
    // Para simulacion, se analiza solo el primer valor de la lista
    // si se repite mas de 1 vez, se considera anomalo
    if
    :: TypeConts[0] > 1 -> anomalous = 1
    :: else -> skip
    fi;

    typesCh!anomalous
}

// AGGREGATOR
// Recoge los resultados de la deteccion concurrente
proctype Aggregator(){
    int us; // recolectar user
    int ta; // recolectar target
    int pa; // recolectar par
    int ty; // recolectar typo

    usersCh?us;
    targetsCh?ta;
    pairsCh?pa;
    typesCh?ty;

    /*
        Acá se puede realizar algun metodo con los resultados anomalos
        guardar, imprimir, analizar, etc.
    */

}

// init
init {
    byte i = 0; // id de worker - aumenta

    // Reader
    run Reader();
    
    // Worker Pool
    do
    :: i < N_WORKERS ->
        run Worker(i);
        i++;
    ::else->
        break;
    od;

    // Esperar que terminen los workers
    byte j = 0; // contador finalizados
    byte k; // para recibir el valor
    do
    :: j < N_WORKERS ->
        done?k;
        j++;
    :: else ->
        break;
    od;

    // CORRRER DETECCIONES
    run DetectUsers();
    run DetectTargets();
    run DetectPairs();
    run DetectTypes();

    // Recopilar anomalos
    run Aggregator();

}

