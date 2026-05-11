package preprocess

func IsSpam(text string, bigramsSet map[string]bool) bool {
	count := CountMatchingBigrams(text, bigramsSet)
	return count >= 4
}

func CountMatchingBigrams(text string, bigramsSet map[string]bool) int {
	words := CleanText(text)
	textBigrams := ExtractBigrams(words)
	
	count := 0
	for _, bigram := range textBigrams {
		if bigramsSet[bigram] {
			count++
		}
	}

	return count
}
