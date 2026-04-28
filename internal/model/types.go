package model

import "sync"

type Config struct {
	Mode       string `json:"mode"`
	Input      string `json:"input"`
	Runs       int    `json:"runs"`
	Goroutines int    `json:"goroutines"`
}

type Record struct {
	UserKey   string
	TargetKey string
	TypeKey   string
}

type GlobalState struct {
	Mu sync.Mutex

	UserCounts   map[string]int
	TargetCounts map[string]int
	PairCounts   map[string]int
	TypeCounts   map[string]int
}

type DetectionResult struct {
	SuspiciousUsers   []string `json:"suspicious_users"`
	SuspiciousTargets []string `json:"suspicious_targets"`
	SuspiciousPairs   []string `json:"suspicious_pairs"`
	SuspiciousTypes   []string `json:"suspicious_types"`
}

type DeviceInfo struct {
	CPUName      string  `json:"cpu_name"`
	LogicalCores int     `json:"logical_cores"`
	TotalRAMGB   float64 `json:"total_ram_gb"`
}

type ExecutionParams struct {
	Command    string `json:"command"`
	Mode       string `json:"mode"`
	Input      string `json:"input"`
	Runs       int    `json:"runs"`
	Goroutines int    `json:"goroutines"`
}

type MemoryMetrics struct {
	PeakRSSMB float64 `json:"peak_rss_mb"`
}

type Iteration struct {
	Iteration int     `json:"iteration"`
	TimeMs    float64 `json:"time_ms"`
	MemoryMetrics
}

type Summary struct {
	TotalRuns         int     `json:"total_runs"`
	MeanTimeMs        float64 `json:"mean_time_ms"`
	TrimmedMeanTimeMs float64 `json:"trimmed_mean_time_ms"`
	AveragePeakRSSMB  float64 `json:"average_peak_rss_mb"`
	TrimmedPeakRSSMB  float64 `json:"trimmed_peak_rss_mb"`
	OutliersRemoved   int     `json:"outliers_removed"`
}

type Report struct {
	Timestamp       string          `json:"timestamp"`
	DeviceInfo      DeviceInfo      `json:"device_info"`
	ExecutionParams ExecutionParams `json:"execution_params"`
	Iterations      []Iteration     `json:"iterations"`
	Summary         Summary         `json:"summary"`
	DetectionResult DetectionResult `json:"detection_result"`
}
