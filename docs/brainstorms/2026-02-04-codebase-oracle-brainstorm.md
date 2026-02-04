---
date: 2026-02-04
topic: codebase-oracle
---

# Codebase Oracle

## What We're Building

A Claude Code plugin that mines git commit history to produce smarter skills, agents, and CLAUDE.md files that understand *why* a codebase evolved the way it did—not just its current state.

The tool walks merge commits chronologically, identifies significant architectural decisions, and produces tiered documentation:
- **Critical patterns** baked into CLAUDE.md (always loaded)
- **Detailed history docs** queryable on-demand via keyword/file routing or MCP service

The key insight: current Claude file generators analyze static code and miss institutional knowledge. Codebase Oracle captures the "why" that only commit history reveals.

## Why This Approach

**Parallel paths:** We're designing two storage/retrieval backends:

1. **File-based (Approach A)** - For smaller repos or teams wanting simplicity
   - `docs/history/index.md` acts as a routing manifest
   - `docs/history/*.md` contains detailed historical docs
   - Keyword + file-based routing loads docs on-demand

2. **MCP-based (Approach C)** - For enterprise scale and multi-repo access
   - Central MCP server indexes history across repos
   - Enables cross-repo queries ("why does the API client work this way?" while in consumer repo)
   - Semantic search capabilities

Both share the same history-mining core; only the storage/retrieval layer differs.

**Why significance-based condensation:** For large repos, context limits require breaking up the traversal. Rather than arbitrary checkpoints (every N commits), we pause at significant changes—major refactors, framework migrations, architectural pivots. This preserves semantic boundaries.

**Why merge commits only:** Merge commits represent reviewed units of work with PR descriptions that explain intent. Individual commits are often noise ("fix typo", "WIP"). Merge commits are the meaningful history.

## Key Decisions

- **Target user:** Team/org tooling (runs periodically, not ad-hoc)
- **Primary output:** Smarter skills/agents that behave differently because they understand history
- **Traversal order:** Oldest-first chronological (builds understanding like an engineer who was there)
- **Commit selection:** Merge commits only (meaningful units with PR context)
- **Context access model:** Tiered—critical in CLAUDE.md, detailed queryable on-demand
- **History storage:** `docs/history/` committed to repo (visible, versioned)
- **Condensation trigger:** Significance-based (major changes trigger checkpoint)
- **Query triggers:** Combined approach
  - Keyword matching (primary)
  - File-based routing (when modifying files with history)
  - Explicit `/history <topic>` command (escape hatch)

## Insight Categories to Capture

1. **Architectural pivots** - Major refactors, framework changes, why team moved from X to Y
2. **Bug patterns** - Recurring issues, gotchas that caused problems
3. **Abandoned approaches** - Things tried and reverted (what NOT to do)
4. **Convention emergence** - How coding patterns evolved

## Open Questions

1. **How to detect "significant" commits?** Options:
   - File count threshold
   - Certain file patterns (migrations, config, core modules)
   - Commit message keywords ("refactor", "migrate", "breaking")
   - LLM judgment call during traversal

2. **What format for the routing index?** Needs to be cheap to parse, support keyword and file-path lookups.

3. **How to handle PR descriptions that are missing or low-quality?** The merge commit message alone may not explain "why."

4. **MCP server architecture** - Separate brainstorm needed for the multi-repo MCP design.

5. **Incremental updates** - How does the tool handle new commits after initial history processing?

## Next Steps

→ `/workflows:plan` for implementation details
