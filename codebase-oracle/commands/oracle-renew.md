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

## Step 2: Scry for New Visions

Tell the user: `[Oracle] Peering beyond the last divination...`

Run the same queries as `/oracle:divine`, but with a range. For each query, add `<last_commit>..HEAD`:

### Visions of destruction since last divination
```bash
git log --diff-filter=D --format='%H|%aI|%s' --reverse <last_commit>..HEAD > /tmp/oracle-new-deletions.txt
```

### Great upheavals since last divination
```bash
git log --shortstat --format='%H|%aI|%s|' --reverse <last_commit>..HEAD | awk '/\|$/{info=$0} /files? changed/{if($1>=10) print info}' > /tmp/oracle-new-large.txt
```

### Words of power since last divination
```bash
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse <last_commit>..HEAD > /tmp/oracle-new-keywords.txt
```

### Sacred configurations since last divination
```bash
git log --format='%H|%aI|%s' --reverse <last_commit>..HEAD -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' '**/schema*' '**/migration*' 'config/**' > /tmp/oracle-new-config.txt
```

Combine and deduplicate:

```bash
cat /tmp/oracle-new-*.txt | cut -d'|' -f1-3 | sort -t'|' -k2 -u | sort -t'|' -k1 -u > /tmp/oracle-new-visions.txt && wc -l < /tmp/oracle-new-visions.txt
```

If no new visions: `[Oracle] The waters are still. No new wisdom since the last divination.`

---

## Step 3: Read the New Runes

Follow `/oracle:divine` Phase 2:
- Show progress for each vision
- Inscribe new prophecies or update existing ones

```
[Oracle] The spirits stir with 12 new visions...
[Oracle] Reading rune 1/12: abc1234 "Add caching layer" — a prophecy emerges!
[Oracle] Inscribing prophecy: Caching Strategy
```

---

## Step 4: Update the Codex

Merge new entries into `docs/oracle/index.yaml`:
- Add entries for new prophecies
- Update `generated` timestamp
- Update `last_commit` to newest SHA
- Update `total_docs` count

---

## Step 5: Mark the New Bookmark

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
