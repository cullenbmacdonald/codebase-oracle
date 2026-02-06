---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch this command as a background agent.**

---

## Phase 1: Scrying the Repository (Parallel)

Tell the user: `[Oracle] Scrying the repository depths...`

Run these **5 Bash commands in parallel** (all in one message). Each writes to a temp file:

```bash
# 1. Visions of destruction (deletions)
git log --diff-filter=D --format='%H|%aI|%s' --reverse > /tmp/oracle-deletions.txt

# 2. Great upheavals (large changes)
git log --shortstat --format='%H|%aI|%s|' --reverse | awk '/\|$/{info=$0} /files? changed/{if($1>=10) print info}' > /tmp/oracle-large.txt

# 3. Words of power (keyword matches)
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse > /tmp/oracle-keywords.txt

# 4. Paths not taken (reverts)
git log --grep='^Revert' --format='%H|%aI|%s' --reverse > /tmp/oracle-reverts.txt

# 5. Sacred configurations
git log --format='%H|%aI|%s' --reverse -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' 'Cargo.toml' 'go.mod' 'requirements*.txt' '**/schema*' '**/migration*' 'config/**' 'db/migrate/**' > /tmp/oracle-config.txt
```

**Call all 5 Bash commands in a single message** so they run in parallel.

### Gathering the Visions

After all 5 complete, run:

```bash
cat /tmp/oracle-*.txt | cut -d'|' -f1-3 | sort -t'|' -k2 -u | sort -t'|' -k1 -u > /tmp/oracle-visions.txt && wc -l < /tmp/oracle-visions.txt
```

Read the combined file:

```bash
cat /tmp/oracle-visions.txt
```

Tell the user: `[Oracle] The scrying reveals X visions from the past...`

---

## Phase 2: Reading the Runes

**For each vision, show progress:**

```
[Oracle] Reading rune 1/150: abc1234 "Remove legacy auth" — examining...
[Oracle] Reading rune 2/150: def5678 "Migrate to JWT" — a prophecy emerges!
[Oracle] Inscribing prophecy: JWT Authentication
```

**For visions worth documenting, consult the full record:**

```bash
git show --stat <sha>
git show <sha>  # the complete vision if needed
```

### What Prophecies to Record

**CALIBRATION:** The oracle speaks liberally. 500 visions should yield 50-100+ prophecies. False visions are acceptable—lost knowledge is not.

**PHILOSOPHY:** Do not merely summarize the past. Inscribe the wisdom that WOULD EXIST had the ancients documented their ways.

**Categories of Prophecy:**

- **Sacred Patterns** - How things are done (auth, database, API design)
- **Hard-Won Wisdom** - Lessons from tribulation (scaling woes, race conditions)
- **Abandoned Paths** - What was forsaken and why (deprecated features, failed experiments)
- **The Old Ways** - How things are named and structured

### Prophecy Format

Write as the engineer who just completed the work:

```markdown
---
title: JWT Authentication
category: authentication
tags: [jwt, auth, tokens, security]
source_commits: [abc1234, def5678]
---

# JWT Authentication

## Overview
We use JWT tokens for API authentication.

## Implementation
[Specific details]

## Gotchas
- Tokens must be refreshed before expiry
- Always validate the `aud` claim

## Related Files
- `app/services/auth/jwt_service.rb`
```

### Updating the Codex

As history unfolds chronologically, update existing prophecies:
- Mark superseded ways with `status: superseded`
- Add "History" sections showing evolution
- Set `status: abandoned` for forsaken approaches

---

## Phase 3: Sealing the Wisdom

### Create the Index of Prophecies

Write `docs/oracle/index.yaml`:

```yaml
version: 1
generated: [timestamp]
last_commit: [most recent SHA]
total_docs: [count]
entries:
  - file: [filename].md
    keywords: [relevant keywords]
    paths: [file patterns affected]
    category: [category]
    summary: [one line]
```

### Update CLAUDE.md

Add a "Wisdom of the Ancients" section:
- Key architectural decisions (1-2 sentences each)
- Active warnings and gotchas
- Current conventions

Keep under 500 words.

### Mark the Bookmark

Create `.claude/oracle-checkpoint.json`:

```json
{
  "last_commit": "[SHA]",
  "last_run": "[timestamp]",
  "prophecies_recorded": [count]
}
```

---

## Report Completion

```
[Oracle] The divination is complete!

  Visions examined: 150
  Prophecies inscribed: 47
  Codex location: docs/oracle/
  CLAUDE.md has received the ancient wisdom
```

---

## The Oracle's Principles

1. **Scry in parallel** - Cast all five visions simultaneously
2. **Gather and distill** - Combine visions before reading
3. **Show the journey** - Let the seeker witness each rune read
4. **Honor the timestamps** - Dates come from git, never from inference
5. **Speak liberally** - False prophecies fade; lost wisdom is gone forever
