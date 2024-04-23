package pritt

// A Struct to represent a Git branch and its information
type GitBranch struct {
	// The name of the git branch
	Name string

	// The commit head of the branch
	Head string

	// The commits for the given branch
	Commits []GitCommit
}
