package system

import (
	"fmt"

	"github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"
	"github.com/shirou/gopsutil/v4/cpu"
	"github.com/shirou/gopsutil/v4/mem"
)

func GetInfo() (model.DeviceInfo, error) {
	cpuInfo, err := cpu.Info()
	if err != nil {
		return model.DeviceInfo{}, fmt.Errorf("get cpu info: %w", err)
	}
	if len(cpuInfo) == 0 {
		return model.DeviceInfo{}, fmt.Errorf("get cpu info: empty cpu info")
	}

	cores, err := cpu.Counts(true)
	if err != nil {
		return model.DeviceInfo{}, fmt.Errorf("get cpu cores: %w", err)
	}

	vm, err := mem.VirtualMemory()
	if err != nil {
		return model.DeviceInfo{}, fmt.Errorf("get memory info: %w", err)
	}

	return model.DeviceInfo{
		CPUName:      cpuInfo[0].ModelName,
		LogicalCores: cores,
		TotalRAMGB:   float64(vm.Total) / (1024 * 1024 * 1024),
	}, nil
}
