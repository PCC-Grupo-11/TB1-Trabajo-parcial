package benchmark

import (
	"fmt"
	"runtime"
	"sync"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/stats"
)

func RunConcurrent(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	if cfg.Runs < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("runs must be >= 1")
	}
	if cfg.Mode != "concurrent" {
		return nil, emptyDetectionResult(), fmt.Errorf("RunConcurrent requires mode=concurrent")
	}
	if cfg.Goroutines < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("goroutines must be >= 1 for concurrent mode")
	}

	var finalDetection model.DetectionResult
	iterations, err := runIterations(cfg.Runs, func() (float64, model.MemoryMetrics, error) {
		runtime.GC()

		detection, timeMs, memory, err := runConcurrentIteration(cfg.Input, cfg.Goroutines)
		if err != nil {
			return 0, model.MemoryMetrics{}, err
		}

		finalDetection = detection
		return timeMs, memory, nil
	})
	if err != nil {
		return nil, emptyDetectionResult(), err
	}

	return iterations, finalDetection, nil
}

func runConcurrentIteration(inputPath string, goroutines int) (model.DetectionResult, float64, model.MemoryMetrics, error) {
	state := newGlobalState()
	detection := emptyDetectionResult()

	timeMs, memory, err := Measure(func() error {
		records := make(chan model.Record, goroutines*100)
		errCh := make(chan error, 1)

		go func() {
			errCh <- StreamRecords(inputPath, records)
		}()

		var wg sync.WaitGroup
		wg.Add(goroutines)
		for i := 0; i < goroutines; i++ {
			go func() {
				defer wg.Done()
				for record := range records {
					state.Mu.Lock()
					state.UserCounts[record.UserKey]++
					state.TargetCounts[record.TargetKey]++
					state.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
					state.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
					state.Mu.Unlock()
				}
			}()
		}

		wg.Wait()

		if err := <-errCh; err != nil {
			return err
		}

		detection = stats.DetectAnomalies(state.UserCounts, state.TargetCounts, state.PairCounts, state.TypeCounts)
		return nil
	})
	if err != nil {
		return emptyDetectionResult(), 0, model.MemoryMetrics{}, err
	}

	return detection, timeMs, memory, nil
}
