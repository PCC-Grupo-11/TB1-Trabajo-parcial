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
	defaultRuns       = 1
	defaultGoroutines = 4
)

var usageText = fmt.Sprintf(`Usage:
	benchmark -m <sequential|concurrent> -i <dataset.csv> [-n runs] [-g goroutines]
	benchmark --mode <sequential|concurrent> --input <dataset.csv> [--runs runs] [--goroutines goroutines]

Flags:
  -m, --mode         Required. Execution mode: sequential|concurrent
  -i, --input        Required. Dataset path
  -n, --runs         Optional. Number of iterations (default %d)
  -g, --goroutines   Optional. Number of goroutines (default %d)
`, defaultRuns, defaultGoroutines)

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

func Parse() (model.Config, error) {
	return ParseArgs(os.Args[1:])
}

func ParseArgs(args []string) (model.Config, error) {
	fs := flag.NewFlagSet("benchmark", flag.ContinueOnError)
	fs.SetOutput(io.Discard)

	modeFlag := &stringFlag{}
	inputFlag := &stringFlag{}
	runsFlag := &intFlag{value: defaultRuns}
	goroutinesFlag := &intFlag{value: defaultGoroutines}

	registerFlag(fs, modeFlag, "m", "mode", "execution mode")
	registerFlag(fs, inputFlag, "i", "input", "dataset path")
	registerFlag(fs, runsFlag, "n", "runs", "number of runs")
	registerFlag(fs, goroutinesFlag, "g", "goroutines", "number of goroutines")

	if err := fs.Parse(args); err != nil {
		return model.Config{}, fmt.Errorf("%w\n\n%s", err, usageText)
	}

	if !modeFlag.wasSet || strings.TrimSpace(modeFlag.value) == "" {
		return model.Config{}, fmt.Errorf("mode is required\n\n%s", usageText)
	}

	mode := strings.ToLower(strings.TrimSpace(modeFlag.value))
	if mode != "sequential" && mode != "concurrent" {
		return model.Config{}, fmt.Errorf("invalid mode %q; expected sequential|concurrent\n\n%s", modeFlag.value, usageText)
	}

	if !inputFlag.wasSet || strings.TrimSpace(inputFlag.value) == "" {
		return model.Config{}, fmt.Errorf("input is required\n\n%s", usageText)
	}

	if runsFlag.value < 1 {
		return model.Config{}, fmt.Errorf("runs must be >= 1")
	}

	cfg := model.Config{
		Mode:  mode,
		Input: strings.TrimSpace(inputFlag.value),
		Runs:  runsFlag.value,
	}

	switch mode {
	case "sequential":
		if goroutinesFlag.wasSet {
			return model.Config{}, fmt.Errorf("goroutines is only valid in concurrent mode")
		}
		cfg.Goroutines = 0
	case "concurrent":
		if goroutinesFlag.value < 1 {
			return model.Config{}, fmt.Errorf("goroutines must be >= 1")
		}
		cfg.Goroutines = goroutinesFlag.value
	}

	return cfg, nil
}

func registerFlag(fs *flag.FlagSet, value flag.Value, shortName string, longName string, usage string) {
	fs.Var(value, shortName, usage)
	fs.Var(value, longName, usage)
}
