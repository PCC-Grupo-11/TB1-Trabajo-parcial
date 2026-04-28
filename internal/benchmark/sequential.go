package benchmark

import (
	"fmt"
	"runtime"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/stats"
)

func RunSequential(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	if cfg.Runs < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("runs must be >= 1")
	}
	if cfg.Mode != "sequential" {
		return nil, emptyDetectionResult(), fmt.Errorf("RunSequential requires mode=sequential")
	}

	var finalDetection model.DetectionResult
	iterations, err := runIterations(cfg.Runs, func() (float64, model.MemoryMetrics, error) {
		runtime.GC()

		detection, timeMs, memory, err := runSequentialIteration(cfg.Input)
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

func runSequentialIteration(inputPath string) (model.DetectionResult, float64, model.MemoryMetrics, error) {
	counts := newCountSet()
	detection := emptyDetectionResult()
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

		detection = stats.DetectAnomalies(counts.UserCounts, counts.TargetCounts, counts.PairCounts)
		return nil
	})
	if err != nil {
		return emptyDetectionResult(), 0, model.MemoryMetrics{}, err
	}

	return detection, timeMs, memory, nil
}
