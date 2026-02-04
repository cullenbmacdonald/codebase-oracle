#!/bin/bash
# Detect the git workflow type used in this repository
# Returns: merge | squash | rebase | mixed

set -e

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "error: not a git repository" >&2
    exit 1
fi

# Count total commits
total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")

if [ "$total_commits" -eq 0 ]; then
    echo "error: no commits found" >&2
    exit 1
fi

# Count merge commits
merge_commits=$(git rev-list --merges --count HEAD 2>/dev/null || echo "0")

# Calculate ratio
if [ "$total_commits" -gt 0 ]; then
    merge_ratio=$((merge_commits * 100 / total_commits))
else
    merge_ratio=0
fi

# Determine workflow type
# - If > 30% are merge commits, likely merge-based workflow
# - If < 5% are merge commits, likely rebase or squash
# - In between is mixed

if [ "$merge_ratio" -gt 30 ]; then
    echo "merge"
elif [ "$merge_ratio" -lt 5 ]; then
    # Distinguish between rebase and squash by checking for PR patterns
    # Squash commits often have "PR #" or "(#" in messages
    pr_pattern_count=$(git log --oneline HEAD | grep -c -E '\(#[0-9]+\)|PR #[0-9]+' || echo "0")
    pr_ratio=$((pr_pattern_count * 100 / total_commits))

    if [ "$pr_ratio" -gt 20 ]; then
        echo "squash"
    else
        echo "rebase"
    fi
else
    echo "mixed"
fi
