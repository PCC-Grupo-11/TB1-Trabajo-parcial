# Informe de Análisis de GAPs — Detector Concurrente de Red Flags

**Repositorio:** [PCC-Grupo-11/TB1-Trabajo-parcial](https://github.com/PCC-Grupo-11/TB1-Trabajo-parcial)  
**Branch analizada:** `PC3`  
**Fecha de análisis:** 10 de mayo de 2026  
**Herramienta:** Claude (Anthropic) — análisis estático del código fuente

---

## 1. Resumen Ejecutivo

Se analizaron todos los archivos de la rama `PC3`: **22 archivos Go** (incluyendo `PC1/corrección/Cleaning.go` y `PC1/corrección/Eda.go`), **3 archivos Promela**, **1 script Python**, **2 notebooks Jupyter** y **19 reportes JSON de benchmark**. Se identificaron GAPs en cuatro dimensiones:

| Dimensión | Críticos | Medios | Bajos |
|-----------|:---:|:---:|:---:|
| Concurrencia | 2 | 2 | 1 |
| Calidad de código | 0 | 3 | 3 |
| Seguridad | 1 | 2 | 1 |
| Arquitectura | 1 | 2 | 1 |
| **Total** | **4** | **9** | **6** |

### Archivos analizados

| Carpeta | Archivos | Descripción |
|---------|----------|-------------|
| `cmd/` | `concurrent/main.go`, `sequential/main.go` | Entry points del benchmark |
| `internal/benchmark/` | `concurrent.go`, `sequential.go`, `reader.go`, `counters.go`, `runner.go`, `metrics.go`, `monitor.go`, `iterations.go` | Lógica de benchmark y concurrencia |
| `internal/preprocess/` | `preprocess.go`, `spam_detect.go`, `loader.go` | Limpieza de texto y detección de spam |
| `internal/stats/` | `stats.go` | Detección de anomalías por z-score |
| `internal/model/` | `types.go` | Structs compartidos |
| `internal/cli/` | `flags.go`, `command.go` | Parsing de argumentos |
| `internal/report/` | `console.go`, `json.go` | Salida de reportes |
| `internal/system/` | `info.go` | Info del hardware |
| `PC1/corrección/` | `Cleaning.go`, `Eda.go` | Limpieza y EDA corregidos del dataset INDECOPI |
| `PC1/go/` | `cleaning.go`, `eda.go` | Versión anterior de limpieza/EDA |
| `simulation/` | `ModeloFinal/trabajo.pml`, `ModeloInicial/trabajo.pml`, `extra.pml` | Verificación formal en Spin |
| `scripts/` | `run_benchmarks.py` | Automatización de benchmarks |

---

## 2. GAPs en Patrones de Concurrencia

### GAP-C1: Mutex global serializa todo el trabajo de los workers [CRÍTICO]

**Archivo:** `internal/benchmark/concurrent.go`, líneas 43-58

```go
state.Mu.Lock()
state.UserCounts[record.UserKey]++
state.TargetCounts[record.TargetKey]++
state.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
state.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
if isSpam {
    state.SpamCount++
    state.SpamByUser[record.UserKey]++
}
state.Mu.Unlock()
```

**Problema:** Un único `sync.Mutex` protege 5 mapas y 1 contador. Cada worker lo adquiere por cada registro, serializando el ~95% del tiempo de ejecución. Los benchmarks confirman que el speedup se estanca en ~1.06x para N≥2 workers.

**Impacto:** El paralelismo real es nulo. El speedup de 1.31x proviene exclusivamente del canal buffered (desacoplamiento I/O-cómputo con 1 worker).

**Mejora propuesta:** Patrón **Owner Goroutine** con canales por shard (ya validado en `simulation/ModeloFinal/trabajo.pml`). Cada goroutine es dueña exclusiva de su porción del mapa; los workers envían actualizaciones por canal, eliminando el mutex.

---

### GAP-C2: Buffer del canal hardcodeado [MEDIO]

**Archivo:** `internal/benchmark/concurrent.go`, línea 10

```go
const recordBufferMultiplier = 80
```

**Problema:** El multiplicador de buffer está fijo. Los benchmarks muestran variación del 26.2% entre buffer=5 y buffer=100, pero no se expone como flag CLI.

**Mejora:** Exponerlo como flag `-b` / `--buffer`.

---

### GAP-C3: Sin `context.Context` ni cancelación [MEDIO]

**Archivos:** `internal/benchmark/concurrent.go`, `reader.go`

**Problema:** No se usa `context.Context`. Si el Reader falla, los workers siguen procesando hasta que el canal se cierre. El error solo se detecta después de `wg.Wait()`.

**Mejora:** Agregar `context.WithCancel` para propagar errores inmediatamente.

---

### GAP-C4: Race condition potencial en `DetectAnomaliesConcurrent` [CRÍTICO]

**Archivo:** `internal/stats/stats.go`, líneas 68-84

```go
func DetectAnomaliesConcurrent(state *model.GlobalState) model.DetectionResult {
    go func() { usersCh <- detect(state.UserCounts, ...) }()
    go func() { targetsCh <- detect(state.TargetCounts, ...) }()
    // 5 goroutines leen mapas concurrentemente sin sync
}
```

**Problema:** Las 5 goroutines leen `GlobalState` sin sincronización explícita. Aunque en la práctica se ejecutan después de `wg.Wait()`, la relación happens-before es frágil y no está documentada.

**Mejora:** Pasar copias de los mapas a cada goroutine, o usar `sync.RWMutex` con `RLock()`.

---

### GAP-C5: Modelo Promela no refleja la implementación actual [BAJO]

**Archivo:** `simulation/ModeloFinal/trabajo.pml`

**Problema:** Usa `atomic { mutex == false -> mutex = true }` (spinlock ideal), pero Go usa `sync.Mutex` (FIFO). No modela la detección de spam ni canales buffered del Reader.

**Mejora:** Extender el modelo para cubrir el flujo completo.

---

## 3. GAPs en Calidad de Código

### GAP-Q1: Duplicación entre `cmd/concurrent/main.go` y `cmd/sequential/main.go` [MEDIO]

Ambos archivos son idénticos salvo la cadena `"concurrent"` vs `"sequential"`.

**Mejora:** Unificar en un solo binario con flag `--mode`.

---

### GAP-Q2: Sin tests unitarios [MEDIO]

No existe ningún `_test.go` en el repositorio. Funciones críticas como `detect()`, `IsSpam()`, `CleanText()`, `normalizeKey()` y `isValidRUC()` no tienen cobertura.

**Mejora:** Agregar tests para `internal/preprocess/`, `internal/stats/`, `internal/benchmark/reader.go` y `PC1/corrección/`.

---

### GAP-Q3: Ausencia de logging estructurado [MEDIO]

Toda la salida es `fmt.Printf`. No hay niveles de log ni timestamps correlacionables con benchmarks.

**Mejora:** Usar `log/slog` (Go 1.21+).

---

### GAP-Q4: Errores de CSV se ignoran silenciosamente [BAJO]

**Archivos:** `internal/benchmark/reader.go` (línea 44), `PC1/corrección/Cleaning.go` (línea 108)

Ambos archivos hacen `continue` cuando hay errores de lectura CSV sin contarlos ni reportarlos.

```go
// reader.go
if rowLen <= userIdx || ... { continue }  // fila incompleta ignorada

// Cleaning.go
if err != nil { continue }  // error de parsing ignorado
```

**Mejora:** Agregar contadores de filas descartadas al reporte.

---

### GAP-Q5: Magic numbers en umbrales de z-score [BAJO]

**Archivo:** `internal/stats/stats.go`, líneas 11-14

```go
userThresholdZScore   = 5.0
targetThresholdZScore = 1.0   // muy bajo: marca todo a >1σ
pairThresholdZScore   = 12.0
typeThresholdZScore   = 8.0
```

Sin documentación de por qué se eligieron estos valores. `targetThresholdZScore = 1.0` es inusualmente bajo.

**Mejora:** Documentar justificación y considerar configuración externa.

---

### GAP-Q6: `pairKey` usa separador que podría colisionar [BAJO]

**Archivo:** `internal/benchmark/counters.go`

```go
func pairKey(left, right string) string {
    return left + " || " + right
}
```

Si un nombre contuviese `" || "`, habría colisión de claves.

**Mejora:** Usar separador nulo (`\x00`) o struct como key.

---

## 4. GAPs de Seguridad

### GAP-S1: Sin validación de input del CSV [CRÍTICO]

**Archivos:** `internal/benchmark/reader.go`, `PC1/corrección/Cleaning.go`

No se valida tamaño de archivo, longitud de campos ni encoding. Un CSV con campos de texto extremadamente largos podría agotar la memoria.

**Nota positiva:** `PC1/corrección/Cleaning.go` usa `LazyQuotes: true` y `TrimLeadingSpace: true`, lo cual mejora la robustez frente a CSVs mal formados. Pero no limita tamaño de campos.

**Mejora:** Verificar `len(field)` y encoding UTF-8.

---

### GAP-S2: Ruta de input sin validación [MEDIO]

**Archivos:** `internal/cli/flags.go`, `PC1/corrección/Cleaning.go`

La ruta se pasa directo a `os.Open()` sin verificar si es archivo regular, symlink, directorio, etc.

**Mejora:** Validar con `os.Stat()` + `info.IsDir()`.

---

### GAP-S3: Escritura de reportes sin restricción de path [MEDIO]

**Archivos:** `internal/report/json.go`, `PC1/corrección/Cleaning.go` y `Eda.go`

Se crean archivos con `os.WriteFile` y `os.Create` sin verificar si el path de destino es un symlink o reside en un directorio inseguro.

**Mejora:** Verificar que el directorio no sea symlink.

---

### GAP-S4: Sin CI/CD ni verificación de dependencias [BAJO]

No hay GitHub Actions. Las dependencias (`gopsutil`) no se auditan automáticamente.

**Mejora:** Agregar pipeline con `govulncheck` y `go vet`.

---

## 5. GAPs de Arquitectura y Escalabilidad

### GAP-A1: Mapas en memoria sin límite [CRÍTICO]

**Archivo:** `internal/model/types.go`

Los 5 mapas de `GlobalState` crecen sin límite. `PairCounts` almacena combinaciones (usuario, empresa) que escalan cuadráticamente. Con 1M registros consume ~485 MB; con mayor cardinalidad podría agotar la RAM.

**Mejora:** Usar **Count-Min Sketch** para contadores de alta cardinalidad o particionamiento en disco.

---

### GAP-A2: Sin soporte para procesamiento distribuido [MEDIO]

Arquitectura mono-nodo. No hay abstracción para distribuir trabajo entre máquinas.

**Mejora:** Diseñar interfaz de particionamiento (e.g., gRPC o NATS) para distribución futura.

---

### GAP-A3: Script de benchmarks usa `time.sleep` fijo [MEDIO]

**Archivo:** `scripts/run_benchmarks.py`, línea 67

```python
time.sleep(20)  # cooldown fijo
```

No verifica estabilización del sistema (CPU idle, GC) antes de la siguiente iteración.

**Mejora:** Monitorear CPU hasta idle antes de lanzar.

---

### GAP-A4: Nombre de archivo con espacio [BAJO]

**Archivo:** `scripts/run_benchmarks.py`, línea 16

```python
DEFAULT_INPUT = "./data/Dataset Arreglado.csv"
```

Puede causar problemas en shell scripts y CI/CD.

**Mejora:** Renombrar a `dataset_arreglado.csv`.

---

## 6. Observaciones Positivas

No todo son GAPs. El proyecto presenta fortalezas destacables:

| Aspecto | Detalle |
|---------|---------|
| **Estructura de paquetes** | Clara separación: `cmd/`, `internal/benchmark/`, `internal/preprocess/`, etc. Sigue convenciones idiomáticas de Go. |
| **Verificación formal** | Modelo Promela verificado con Spin: 19M estados, 28M transiciones, 0 errores, 0 deadlocks, 0 estados inalcanzables. |
| **Benchmarking riguroso** | 20 iteraciones por configuración, trimmed mean al 20%, monitoreo de RSS y CPU por muestreo con `gopsutil`. |
| **PC1/corrección** | `Cleaning.go` y `Eda.go` corregidos con `LazyQuotes`, validación de RUC (`isValidRUC`), normalización de acentos, reportes JSON detallados con razones de descarte y barras de progreso. |
| **Detección concurrente** | `DetectAnomaliesConcurrent()` paraleliza las 5 detecciones (users, targets, pairs, types, spam) en goroutines independientes. |
| **CLI bien diseñada** | Flags con doble nombre (`-i`/`--input`, `-n`/`--runs`), validaciones, mensajes de uso claros. |

---

## 7. Matriz de Priorización

| ID | GAP | Severidad | Esfuerzo | Prioridad |
|----|-----|-----------|----------|-----------|
| GAP-C1 | Mutex global serializa workers | Crítico | Alto | 1 |
| GAP-C4 | Race condition en detección | Crítico | Bajo | 2 |
| GAP-S1 | Sin validación de input CSV | Crítico | Medio | 3 |
| GAP-A1 | Mapas sin límite de memoria | Crítico | Alto | 4 |
| GAP-Q2 | Sin tests unitarios | Medio | Medio | 5 |
| GAP-C3 | Sin context.Context | Medio | Bajo | 6 |
| GAP-C2 | Buffer hardcodeado | Medio | Bajo | 7 |
| GAP-Q1 | Duplicación en cmd/ | Medio | Bajo | 8 |
| GAP-Q3 | Sin logging estructurado | Medio | Medio | 9 |
| GAP-S2 | Path sin validación | Medio | Bajo | 10 |
| GAP-S3 | Escritura insegura de reportes | Medio | Bajo | 11 |
| GAP-A2 | Sin procesamiento distribuido | Medio | Alto | 12 |
| GAP-A3 | Sleep fijo en benchmarks | Medio | Bajo | 13 |
| GAP-C5 | Promela incompleto | Bajo | Medio | 14 |
| GAP-Q4 | Errores CSV ignorados | Bajo | Bajo | 15 |
| GAP-Q5 | Magic numbers en umbrales | Bajo | Bajo | 16 |
| GAP-Q6 | Separador pairKey frágil | Bajo | Bajo | 17 |
| GAP-S4 | Sin CI/CD | Bajo | Medio | 18 |
| GAP-A4 | Nombre archivo con espacio | Bajo | Bajo | 19 |

---

## 8. Conclusión

El proyecto presenta una arquitectura concurrente funcional con buena separación de responsabilidades y una verificación formal sólida en Spin. Los archivos corregidos en `PC1/corrección/` mejoran la robustez del pipeline de limpieza y EDA. El **GAP principal** sigue siendo el mutex global (`GAP-C1`) que anula el beneficio del paralelismo — su reemplazo por el patrón Owner Goroutine (ya validado en Promela) tendría el mayor impacto en rendimiento y escalabilidad. En segundo lugar, la ausencia de tests (`GAP-Q2`) y la falta de validación del CSV (`GAP-S1`) son las brechas más urgentes de cerrar.
