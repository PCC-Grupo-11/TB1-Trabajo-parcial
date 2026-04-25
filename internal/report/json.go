package report

import (
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func ExportJSON(report model.Report) (filename string, err error) {
	filename = fmt.Sprintf("benchmark_%s.json", time.Now().Format("20060102_150405"))

	payload, err := json.MarshalIndent(report, "", "  ")
	if err != nil {
		return "", fmt.Errorf("marshal report json: %w", err)
	}

	if err := os.WriteFile(filename, payload, 0o644); err != nil {
		return "", fmt.Errorf("write report json: %w", err)
	}

	return filename, nil
}
