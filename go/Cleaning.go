package main
 
import (
	"encoding/csv"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"
	"time"
	"unicode"
)
 
var accentReplacer = strings.NewReplacer(
	"á", "A", "à", "A", "é", "E", "è", "E", "í", "I", "ì", "I",
	"ó", "O", "ò", "O", "ú", "U", "ù", "U", "ü", "U", "ñ", "N", "ç", "C",
	"Á", "A", "É", "E", "Í", "I", "Ó", "O", "Ú", "U", "Ñ", "N",
)
var reSpecial = regexp.MustCompile(`[^A-Z0-9 ]`)
 
func normalizeKey(s string) string {
	s = strings.ToUpper(strings.TrimSpace(s))
	s = accentReplacer.Replace(s)
	var b strings.Builder
	for _, r := range s {
		if r <= unicode.MaxASCII {
			b.WriteRune(r)
		} else {
			b.WriteRune(' ')
		}
	}
	return strings.Join(strings.Fields(reSpecial.ReplaceAllString(b.String(), " ")), " ")
}
 
func cleanTexto(s string) string {
	s = strings.TrimSpace(s)
	s = strings.ReplaceAll(s, "\n", " ")
	s = strings.ReplaceAll(s, "\r", " ")
	return strings.Join(strings.Fields(s), " ")
}
 
func isValidRUC(s string) bool {
	s = strings.TrimSpace(s)
	if len(s) != 11 {
		return false
	}
	for _, c := range s {
		if c < '0' || c > '9' {
			return false
		}
	}
	return true
}
 
type Report struct {
	Timestamp      string         `json:"timestamp"`
	InputFile      string         `json:"input_file"`
	OutputFile     string         `json:"output_file"`
	OriginalRows   int            `json:"original_rows"`
	CleanedRows    int            `json:"cleaned_rows"`
	DroppedRows    int            `json:"dropped_rows"`
	DroppedReasons map[string]int `json:"dropped_reasons"`
}
 
func main() {
	input  := flag.String("input", "../../data/Dataset_Arreglado.csv", "CSV de entrada")
	output := flag.String("output", "../../data/cleaned_dataset.csv", "CSV de salida")
	report := flag.String("report", "cleaning_report.json", "Reporte JSON")
	flag.Parse()
 
	fmt.Printf("=== Limpieza Dataset INDECOPI ===\nInput : %s\nOutput: %s\n\n", *input, *output)
 
	inFile, err := os.Open(*input)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}
	defer inFile.Close()
 
	reader := csv.NewReader(inFile)
	reader.LazyQuotes = true
	reader.TrimLeadingSpace = true
 
	header, err := reader.Read()
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR leyendo header: %v\n", err)
		os.Exit(1)
	}
 
	idx := make(map[string]int)
	for i, col := range header {
		idx[strings.TrimSpace(col)] = i
	}
	for _, col := range []string{"USER_KEY", "TARGET_KEY", "TYPE_KEY", "TEXTO_RECLAMO"} {
		if _, ok := idx[col]; !ok {
			fmt.Fprintf(os.Stderr, "ERROR: columna %q no encontrada. Columnas: %v\n", col, header)
			os.Exit(1)
		}
	}
 
	outFile, err := os.Create(*output)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR creando output: %v\n", err)
		os.Exit(1)
	}
	defer outFile.Close()
 
	writer := csv.NewWriter(outFile)
	defer writer.Flush()
	writer.Write([]string{"USER_KEY", "TARGET_KEY", "TYPE_KEY", "TEXTO_RECLAMO"})
 
	dropped := map[string]int{
		"empty_user":   0,
		"empty_target": 0,
		"empty_type":   0,
		"empty_texto":  0,
		"texto_short":  0,
	}
	original, cleaned := 0, 0
 
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			continue
		}
		original++
 
		userKey   := normalizeKey(row[idx["USER_KEY"]])
		targetKey := strings.TrimSpace(row[idx["TARGET_KEY"]])
		typeKey   := normalizeKey(row[idx["TYPE_KEY"]])
		texto     := cleanTexto(row[idx["TEXTO_RECLAMO"]])
 
		if userKey == ""   { dropped["empty_user"]++;   continue }
		if targetKey == "" { dropped["empty_target"]++; continue }
		if typeKey == ""   { dropped["empty_type"]++;   continue }
		if texto == ""     { dropped["empty_texto"]++;  continue }
		if len(strings.Fields(texto)) < 5 {
			dropped["texto_short"]++
			continue
		}
 
		if !isValidRUC(targetKey) {
			targetKey = normalizeKey(targetKey)
		}
 
		writer.Write([]string{userKey, targetKey, typeKey, texto})
		cleaned++
 
		if cleaned%200_000 == 0 {
			fmt.Printf("  %d filas limpias...\n", cleaned)
		}
	}
 
	data, _ := json.MarshalIndent(Report{
		Timestamp:      time.Now().Format(time.RFC3339),
		InputFile:      *input,
		OutputFile:     *output,
		OriginalRows:   original,
		CleanedRows:    cleaned,
		DroppedRows:    original - cleaned,
		DroppedReasons: dropped,
	}, "", "  ")
	os.WriteFile(*report, data, 0644)
 
	fmt.Printf("\n=== Resumen ===\n")
	fmt.Printf("  Originales      : %d\n", original)
	fmt.Printf("  Limpias         : %d\n", cleaned)
	fmt.Printf("  Descartadas     : %d (%.1f%%)\n", original-cleaned, float64(original-cleaned)/float64(max(original, 1))*100)
	fmt.Printf("  Sin usuario     : %d\n", dropped["empty_user"])
	fmt.Printf("  Sin empresa     : %d\n", dropped["empty_target"])
	fmt.Printf("  Sin tipo        : %d\n", dropped["empty_type"])
	fmt.Printf("  Sin texto       : %d\n", dropped["empty_texto"])
	fmt.Printf("  Texto muy corto : %d\n", dropped["texto_short"])
	fmt.Printf("  Reporte: %s\n", *report)
}
 
func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}