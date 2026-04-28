package benchmark

import "github.com/PCC-Grupo-11/TB1-Trabajo-parcial/internal/model"

func newGlobalState() *model.GlobalState {
	return &model.GlobalState{
		UserCounts:   make(map[string]int),
		TargetCounts: make(map[string]int),
		PairCounts:   make(map[string]int),
		TypeCounts:   make(map[string]int),
	}
}

func pairKey(left string, right string) string {
	return left + " || " + right
}

func emptyDetectionResult() model.DetectionResult {
	return model.DetectionResult{
		SuspiciousUsers:   []string{},
		SuspiciousTargets: []string{},
		SuspiciousPairs:   []string{},
		SuspiciousTypes:   []string{},
	}
}
