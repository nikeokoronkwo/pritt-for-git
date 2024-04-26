package pritt

// A  Struct meant to represent a Git Project Structure
type GitProject struct {
	// The branches present in the project
	Branches []GitBranch

	// The tags in a git repository
	Tags []GitTag

	// The main branch of the project as a string
	MainBranch string

	// The HEAD of a git project
	HEAD GitHead

	// The Current Commit Message
	CommitMessage string
}
