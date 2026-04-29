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
	cpuValues := make([]float64, 0, n)
	totalTime := 0.0
	totalMaxRSS := 0.0
	totalAvgCPU := 0.0

	for _, it := range iterations {
		times = append(times, it.TimeMs)
		rssValues = append(rssValues, it.MaxRSSMB)
		cpuValues = append(cpuValues, it.AvgCPUPercent)
		totalTime += it.TimeMs
		totalMaxRSS += it.MaxRSSMB
		totalAvgCPU += it.AvgCPUPercent
	}

	sort.Float64s(times)
	sort.Float64s(rssValues)
	sort.Float64s(cpuValues)

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

	trimmedCPU := cpuValues
	if k > 0 && 2*k < n {
		trimmedCPU = cpuValues[k : n-k]
	}

	outliersRemoved := n - len(trimmed)

	return model.Summary{
		TotalRuns:            n,
		MeanTimeMs:           totalTime / float64(n),
		TrimmedMeanTimeMs:    average(trimmed),
		AverageMaxRSSMB:      totalMaxRSS / float64(n),
		TrimmedMaxRSSMB:      average(trimmedRSS),
		AverageAvgCPUPercent: totalAvgCPU / float64(n),
		TrimmedAvgCPUPercent: average(trimmedCPU),
		OutliersRemoved:      outliersRemoved,
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

func DetectAnomaliesConcurrent(state *model.GlobalState) model.DetectionResult {
	usersCh := make(chan []string, 1)
	targetsCh := make(chan []string, 1)
	pairsCh := make(chan []string, 1)
	typesCh := make(chan []string, 1)

	go func() { usersCh <- detect(state.UserCounts, userThresholdZScore) }()
	go func() { targetsCh <- detect(state.TargetCounts, targetThresholdZScore) }()
	go func() { pairsCh <- detect(state.PairCounts, pairThresholdZScore) }()
	go func() { typesCh <- detect(state.TypeCounts, typeThresholdZScore) }()

	suspiciousUsers := <-usersCh
	suspiciousTargets := <-targetsCh
	suspiciousPairs := <-pairsCh
	suspiciousTypes := <-typesCh

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
