package pritt

import (
	"fmt"
	"strings"
)

// An enum type to represent the type of a git log/commit
type HeadLogType int

const (
	// Represents a commit log
	Commit HeadLogType = iota

	// Represents a checkout log
	Checkout

	// Represents a branch log
	Branch
)

// Converts a git log as a string to a HeadLogType
func returnGitLog(str string) (HeadLogType, error) {
	if strings.Contains(str, "commit") {
		return Commit, nil
	} else if strings.Contains(str, "checkout") {
		return Checkout, nil
	} else if strings.Contains(str, "branch") {
		return Branch, nil
	} else {
		return -1, fmt.Errorf("unknown commit type")
	}
}
