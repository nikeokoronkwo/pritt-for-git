package pritt

type GitCommitExport struct {
	// The previous commit hash
	PreviousHash string `json:"prevHash"`

	// The current, new commit hash from this log
	CurrentHash string `json:"currentHash"`

	// The name of the user who placed this commit
	Name string `json:"name"`

	// The email of the user who placed this commit
	Email string `json:"email"`

	// The commit message for this commit
	CommitMessage string `json:"message"`

	// The log type of this commit as a HeadLogType
	LogType string `json:"log"`

	// Whether the given commit was the initial commit
	InitialCommit bool `json:"initial"`
}

type GitProjectExport struct {
	// The branches present in the project
	Branches []struct {
		Name    string            `json:"name"`
		Head    string            `json:"head"`
		Commits []GitCommitExport `json:"commits"`
	} `json:"branches"`

	// The tags in a git repository
	Tags []struct {
		Name    string            `json:"name"`
		Head    string            `json:"head"`
		Commits []GitCommitExport `json:"commits"`
	} `json:"tags"`

	// The main branch of the project as a string
	MainBranch string `json:"main"`

	// The HEAD of a git project
	HEAD struct {
		Ref     string            `json:"ref"`
		Commits []GitCommitExport `json:"commits"`
	} `json:"head"`

	// The Current Commit Message
	CommitMessage string `json:"commit"`
}
