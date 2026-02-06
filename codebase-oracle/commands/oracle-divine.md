---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch a background agent or use the Task tool.**

---

## Phase 1: Build Candidate List

First, identify significant commits using these git queries. Run each and collect the SHAs:

### 1. Commits with deletions (gold for institutional knowledge)
```bash
git log --diff-filter=D --format='%H|%aI|%s' --reverse
```

### 2. Large changes (10+ files modified)
```bash
git log --format='%H|%aI|%s' --reverse | while read line; do
  sha=$(echo "$line" | cut -d'|' -f1)
  count=$(git show --stat --format='' "$sha" 2>/dev/null | grep -c '|' || echo 0)
  [ "$count" -ge 10 ] && echo "$line"
done
```

### 3. Keyword matches in commit messages
```bash
git log --grep='refactor\|migrate\|remove\|deprecate\|breaking\|security\|revert\|upgrade\|rename\|restructure\|overhaul\|rewrite\|introduce' -i -E --format='%H|%aI|%s' --reverse
```

### 4. Reverts
```bash
git log --grep='^Revert' --format='%H|%aI|%s' --reverse
```

### 5. Config and schema changes
```bash
git log --format='%H|%aI|%s' --reverse -- '*.yml' '*.yaml' 'Gemfile*' 'package*.json' '**/schema*' '**/migration*' 'config/**'
```

### Combine and deduplicate

Collect all SHAs from above, remove duplicates, sort by date. This is your **candidate list**.

Tell the user: "Phase 1 complete. Found X candidate commits to analyze."

---

## Phase 2: Process Candidates

**For each candidate, show progress:**

```
[Oracle] 1/150: abc1234 (2023-01-15) "Remove legacy auth" → evaluating...
[Oracle] 2/150: def5678 (2023-01-16) "Migrate to JWT" → DOCUMENTING
```

**For candidates worth documenting, get the full context:**

```bash
git show --stat <sha>
git show <sha>  # full diff if needed
```

### What to Document

**CALIBRATION:** For a mature repo, document liberally. 500 candidates should yield 50-100+ docs. False positives are fine - false negatives lose knowledge.

**PHILOSOPHY:** Don't summarize history. Produce documentation that WOULD EXIST if the team had been using compound-engineering from the beginning.

Document these categories:

**Solutions/Patterns** - How things are done:
- Authentication, database patterns, API design, testing strategies

**Learnings** - Things discovered the hard way:
- Why X didn't scale, race conditions, performance gotchas

**Removals** - What was stopped and why:
- Deprecated features, abandoned experiments, removed dependencies

**Conventions** - How things are named/structured:
- File organization, naming patterns, code style decisions

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

Processing chronologically, you'll see patterns change. Update existing docs:
- Mark superseded approaches with `status: superseded`
- Add "History" sections showing evolution
- Link related docs (supersedes, see-also)
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

Add a "Historical Context" section with critical patterns:
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

1. **Build the list first** - Run the git queries, collect candidates, THEN process
2. **Show progress** - User sees each candidate being evaluated
3. **Dates from git** - Never infer dates, use commit timestamps
4. **Document liberally** - False positives fine, false negatives lose knowledge
5. **Present tense** - Write as if patterns are current (unless removed)
