package benchmark

import (
	"runtime"
	"time"
)

func Measure(fn func()) (timeMs float64, ramMB float64) {
	var m1 runtime.MemStats
	var m2 runtime.MemStats

	runtime.ReadMemStats(&m1)
	start := time.Now()
	fn()
	elapsed := time.Since(start)
	runtime.ReadMemStats(&m2)

	var allocDelta uint64
	if m2.Alloc >= m1.Alloc {
		allocDelta = m2.Alloc - m1.Alloc
	}

	timeMs = float64(elapsed.Nanoseconds()) / 1e6
	ramMB = float64(allocDelta) / (1024 * 1024)
	return timeMs, ramMB
}
