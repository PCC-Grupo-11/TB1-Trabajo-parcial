package benchmark

import "github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"

const bytesPerMB = 1024 * 1024

func Measure(fn func() error) (timeMs float64, memory model.Metrics, err error) {
	resourceReader, err := newResourceReader()
	if err != nil {
		return 0, model.Metrics{}, err
	}

	elapsed, maxRSS, avgCPUPercent, runErr := runWithResourceSampling(fn, resourceReader)
	timeMs = float64(elapsed.Nanoseconds()) / 1e6

	if runErr != nil {
		return timeMs, model.Metrics{}, runErr
	}

	memory = model.Metrics{
		MaxRSSMB:      float64(maxRSS) / bytesPerMB,
		AvgCPUPercent: avgCPUPercent,
	}

	return timeMs, memory, runErr
}
