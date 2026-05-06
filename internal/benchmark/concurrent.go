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
	if cfg.Workers < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("workers must be >= 1 for concurrent mode")
	}

	var finalDetection model.DetectionResult
	iterations, err := runIterations(cfg.Runs, func() (float64, model.Metrics, error) {
		runtime.GC()

		detection, timeMs, memory, err := runConcurrentIteration(cfg.Input, cfg.Workers, cfg.RecordBufferMultiplier)
		if err != nil {
			return 0, model.Metrics{}, err
		}

		finalDetection = detection
		return timeMs, memory, nil
	})
	if err != nil {
		return nil, emptyDetectionResult(), err
	}

	return iterations, finalDetection, nil
}

func runConcurrentIteration(inputPath string, workers int, recordBufferMultiplier int) (model.DetectionResult, float64, model.Metrics, error) {
	state := newGlobalState()
	detection := emptyDetectionResult()

	timeMs, memory, err := Measure(func() error {
		records := make(chan model.Record, workers*recordBufferMultiplier)
		errCh := make(chan error, 1)

		go func() {
			errCh <- StreamRecords(inputPath, records)
		}()

		var wg sync.WaitGroup
		wg.Add(workers)
		for range workers {
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

		detection = stats.DetectAnomaliesConcurrent(state)
		return nil
	})
	if err != nil {
		return emptyDetectionResult(), 0, model.Metrics{}, err
	}

	return detection, timeMs, memory, nil
}
