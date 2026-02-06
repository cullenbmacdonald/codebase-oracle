---
name: git-history
description: |
  Knowledge and workflows for divining wisdom from git commit history.
  Use this skill when you need to understand why a codebase evolved, not just what it contains.
---

# The Art of Divination

This skill provides knowledge for extracting institutional wisdom from git repositories—the "why" behind code decisions that static analysis misses.

## The Oracle's Purpose

Current Claude file generators analyze code as it exists now. They miss:
- **Sacred Patterns** - Why was this approach chosen over alternatives?
- **Hard-Won Wisdom** - What gotchas have been discovered through tribulation?
- **Abandoned Paths** - What was tried and didn't work?
- **The Old Ways** - How did conventions emerge and evolve?

The Codebase Oracle divines commit history to capture this ancient knowledge.

## The Tiered Codex

### Tier 1: Always Present (CLAUDE.md)

Critical wisdom that affects everyday development:
- Key architectural decisions (1-2 sentences each)
- Active warnings and gotchas
- Current conventions

Size target: < 500 words in the Wisdom of the Ancients section.

### Tier 2: On-Demand (docs/oracle/)

Detailed prophecies loaded when relevant:
- Full context for architectural decisions
- Complete bug analysis and fixes
- Detailed migration stories

Summoned via:
- Keyword matching in seeker queries
- File-based routing when editing related artifacts
- Explicit `/oracle:consult <topic>` command

### Tier 3: Raw Runes (git log)

The original commits, available but never bulk-loaded:
- Referenced by SHA in prophecies
- Can be inspected for full diff details
- Source of truth when prophecies need updating

## The Sacred Workflows

### Initial Divination

1. Seeker invokes `/oracle:divine`
2. Rune-reader agent traverses commits oldest-first
3. Vision-judge evaluates each commit for wisdom
4. Codex-scribe inscribes prophecies when visions accumulate
5. Final index and CLAUDE.md wisdom section generated

### Renewal of Knowledge

1. Seeker invokes `/oracle:renew`
2. Bookmark reveals last processed commit
3. Only new commits since bookmark are divined
4. Index and CLAUDE.md updated with new wisdom

### Consulting the Oracle

1. Seeker asks question or edits artifact
2. SessionStart hook has loaded the index of prophecies
3. Keywords or file paths matched against index
4. Relevant prophecies summoned into context
5. Response includes ancient wisdom

## References

For detailed specifications, consult:
- `references/significance-criteria.md` - How visions are judged
- `references/index-schema.md` - Index of prophecies format
