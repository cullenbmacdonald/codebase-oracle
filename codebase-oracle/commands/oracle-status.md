---
name: oracle:status
description: Show the current state of the oracle — last divination, prophecy count, and repo drift
---

# Oracle Status

Check the oracle's current state: when it last spoke, how many prophecies it has inscribed, and how far the repository has drifted since.

**IMPORTANT: Execute these steps directly. Do NOT launch this command as a background agent.**

---

## The Ritual

Tell the user: `[Oracle] Reading the signs...`

### Step 1: Read the Checkpoint

Check whether the oracle has ever been awakened:

```bash
cat .claude/oracle-checkpoint.json 2>/dev/null || echo "NOT_FOUND"
```

If `NOT_FOUND`, tell the user:

```
[Oracle] The oracle has not yet been awakened.

Run /oracle:divine to begin the first divination.
```

Then stop.

### Step 2: Count the Prophecies

```bash
ls docs/oracle/*.md 2>/dev/null | wc -l | tr -d ' '
```

### Step 3: Measure the Drift

How many commits have been added since the last divination:

```bash
git rev-list <last_commit>..HEAD --count 2>/dev/null || echo "0"
```

Use the `last_commit` value from the checkpoint JSON.

### Step 4: Identify New Commits

List the commits that have arrived since the last divination:

```bash
git log <last_commit>..HEAD --oneline 2>/dev/null | head -10
```

---

## Output Format

```
[Oracle] The oracle speaks of its own state...

  Last divination : {last_run}
  Anchored commit : {last_commit_short}
  Prophecies held : {prophecy_count}

  Drift since last divination: {drift_count} commit(s)
  {If drift > 0: list up to 10 commits, one per line, prefixed with "  • "}

  {If drift == 0:
    The codex is current. No new knowledge awaits.
  }
  {If drift > 0 and drift <= 20:
    New knowledge may have emerged. Consider /oracle:renew to capture it.
  }
  {If drift > 20:
    Significant drift detected. Run /oracle:renew to keep the codex current.
  }
```

---

## Notes

- Requires `/oracle:divine` to have been run at least once
- Use `/oracle:renew` to update the oracle after new commits
- Use `/oracle:consult` to query existing prophecies
