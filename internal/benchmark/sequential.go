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
	state := newGlobalState()
	detection := emptyDetectionResult()
	timeMs, memory, err := Measure(func() error {
		err := countSequentialRecords(inputPath, state)
		if err != nil {
			return err
		}

		detection = stats.DetectAnomalies(state)
		return nil
	})
	if err != nil {
		return emptyDetectionResult(), 0, model.MemoryMetrics{}, err
	}

	return detection, timeMs, memory, nil
}

func countSequentialRecords(inputPath string, state *model.GlobalState) error {
	return forEachRecord(inputPath, func(record model.Record) error {
		applyRecordCounts(state, record)
		return nil
	})
}

func applyRecordCounts(state *model.GlobalState, record model.Record) {
	state.UserCounts[record.UserKey]++
	state.TargetCounts[record.TargetKey]++
	state.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
	state.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
}
