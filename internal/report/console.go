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
	fmt.Printf("Goroutines: %d\n", report.ExecutionParams.Goroutines)
	fmt.Println()

	fmt.Println("=== ITERATIONS ===")
	for _, it := range report.Iterations {
		fmt.Printf("Iteration %d | time_ms=%.3f | ram_mb=%.3f\n", it.Iteration, it.TimeMs, it.RamMB)
	}
	fmt.Println()

	fmt.Println("=== SUMMARY ===")
	fmt.Printf("Total runs: %d\n", report.Summary.TotalRuns)
	fmt.Printf("Mean time (ms): %.3f\n", report.Summary.MeanTimeMs)
	fmt.Printf("Trimmed mean time (ms): %.3f\n", report.Summary.TrimmedMeanTimeMs)
	fmt.Printf("Average RAM (MB): %.3f\n", report.Summary.AverageRamMB)
	fmt.Printf("Outliers removed: %d\n", report.Summary.OutliersRemoved)
	fmt.Println()

	fmt.Println("=== DETECTION ===")
	if len(report.DetectionResult.SuspiciousUsers) == 0 {
		fmt.Println("Suspicious users: none")
	} else {
		fmt.Printf("Suspicious users: %v\n", report.DetectionResult.SuspiciousUsers)
	}

	if len(report.DetectionResult.SuspiciousTargets) == 0 {
		fmt.Println("Suspicious targets: none")
	} else {
		fmt.Printf("Suspicious targets: %v\n", report.DetectionResult.SuspiciousTargets)
	}

	if len(report.DetectionResult.SuspiciousPairs) == 0 {
		fmt.Println("Suspicious pairs: none")
	} else {
		fmt.Printf("Suspicious pairs: %v\n", report.DetectionResult.SuspiciousPairs)
	}
}
