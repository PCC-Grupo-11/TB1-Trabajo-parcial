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
	if report.ExecutionParams.Mode == "sequential" {
		fmt.Println("Goroutines: -")
	} else {
		fmt.Printf("Goroutines: %d\n", report.ExecutionParams.Goroutines)
	}
	fmt.Println()

	fmt.Println("=== ITERATIONS ===")
	for _, it := range report.Iterations {
		fmt.Printf("Iteration %d | time_ms=%.3f | heap_alloc_mb=%.3f | rss_delta_mb=%.3f | peak_rss_mb=%.3f\n",
			it.Iteration,
			it.TimeMs,
			it.HeapAllocMB,
			it.RSSDeltaMB,
			it.PeakRSSMB,
		)
	}
	fmt.Println()

	fmt.Println("=== SUMMARY ===")
	fmt.Printf("Total runs: %d\n", report.Summary.TotalRuns)
	fmt.Printf("Mean time (ms): %.3f\n", report.Summary.MeanTimeMs)
	fmt.Printf("Trimmed mean time (ms): %.3f\n", report.Summary.TrimmedMeanTimeMs)
	fmt.Printf("Average RAM (Heap Alloc): %.3f MB\n", report.Summary.AverageHeapAllocMB)
	fmt.Printf("Average RAM (RSS):        %.3f MB\n", report.Summary.AverageRSSDeltaMB)
	fmt.Printf("Average RAM (Peak RSS):   %.3f MB\n", report.Summary.AveragePeakRSSMB)
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
