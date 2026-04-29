package benchmark

import (
	"os"
	"time"

	"github.com/shirou/gopsutil/v4/process"
)

const rssSampleInterval = 10 * time.Millisecond

func newResourceReader() (func() (uint64, float64, error), error) {
	proc, err := process.NewProcess(int32(os.Getpid()))
	if err != nil {
		return nil, err
	}
	
	_, _ = proc.CPUPercent()

	return func() (uint64, float64, error) {
		memInfo, err := proc.MemoryInfo()
		if err != nil {
			return 0, 0, err
		}

		cpuPercent, err := proc.CPUPercent()
		if err != nil {
			return 0, 0, err
		}

		return memInfo.RSS, cpuPercent, nil
	}, nil
}

func runWithResourceSampling(
	fn func() error,
	resourceReader func() (uint64, float64, error),
) (elapsed time.Duration, maxRSS uint64, avgCPUPercent float64, runErr error) {
	baselineRSS, _, err := resourceReader()
	if err != nil {
		return 0, 0, 0, err
	}

	stop := make(chan struct{})
	resultCh := make(chan struct {
		maxRSS        uint64
		avgCPUPercent float64
	}, 1)

	go func() {
		max := baselineRSS
		totalCPU := 0.0
		samples := 0
		ticker := time.NewTicker(rssSampleInterval)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				rss, cpuPercent, sampleErr := resourceReader()
				if sampleErr == nil {
					max = maxUint64(max, rss)
					totalCPU += cpuPercent
					samples++
				}
			case <-stop:
				avg := 0.0
				if samples > 0 {
					avg = totalCPU / float64(samples)
				}

				resultCh <- struct {
					maxRSS        uint64
					avgCPUPercent float64
				}{
					maxRSS:        max,
					avgCPUPercent: avg,
				}
				return
			}
		}
	}()

	start := time.Now()
	runErr = fn()
	elapsed = time.Since(start)

	close(stop)
	result := <-resultCh
	maxRSS = result.maxRSS
	avgCPUPercent = result.avgCPUPercent

	return elapsed, maxRSS, avgCPUPercent, runErr
}

func maxUint64(a uint64, b uint64) uint64 {
	if a >= b {
		return a
	}
	return b
}
