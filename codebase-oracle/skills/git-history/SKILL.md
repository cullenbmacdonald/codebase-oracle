---
name: git-history
description: |
  Knowledge and workflows for mining git commit history to extract institutional knowledge.
  Use this skill when you need to understand why a codebase evolved, not just what it contains.
---

# Git History Mining

This skill provides knowledge for extracting institutional knowledge from git repositories—the "why" behind code decisions that static analysis misses.

## Core Concept

Current Claude file generators analyze code as it exists now. They miss:
- **Architectural pivots** - Why was this approach chosen over alternatives?
- **Bug patterns** - What gotchas have been discovered?
- **Abandoned approaches** - What was tried and didn't work?
- **Convention emergence** - How did patterns evolve?

Codebase Oracle mines commit history to capture this context.

## Tiered Documentation Model

### Tier 1: Always Loaded (CLAUDE.md)

Critical patterns that affect everyday development:
- Key architectural decisions (1-2 sentences each)
- Active gotchas and warnings
- Current conventions

Size target: < 500 words in the Historical Context section.

### Tier 2: On-Demand (docs/history/)

Detailed historical documentation loaded when relevant:
- Full context for architectural decisions
- Complete bug analysis and fixes
- Detailed migration stories

Loaded via:
- Keyword matching in user queries
- File-based routing when editing related files
- Explicit `/oracle:consult <topic>` command

### Tier 3: Raw (git log)

The original commits, available but never bulk-loaded:
- Referenced by SHA in history docs
- Can be inspected for full diff details
- Source of truth when docs need updating

## Workflows

### Initial Mining

1. User runs `/oracle:divine`
2. history-miner agent traverses commits oldest-first
3. significance-judge evaluates each commit
4. context-condenser writes docs when context accumulates
5. Final index and CLAUDE.md section generated

### Incremental Updates

1. User runs `/oracle:renew`
2. Checkpoint tells us last processed commit
3. Only new commits since checkpoint are processed
4. Index and CLAUDE.md updated incrementally

### On-Demand Retrieval

1. User asks question or edits file
2. SessionStart hook has loaded routing index
3. Keywords or file paths matched against index
4. Relevant history docs loaded into context
5. Response includes historical context

## References

For detailed specifications, see:
- `references/significance-criteria.md` - How commits are evaluated
- `references/index-schema.md` - Routing index format
