package stats

import (
	"math"
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
	totalHeapAlloc := 0.0
	totalRSSDelta := 0.0
	totalPeakRSS := 0.0

	for _, it := range iterations {
		times = append(times, it.TimeMs)
		totalTime += it.TimeMs
		totalHeapAlloc += it.HeapAllocMB
		totalRSSDelta += it.RSSDeltaMB
		totalPeakRSS += it.PeakRSSMB
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
		TotalRuns:          n,
		MeanTimeMs:         totalTime / float64(n),
		TrimmedMeanTimeMs:  average(trimmed),
		AverageHeapAllocMB: totalHeapAlloc / float64(n),
		AverageRSSDeltaMB:  totalRSSDelta / float64(n),
		AveragePeakRSSMB:   totalPeakRSS / float64(n),
		OutliersRemoved:    outliersRemoved,
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

func MergeShards(shards []*model.Shard) (userCounts, targetCounts, pairCounts, typeCounts map[string]int) {
	userCounts = make(map[string]int)
	targetCounts = make(map[string]int)
	pairCounts = make(map[string]int)
	typeCounts = make(map[string]int)

	for _, shard := range shards {
		for k, v := range shard.UserCounts {
			userCounts[k] += v
		}
		for k, v := range shard.TargetCounts {
			targetCounts[k] += v
		}
		for k, v := range shard.PairCounts {
			pairCounts[k] += v
		}
		for k, v := range shard.TypeCounts {
			typeCounts[k] += v
		}
	}
	return
}

func DetectAnomalies(userCounts, targetCounts, pairCounts map[string]int) model.DetectionResult {
	suspiciousUsers := detect(userCounts, 2.0)
	suspiciousTargets := detect(targetCounts, 2.0)
	suspiciousPairs := detect(pairCounts, 1.0)

	return model.DetectionResult{
		SuspiciousUsers:   suspiciousUsers,
		SuspiciousTargets: suspiciousTargets,
		SuspiciousPairs:   suspiciousPairs,
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
