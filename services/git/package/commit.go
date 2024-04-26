package pritt

// Struct to represent the information from a git commit log
type GitCommit struct {
	// The previous commit hash
	PreviousHash string

	// The current, new commit hash from this log
	CurrentHash string

	// The name of the user who placed this commit
	Name string

	// The email of the user who placed this commit
	Email string

	// The commit message for this commit
	CommitMessage string

	// The log type of this commit as a HeadLogType
	LogType HeadLogType

	// Whether the given commit was the initial commit
	InitialCommit bool
}
