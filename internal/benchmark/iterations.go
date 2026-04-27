package benchmark

import "github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"

func runIterations(runs int, iterationFn func() (timeMs float64, ramMB float64, err error)) ([]model.Iteration, error) {
	iterations := make([]model.Iteration, 0, runs)

	for i := 0; i < runs; i++ {
		timeMs, ramMB, err := iterationFn()
		if err != nil {
			return nil, err
		}

		iterations = append(iterations, model.Iteration{
			Iteration: i + 1,
			TimeMs:    timeMs,
			RamMB:     ramMB,
		})
	}

	return iterations, nil
}
