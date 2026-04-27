package benchmark

import (
	"fmt"
	"hash/fnv"
	"runtime"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

const fixedShardCount = 16

func RunSequential(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	if cfg.Runs < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("runs must be >= 1")
	}
	if cfg.Mode != "sequential" {
		return nil, emptyDetectionResult(), fmt.Errorf("RunSequential requires mode=sequential")
	}

	iterations := make([]model.Iteration, 0, cfg.Runs)
	for i := 0; i < cfg.Runs; i++ {
		runtime.GC()

		_, timeMs, ramMB, err := runSequentialIteration(cfg.Input)
		if err != nil {
			return nil, emptyDetectionResult(), err
		}

		iterations = append(iterations, model.Iteration{
			Iteration: i + 1,
			TimeMs:    timeMs,
			RamMB:     ramMB,
		})
	}

	return iterations, emptyDetectionResult(), nil
}

func RunConcurrent(cfg model.Config) ([]model.Iteration, model.DetectionResult, error) {
	if cfg.Runs < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("runs must be >= 1")
	}
	if cfg.Mode != "concurrent" {
		return nil, emptyDetectionResult(), fmt.Errorf("RunConcurrent requires mode=concurrent")
	}
	if cfg.Goroutines < 1 {
		return nil, emptyDetectionResult(), fmt.Errorf("goroutines must be >= 1 for concurrent mode")
	}

	iterations := make([]model.Iteration, 0, cfg.Runs)
	for i := 0; i < cfg.Runs; i++ {
		runtime.GC()

		_, timeMs, ramMB, err := runConcurrentIteration(cfg.Input, cfg.Goroutines)
		if err != nil {
			return nil, emptyDetectionResult(), err
		}

		iterations = append(iterations, model.Iteration{
			Iteration: i + 1,
			TimeMs:    timeMs,
			RamMB:     ramMB,
		})
	}

	return iterations, emptyDetectionResult(), nil
}

func runSequentialIteration(inputPath string) (*countMaps, float64, float64, error) {
	counts := newCountMaps()
	timeMs, ramMB, err := MeasureWithError(func() error {
		records := make(chan model.Record, 1024)
		errCh := make(chan error, 1)

		go func() {
			errCh <- StreamRecords(inputPath, records)
			close(errCh)
		}()

		for record := range records {
			counts.UserCounts[record.UserKey]++
			counts.TargetCounts[record.TargetKey]++
			counts.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
			counts.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
		}

		if err := <-errCh; err != nil {
			return err
		}

		return nil
	})
	if err != nil {
		return nil, 0, 0, err
	}

	return counts, timeMs, ramMB, nil
}

func runConcurrentIteration(inputPath string, goroutines int) ([]*model.Shard, float64, float64, error) {
	shards := newShards(fixedShardCount)

	timeMs, ramMB, err := MeasureWithError(func() error {
		records := make(chan model.Record, goroutines*10)
		errCh := make(chan error, 1)
		workersDone := make(chan struct{})

		go func() {
			errCh <- StreamRecords(inputPath, records)
			close(errCh)
		}()

		for i := 0; i < goroutines; i++ {
			go func() {
				for record := range records {
					idx := shardIndex(record.UserKey, len(shards))
					shard := shards[idx]

					shard.Mu.Lock()
					shard.UserCounts[record.UserKey]++
					shard.TargetCounts[record.TargetKey]++
					shard.PairCounts[pairKey(record.UserKey, record.TargetKey)]++
					shard.TypeCounts[pairKey(record.UserKey, record.TypeKey)]++
					shard.Mu.Unlock()
				}
				workersDone <- struct{}{}
			}()
		}

		for i := 0; i < goroutines; i++ {
			<-workersDone
		}

		if err := <-errCh; err != nil {
			return err
		}

		return nil
	})
	if err != nil {
		return nil, 0, 0, err
	}

	return shards, timeMs, ramMB, nil
}

type countMaps struct {
	UserCounts   map[string]int
	TargetCounts map[string]int
	PairCounts   map[string]int
	TypeCounts   map[string]int
}

func newCountMaps() *countMaps {
	return &countMaps{
		UserCounts:   make(map[string]int),
		TargetCounts: make(map[string]int),
		PairCounts:   make(map[string]int),
		TypeCounts:   make(map[string]int),
	}
}

func newShards(k int) []*model.Shard {
	if k < 1 {
		k = 1
	}

	shards := make([]*model.Shard, 0, k)
	for i := 0; i < k; i++ {
		shards = append(shards, &model.Shard{
			UserCounts:   make(map[string]int),
			TargetCounts: make(map[string]int),
			PairCounts:   make(map[string]int),
			TypeCounts:   make(map[string]int),
		})
	}

	return shards
}

func shardIndex(userKey string, shardCount int) int {
	if shardCount <= 1 {
		return 0
	}

	h := fnv.New32a()
	_, _ = h.Write([]byte(userKey))
	return int(h.Sum32() % uint32(shardCount))
}

func pairKey(left string, right string) string {
	return left + "|" + right
}

func emptyDetectionResult() model.DetectionResult {
	return model.DetectionResult{
		SuspiciousUsers:   []string{},
		SuspiciousTargets: []string{},
		SuspiciousPairs:   []string{},
	}
}
