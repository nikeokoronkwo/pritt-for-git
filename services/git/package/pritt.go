package pritt

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// Main function to extract the information about a git commit and return a GitProject for it
func GetGitInfo(dir string) (GitProject, error) {
	// Initialise a git project
	var gitProject GitProject = GitProject{}
	gitDir := fmt.Sprintf("%s/%s", dir, ".git")

	if _, err := os.Stat(gitDir); os.IsNotExist(err) {
		return GitProject{}, err
	}
	// Walk through git directory
	err := filepath.WalkDir(gitDir, func(path string, dir fs.DirEntry, err error) error {
		// Process HEAD info
		if dir.Name() == "HEAD" && path == fmt.Sprintf("%s/HEAD", gitDir) {
			data, err := os.ReadFile(path)
			if err != nil {
				return fmt.Errorf("error reading from HEAD: %w", err)
			}
			headData := string(data)
			gitProject.HEAD, err = processHead(gitDir, headData)
			if err != nil {
				return fmt.Errorf("error processing HEAD data: %w", err)
			}
			gitProject.MainBranch = gitProject.HEAD.Ref.Name
			refInList := false
			for i, x := range gitProject.Branches {
				if x.Name == gitProject.HEAD.Ref.Name {
					gitProject.HEAD.Ref.Commits = x.Commits
					gitProject.Branches[i] = *gitProject.HEAD.Ref
					refInList = true
				}
			}
			if !refInList {
				gitProject.Branches = append(gitProject.Branches, *gitProject.HEAD.Ref)
			}
		} else if dir.Name() == "COMMIT_EDITMSG" {
			data, err := os.ReadFile(path)
			if err != nil {
				return fmt.Errorf("error reading from COMMIT_EDITMSG: %w", err)
			}
			gitProject.CommitMessage = string(data)
		} else if dir.Name() == "refs" {
			branches, tags, err := processRefs(gitDir)
			if err != nil {
				return fmt.Errorf("error processing refs: %w", err)
			}
			gitProject.Tags = append(gitProject.Tags, tags...)
			for _, branch := range branches {
				for i, x := range gitProject.Branches {
					if branch.Name == x.Name {
						gitProject.Branches[i].Head = branch.Head
					}
				}
			}
		} else if dir.Name() == "logs" {
			err := processLogs(gitDir, &gitProject)
			if err != nil {
				return fmt.Errorf("error processing commit logs: %w", err)
			}
		}
		return nil
	})
	if err != nil {
		return GitProject{}, err
	}
	return gitProject, nil
}

func processLogs(gitDir string, gitProject *GitProject) error {
	headData, err := os.ReadFile(fmt.Sprintf("%s/logs/HEAD", gitDir))
	if err != nil {
		return fmt.Errorf("the commit logs for HEAD could not be read")
	}
	headLogs := strings.Split(strings.TrimRight(string(headData), "\n"), "\n")
	for _, log := range headLogs {
		logInfo := strings.Split(log, " ")
		headRef := &gitProject.HEAD
		tabSplit := strings.Split(logInfo[5], "\t")
		logType, err := returnGitLog(strings.TrimLeft(tabSplit[1], ":"))
		if err != nil {
			fmt.Println("log: ", err)
		}
		headRef.Commits = append(headRef.Commits, GitCommit{
			PreviousHash:  logInfo[0],
			CurrentHash:   logInfo[1],
			Name:          logInfo[2],
			Email:         strings.TrimRight(strings.TrimLeft(logInfo[3], "<"), ">"),
			LogType:       logType,
			InitialCommit: strings.Contains(logInfo[6], "(initial)"),
			CommitMessage: strings.TrimPrefix(strings.Join(logInfo[6:], " "), "(initial): "),
		})
	}
	headDir := fmt.Sprintf("%s/logs/refs/heads", gitDir)
	err = filepath.WalkDir(headDir, func(path string, dir fs.DirEntry, e error) error {
		if path == headDir {
			return nil
		}
		branchData, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("error reading branch '%s' log: %w", dir.Name(), err)
		}
		branchLogs := strings.Split(strings.TrimRight(string(branchData), "\n"), "\n")
		var branchIndex int = -1
		for i, b := range gitProject.Branches {
			if b.Name == dir.Name() {
				branchIndex = i
			}
		}
		if branchIndex == -1 {
			gitProject.Branches = append(gitProject.Branches, GitBranch{
				Name: dir.Name(),
			})
			for i, b := range gitProject.Branches {
				if b.Name == dir.Name() {
					branchIndex = i
				}
			}
		}
		for _, log := range branchLogs {
			logInfo := strings.Split(log, " ")
			headRef := &gitProject.Branches[branchIndex]
			logType, err := returnGitLog(strings.TrimLeft(strings.Split(logInfo[5], "\t")[1], ":"))
			if err != nil {
				fmt.Println("log: ", err)
			}

			headRef.Commits = append(headRef.Commits, GitCommit{
				PreviousHash:  logInfo[0],
				CurrentHash:   logInfo[1],
				Name:          logInfo[2],
				Email:         strings.TrimRight(strings.TrimLeft(logInfo[3], "<"), ">"),
				LogType:       logType,
				InitialCommit: strings.Contains(logInfo[6], "(initial)"),
				CommitMessage: strings.TrimPrefix(strings.Join(logInfo[6:], " "), "(initial): "),
			})
		}
		return nil
	})
	if err != nil {
		return err
	}
	return nil
}

func processRefs(gitDir string) ([]GitBranch, []GitTag, error) {
	branches, err := processBranches(gitDir)
	if err != nil {
		return []GitBranch{}, []GitTag{}, err
	}
	tags, err := processTags(gitDir)
	if err != nil {
		return []GitBranch{}, []GitTag{}, err
	}
	return branches, tags, nil
}

func processBranches(gitDir string) ([]GitBranch, error) {
	var gitBranches []GitBranch
	x := fmt.Sprintf("%s/refs/heads", gitDir)
	err := filepath.WalkDir(x, func(path string, dir fs.DirEntry, e error) error {
		if path == x {
			return nil
		}
		branchData, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("error reading ref of branch %s: %w", dir.Name(), err)
		}
		branchHead := strings.TrimLeft(string(branchData), "\n")
		gitBranches = append(gitBranches, GitBranch{
			Name: dir.Name(),
			Head: branchHead,
		})
		return nil
	})
	if err != nil {
		return []GitBranch{}, err
	}
	return gitBranches, nil
}

func processTags(gitDir string) ([]GitTag, error) {
	var gitTags []GitTag
	x := fmt.Sprintf("%s/refs/tags", gitDir)
	err := filepath.WalkDir(x, func(path string, dir fs.DirEntry, e error) error {
		if path == x {
			return nil
		}
		if e != nil {
			return fmt.Errorf("unknown error: %w", e)
		}
		tagData, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("error reading ref of tag %s: %w", dir.Name(), err)
		}
		tagHead := strings.TrimLeft(string(tagData), "\n")
		gitTags = append(gitTags, GitTag{
			Name: dir.Name(),
			Head: tagHead,
		})
		return nil
	})
	if err != nil {
		return []GitTag{}, err
	}
	return gitTags, nil
}

func processHead(gitDir string, head string) (GitHead, error) {
	var gitHead GitHead = GitHead{}
	headByLines := strings.Split(head, "\n")
	for _, line := range headByLines {
		lineInfo := strings.Split(line, ": ")
		if lineInfo[0] == "ref" {
			refName := filepath.Base(lineInfo[1])
			refPath := fmt.Sprintf("%s/%s", gitDir, lineInfo[1])
			refInfo, err := os.ReadFile(refPath)
			if err != nil {
				return GitHead{}, fmt.Errorf("the ref specified in HEAD could not be found")
			}
			headRefInfo := strings.TrimSuffix(string(refInfo), "\n")
			headRef := GitBranch{
				Name: refName,
				Head: headRefInfo,
			}
			gitHead.Ref = &headRef
			return gitHead, nil
		}
	}
	return gitHead, fmt.Errorf("could not find HEAD reference")
}
