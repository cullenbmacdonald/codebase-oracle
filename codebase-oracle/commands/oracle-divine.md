---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch a background agent or use the Task tool. Process commits inline and show progress to the user.**

## Step 1: Announce and Count

First, tell the user what you're doing and count commits:

```bash
git rev-list --count HEAD
```

Say: "Divining history from X commits. This will take a moment..."

## Step 2: Get All Commits

```bash
git log --reverse --format='%H|%aI|%an|%s'
```

Parse this into a list. Each line is: `SHA|DATE|AUTHOR|MESSAGE`

## Step 3: Process Each Commit (Show Progress)

For each commit, show the user what you're looking at:

```
[Oracle] 1/500: abc1234 (2023-01-15) "Initial commit"
[Oracle] 2/500: def5678 (2023-01-16) "Add user model"
[Oracle] 3/500: ghi9012 (2023-01-17) "Implement authentication" → SIGNIFICANT: introduces auth pattern
```

For commits that look significant, run:
```bash
git show --stat <sha>
```

To see what files changed. Look for:
- **Deletions** (files/directories removed) - ALWAYS significant
- **New directories** - often significant
- **Config/migration changes** - usually significant
- **Large diffs** (10+ files) - worth examining
- **Keywords in message**: refactor, migrate, remove, deprecate, breaking, introduce

## Step 4: Accumulate Findings

As you find significant commits, group them by theme:
- Architectural changes
- Bug fixes / gotchas discovered
- Things removed / abandoned
- Conventions established

## Step 5: Write Documentation

Create `docs/history/` directory if needed:
```bash
mkdir -p docs/history
```

Write markdown files for each significant theme. **Use commit dates from git, not inferred dates.**

Format:
```markdown
---
date: 2023-01-17
category: architectural_pivot
commits: [abc1234, def5678]
---

# Authentication System Introduction

**Commits:** abc1234 (2023-01-17), def5678 (2023-01-18)
**Authors:** Jane Dev, John Dev

## What Changed
[Description based on the diffs]

## Why It Matters
[Institutional knowledge extracted]
```

## Step 6: Create Index

Write `docs/history/index.yaml`:
```yaml
version: 1
generated: [current timestamp]
last_commit: [most recent SHA processed]
entries:
  - file: [filename].md
    keywords: [relevant keywords]
    paths: [file patterns affected]
    category: [category]
    summary: [one line summary]
```

## Step 7: Update CLAUDE.md

Add or update a "Historical Context" section in CLAUDE.md with the most critical patterns.

## Step 8: Report Completion

```
[Oracle] Divination complete!
- Commits analyzed: 500
- Significant patterns: 12
- Docs written: docs/history/
- CLAUDE.md updated
```

## Remember

- **Execute inline** - no background agents
- **Show progress** - user should see each commit being processed
- **Dates from git** - never guess or infer dates
- **Deletions matter** - removed code is gold for institutional knowledge
