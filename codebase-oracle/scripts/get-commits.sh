#!/bin/bash
# Fetch commit list with metadata
# Usage: get-commits.sh [--since <sha>] [--merges-only]
# Output: SHA|PARENT_SHA|DATE|AUTHOR|MESSAGE (one per line, oldest first)

set -e

SINCE_SHA=""
MERGES_ONLY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --since)
            SINCE_SHA="$2"
            shift 2
            ;;
        --merges-only)
            MERGES_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "error: not a git repository" >&2
    exit 1
fi

# Build git log command
GIT_CMD="git log --reverse --format='%H|%P|%aI|%an|%s'"

if [ "$MERGES_ONLY" = true ]; then
    GIT_CMD="$GIT_CMD --merges"
fi

if [ -n "$SINCE_SHA" ]; then
    # Verify the SHA exists
    if ! git cat-file -e "$SINCE_SHA" 2>/dev/null; then
        echo "error: commit $SINCE_SHA not found" >&2
        exit 1
    fi
    GIT_CMD="$GIT_CMD ${SINCE_SHA}..HEAD"
fi

# Execute and output
eval "$GIT_CMD"
