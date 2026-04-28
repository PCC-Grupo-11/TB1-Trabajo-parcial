package benchmark

import "github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"

const bytesPerMB = 1024 * 1024

func Measure(fn func() error) (timeMs float64, memory model.MemoryMetrics, err error) {
	rssReader, err := newRSSReader()
	if err != nil {
		return 0, model.MemoryMetrics{}, err
	}

	elapsed, peakRSS, runErr := runWithPeakRSSSampling(fn, rssReader)
	timeMs = float64(elapsed.Nanoseconds()) / 1e6

	if runErr != nil {
		return timeMs, model.MemoryMetrics{}, runErr
	}

	memory = model.MemoryMetrics{
		PeakRSSMB: float64(peakRSS) / bytesPerMB,
	}

	return timeMs, memory, runErr
}
