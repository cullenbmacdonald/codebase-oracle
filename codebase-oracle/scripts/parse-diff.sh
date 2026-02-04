#!/bin/bash
# Generate diff summary for a commit
# Usage: parse-diff.sh <sha>
# Output: JSON with file stats and key changes

set -e

if [ -z "$1" ]; then
    echo "error: commit SHA required" >&2
    exit 1
fi

SHA="$1"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "error: not a git repository" >&2
    exit 1
fi

# Verify the SHA exists
if ! git cat-file -e "$SHA" 2>/dev/null; then
    echo "error: commit $SHA not found" >&2
    exit 1
fi

# Get file stats
stats=$(git show --stat --format='' "$SHA" | head -n -1)

# Get files changed with additions/deletions
files_changed=$(git show --numstat --format='' "$SHA" | awk '{print $3}' | head -20)

# Count totals
total_files=$(git show --stat --format='' "$SHA" | tail -1 | grep -oE '[0-9]+ files?' | grep -oE '[0-9]+' || echo "0")
total_insertions=$(git show --stat --format='' "$SHA" | tail -1 | grep -oE '[0-9]+ insertions?' | grep -oE '[0-9]+' || echo "0")
total_deletions=$(git show --stat --format='' "$SHA" | tail -1 | grep -oE '[0-9]+ deletions?' | grep -oE '[0-9]+' || echo "0")

# Detect file types changed
migration_files=$(echo "$files_changed" | grep -c -E 'migrate|migration' || echo "0")
config_files=$(echo "$files_changed" | grep -c -E 'config|\.env|\.yaml|\.yml|\.json$' || echo "0")
test_files=$(echo "$files_changed" | grep -c -E 'test|spec|_test\.' || echo "0")

# Output as simple key-value for easy parsing
echo "files_changed: $total_files"
echo "insertions: $total_insertions"
echo "deletions: $total_deletions"
echo "migration_files: $migration_files"
echo "config_files: $config_files"
echo "test_files: $test_files"
echo "---"
echo "files:"
echo "$files_changed"
