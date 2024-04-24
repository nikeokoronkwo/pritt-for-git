package main

import (
	"fmt"
	"os"
	"path/filepath"
	"pritt/pritt"
)

func main() {
	// Get the files e.g from arguments
	args := os.Args

	// Ensure there are two (or more) arguments
	if len(args) <= 1 {
		err := fmt.Errorf("provide an argument to get started")
		fmt.Println("Error: ", err)
		os.Exit(1)
	}

	// Get the absolute path
	dir, err := filepath.Abs(args[1])
	if err != nil {
		fmt.Println("Error: ", err)
		os.Exit(1)
	}

	// Get git info
	gitProject, err := pritt.GetGitInfo(dir)
	if err != nil {
		fmt.Println("Error: ", err)
		os.Exit(1)
	}
	fmt.Println(gitProject.HEAD.Ref.Commits)
	os.Exit(0)
}
