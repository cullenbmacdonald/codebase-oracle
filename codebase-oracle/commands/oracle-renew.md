---
name: oracle:renew
description: Renew the oracle's knowledge with recent commits
---

# Renew the Oracle's Knowledge

Renew the oracle's wisdom by processing commits since the last divination.

This is an incremental update that:
- Reads the checkpoint from the last mining run
- Processes only commits since that checkpoint
- Updates the routing index and CLAUDE.md as needed

## Prerequisites

- Must have run `/oracle:divine` at least once
- Checkpoint file must exist at `.claude/oracle-checkpoint.json`
- New commits must exist since last run

## Process

1. **Read Checkpoint** - Get last processed commit SHA
2. **Get New Commits** - Fetch commits since checkpoint
3. **Evaluate & Document** - Process new commits for significance
4. **Update Index** - Merge new entries into routing index
5. **Update CLAUDE.md** - Refresh critical patterns if needed
6. **Save Checkpoint** - Record new progress marker

## Execution

Launch the history-miner agent with update mode:

```
Task history-miner("Update the historical documentation with new commits. Read the checkpoint at .claude/oracle-checkpoint.json to find the last processed commit. Only process commits since then. Update the routing index and CLAUDE.md with any new significant patterns found.")
```

## When to Run

- After pulling new changes from remote
- Periodically as part of CI/CD pipeline
- Before starting work on unfamiliar areas
- When you suspect historical context may be stale

## Output

- Updated `docs/history/*.md` - New docs if significant patterns found
- Updated `docs/history/index.yaml` - New entries added
- Updated `CLAUDE.md` - Critical patterns refreshed if needed
- Updated `.claude/oracle-checkpoint.json` - New progress marker

## Notes

- Much faster than full `/oracle:divine` run
- Only processes delta since last checkpoint
- Safe to run frequently
- If checkpoint is missing, suggest running `/oracle:divine` instead
