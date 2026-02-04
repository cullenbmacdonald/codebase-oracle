---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

## What This Does

1. Gets ALL commits from the repository (oldest to newest)
2. Examines each commit for institutional knowledge
3. Documents significant patterns in `docs/history/`
4. Creates a routing index for on-demand retrieval
5. Updates CLAUDE.md with critical patterns

## Prerequisites

- Must be in a git repository
- Repository must have commit history
- For shallow clones, run `git fetch --unshallow` first

## Execution

**Do not run this in the background.** Show progress as you work.

### Step 1: Count commits

```bash
git rev-list --count HEAD
```

Tell the user: "Found X commits to analyze."

### Step 2: Get all commits

```bash
git log --reverse --format='%H|%aI|%an|%s'
```

### Step 3: Process each commit

For each commit, show progress:

```
[Oracle] Processing commit 1/500: abc123 (2023-01-15) - "Initial commit"
[Oracle] Processing commit 2/500: def456 (2023-01-16) - "Add user authentication"
  → Significant: Introduces authentication pattern
...
```

When you find something significant, say so immediately.

### Step 4: Write documentation

As you accumulate findings (or when context gets large), write to `docs/history/`:
- Create the directory if it doesn't exist
- Write markdown files with commit-anchored dates
- Update the index.yaml

### Step 5: Update CLAUDE.md

Add or update the "Historical Context" section with critical patterns.

### Step 6: Report completion

```
[Oracle] Complete!
- Processed: 500 commits
- Significant patterns found: 12
- Documentation written: docs/history/*.md
- Index updated: docs/history/index.yaml
- CLAUDE.md updated: Yes
```

## Important

- **Show progress as you go** - don't process silently
- **Dates come from git** - never infer or guess dates
- **Anchor to commits** - every claim cites a commit SHA
- **Deletions matter** - removed code is valuable institutional knowledge
