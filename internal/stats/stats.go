package stats

import (
	"math"
	"sort"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

const (
	userThresholdZScore   = 12.0
	targetThresholdZScore = 2.0
	pairThresholdZScore   = 22.0
	typeThresholdZScore   = 15.0
)

func ComputeSummary(iterations []model.Iteration) model.Summary {
	n := len(iterations)
	if n == 0 {
		return model.Summary{}
	}

	times := make([]float64, 0, n)
	rssValues := make([]float64, 0, n)
	totalTime := 0.0
	totalPeakRSS := 0.0

	for _, it := range iterations {
		times = append(times, it.TimeMs)
		rssValues = append(rssValues, it.PeakRSSMB)
		totalTime += it.TimeMs
		totalPeakRSS += it.PeakRSSMB
	}

	sort.Float64s(times)
	sort.Float64s(rssValues)

	k := 0
	switch {
	case n >= 10:
		k = int(0.2 * float64(n))
	case n >= 5:
		k = 1
	}

	trimmed := times
	if k > 0 && 2*k < n {
		trimmed = times[k : n-k]
	}

	trimmedRSS := rssValues
	if k > 0 && 2*k < n {
		trimmedRSS = rssValues[k : n-k]
	}

	outliersRemoved := n - len(trimmed)

	return model.Summary{
		TotalRuns:         n,
		MeanTimeMs:        totalTime / float64(n),
		TrimmedMeanTimeMs: average(trimmed),
		AveragePeakRSSMB:  totalPeakRSS / float64(n),
		TrimmedPeakRSSMB:  average(trimmedRSS),
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

func DetectAnomalies(state *model.GlobalState) model.DetectionResult {
	suspiciousUsers := detect(state.UserCounts, userThresholdZScore)
	suspiciousTargets := detect(state.TargetCounts, targetThresholdZScore)
	suspiciousPairs := detect(state.PairCounts, pairThresholdZScore)
	suspiciousTypes := detect(state.TypeCounts, typeThresholdZScore)

	return model.DetectionResult{
		SuspiciousUsers:   suspiciousUsers,
		SuspiciousTargets: suspiciousTargets,
		SuspiciousPairs:   suspiciousPairs,
		SuspiciousTypes:   suspiciousTypes,
	}
}

func detect(counts map[string]int, zScore float64) []string {
	if len(counts) == 0 {
		return []string{}
	}

	var sum float64
	for _, v := range counts {
		sum += float64(v)
	}
	mean := sum / float64(len(counts))

	var param float64
	for _, v := range counts {
		diff := float64(v) - mean
		param += diff * diff
	}

	std := math.Sqrt(param / float64(len(counts)))
	threshold := mean + zScore*std

	suspicious := make([]string, 0)
	for k, v := range counts {
		if float64(v) > threshold {
			suspicious = append(suspicious, k)
		}
	}

	sort.Strings(suspicious)
	return suspicious
}
