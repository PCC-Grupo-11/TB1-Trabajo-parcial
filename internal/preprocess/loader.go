package preprocess

import (
	"encoding/json"
	"os"
)

func LoadBigrams(path string) (map[string]bool, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}

	var bigrams []string
	err = json.Unmarshal(data, &bigrams)
	if err != nil {
		return nil, err
	}

	bigramsSet := make(map[string]bool, len(bigrams))
	for _, bigram := range bigrams {
		bigramsSet[bigram] = true
	}

	return bigramsSet, nil
}
