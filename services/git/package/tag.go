package pritt

// A Struct to represent a Git Tag and its information
type GitTag struct {
	// The name of the git tag
	Name string

	// The commit head of the tag
	Head string

	// The commits for the given tag
	Commits []GitCommit
}
