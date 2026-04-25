package benchmark

import (
	"math/rand"
	"sync"
	"time"
)

func mockSequential() {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	sleepMs := 100 + r.Intn(201)
	totalBytes := (5 + r.Intn(16)) * 1024 * 1024

	time.Sleep(time.Duration(sleepMs) * time.Millisecond)
	allocateAndTouch(totalBytes)
}

func mockConcurrent(goroutines int) {
	if goroutines < 1 {
		return
	}

	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	totalSleepMs := 100 + r.Intn(201)
	totalBytes := (5 + r.Intn(16)) * 1024 * 1024

	baseSleep := totalSleepMs / goroutines
	extraSleep := totalSleepMs % goroutines
	baseBytes := totalBytes / goroutines
	extraBytes := totalBytes % goroutines

	var wg sync.WaitGroup
	wg.Add(goroutines)

	for i := 0; i < goroutines; i++ {
		idx := i
		go func() {
			defer wg.Done()

			sleepMs := baseSleep
			if idx < extraSleep {
				sleepMs++
			}
			if sleepMs > 0 {
				time.Sleep(time.Duration(sleepMs) * time.Millisecond)
			}

			bytesToAlloc := baseBytes
			if idx < extraBytes {
				bytesToAlloc++
			}
			if bytesToAlloc > 0 {
				allocateAndTouch(bytesToAlloc)
			}
		}()
	}

	wg.Wait()
}

func allocateAndTouch(size int) {
	if size <= 0 {
		return
	}

	data := make([]byte, size)
	for i := 0; i < len(data); i += 4096 {
		data[i] = byte(i)
	}
	data[0] ^= 1
	data[len(data)-1] ^= 1
}
