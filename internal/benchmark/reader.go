package benchmark

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

func StreamRecords(path string, out chan<- model.Record) error {
	defer close(out)

	return forEachRecord(path, func(record model.Record) error {
		out <- record
		return nil
	})
}

func forEachRecord(path string, handle func(model.Record) error) error {
	file, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("open input file: %w", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	header, err := reader.Read()
	if err != nil {
		if err == io.EOF {
			return fmt.Errorf("input file is empty")
		}
		return fmt.Errorf("read csv header: %w", err)
	}

	userIdx := indexOf(header, "USER_KEY")
	targetIdx := indexOf(header, "TARGET_KEY")
	typeIdx := indexOf(header, "TYPE_KEY")
	textoIdx := indexOf(header, "TEXTO_RECLAMO")

	if userIdx == -1 || targetIdx == -1 || typeIdx == -1 || textoIdx == -1 {
		return fmt.Errorf("required columns not found: USER_KEY, TARGET_KEY, TYPE_KEY, TEXTO_RECLAMO")
	}

	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return fmt.Errorf("read csv row: %w", err)
		}

		rowLen := len(row)
		if rowLen <= userIdx || rowLen <= targetIdx || rowLen <= typeIdx || rowLen <= textoIdx {
			continue
		}

		record := model.Record{
			UserKey:      strings.TrimSpace(row[userIdx]),
			TargetKey:    strings.TrimSpace(row[targetIdx]),
			TypeKey:      strings.TrimSpace(row[typeIdx]),
			TextoReclamo: strings.TrimSpace(row[textoIdx]),
		}

		if err := handle(record); err != nil {
			return err
		}
	}

	return nil
}

func indexOf(header []string, name string) int {
	for i, col := range header {
		if strings.EqualFold(strings.TrimSpace(col), name) {
			return i
		}
	}
	return -1
}
