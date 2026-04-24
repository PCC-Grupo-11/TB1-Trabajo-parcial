package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"regexp"
	"strings"
	"time"
)

func cleanText(text string) string {
	text = strings.ToLower(text)

	re := regexp.MustCompile(`[^\w\s]`)
	text = re.ReplaceAllString(text, "")

	text = strings.TrimSpace(text)
	return text
}

func main() {

	inputFile := "../sampling/content/yelp_review_sample_100k.csv"
	outputFile := "yelp_cleaned_go.csv"

	file, err := os.Open(inputFile)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)

	rows, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	out, err := os.Create(outputFile)
	if err != nil {
		panic(err)
	}
	defer out.Close()

	writer := csv.NewWriter(out)
	defer writer.Flush()

	writer.Write([]string{
		"review_id", "user_id", "stars",
		"text", "text_clean",
		"text_len", "date",
	})

	headers := rows[0]

	reviewIdx := -1
	userIdx := -1
	textIdx := -1
	dateIdx := -1
	starsIdx := -1

	for i, col := range headers {
		switch col {
		case "review_id":
			reviewIdx = i
		case "user_id":
			userIdx = i
		case "text":
			textIdx = i
		case "date":
			dateIdx = i
		case "stars":
			starsIdx = i
		}
	}

	if reviewIdx == -1 || userIdx == -1 || textIdx == -1 || dateIdx == -1 || starsIdx == -1 {
		panic("Faltan columnas necesarias en el CSV")
	}

	count := 0

	for _, row := range rows[1:] {

		text := row[textIdx]
		if text == "" {
			continue
		}

		dateStr := row[dateIdx]

		_, err := time.Parse("2006-01-02 15:04:05", dateStr)
		if err != nil {
			_, err = time.Parse("2006-01-02", dateStr)
			if err != nil {
				continue
			}
		}

		clean := cleanText(text)

		writer.Write([]string{
			row[reviewIdx],
			row[userIdx],
			row[starsIdx],
			text,
			clean,
			fmt.Sprintf("%d", len(clean)),
			dateStr,
		})

		count++

		if count%10000 == 0 {
			fmt.Println("Procesados:", count)
		}
	}

	fmt.Println("TOTAL LIMPIOS:", count)
	fmt.Println("Archivo generado:", outputFile)
}
