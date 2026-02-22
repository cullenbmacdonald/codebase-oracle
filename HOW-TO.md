# How to Use Codebase Oracle

Codebase Oracle is a Claude Code plugin that extracts institutional knowledge from your git history and makes it available to Claude as searchable documentation.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- A git repository with commit history

## Installation

```bash
# Clone the plugin
git clone https://github.com/cullenbmacdonald/codebase-oracle.git

# Symlink it into Claude Code's plugins directory
ln -s /path/to/codebase-oracle ~/.claude/plugins/codebase-oracle
```

Restart Claude Code. The `/oracle:*` commands will now be available in any session.

## Step 1: Run the Initial Divination

Navigate to your project directory and start Claude Code:

```bash
cd your-project
claude
```

Run the divine command to analyze your full git history:

```
/oracle:divine
```

This performs three phases:

1. **Scrying** — Runs 5 parallel `git log` queries to identify significant commits (deletions, large changes, keyword matches, reverts, and config changes).
2. **Reading** — Examines each candidate commit and extracts useful institutional knowledge, writing it as markdown "prophecy" files to `docs/oracle/`.
3. **Sealing** — Creates `docs/oracle/index.yaml` (a searchable index), updates `CLAUDE.md` with key patterns and warnings, and saves a checkpoint to `.claude/oracle-checkpoint.json`.

Depending on your history size, this may take several minutes. You'll see progress as each commit is evaluated.

## Step 2: Query the Knowledge Base

Once divination is complete, you can query the oracle:

```
# Search by topic
/oracle:consult auth
/oracle:consult caching
/oracle:consult payments

# Search by file path
/oracle:consult --file src/payments/checkout.ts

# List all documented topics
/oracle:consult --list
```

The oracle reads `docs/oracle/index.yaml`, finds matching entries, and presents the relevant historical context.

## Step 3: Keep It Current

After pulling new commits, run:

```
/oracle:renew
```

This reads the checkpoint to find where it left off, runs the same queries scoped to new commits only, and updates the index and documentation with any new findings.

## What Gets Generated

| File | Purpose |
|------|---------|
| `docs/oracle/index.yaml` | Searchable index of all documented topics |
| `docs/oracle/*.md` | Individual knowledge documents per topic |
| `CLAUDE.md` | Updated with key patterns and active warnings |
| `.claude/oracle-checkpoint.json` | Tracks the last processed commit |

## Knowledge Categories

The oracle documents four types of institutional knowledge:

- **Sacred Patterns** — How things are done (auth flows, API design, database patterns)
- **Hard-Won Wisdom** — Lessons from production incidents, race conditions, scaling issues
- **Abandoned Paths** — Approaches that were tried and discarded, and why
- **The Old Ways** — Naming conventions and structural decisions that evolved over time

## How Claude Uses This Context

After divination, Claude automatically has access to:

- The `CLAUDE.md` additions, which are loaded in every session
- The `docs/oracle/` files, which can be loaded on demand via `/oracle:consult`

This means Claude will understand *why* your code is structured a certain way, not just *what* it does—avoiding suggestions that contradict hard-won decisions buried in your history.
