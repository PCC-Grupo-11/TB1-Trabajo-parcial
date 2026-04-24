package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	filePath := "../sampling/content/yelp_review_sample_100k.csv"

	file, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	data, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	headers := data[0]
	rows := data[1:]

	fmt.Println("Filas:", len(rows))
	fmt.Println("Columnas:", len(headers))

	// encontrar columnas clave
	textIdx := -1
	starsIdx := -1

	for i, col := range headers {
		if col == "text" {
			textIdx = i
		}
		if col == "stars" {
			starsIdx = i
		}
	}

	if textIdx == -1 {
		panic("No existe columna text")
	}

	// 📊 estadísticas
	totalWords := 0
	totalChars := 0
	totalStars := 0.0
	validStars := 0

	for _, row := range rows {
		text := row[textIdx]

		words := strings.Fields(text)
		totalWords += len(words)
		totalChars += len(text)

		if starsIdx != -1 {
			val, err := strconv.ParseFloat(row[starsIdx], 64)
			if err == nil {
				totalStars += val
				validStars++
			}
		}
	}

	fmt.Println("Promedio palabras por review:", float64(totalWords)/float64(len(rows)))
	fmt.Println("Promedio caracteres por review:", float64(totalChars)/float64(len(rows)))

	if validStars > 0 {
		fmt.Println("Promedio estrellas:", totalStars/float64(validStars))
	}

	if starsIdx != -1 {
		countStars := make(map[string]int)

		for _, row := range rows {
			countStars[row[starsIdx]]++
		}

		fmt.Println("\nDistribución de estrellas:")
		for k, v := range countStars {
			fmt.Println("Stars:", k, "->", v)
		}
	}

	wordFreq := make(map[string]int)

	for _, row := range rows {
		text := strings.ToLower(row[textIdx])
		words := strings.Fields(text)

		for _, w := range words {
			if len(w) > 3 { // filtrar palabras muy cortas
				wordFreq[w]++
			}
		}
	}

	fmt.Println("\nTop palabras:")
	count := 0
	for word, freq := range wordFreq {
		fmt.Println(word, ":", freq)
		count++
		if count >= 20 {
			break
		}
	}
}
