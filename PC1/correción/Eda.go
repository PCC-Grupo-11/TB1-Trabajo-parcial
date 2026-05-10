package main
 
import (
	"encoding/csv"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"sort"
	"strings"
	"time"
)
 
var keywords = []string{
	"me dirijo a usted", "por medio de la presente", "mediante la presente",
	"a quien corresponda", "hago de su conocimiento", "pongo en su conocimiento",
	"el suscrito", "la suscrita", "respetuosamente", "atentamente solicito",
	"sirvase", "de conformidad con", "en merito a lo expuesto",
	"en virtud de lo expuesto", "no obstante ello", "sin perjuicio de lo expuesto",
	"en ese sentido", "estando a lo expuesto", "me negaron", "no me quisieron",
	"producto defectuoso", "garantia", "devolucion", "reembolso",
	"solicito la devolucion", "exijo la devolucion", "incumplimiento", "vulneracion",
	"es todo cuanto tengo que decir", "es cuanto tengo que informar",
	"quedo en espera de su respuesta", "quedo a su disposicion",
	"en espera de una pronta",
}
 
var accentMap = strings.NewReplacer(
	"á", "a", "é", "e", "í", "i", "ó", "o", "ú", "u", "ü", "u", "ñ", "n",
	"Á", "a", "É", "e", "Í", "i", "Ó", "o", "Ú", "u", "Ñ", "n",
)
 
func normalize(s string) string {
	return accentMap.Replace(strings.ToLower(s))
}
 
func countKeywords(text string) int {
	norm := normalize(text)
	n := 0
	for _, kw := range keywords {
		if strings.Contains(norm, kw) {
			n++
		}
	}
	return n
}
 
func isBot(text string) bool { return countKeywords(text) >= 3 }
 
type TopEntry struct {
	Key   string `json:"key"`
	Count int    `json:"count"`
}
 
type EDAReport struct {
	Timestamp              string     `json:"timestamp"`
	InputFile              string     `json:"input_file"`
	TotalRows              int        `json:"total_rows"`
	UniqueUsers            int        `json:"unique_users"`
	UniqueTargets          int        `json:"unique_targets"`
	UniqueTypes            int        `json:"unique_types"`
	AvgTextLengthChars     float64    `json:"avg_text_length_chars"`
	AvgWords               float64    `json:"avg_words"`
	BotCount               int        `json:"bot_count"`
	HumanCount             int        `json:"human_count"`
	BotPercent             float64    `json:"bot_percent"`
	AvgKeywordsBot         float64    `json:"avg_keywords_bot"`
	TypeDistribution       []TopEntry `json:"type_distribution"`
	TopTargetsByComplaints []TopEntry `json:"top_targets_by_complaints"`
	TopUsersByComplaints   []TopEntry `json:"top_users_by_complaints"`
}
 
func topN(m map[string]int, n int) []TopEntry {
	entries := make([]TopEntry, 0, len(m))
	for k, v := range m {
		entries = append(entries, TopEntry{k, v})
	}
	sort.Slice(entries, func(i, j int) bool { return entries[i].Count > entries[j].Count })
	if len(entries) > n {
		return entries[:n]
	}
	return entries
}
 
func bar(label string, count, total, width int) {
	pct := 0.0
	if total > 0 {
		pct = float64(count) / float64(total) * 100
	}
	filled := int(pct / 100 * float64(width))
	if filled > width {
		filled = width
	}
	fmt.Printf("  %-32s %s%s %7d (%.1f%%)\n",
		trunc(label, 32),
		strings.Repeat("█", filled),
		strings.Repeat("░", width-filled),
		count, pct)
}
 
func trunc(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n-3] + "..."
}
 
func main() {
	input  := flag.String("input", "../../data/Dataset_Arreglado.csv", "CSV a analizar")
	report := flag.String("report", "eda_report.json", "Reporte JSON")
	topK   := flag.Int("top", 10, "Top N en rankings")
	flag.Parse()
 
	fmt.Printf("=== EDA Dataset INDECOPI ===\nInput: %s\n\n", *input)
 
	file, err := os.Open(*input)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()
 
	reader := csv.NewReader(file)
	reader.LazyQuotes = true
	reader.TrimLeadingSpace = true
 
	header, err := reader.Read()
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR leyendo header: %v\n", err)
		os.Exit(1)
	}
 
	colIdx := make(map[string]int)
	for i, col := range header {
		colIdx[strings.TrimSpace(col)] = i
	}
	for _, col := range []string{"USER_KEY", "TARGET_KEY", "TYPE_KEY", "TEXTO_RECLAMO"} {
		if _, ok := colIdx[col]; !ok {
			fmt.Fprintf(os.Stderr, "ERROR: columna %q no encontrada. Columnas: %v\n", col, header)
			os.Exit(1)
		}
	}
 
	userCounts   := make(map[string]int)
	targetCounts := make(map[string]int)
	typeCounts   := make(map[string]int)
 
	total, botCount, humanCount  := 0, 0, 0
	totalChars, totalWords, kwBot := 0, 0, 0
 
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			continue
		}
 
		user   := strings.TrimSpace(row[colIdx["USER_KEY"]])
		target := strings.TrimSpace(row[colIdx["TARGET_KEY"]])
		typ    := strings.TrimSpace(row[colIdx["TYPE_KEY"]])
		texto  := strings.TrimSpace(row[colIdx["TEXTO_RECLAMO"]])
 
		total++
		userCounts[user]++
		targetCounts[target]++
		typeCounts[typ]++
		totalChars += len(texto)
		totalWords += len(strings.Fields(texto))
 
		kw := countKeywords(texto)
		if isBot(texto) {
			botCount++
			kwBot += kw
		} else {
			humanCount++
		}
 
		if total%200_000 == 0 {
			fmt.Printf("  Analizadas %d filas...\n", total)
		}
	}
 
	avgChars, avgWords, avgKwBot, botPct := 0.0, 0.0, 0.0, 0.0
	if total > 0 {
		avgChars = float64(totalChars) / float64(total)
		avgWords = float64(totalWords) / float64(total)
		botPct   = float64(botCount) / float64(total) * 100
	}
	if botCount > 0 {
		avgKwBot = float64(kwBot) / float64(botCount)
	}
 
	fmt.Printf("\n╔══════════════════════════════════════════╗\n")
	fmt.Printf("║       RESULTADOS EDA — INDECOPI          ║\n")
	fmt.Printf("╚══════════════════════════════════════════╝\n\n")
 
	fmt.Printf("── General ──────────────────────────────────\n")
	fmt.Printf("  Total filas        : %d\n", total)
	fmt.Printf("  Usuarios únicos    : %d\n", len(userCounts))
	fmt.Printf("  Empresas únicas    : %d\n", len(targetCounts))
	fmt.Printf("  Tipos únicos       : %d\n\n", len(typeCounts))
 
	fmt.Printf("── Texto de Reclamo ─────────────────────────\n")
	fmt.Printf("  Avg caracteres     : %.1f\n", avgChars)
	fmt.Printf("  Avg palabras       : %.1f\n\n", avgWords)
 
	fmt.Printf("── Detección de Spam Robótico (umbral >= 3 keywords) ──\n")
	bar("Bot (spam robótico)", botCount,   total, 30)
	bar("Humano",              humanCount, total, 30)
	fmt.Printf("  Avg keywords (bot) : %.1f\n\n", avgKwBot)
 
	fmt.Printf("── Top %d Tipos de Expediente ───────────────\n", *topK)
	for _, e := range topN(typeCounts, *topK) {
		bar(e.Key, e.Count, total, 25)
	}
 
	fmt.Printf("\n── Top %d Empresas más reclamadas ───────────\n", *topK)
	for i, e := range topN(targetCounts, *topK) {
		fmt.Printf("  %2d. %-38s %d\n", i+1, trunc(e.Key, 38), e.Count)
	}
 
	fmt.Printf("\n── Top %d Usuarios con más reclamos ─────────\n", *topK)
	for i, e := range topN(userCounts, *topK) {
		fmt.Printf("  %2d. %-38s %d\n", i+1, trunc(e.Key, 38), e.Count)
	}
 
	data, _ := json.MarshalIndent(EDAReport{
		Timestamp:              time.Now().Format(time.RFC3339),
		InputFile:              *input,
		TotalRows:              total,
		UniqueUsers:            len(userCounts),
		UniqueTargets:          len(targetCounts),
		UniqueTypes:            len(typeCounts),
		AvgTextLengthChars:     avgChars,
		AvgWords:               avgWords,
		BotCount:               botCount,
		HumanCount:             humanCount,
		BotPercent:             botPct,
		AvgKeywordsBot:         avgKwBot,
		TypeDistribution:       topN(typeCounts, *topK),
		TopTargetsByComplaints: topN(targetCounts, *topK),
		TopUsersByComplaints:   topN(userCounts, *topK),
	}, "", "  ")
	os.WriteFile(*report, data, 0644)
	fmt.Printf("\n  Reporte guardado: %s\n", *report)
}