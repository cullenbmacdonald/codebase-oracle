---
name: oracle:renew
description: Renew the oracle's knowledge with recent commits
---

# Renew the Oracle's Knowledge

Renew the oracle's wisdom by processing commits since the last divination.

**IMPORTANT: Execute inline. Do NOT launch a background agent.**

## Prerequisites

- Must have run `/oracle:divine` at least once
- Checkpoint file must exist at `.claude/oracle-checkpoint.json`

---

## Step 1: Check Checkpoint

```bash
cat .claude/oracle-checkpoint.json
```

If the checkpoint doesn't exist, tell the user:
"No checkpoint found. Run `/oracle:divine` first to perform initial history mining."

Extract the `last_commit` SHA from the checkpoint.

---

## Step 2: Generate New Candidates

Run the filter script with the `--since` flag:

```bash
bash scripts/filter-candidates.sh --since <last_commit_sha>
```

Or if installed as a plugin:
```bash
bash .claude-plugin/scripts/filter-candidates.sh --since <last_commit_sha>
```

This creates `docs/oracle/.candidates.json` with only commits since the checkpoint.

If no candidates found, tell the user:
"No significant commits since last divination. History is up to date."

---

## Step 3: Process New Candidates

Follow the same process as `/oracle:divine` Phase 2:

1. Read the candidates file
2. For each candidate, show progress
3. Create new docs or update existing ones
4. Show what's being documented

```
[Oracle] Renewing with 12 new candidates...
[Oracle] 1/12: abc1234 (2024-02-01) "Add caching layer" [keyword] → DOCUMENTING
[Oracle] 2/12: def5678 (2024-02-02) "Fix race condition" [keyword] → DOCUMENTING
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

Update `.claude/oracle-checkpoint.json`:

```json
{
  "last_commit": "[newest SHA processed]",
  "last_run": "[current timestamp]",
  "docs_created": [total count]
}
```

---

## Step 6: Clean Up

```bash
rm docs/oracle/.candidates.json
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

---

## When to Run

- After pulling new changes from remote
- Before starting work on unfamiliar areas
- Periodically to stay current
- Much faster than full `/oracle:divine`
