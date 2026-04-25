package report

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func ExportJSON(report model.Report) (filename string, err error) {
	const resultsDir = "results"

	if err := os.MkdirAll(resultsDir, 0o755); err != nil {
		return "", fmt.Errorf("create results directory: %w", err)
	}

	basename := fmt.Sprintf("benchmark_%s.json", time.Now().Format("20060102_150405"))
	filename = filepath.Join(resultsDir, basename)

	payload, err := json.MarshalIndent(report, "", "  ")
	if err != nil {
		return "", fmt.Errorf("marshal report json: %w", err)
	}

	if err := os.WriteFile(filename, payload, 0o644); err != nil {
		return "", fmt.Errorf("write report json: %w", err)
	}

	return filename, nil
}
