package benchmark

import (
	"fmt"
	"os"
	"runtime"
	"time"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	"github.com/shirou/gopsutil/v4/process"
)

const (
	bytesPerMB        = 1024 * 1024
	rssSampleInterval = 10 * time.Millisecond
)

func Measure(fn func() error) (timeMs float64, memory model.MemoryMetrics, err error) {
	beforeHeap := readHeapAllocBytes()
	beforeRSS, err := readProcessRSSBytes()
	if err != nil {
		return 0, model.MemoryMetrics{}, fmt.Errorf("read process rss before run: %w", err)
	}

	peakRSS := beforeRSS
	done := make(chan struct{})
	stopped := make(chan struct{})

	go func() {
		ticker := time.NewTicker(rssSampleInterval)
		defer ticker.Stop()
		defer close(stopped)

		for {
			select {
			case <-ticker.C:
				rss, sampleErr := readProcessRSSBytes()
				if sampleErr == nil && rss > peakRSS {
					peakRSS = rss
				}
			case <-done:
				return
			}
		}
	}()

	start := time.Now()
	runErr := fn()
	elapsed := time.Since(start)
	timeMs = float64(elapsed.Nanoseconds()) / 1e6

	close(done)
	<-stopped

	afterHeap := readHeapAllocBytes()

	afterRSS, rssErr := readProcessRSSBytes()
	if rssErr != nil {
		if runErr != nil {
			return timeMs, model.MemoryMetrics{}, runErr
		}
		return timeMs, model.MemoryMetrics{}, fmt.Errorf("read process rss after run: %w", rssErr)
	}

	if afterRSS > peakRSS {
		peakRSS = afterRSS
	}

	memory = model.MemoryMetrics{
		HeapAllocMB: toDeltaMB(beforeHeap, afterHeap),
		RSSDeltaMB:  toDeltaMB(beforeRSS, afterRSS),
		PeakRSSMB:   float64(peakRSS) / bytesPerMB,
	}

	return timeMs, memory, runErr
}

func readProcessRSSBytes() (uint64, error) {
	proc, err := process.NewProcess(int32(os.Getpid()))
	if err != nil {
		return 0, err
	}

	memInfo, err := proc.MemoryInfo()
	if err != nil {
		return 0, err
	}

	return memInfo.RSS, nil
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
