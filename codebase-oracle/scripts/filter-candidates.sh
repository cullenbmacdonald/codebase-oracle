#!/bin/bash
# Filter commits to find candidates worth documenting
# Usage: filter-candidates.sh [--since <sha>] [--output <file>]
# Output: JSON array of candidate commits with metadata
#
# Heuristics applied:
# 1. Deletions (removed files/directories)
# 2. Large changes (10+ files modified)
# 3. Keyword matches (refactor, migrate, remove, etc.)
# 4. New directories introduced
# 5. Reverts
# 6. Config/schema changes

set -e

OUTPUT_FILE="docs/oracle/.candidates.json"
SINCE_SHA=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --since)
            SINCE_SHA="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
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

# Build base git log range
if [ -n "$SINCE_SHA" ]; then
    if ! git cat-file -e "$SINCE_SHA" 2>/dev/null; then
        echo "error: commit $SINCE_SHA not found" >&2
        exit 1
    fi
    RANGE="${SINCE_SHA}..HEAD"
else
    RANGE="HEAD"
fi

# Temporary file for collecting candidate SHAs
CANDIDATES=$(mktemp)
trap "rm -f $CANDIDATES" EXIT

echo "Filtering commits for significance..." >&2

# 1. Commits with deletions
echo "  - Finding deletions..." >&2
git log --diff-filter=D --format='%H' --reverse $RANGE >> "$CANDIDATES" 2>/dev/null || true

# 2. Large changes (10+ files)
echo "  - Finding large changes..." >&2
git log --format='%H' --reverse $RANGE | while read sha; do
    count=$(git show --stat --format='' "$sha" 2>/dev/null | grep -c '|' || echo 0)
    if [ "$count" -ge 10 ]; then
        echo "$sha"
    fi
done >> "$CANDIDATES"

# 3. Keyword matches in commit messages
echo "  - Finding keyword matches..." >&2
KEYWORDS="refactor|migrate|remove|deprecate|breaking|security|revert|upgrade|downgrade|rename|restructure|overhaul|rewrite|introduce|implement|add support|drop support"
git log --grep="$KEYWORDS" -i -E --format='%H' --reverse $RANGE >> "$CANDIDATES" 2>/dev/null || true

# 4. New directories (commits that add files in new top-level or src-level dirs)
echo "  - Finding new directories..." >&2
git log --diff-filter=A --format='%H' --reverse $RANGE | while read sha; do
    # Check if this commit introduced a new directory
    new_dirs=$(git show --name-status --format='' "$sha" 2>/dev/null | grep '^A' | awk '{print $2}' | grep -E '^[^/]+/|^src/[^/]+/' | cut -d'/' -f1-2 | sort -u)
    if [ -n "$new_dirs" ]; then
        # Check if any of these dirs are new (first commit to touch them)
        for dir in $new_dirs; do
            first_commit=$(git log --format='%H' --reverse -- "$dir" 2>/dev/null | head -1)
            if [ "$first_commit" = "$sha" ]; then
                echo "$sha"
                break
            fi
        done
    fi
done >> "$CANDIDATES" 2>/dev/null || true

# 5. Reverts (explicit)
echo "  - Finding reverts..." >&2
git log --grep="^Revert" --format='%H' --reverse $RANGE >> "$CANDIDATES" 2>/dev/null || true

# 6. Config and schema changes
echo "  - Finding config/schema changes..." >&2
git log --format='%H' --reverse $RANGE -- \
    '*.yml' '*.yaml' '*.json' '*.toml' \
    '**/schema*' '**/migration*' '**/migrate*' \
    'Gemfile*' 'package*.json' 'Cargo.toml' 'requirements*.txt' 'go.mod' \
    '.env*' 'config/**' \
    >> "$CANDIDATES" 2>/dev/null || true

# Deduplicate and sort by commit date
echo "  - Deduplicating..." >&2
UNIQUE_CANDIDATES=$(sort -u "$CANDIDATES")
TOTAL_CANDIDATES=$(echo "$UNIQUE_CANDIDATES" | grep -c . || echo 0)

echo "Found $TOTAL_CANDIDATES candidate commits" >&2

# Create output directory if needed
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Generate JSON output
echo "Generating $OUTPUT_FILE..." >&2
echo "{" > "$OUTPUT_FILE"
echo "  \"generated\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$OUTPUT_FILE"
echo "  \"total\": $TOTAL_CANDIDATES," >> "$OUTPUT_FILE"
echo "  \"candidates\": [" >> "$OUTPUT_FILE"

FIRST=true
echo "$UNIQUE_CANDIDATES" | while read sha; do
    if [ -z "$sha" ]; then continue; fi

    # Get commit metadata
    INFO=$(git log -1 --format='%aI|%an|%s' "$sha" 2>/dev/null)
    DATE=$(echo "$INFO" | cut -d'|' -f1)
    AUTHOR=$(echo "$INFO" | cut -d'|' -f2 | sed 's/"/\\"/g')
    SUBJECT=$(echo "$INFO" | cut -d'|' -f3- | sed 's/"/\\"/g')
    SHORT_SHA=$(echo "$sha" | cut -c1-7)

    # Determine why this commit was flagged
    REASONS=""

    # Check deletion
    if git show --diff-filter=D --format='' "$sha" 2>/dev/null | grep -q .; then
        REASONS="${REASONS}deletion,"
    fi

    # Check large change
    FILE_COUNT=$(git show --stat --format='' "$sha" 2>/dev/null | grep -c '|' || echo 0)
    if [ "$FILE_COUNT" -ge 10 ]; then
        REASONS="${REASONS}large_change,"
    fi

    # Check keyword
    if echo "$SUBJECT" | grep -iE "$KEYWORDS" > /dev/null 2>&1; then
        REASONS="${REASONS}keyword,"
    fi

    # Check revert
    if echo "$SUBJECT" | grep -q "^Revert"; then
        REASONS="${REASONS}revert,"
    fi

    # Clean up reasons
    REASONS=$(echo "$REASONS" | sed 's/,$//')
    if [ -z "$REASONS" ]; then
        REASONS="config_schema"
    fi

    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    printf '    {"sha": "%s", "short": "%s", "date": "%s", "author": "%s", "subject": "%s", "reasons": "%s", "processed": false}' \
        "$sha" "$SHORT_SHA" "$DATE" "$AUTHOR" "$SUBJECT" "$REASONS" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "  ]" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo "Done! Candidates written to $OUTPUT_FILE" >&2
