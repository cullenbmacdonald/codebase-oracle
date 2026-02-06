---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch this command as a background agent.**

---

## Phase 1: Gather Candidates (Parallel)

Run these **5 Bash commands in parallel** (all in one message). Each writes to a temp file:

```bash
# 1. Commits with deletions
git log --diff-filter=D --format='%H|%aI|%s' --reverse > /tmp/oracle-deletions.txt

# 2. Large changes (10+ files)
git log --shortstat --format='%H|%aI|%s|' --reverse | awk '/\|$/{info=$0} /files? changed/{if($1>=10) print info}' > /tmp/oracle-large.txt

# 3. Keyword matches
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse > /tmp/oracle-keywords.txt

# 4. Reverts
git log --grep='^Revert' --format='%H|%aI|%s' --reverse > /tmp/oracle-reverts.txt

# 5. Config/schema changes
git log --format='%H|%aI|%s' --reverse -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' 'Cargo.toml' 'go.mod' 'requirements*.txt' '**/schema*' '**/migration*' 'config/**' 'db/migrate/**' > /tmp/oracle-config.txt
```

**Call all 5 Bash commands in a single message** so they run in parallel.

### Combine Results

After all 5 complete, run:

```bash
cat /tmp/oracle-*.txt | cut -d'|' -f1-3 | sort -t'|' -k2 -u | sort -t'|' -k1 -u > /tmp/oracle-candidates.txt && wc -l < /tmp/oracle-candidates.txt
```

This deduplicates by SHA and sorts by date. Read the combined file:

```bash
cat /tmp/oracle-candidates.txt
```

Tell the user: "Phase 1 complete. Found X unique candidates."

---

## Phase 2: Process Candidates

**For each candidate, show progress:**

```
[Oracle] 1/150: abc1234 (2023-01-15) "Remove legacy auth" → evaluating...
[Oracle] 2/150: def5678 (2023-01-16) "Migrate to JWT" → DOCUMENTING
```

**For candidates worth documenting, get context:**

```bash
git show --stat <sha>
git show <sha>  # full diff if needed
```

### What to Document

**CALIBRATION:** Document liberally. 500 candidates should yield 50-100+ docs. False positives are fine.

**PHILOSOPHY:** Don't summarize history. Produce documentation that WOULD EXIST if the team had used compound-engineering from the start.

**Categories:**

- **Solutions/Patterns** - How things are done (auth, database, API design)
- **Learnings** - Things discovered the hard way (scaling issues, race conditions)
- **Removals** - What was stopped and why (deprecated features, abandoned experiments)
- **Conventions** - How things are named/structured

### Document Format

Write as the engineer who just finished the work:

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

### Update Docs as History Unfolds

Processing chronologically, update existing docs when patterns change:
- Mark superseded approaches with `status: superseded`
- Add "History" sections showing evolution
- Set `status: removed` for deprecated features

---

## Phase 3: Finalize

### Create Index

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

Add a "Historical Context" section:
- Key architectural decisions (1-2 sentences each)
- Active gotchas and warnings
- Current conventions

Keep under 500 words.

### Save Checkpoint

Create `.claude/oracle-checkpoint.json`:

```json
{
  "last_commit": "[SHA]",
  "last_run": "[timestamp]",
  "docs_created": [count]
}
```

---

## Report Completion

```
[Oracle] Divination complete!
- Candidates analyzed: 150
- Docs written: 47
- Index: docs/oracle/index.yaml
- CLAUDE.md updated
```

---

## Key Principles

1. **Parallel candidate gathering** - Launch 5 agents simultaneously
2. **Combine and dedupe** - Merge results before processing
3. **Show progress** - User sees each candidate evaluated
4. **Dates from git** - Never infer, use commit timestamps
5. **Document liberally** - False positives fine, false negatives lose knowledge
