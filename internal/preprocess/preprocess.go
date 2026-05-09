package preprocess

import (
	"strings"
	"unicode"
)

var stopwords = map[string]bool{
	"de":     true,
	"la":     true,
	"el":     true,
	"los":    true,
	"las":    true,
	"y":      true,
	"o":      true,
	"con":    true,
	"sin":    true,
	"pero":   true,
	"ya":     true,
	"se":     true,
	"su":     true,
	"más":    true,
	"por":    true,
	"para":   true,
	"del":    true,
	"que":    true,
	"una":    true,
	"uno":    true,
	"unos":   true,
	"unas":   true,
	"al":     true,
	"es":     true,
	"en":     true,
	"un":     true,
}

func CleanText(text string) []string {
	text = strings.ToLower(text)
	words := strings.Fields(text)

	var cleanWords []string

	for _, word := range words {
		word = stripPunctuation(word)

		if word == "" {
			continue
		}

		if isNumeric(word) {
			continue
		}

		if len(word) <= 2 {
			continue
		}

		if stopwords[word] {
			continue
		}

		cleanWords = append(cleanWords, word)
	}

	return cleanWords
}

func ExtractBigrams(words []string) []string {
	var bigrams []string

	for i := 0; i < len(words)-1; i++ {
		bigram := words[i] + " " + words[i+1]
		bigrams = append(bigrams, bigram)
	}

	return bigrams
}

func stripPunctuation(word string) string {
	return strings.Trim(word, `.,;:!?()[]{}\"\' `)
}

func isNumeric(word string) bool {
	if word == "" {
		return false
	}
	for _, r := range word {
		if !unicode.IsDigit(r) {
			return false
		}
	}
	return true
}
