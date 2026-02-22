---
name: oracle:renew
description: Renew the oracle's knowledge with recent commits
---

# Renew the Oracle's Knowledge

Awaken the oracle to divine wisdom from commits since the last consultation.

**IMPORTANT: Execute inline. Do NOT launch a background agent.**

---

## Step 1: Consult the Bookmark

```bash
cat .claude/oracle-checkpoint.json
```

If the bookmark is missing, tell the seeker:
`[Oracle] No record of previous divination. Seek /oracle:divine first to awaken the oracle.`

Extract the `last_commit` SHA from the bookmark.

---

## Step 2: Scry for New Visions (Parallel)

Tell the user: `[Oracle] Peering beyond the last divination...`

Run these **5 Bash commands in parallel** (all in one message), replacing `<last_commit>` with the SHA from the bookmark. Each writes to a temp file:

```bash
# 1. Visions of destruction since last divination
git log --diff-filter=D --format='%H|%aI|%s' --reverse <last_commit>..HEAD > /tmp/oracle-new-deletions.txt
```

```bash
# 2. Great upheavals since last divination
git log --shortstat --format='%H|%aI|%s|' --reverse <last_commit>..HEAD | awk '/\|$/{info=$0} /files? changed/{if($1>=10) print info}' > /tmp/oracle-new-large.txt
```

```bash
# 3. Words of power since last divination
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse <last_commit>..HEAD > /tmp/oracle-new-keywords.txt
```

```bash
# 4. Paths not taken since last divination
git log --grep='^Revert' --format='%H|%aI|%s' --reverse <last_commit>..HEAD > /tmp/oracle-new-reverts.txt
```

```bash
# 5. Sacred configurations since last divination
git log --format='%H|%aI|%s' --reverse <last_commit>..HEAD -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' 'Cargo.toml' 'go.mod' 'requirements*.txt' '**/schema*' '**/migration*' 'config/**' 'db/migrate/**' > /tmp/oracle-new-config.txt
```

**Call all 5 Bash commands in a single message** so they run in parallel.

### Gathering the New Visions

After all 5 complete, run:

```bash
cat /tmp/oracle-new-*.txt | cut -d'|' -f1-3 | sort -t'|' -k2 -u | sort -t'|' -k1 -u > /tmp/oracle-new-visions.txt && wc -l < /tmp/oracle-new-visions.txt
```

If no new visions: `[Oracle] The waters are still. No new wisdom since the last divination.`

Tell the user: `[Oracle] The spirits stir with X new visions...`

---

## Step 3: Read the New Runes

Follow `/oracle:divine` Phase 2:
- Show progress for each vision
- Consult the full record for promising visions:

```bash
git show --stat <sha>
git show <sha>  # the complete vision if needed
```

- Inscribe new prophecies or update existing ones

```
[Oracle] Reading rune 1/12: abc1234 "Add caching layer" — a prophecy emerges!
[Oracle] Inscribing prophecy: Caching Strategy
```

**CALIBRATION:** Be liberal—false prophecies fade; lost wisdom is gone forever.

As history unfolds chronologically, update existing prophecies:
- Mark superseded ways with `status: superseded`
- Add "History" sections showing evolution
- Set `status: abandoned` for forsaken approaches

---

## Step 4: Update the Codex

Merge new entries into `docs/oracle/index.yaml`:
- Add entries for new prophecies
- Update `generated` timestamp
- Update `last_commit` to newest SHA
- Update `total_docs` count

---

## Step 5: Update CLAUDE.md

If any new prophecies were inscribed, refresh the "Wisdom of the Ancients" section in CLAUDE.md:
- Add new architectural decisions (1-2 sentences each)
- Add any new active warnings and gotchas
- Update current conventions if they changed

Keep the section under 500 words.

---

## Step 6: Mark the New Bookmark

```json
{
  "last_commit": "[newest SHA]",
  "last_run": "[timestamp]",
  "prophecies_recorded": [total count]
}
```

---

## Report Completion

```
[Oracle] The renewal is complete!

  New visions examined: 12
  Prophecies inscribed: 3
  Prophecies amended: 1
  The bookmark advances
```
