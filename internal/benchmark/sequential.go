package benchmark

import (
	"fmt"
	"runtime"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func RunSequential(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	if cfg.Runs < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("runs must be >= 1")
	}
	if cfg.Mode != "sequential" {
		return nil, emptyDetectionResult(), fmt.Errorf("RunSequential requires mode=sequential")
	}

	iterations, err := runIterations(cfg.Runs, func() (float64, model.MemoryMetrics, error) {
		runtime.GC()

		_, timeMs, memory, err := runSequentialIteration(cfg.Input)
		if err != nil {
			return 0, model.MemoryMetrics{}, err
		}

		return timeMs, memory, nil
	})
	if err != nil {
		return nil, emptyDetectionResult(), err
	}

	return iterations, emptyDetectionResult(), nil
}

func runSequentialIteration(inputPath string) (*countMaps, float64, model.MemoryMetrics, error) {
	counts := newCountMaps()
	timeMs, memory, err := Measure(func() error {
		records := make(chan model.Record, 1024)
		errCh := make(chan error, 1)

		go func() {
			errCh <- StreamRecords(inputPath, records)
			close(errCh)
		}()

		for record := range records {
			counts.UserCounts[record.UserKey]++
			counts.TargetCounts[record.TargetKey]++
			counts.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
			counts.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
		}

		if err := <-errCh; err != nil {
			return err
		}

		return nil
	})
	if err != nil {
		return nil, 0, model.MemoryMetrics{}, err
	}

	return counts, timeMs, memory, nil
}
