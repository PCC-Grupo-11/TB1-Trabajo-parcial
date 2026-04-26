package benchmark

import (
	"fmt"
	"runtime"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func StartRecordStream(cfg model.Config) (<-chan model.Record, <-chan error) {
	bufferSize := cfg.Goroutines * 10
	if bufferSize < 10 {
		bufferSize = 10
	}
	recordsChan := make(chan model.Record, bufferSize)
	errChan := make(chan error)

	go func() {
		errChan <- StreamRecords(cfg.Input, recordsChan)
		close(errChan)
	}()

	return recordsChan, errChan
}

func Run(cfg model.Config) ([]model.Iteration, error) {
	if cfg.Runs < 1 {
		return nil, fmt.Errorf("runs must be >= 1")
	}

	var runFn func()
	switch cfg.Mode {
	case "sequential":
		runFn = mockSequential
	case "concurrent":
		if cfg.Goroutines < 1 {
			return nil, fmt.Errorf("goroutines must be >= 1 for concurrent mode")
		}
		g := cfg.Goroutines
		runFn = func() {
			mockConcurrent(g)
		}
	default:
		return nil, fmt.Errorf("invalid mode %q", cfg.Mode)
	}

	iterations := make([]model.Iteration, 0, cfg.Runs)
	for i := 0; i < cfg.Runs; i++ {
		runtime.GC()
		timeMs, ramMB := Measure(runFn)
		iterations = append(iterations, model.Iteration{
			Iteration: i + 1,
			TimeMs:    timeMs,
			RamMB:     ramMB,
		})
	}

	return iterations, nil
}
