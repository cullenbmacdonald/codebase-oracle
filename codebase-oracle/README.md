# Codebase Oracle

**Your codebase has a story. Most AI tools only read the last page.**

Codebase Oracle is a Claude Code plugin that mines your git history to understand *why* your code exists—not just what it does. It captures the institutional knowledge that lives in commit messages, PR descriptions, and the evolution of your architecture, then makes that wisdom available to Claude on demand.

---

## The Problem

You've seen this before: an AI assistant confidently suggests a pattern your team abandoned two years ago. Or it recommends an approach that caused a production incident. Or it misses the subtle convention that emerged after three painful refactors.

Static code analysis can't capture:
- Why you migrated from REST to GraphQL (and the edge cases that drove that decision)
- The race condition that took a week to debug
- Why that "weird" naming convention exists
- What you tried before settling on the current architecture

This knowledge lives in your git history. Engineers who've been around carry it implicitly. New team members spend months absorbing it. And AI tools? They're completely blind to it.

## The Solution

Codebase Oracle traverses your commit history and extracts the decisions that matter. It identifies architectural pivots, bug patterns, abandoned approaches, and emerging conventions—then organizes them into documentation that Claude can access when relevant.

The result: an AI assistant that understands your codebase the way a senior engineer does.

---

## How It Works

### Divine the History

Run `/oracle:divine` to analyze your repository's complete git history. The oracle walks through commits chronologically, evaluating each one for institutional knowledge value.

Significant commits are categorized:
- **Architectural pivots** — Framework migrations, new patterns, structural changes
- **Bug patterns** — Recurring issues, discovered gotchas, edge cases
- **Abandoned approaches** — What was tried and why it didn't work
- **Convention emergence** — How your team's standards evolved

### Tiered Knowledge Access

Not everything needs to be in context all the time. Codebase Oracle uses a tiered system:

**Always loaded:** Critical patterns and active gotchas go directly into your CLAUDE.md. These are the things Claude should never forget.

**On-demand:** Detailed historical documentation lives in `docs/history/`. When you ask about authentication, Claude automatically loads the relevant history. When you edit a file, context about that area appears.

**Available but not loaded:** The raw git history remains accessible for deep dives, but doesn't consume context.

### Stay Current

Run `/oracle:renew` after pulling new changes. The oracle picks up where it left off, processing only new commits and updating documentation as needed.

### Ask Questions

Use `/oracle:consult` to query historical context directly:

```
/oracle:consult auth
/oracle:consult --file src/payments/checkout.ts
/oracle:consult --list
```

---

## Installation

```bash
# Clone or download codebase-oracle
git clone https://github.com/cullenbmacdonald/codebase-oracle.git

# Symlink to your Claude Code plugins directory
ln -s /path/to/codebase-oracle ~/.claude/plugins/codebase-oracle
```

The plugin will be available in your next Claude Code session.

## Quick Start

```bash
# In any git repository
cd your-project

# Start Claude Code
claude

# Divine the complete history (run once)
/oracle:divine

# Later, update with new commits
/oracle:renew

# Query specific topics
/oracle:consult authentication
```

---

## Why This Matters

Every codebase accumulates decisions. Some are documented. Most aren't. The ones that matter most—the hard-won lessons from production incidents, the architectural pivots that took months to execute, the patterns that emerged from painful iteration—these live only in the minds of engineers who were there.

When those engineers leave, the knowledge leaves with them. When AI tools work on your code, they're working without that context.

Codebase Oracle changes that. It turns your git history into institutional memory that persists across team changes and enhances every AI interaction with your code.

Your commits already contain the story. Codebase Oracle helps Claude read it.

---

## License

MIT
