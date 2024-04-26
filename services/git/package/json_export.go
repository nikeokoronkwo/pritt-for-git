package pritt

func ConvertToExport(p GitProject) GitProjectExport {
	return GitProjectExport{
		MainBranch:    p.MainBranch,
		CommitMessage: p.CommitMessage,
		HEAD: struct {
			Ref     string            "json:\"ref\""
			Commits []GitCommitExport "json:\"commits\""
		}{
			Ref:     p.HEAD.Ref.Name,
			Commits: transformCommits(p.HEAD.Commits),
		},
		Branches: transform(p.Branches, func(a GitBranch) struct {
			Name    string            `json:"name"`
			Head    string            `json:"head"`
			Commits []GitCommitExport `json:"commits"`
		} {
			return struct {
				Name    string            "json:\"name\""
				Head    string            "json:\"head\""
				Commits []GitCommitExport "json:\"commits\""
			}{
				Name:    a.Name,
				Head:    a.Head,
				Commits: transformCommits(a.Commits),
			}
		}),
		Tags: transform(p.Tags, func(a GitTag) struct {
			Name    string            `json:"name"`
			Head    string            `json:"head"`
			Commits []GitCommitExport `json:"commits"`
		} {
			return struct {
				Name    string            "json:\"name\""
				Head    string            "json:\"head\""
				Commits []GitCommitExport "json:\"commits\""
			}{
				Name:    a.Name,
				Head:    a.Head,
				Commits: transformCommits(a.Commits),
			}
		}),
	}
}

func transformCommits(p []GitCommit) []GitCommitExport {
	return transform(p, func(a GitCommit) GitCommitExport {
		return GitCommitExport{
			PreviousHash:  a.PreviousHash,
			CurrentHash:   a.CurrentHash,
			Name:          a.Name,
			CommitMessage: a.CommitMessage,
			InitialCommit: a.InitialCommit,
			LogType:       GetGitLogAsString(a.LogType),
		}
	})
}

func transform[T, S any](input []T, transformer func(el T) S) []S {
	var output []S = []S{}
	for _, v := range input {
		output = append(output, transformer(v))
	}
	return output
}

func GetGitLogAsString(log HeadLogType) string {
	switch log {
	case 0:
		return "commit"
	case 1:
		return "checkout"
	case 2:
		return "branch"
	}
	return ""
}
