package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	pritt "./package"
)

func main() {
	var project pritt.GitProject

	// Get the files e.g from arguments
	args := os.Args

	// Ensure there are two (or more) arguments
	if len(args) <= 1 {
		/* err := fmt.Errorf("provide an argument to get started")
		fmt.Println("Error: ", err) */
		os.Exit(1)
	}

	if args[1] == "--help" {
		fmt.Println("pritt-git [options] <directory>")
		os.Exit(0)
	}

	// Get the absolute path
	dir, err := filepath.Abs(args[1])
	if err != nil {
		// fmt.Println("Error: ", err)
		os.Exit(1)
	}

	// Get git info
	project, err = pritt.GetGitInfo(dir)
	if err != nil {
		// fmt.Println("Error: ", err)
		os.Exit(1)
	}

	if len(args) > 2 {
		fmt.Println(args)
		if args[2] == "--json" {
			jsonRaw, err := json.Marshal(pritt.ConvertToExport(project))
			if err != nil {
				// fmt.Println("Error marshalling: ", err)
				os.Exit(1)
			}
			fmt.Print(string(jsonRaw))
		} else if !strings.Contains(args[2], "-") {
			output, err := filepath.Abs(args[2])
			if err != nil {
				// fmt.Println("Error: ", err)
				os.Exit(1)
			}
			jsonRaw, err := json.Marshal(pritt.ConvertToExport(project))
			if err != nil {
				// fmt.Println("Error marshalling: ", err)
				os.Exit(1)
			}
			os.WriteFile(output, jsonRaw, 0644)
		} else {
			// fmt.Println("Error: Operation not supported")
			os.Exit(2)
		}
	} else {
		fmt.Print(project)
	}
}
