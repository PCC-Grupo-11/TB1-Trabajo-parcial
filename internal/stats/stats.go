package stats

import (
	"sort"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func ComputeSummary(iterations []model.Iteration) model.Summary {
	n := len(iterations)
	if n == 0 {
		return model.Summary{}
	}

	times := make([]float64, 0, n)
	totalTime := 0.0
	totalRAM := 0.0

	for _, it := range iterations {
		times = append(times, it.TimeMs)
		totalTime += it.TimeMs
		totalRAM += it.RamMB
	}

	sort.Float64s(times)

	k := 0
	switch {
	case n >= 10:
		k = int(0.1 * float64(n))
	case n >= 5:
		k = 1
	}

	trimmed := times
	if k > 0 && 2*k < n {
		trimmed = times[k : n-k]
	}

	outliersRemoved := n - len(trimmed)

	return model.Summary{
		TotalRuns:         n,
		MeanTimeMs:        totalTime / float64(n),
		TrimmedMeanTimeMs: average(trimmed),
		AverageRamMB:      totalRAM / float64(n),
		OutliersRemoved:   outliersRemoved,
	}
}

func average(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}

	total := 0.0
	for _, v := range values {
		total += v
	}
	return total / float64(len(values))
}
