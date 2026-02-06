---
name: oracle:renew
description: Renew the oracle's knowledge with recent commits
---

# Renew the Oracle's Knowledge

Renew the oracle's wisdom by processing commits since the last divination.

**IMPORTANT: Execute inline. Do NOT launch a background agent.**

---

## Step 1: Check Checkpoint

```bash
cat .claude/oracle-checkpoint.json
```

If missing, tell the user: "No checkpoint found. Run `/oracle:divine` first."

Extract the `last_commit` SHA.

---

## Step 2: Find New Candidates

Run the same queries as `/oracle:divine`, but with a range. For each query, add `<last_commit>..HEAD`:

### Deletions since checkpoint
```bash
git log --diff-filter=D --format='%H|%aI|%s' --reverse <last_commit>..HEAD
```

### Large changes since checkpoint
```bash
git log --format='%H|%aI|%s' --reverse <last_commit>..HEAD | while read line; do
  sha=$(echo "$line" | cut -d'|' -f1)
  count=$(git show --stat --format='' "$sha" 2>/dev/null | grep -c '|' || echo 0)
  [ "$count" -ge 10 ] && echo "$line"
done
```

### Keyword matches since checkpoint
```bash
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse <last_commit>..HEAD
```

### Config changes since checkpoint
```bash
git log --format='%H|%aI|%s' --reverse <last_commit>..HEAD -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' '**/schema*' '**/migration*' 'config/**'
```

Combine and deduplicate.

If no candidates: "No significant commits since last divination. History is up to date."

---

## Step 3: Process New Candidates

Follow `/oracle:divine` Phase 2:
- Show progress for each candidate
- Create new docs or update existing ones

```
[Oracle] Renewing with 12 new candidates...
[Oracle] 1/12: abc1234 (2024-02-01) "Add caching layer" → DOCUMENTING
```

---

## Step 4: Update Index

Merge new entries into `docs/oracle/index.yaml`:
- Add entries for new docs
- Update `generated` timestamp
- Update `last_commit` to newest SHA
- Update `total_docs` count

---

## Step 5: Update Checkpoint

```json
{
  "last_commit": "[newest SHA]",
  "last_run": "[timestamp]",
  "docs_created": [total count]
}
```

---

## Report Completion

```
[Oracle] Renewal complete!
- New candidates analyzed: 12
- New docs written: 3
- Docs updated: 1
- Checkpoint updated
```
