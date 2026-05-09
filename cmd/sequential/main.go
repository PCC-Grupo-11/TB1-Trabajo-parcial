package main

import (
	"fmt"
	"os"
	"time"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/benchmark"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/cli"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	reportpkg "github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/report"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/stats"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/system"
)

func main() {
	cfg, err := cli.Parse("sequential")
	if err != nil {
		exitWithError(err)
	}

	device, err := system.GetInfo()
	if err != nil {
		exitWithError(err)
	}

	iterations, detection, err := benchmark.Run(cfg)
	if err != nil {
		exitWithError(err)
	}

	summary := stats.ComputeSummary(iterations)

	reportObj := model.Report{
		Timestamp:  time.Now().Format(time.RFC3339),
		DeviceInfo: device,
		ExecutionParams: model.ExecutionParams{
			Command:     cli.BuildCommand(os.Args),
			Input:       cfg.Input,
			Mode:        cfg.Mode,
			Runs:        cfg.Runs,
			Workers:     cfg.Workers,
			BigramsPath: cfg.BigramsPath,
		},
		Iterations:      iterations,
		Summary:         summary,
		DetectionResult: detection,
	}

	filename, err := reportpkg.ExportJSON(reportObj)
	if err != nil {
		exitWithError(err)
	}

	reportpkg.PrintReport(reportObj)
	fmt.Printf("\nJSON file: %s\n", filename)
}

func exitWithError(err error) {
	fmt.Fprintf(os.Stderr, "error: %v\n", err)
	os.Exit(1)
}
