---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch a background agent or use the Task tool. Process candidates inline and show progress to the user.**

## Two-Phase Approach

This command uses a **two-phase approach** for deterministic execution:

1. **Phase 1 (Script):** Run `filter-candidates.sh` to identify significant commits using heuristics
2. **Phase 2 (Claude):** Process the bounded candidate list, creating documentation

This ensures every candidate gets processed - no summarizing or skipping.

---

## Phase 1: Generate Candidates

First, run the filter script to identify significant commits:

```bash
# From the repo root where codebase-oracle is installed
bash .claude-plugin/scripts/filter-candidates.sh
```

Or if running from within the codebase-oracle directory:
```bash
bash scripts/filter-candidates.sh
```

This creates `docs/oracle/.candidates.json` with commits filtered by:
- File deletions (something was removed - why?)
- Large changes (10+ files modified)
- Keyword matches (refactor, migrate, remove, deprecate, breaking, security, etc.)
- New directories introduced
- Reverts (something didn't work)
- Config/schema changes

Tell the user: "Phase 1 complete. Found X candidate commits to analyze."

---

## Phase 2: Process Candidates

Read the candidates file:

```bash
cat docs/oracle/.candidates.json
```

**For each candidate in the array, show progress:**

```
[Oracle] 1/150: abc1234 (2023-01-15) "Remove legacy auth" [deletion]
[Oracle] 2/150: def5678 (2023-01-16) "Migrate to JWT" [keyword]
[Oracle] 3/150: ghi9012 (2023-01-17) "Add payments module" [new_directory] → DOCUMENTING
```

**For candidates worth documenting, get the full diff:**

```bash
git show --stat <sha>
git show <sha>  # if you need the actual diff
```

### Document Liberally

**CALIBRATION:** For a mature repo, expect to document A LOT. 500 candidates should yield 50-100+ history docs. When in doubt, document it.

**PHILOSOPHY:** Don't summarize history. Produce documentation that WOULD EXIST if the team had been using compound-engineering from the beginning.

### What to Document

**Solutions/Patterns** - How we do things:
- Authentication approach
- Database patterns
- API design conventions
- Testing strategies

**Learnings** - Things discovered the hard way:
- Why X didn't scale
- Race conditions found
- Performance gotchas

**Removals** - What we stopped doing and why:
- Deprecated features
- Abandoned experiments
- Removed dependencies

**Conventions** - How we name/structure things:
- File organization
- Naming patterns
- Code style decisions

### Document Format

Write as if you're the engineer who just finished the work:

```markdown
---
title: JWT Authentication
category: authentication
tags: [jwt, auth, tokens, security]
source_commits: [abc1234, def5678]
---

# JWT Authentication

## Overview
We use JWT tokens for API authentication. Tokens are issued on login and validated on each request.

## Implementation
[Specific details from the code]

## Gotchas
- Tokens must be refreshed before expiry, not after
- Always validate the `aud` claim

## Related Files
- `app/services/auth/jwt_service.rb`
- `app/middleware/authenticate.rb`
```

### Update Docs as History Unfolds

As you process candidates chronologically, update existing docs when patterns change:

- Mark superseded approaches
- Add "History" sections showing evolution
- Link related docs (supersedes, see-also)
- Set `status: removed` for deprecated features

---

## Phase 3: Finalize

### Create Index

Write `docs/oracle/index.yaml`:

```yaml
version: 1
generated: [current timestamp]
last_commit: [most recent SHA processed]
total_docs: [count]
entries:
  - file: [filename].md
    keywords: [relevant keywords]
    paths: [file patterns affected]
    category: [category]
    summary: [one line summary]
```

### Update CLAUDE.md

Add or update a "Historical Context" section with the most critical patterns:
- Key architectural decisions (1-2 sentences each)
- Active gotchas and warnings
- Current conventions

Keep it under 500 words.

### Mark Candidates Processed

Update the candidates file to mark completion:

```bash
# Update .candidates.json to set all "processed": true
# Or simply delete it since divine is complete
rm docs/oracle/.candidates.json
```

### Save Checkpoint

Create `.claude/oracle-checkpoint.json`:

```json
{
  "last_commit": "[most recent SHA]",
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
- CLAUDE.md updated with critical patterns
```

---

## Key Principles

1. **Bounded iteration** - Process the candidates file, not "all commits"
2. **Show progress** - User sees each candidate being evaluated
3. **Dates from git** - Never infer dates, always use commit timestamps
4. **Document liberally** - False positives are fine, false negatives lose knowledge
5. **Present tense** - Write docs as if patterns are current (unless removed)
6. **Specific and actionable** - Not vague historical summaries
