# Codebase Oracle

A Claude Code plugin that mines git commit history to produce smarter skills, agents, and CLAUDE.md files that understand *why* a codebase evolved—not just its current state.

## Installation

1. Copy or symlink the `codebase-oracle` directory to your Claude Code plugins directory
2. The plugin will be automatically discovered on next session

## Commands

### `/oracle:divine`

Perform a full mining of the repository's git history. This traverses all commits from oldest to newest, identifies significant patterns, and generates documentation.

```
/oracle:divine
```

**Output:**
- `docs/oracle:consult/*.md` - Detailed documentation for each significant pattern
- `docs/oracle:consult/index.yaml` - Routing index for on-demand retrieval
- Updated `CLAUDE.md` - Critical patterns section added
- `.claude/oracle-checkpoint.json` - Progress marker

### `/oracle:renew`

Incrementally update historical documentation with new commits since the last run.

```
/oracle:renew
```

### `/oracle:consult <topic>`

Query historical context for a specific topic or file.

```
/oracle:consult auth          # Search by keyword
/oracle:consult --file src/auth/login.ts  # Search by file path
/oracle:consult --list        # List all available topics
```

## How It Works

### Tiered Documentation

1. **CLAUDE.md** (always loaded) - Critical patterns, gotchas, conventions
2. **docs/oracle:consult/** (on-demand) - Detailed historical documentation
3. **git log** (never bulk-loaded) - Raw commits for reference

### Significance Detection

Commits are evaluated for:
- **Architectural pivots** - Framework migrations, pattern introductions
- **Bug patterns** - Recurring issues, gotchas discovered
- **Abandoned approaches** - Reverted features, replaced implementations
- **Convention emergence** - Naming, testing, structure conventions

### Workflow Detection

The plugin automatically detects:
- **Merge-based** - Process merge commits
- **Squash-merge** - Process all commits, filter by significance
- **Rebase** - Process all commits, filter by significance
- **Mixed** - Process merge commits AND significant non-merges

## Plugin Structure

```
codebase-oracle/
├── .claude-plugin/plugin.json    # Plugin manifest
├── agents/
│   ├── history-miner.md          # Traverses git history
│   ├── significance-judge.md     # Evaluates commit significance
│   └── context-condenser.md      # Writes documentation
├── commands/
│   ├── oracle-mine.md            # /oracle:divine
│   ├── oracle-update.md          # /oracle:renew
│   └── history.md                # /oracle:consult <topic>
├── skills/
│   └── git-history/
│       ├── SKILL.md              # History mining knowledge
│       └── references/           # Detailed schemas
├── hooks/
│   └── hooks.json                # SessionStart hook
└── scripts/
    ├── detect-workflow.sh        # Workflow detection
    ├── get-commits.sh            # Commit fetching
    └── parse-diff.sh             # Diff parsing
```

## License

MIT
