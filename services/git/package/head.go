package pritt

// Struct to represent the HEAD of a Git Repository
type GitHead struct {
	Ref     *GitBranch
	Commits []GitCommit
}
