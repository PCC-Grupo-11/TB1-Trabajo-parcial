package model

type Config struct {
	Mode       string `json:"mode"`
	Runs       int    `json:"runs"`
	Goroutines int    `json:"goroutines"`
}

type DeviceInfo struct {
	CPUName      string  `json:"cpu_name"`
	LogicalCores int     `json:"logical_cores"`
	TotalRAMGB   float64 `json:"total_ram_gb"`
}

type ExecutionParams struct {
	Mode       string `json:"mode"`
	Runs       int    `json:"runs"`
	Goroutines int    `json:"goroutines"`
}

type Iteration struct {
	Iteration int     `json:"iteration"`
	TimeMs    float64 `json:"time_ms"`
	RamMB     float64 `json:"ram_mb"`
}

type Summary struct {
	TotalRuns         int     `json:"total_runs"`
	MeanTimeMs        float64 `json:"mean_time_ms"`
	TrimmedMeanTimeMs float64 `json:"trimmed_mean_time_ms"`
	AverageRamMB      float64 `json:"average_ram_mb"`
	OutliersRemoved   int     `json:"outliers_removed"`
}

type Report struct {
	Timestamp       string          `json:"timestamp"`
	DeviceInfo      DeviceInfo      `json:"device_info"`
	ExecutionParams ExecutionParams `json:"execution_params"`
	Iterations      []Iteration     `json:"iterations"`
	Summary         Summary         `json:"summary"`
}
