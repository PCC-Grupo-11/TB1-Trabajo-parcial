package cli

import (
	"flag"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

const (
	defaultRuns    = 1
	defaultWorkers = 4
	defaultBigrams = "data/top_200_bigrams.json"
)

func usageText(mode string) string {
	if mode == "sequential" {
		return fmt.Sprintf(`Usage:
	sequential -i <dataset.csv> [-n runs]
	sequential --input <dataset.csv> [--runs runs] [--bigrams file]

Flags:
  -i, --input        Required. Dataset path
  -n, --runs         Optional. Number of iterations (default %d)
  -b, --bigrams      Optional. Bigram JSON path (default %s)
`, defaultRuns, defaultBigrams)
	}
	return fmt.Sprintf(`Usage:
	concurrent -i <dataset.csv> [-n runs] [-w workers]
	concurrent --input <dataset.csv> [--runs runs] [--workers workers] [--bigrams file]

Flags:
  -i, --input        Required. Dataset path
  -n, --runs         Optional. Number of iterations (default %d)
  -w, --workers      Optional. Number of workers (default %d)
  -b, --bigrams      Optional. Bigram JSON path (default %s)
`, defaultRuns, defaultWorkers, defaultBigrams)
}

type stringFlag struct {
	value  string
	wasSet bool
}

func (s *stringFlag) String() string {
	return s.value
}

func (s *stringFlag) Set(value string) error {
	s.value = value
	s.wasSet = true
	return nil
}

type intFlag struct {
	value  int
	wasSet bool
}

func (i *intFlag) String() string {
	return fmt.Sprintf("%d", i.value)
}

func (i *intFlag) Set(value string) error {
	parsed, err := strconv.Atoi(value)
	if err != nil {
		return fmt.Errorf("invalid integer value %q", value)
	}
	i.value = parsed
	i.wasSet = true
	return nil
}

func Parse(mode string) (model.Config, error) {
	return ParseArgs(os.Args[1:], mode)
}

func ParseArgs(args []string, mode string) (model.Config, error) {
	fs := flag.NewFlagSet(mode, flag.ContinueOnError)
	fs.SetOutput(io.Discard)

	inputFlag := &stringFlag{}
	runsFlag := &intFlag{value: defaultRuns}
	workersFlag := &intFlag{value: defaultWorkers}
	bigramsFlag := &stringFlag{value: defaultBigrams}

	registerFlag(fs, inputFlag, "i", "input", "dataset path")
	registerFlag(fs, runsFlag, "n", "runs", "number of runs")
	registerFlag(fs, bigramsFlag, "b", "bigrams", "bigram JSON path")

	if mode == "concurrent" {
		registerFlag(fs, workersFlag, "w", "workers", "number of workers")
	}

	if err := fs.Parse(args); err != nil {
		return model.Config{}, fmt.Errorf("%w\n\n%s", err, usageText(mode))
	}

	if !inputFlag.wasSet || strings.TrimSpace(inputFlag.value) == "" {
		return model.Config{}, fmt.Errorf("input is required\n\n%s", usageText(mode))
	}

	if runsFlag.value < 1 {
		return model.Config{}, fmt.Errorf("runs must be >= 1")
	}

	cfg := model.Config{
		Mode:        mode,
		Input:       strings.TrimSpace(inputFlag.value),
		Runs:        runsFlag.value,
		BigramsPath: strings.TrimSpace(bigramsFlag.value),
	}

	switch mode {
	case "sequential":
		cfg.Workers = -1
	case "concurrent":
		if workersFlag.value < 1 {
			return model.Config{}, fmt.Errorf("workers must be >= 1")
		}
		cfg.Workers = workersFlag.value
	default:
		return model.Config{}, fmt.Errorf("invalid mode %q", mode)
	}

	return cfg, nil
}

func registerFlag(fs *flag.FlagSet, value flag.Value, shortName string, longName string, usage string) {
	fs.Var(value, shortName, usage)
	fs.Var(value, longName, usage)
}
