package benchmark

import (
	"fmt"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func Run(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	switch cfg.Mode {
	case "sequential":
		return RunSequential(cfg)
	case "concurrent":
		return RunConcurrent(cfg)
	default:
		return nil, emptyDetectionResult(), fmt.Errorf("invalid mode %q", cfg.Mode)
	}
}
