package benchmark

import (
	"os"
	"time"

	"github.com/shirou/gopsutil/v4/process"
)

const rssSampleInterval = 10 * time.Millisecond

func newRSSReader() (func() (uint64, error), error) {
	proc, err := process.NewProcess(int32(os.Getpid()))
	if err != nil {
		return nil, err
	}

	return func() (uint64, error) {
		memInfo, err := proc.MemoryInfo()
		if err != nil {
			return 0, err
		}

		return memInfo.RSS, nil
	}, nil
}

func runWithMaxRSSSampling(
	fn func() error,
	rssReader func() (uint64, error),
) (elapsed time.Duration, maxRSS uint64, runErr error) {
	baselineRSS, err := rssReader()
	if err != nil {
		return 0, 0, err
	}

	stop := make(chan struct{})
	maxRSSCh := make(chan uint64, 1)

	go func() {
		max := baselineRSS
		ticker := time.NewTicker(rssSampleInterval)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				rss, sampleErr := rssReader()
				if sampleErr == nil {
					max = maxUint64(max, rss)
				}
			case <-stop:
				maxRSSCh <- max
				return
			}
		}
	}()

	start := time.Now()
	runErr = fn()
	elapsed = time.Since(start)

	close(stop)
	maxRSS = <-maxRSSCh

	return elapsed, maxRSS, runErr
}

func maxUint64(a uint64, b uint64) uint64 {
	if a >= b {
		return a
	}
	return b
}
