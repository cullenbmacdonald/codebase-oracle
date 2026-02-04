---
title: "feat: Codebase Oracle Plugin"
type: feat
date: 2026-02-04
---

# feat: Codebase Oracle Plugin

## Overview

Codebase Oracle is a Claude Code plugin that mines git commit history to produce smarter skills, agents, and CLAUDE.md files that understand *why* a codebase evolved—not just its current state. It captures institutional knowledge that static code analysis misses: architectural pivots, bug patterns, abandoned approaches, and convention emergence.

## Problem Statement / Motivation

Current tooling that generates Claude files (CLAUDE.md, skills, agents) analyzes static code and misses critical context:

- **Why** was this architecture chosen?
- **What** approaches were tried and abandoned?
- **When** did conventions emerge and why?
- **Which** bugs recur and how were they fixed?

Engineers who've been with a project carry this knowledge implicitly. New engineers, and Claude, lack it. Codebase Oracle extracts this institutional knowledge from git history and makes it available in a tiered system: critical patterns always loaded, detailed history queryable on-demand.

## Proposed Solution

A Claude Code plugin with two parallel paths:

### File-Based Backend (Simpler)
- `docs/history/index.yaml` - routing manifest mapping keywords/files → docs
- `docs/history/*.md` - detailed historical documentation per significant change
- `CLAUDE.md` section - critical patterns always in context

### MCP-Based Backend (Enterprise)
- Central MCP server indexing history across multiple repos
- Semantic search for historical context
- Cross-repo queries (e.g., "why does the API client work this way?" while in consumer repo)

Both share the same **history-mining core**:

```
┌─────────────────────────────────────────────────────────────────┐
│                      Codebase Oracle                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐ │
│  │ Git Walker  │───>│ Significance│───>│ Context Condenser   │ │
│  │             │    │ Detector    │    │                     │ │
│  └─────────────┘    └─────────────┘    └─────────────────────┘ │
│         │                  │                      │             │
│         v                  v                      v             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐ │
│  │ Diff Parser │    │ LLM Judge   │    │ Doc Writer          │ │
│  │             │    │             │    │                     │ │
│  └─────────────┘    └─────────────┘    └─────────────────────┘ │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Storage Backends                         ││
│  │  ┌─────────────┐              ┌─────────────────────────┐  ││
│  │  │ File-Based  │              │ MCP Server              │  ││
│  │  │ (docs/)     │              │ (semantic search)       │  ││
│  │  └─────────────┘              └─────────────────────────┘  ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Technical Considerations

### Git Workflow Compatibility

**Decision:** Fall back to significant commits when merge commits aren't available.

| Workflow | Detection | Processing |
|----------|-----------|------------|
| Merge-based | `git log --merges` returns results | Process merge commits |
| Squash-merge | No merge commits, but PRs exist | Process commits matching significance criteria |
| Rebase | No merge commits, linear history | Process commits matching significance criteria |
| Mixed | Some merges, some squashes | Process both merge commits and significant non-merges |

### Significance Detection

**Decision:** LLM judgment for each commit.

The LLM evaluates each commit against these criteria:
- **Architectural changes:** New modules, framework migrations, pattern shifts
- **Bug patterns:** Recurring issues, gotchas, edge cases discovered
- **Abandoned approaches:** Reverted commits, replaced implementations
- **Convention changes:** Naming, structure, testing pattern evolution

Prompt for significance detection:
```
Analyze this commit to determine if it represents significant institutional knowledge:

Commit: {sha}
Message: {message}
Files changed: {file_list}
Diff summary: {diff_stats}

Consider:
1. Does this change architecture or patterns?
2. Does this fix a recurring bug or reveal a gotcha?
3. Does this revert or replace a previous approach?
4. Does this establish or change conventions?

Respond with:
- significant: true/false
- category: architectural_pivot | bug_pattern | abandoned_approach | convention_emergence | not_significant
- brief_reason: <one sentence explanation>
```

### Context Condensation

**Trigger:** Before Claude's automatic summarization kicks in (proactive condensation).

**Strategy:**
1. Track accumulated context as commits are processed
2. When approaching ~50K tokens, pause and write current findings
3. Generate a summary document for the processed range
4. Clear working context, retain checkpoint marker
5. Continue from checkpoint

**Checkpoint format** (`.claude/oracle-checkpoint.json`):
```json
{
  "last_commit_sha": "abc123def456",
  "last_commit_date": "2024-03-15T10:30:00Z",
  "docs_generated": ["2024-01-auth-migration.md", "2024-02-api-refactor.md"],
  "total_commits_processed": 150,
  "total_significant": 12
}
```

### Missing PR Description Handling

**Decision:** Almost always infer from diff using LLM.

When commit message is unhelpful (< 50 chars or generic like "Fixed bug"):
```
The commit message "{message}" doesn't explain the reasoning.
Analyze the diff to infer:
1. What problem was being solved?
2. Why was this approach chosen?
3. What alternatives might have been considered?

Diff:
{diff_content}
```

### Index Format (Routing Manifest)

**File:** `docs/history/index.yaml`

```yaml
version: 1
generated: 2026-02-04T12:00:00Z
last_commit: abc123def456
total_docs: 12

entries:
  - file: 2024-03-auth-migration.md
    keywords: [auth, jwt, oauth, session, login, authentication, token]
    paths:
      - "src/auth/**"
      - "lib/session.ts"
      - "config/auth.yaml"
    commits: [abc123, def456]
    category: architectural_pivot
    summary: "Migration from cookie-based sessions to JWT authentication"

  - file: 2024-05-api-client-refactor.md
    keywords: [api, client, http, fetch, request, retry]
    paths:
      - "src/api/**"
      - "lib/http-client.ts"
    commits: [ghi789]
    category: architectural_pivot
    summary: "Refactored API client to use fetch with retry logic"
```

### Query Triggers

| Trigger | Implementation | Example |
|---------|----------------|---------|
| **Keyword matching** | Parse user message for index keywords | "Why do we use JWT?" → matches `auth, jwt` → loads auth-migration.md |
| **File-based routing** | When modifying files, check index paths | Editing `src/auth/login.ts` → matches `src/auth/**` → loads auth-migration.md |
| **Explicit command** | `/history <topic>` slash command | `/history auth` → keyword search → loads relevant docs |

### CLAUDE.md Integration

**Strategy:** Append to a clearly marked section, preserve existing content.

```markdown
<!-- Existing CLAUDE.md content preserved above -->

## Historical Context (Auto-generated by Codebase Oracle)

> Last updated: 2026-02-04 | Commits analyzed: 1,247 | Significant patterns: 15

### Critical Patterns

**Authentication:** Uses JWT tokens (migrated from sessions in 2024 due to scaling).
See `docs/history/2024-03-auth-migration.md` for full context.

**API Client:** Custom fetch wrapper with exponential backoff retry.
See `docs/history/2024-05-api-client-refactor.md` for full context.

### Gotchas

- **Race condition in checkout:** Always await cart.save() before redirect.
  See `docs/history/2024-07-checkout-race-fix.md`.

### Conventions

- **Naming:** Components use PascalCase, hooks use camelCase with `use` prefix.
- **Testing:** Co-locate tests in `__tests__/` directories.

---
*For detailed history, run `/history <topic>` or see `docs/history/index.yaml`*
```

## Acceptance Criteria

### Core Functionality

- [x] Plugin structure follows Claude Code conventions (skills/, agents/, commands/, hooks/)
- [x] Traverses git history oldest-first
- [x] Detects merge commits; falls back to significant commits when none exist
- [x] Uses LLM to judge commit significance
- [x] Infers intent from diffs when commit messages are unhelpful
- [x] Writes history docs to `docs/history/*.md`
- [x] Generates routing index at `docs/history/index.yaml`
- [x] Appends critical patterns to CLAUDE.md
- [x] Supports incremental updates (new commits since last run)

### Context Management

- [x] Proactively condenses context before hitting limits
- [x] Maintains checkpoint for resume capability
- [x] Progressive disclosure: lean index, detailed docs on-demand

### Retrieval System

- [x] Keyword matching loads relevant history docs
- [x] File-based routing triggers on file modification
- [x] `/history` slash command for explicit retrieval
- [x] SessionStart hook loads index for routing

### Testing

- [x] Works on repos with merge-commit workflow
- [x] Works on repos with squash-merge workflow
- [x] Handles repos with shallow clones gracefully (warning + proceed)
- [x] Recovers from interrupted processing via checkpoint

## Success Metrics

- **Coverage:** >80% of significant architectural decisions captured
- **Accuracy:** LLM significance detection has <10% false negatives
- **Utility:** Queries return relevant history docs >90% of the time
- **Performance:** Initial run completes in reasonable time (hours acceptable for large repos)

## Dependencies & Risks

### Dependencies

- **Git CLI:** Must be available in environment
- **GitHub CLI (optional):** For enhanced PR metadata fetching
- **Claude Code plugin system:** Skills, agents, hooks, commands

### Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Large repos take too long | User abandonment | Progress indicators, background processing |
| LLM significance detection inconsistent | Missed patterns or noise | Tune prompts, allow manual overrides |
| Shallow clones in CI | Missing history | Detect and warn, suggest `--unshallow` |
| Context limit hit mid-commit | Data loss | Checkpoint before each commit group |

## Plugin Structure

```
codebase-oracle/
├── .claude-plugin/
│   └── plugin.json                    # Plugin manifest
├── skills/
│   └── git-history/
│       ├── SKILL.md                   # History mining knowledge
│       └── references/
│           ├── significance-criteria.md
│           └── index-schema.md
├── agents/
│   ├── history-miner.md               # Traverses and analyzes history
│   ├── significance-judge.md          # Evaluates commit significance
│   └── context-condenser.md           # Summarizes findings
├── commands/
│   ├── oracle-mine.md                 # /oracle:mine - full history run
│   ├── oracle-update.md               # /oracle:update - incremental
│   └── history.md                     # /history <topic> - retrieval
├── hooks/
│   └── hooks.json                     # SessionStart: load index
└── scripts/
    ├── detect-workflow.sh             # Detect merge vs squash vs rebase
    ├── get-commits.sh                 # Fetch commit list with metadata
    └── parse-diff.sh                  # Generate diff summaries
```

## References & Research

### Internal References
- Brainstorm: `docs/brainstorms/2026-02-04-codebase-oracle-brainstorm.md`

### External References
- Claude Code Plugin Development: Standard plugin structure with skills/, agents/, hooks/
- MCP TypeScript SDK: `@modelcontextprotocol/server`, `@modelcontextprotocol/node`
- Git history analysis: `git log --format`, `git diff`, `gh pr view`
- Conventional Commits: For message parsing and categorization

### Patterns
- Progressive disclosure: Lean SKILL.md router, detailed references on-demand
- Tiered documentation: Always-loaded (CLAUDE.md) → on-demand (docs/history/)
- Hook-based context injection: SessionStart loads routing index
