package benchmark

import (
	"fmt"
	"runtime"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
)

const bytesPerMB = 1024 * 1024

func Measure(fn func() error) (timeMs float64, memory model.MemoryMetrics, err error) {
	beforeHeap := readHeapAllocBytes()

	rssReader, err := newRSSReader()
	if err != nil {
		return 0, model.MemoryMetrics{}, fmt.Errorf("create process rss reader: %w", err)
	}

	beforeRSS, err := rssReader()
	if err != nil {
		return 0, model.MemoryMetrics{}, fmt.Errorf("read process rss before run: %w", err)
	}

	elapsed, peakRSS, runErr := runWithPeakRSSSampling(fn, beforeRSS, rssReader)
	timeMs = float64(elapsed.Nanoseconds()) / 1e6

	afterHeap := readHeapAllocBytes()

	afterRSS, rssErr := rssReader()
	if rssErr != nil {
		if runErr != nil {
			return timeMs, model.MemoryMetrics{}, runErr
		}
		return timeMs, model.MemoryMetrics{}, fmt.Errorf("read process rss after run: %w", rssErr)
	}

	peakRSS = maxUint64(peakRSS, afterRSS)

	memory = model.MemoryMetrics{
		HeapAllocMB: toDeltaMB(beforeHeap, afterHeap),
		RSSDeltaMB:  toDeltaMB(beforeRSS, afterRSS),
		PeakRSSMB:   float64(peakRSS) / bytesPerMB,
	}

	return timeMs, memory, runErr
}

func readHeapAllocBytes() uint64 {
	var memStats runtime.MemStats
	runtime.ReadMemStats(&memStats)
	return memStats.Alloc
}

func toDeltaMB(before uint64, after uint64) float64 {
	if after < before {
		return 0
	}

	return float64(after-before) / bytesPerMB
}
