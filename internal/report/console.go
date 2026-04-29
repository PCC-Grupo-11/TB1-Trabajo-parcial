package report

import (
	"fmt"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func PrintReport(report model.Report) {
	fmt.Println("=== DEVICE INFO ===")
	fmt.Printf("CPU: %s\n", report.DeviceInfo.CPUName)
	fmt.Printf("Logical cores: %d\n", report.DeviceInfo.LogicalCores)
	fmt.Printf("Total RAM (GB): %.2f\n", report.DeviceInfo.TotalRAMGB)
	fmt.Println()

	fmt.Println("=== EXECUTION PARAMS ===")
	fmt.Printf("Command: %s\n", report.ExecutionParams.Command)
	fmt.Printf("Mode: %s\n", report.ExecutionParams.Mode)
	fmt.Printf("Input: %s\n", report.ExecutionParams.Input)
	fmt.Printf("Runs: %d\n", report.ExecutionParams.Runs)
	fmt.Printf("Workers: %d\n", report.ExecutionParams.Workers)
	fmt.Printf("Record buffer multiplier: %d\n", report.ExecutionParams.RecordBufferMultiplier)
	fmt.Println()

	fmt.Println("=== ITERATIONS ===")
	for _, it := range report.Iterations {
		fmt.Printf("Iteration %d | time_ms=%.3f | max_rss_mb=%.3f | avg_cpu_percent=%.3f\n",
			it.Iteration,
			it.TimeMs,
			it.MaxRSSMB,
			it.AvgCPUPercent,
		)
	}
	fmt.Println()

	fmt.Println("=== SUMMARY ===")
	fmt.Printf("Total runs:              %d\n", report.Summary.TotalRuns)
	fmt.Printf("Mean time (ms):          %.3f\n", report.Summary.MeanTimeMs)
	fmt.Printf("Trimmed mean time (ms):  %.3f\n", report.Summary.TrimmedMeanTimeMs)
	fmt.Printf("Max RAM usage (RSS):     %.3f MB\n", report.Summary.AverageMaxRSSMB)
	fmt.Printf("Trimmed max RAM (RSS):   %.3f MB\n", report.Summary.TrimmedMaxRSSMB)
	fmt.Printf("Avg CPU (%%):             %.3f\n", report.Summary.AverageAvgCPUPercent)
	fmt.Printf("Trimmed avg CPU (%%):     %.3f\n", report.Summary.TrimmedAvgCPUPercent)
	fmt.Printf("Outliers removed:        %d\n", report.Summary.OutliersRemoved)
	fmt.Println()

	fmt.Println("=== DETECTION ===")
	printSuspiciousList("Suspicious users", report.DetectionResult.SuspiciousUsers)
	printSuspiciousList("Suspicious targets", report.DetectionResult.SuspiciousTargets)
	printSuspiciousList("Suspicious pairs", report.DetectionResult.SuspiciousPairs)
	printSuspiciousList("Suspicious types", report.DetectionResult.SuspiciousTypes)
}

func printSuspiciousList(label string, values []string) {
	if len(values) == 0 {
		fmt.Printf("%s: none\n", label)
		return
	}

	fmt.Printf("%s: %v\n", label, values)
}
