package benchmark

import (
	"fmt"
	"hash/fnv"
	"runtime"
	"sync"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/stats"
)

const fixedShardCount = 16

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

	var finalDetection model.DetectionResult
	iterations, err := runIterations(cfg.Runs, func() (float64, model.MemoryMetrics, error) {
		runtime.GC()

		detection, timeMs, memory, err := runConcurrentIteration(cfg.Input, cfg.Goroutines)
		if err != nil {
			return 0, model.MemoryMetrics{}, err
		}

		finalDetection = detection
		return timeMs, memory, nil
	})
	if err != nil {
		return nil, emptyDetectionResult(), err
	}

	return iterations, finalDetection, nil
}

func runConcurrentIteration(inputPath string, goroutines int) (model.DetectionResult, float64, model.MemoryMetrics, error) {
	shards := newShards(fixedShardCount)
	detection := emptyDetectionResult()

	timeMs, memory, err := Measure(func() error {
		records := make(chan model.Record, goroutines*10)
		errCh := make(chan error, 1)

		go func() {
			errCh <- StreamRecords(inputPath, records)
			close(errCh)
		}()

		var wg sync.WaitGroup
		wg.Add(goroutines)
		for i := 0; i < goroutines; i++ {
			go func() {
				defer wg.Done()
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
			}()
		}

		wg.Wait()

		if err := <-errCh; err != nil {
			return err
		}

		userC, targetC, pairC, _ := stats.MergeShards(shards)
		detection = stats.DetectAnomalies(userC, targetC, pairC)
		return nil
	})
	if err != nil {
		return emptyDetectionResult(), 0, model.MemoryMetrics{}, err
	}

	return detection, timeMs, memory, nil
}

func newShards(k int) []*model.Shard {
	if k < 1 {
		k = 1
	}

	shards := make([]*model.Shard, 0, k)
	for i := 0; i < k; i++ {
		shards = append(shards, &model.Shard{
			CountSet: *newCountSet(),
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
