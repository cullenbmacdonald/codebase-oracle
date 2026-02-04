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

## The Legacy Repository Disadvantage

Here's an uncomfortable truth: repositories created before the age of AI coding assistants are at a structural disadvantage—and that gap widens every day.

**New repositories can be AI-native from birth.** Teams starting projects today can write CLAUDE.md files on day one. They can craft commit messages knowing an AI will read them. They can capture architectural decisions in formats optimized for language model consumption. Every piece of context is explicit because they know implicit knowledge doesn't transfer to AI.

**Legacy repositories have years of implicit knowledge baked in.** The conventions exist but aren't written down. The architectural decisions made sense to the team at the time—no need to explain why when everyone shared the context. Commit messages like "fixed the bug" were fine because the humans reading them knew which bug.

**The "catch-up" tools don't actually catch up.** There's an emerging category of tools that analyze your static codebase and generate AI context files. They scan your code structure, infer patterns, and produce a CLAUDE.md. This is better than nothing, but it's fundamentally limited.

These tools can only see what exists now. They can tell you that your codebase uses service objects, but not that you tried three other patterns first. They can document your current authentication flow, but not the security incident that shaped it. They produce a snapshot of the present while the institutional knowledge that matters most lives in the journey.

**The engineers who made the decisions are often gone.** That architect who chose the event-driven pattern? Left eighteen months ago. The tech lead who vetoed GraphQL the first time? At another company now. Their reasoning exists only in scattered PR descriptions, terse commit messages, and maybe a few outdated wiki pages.

**Every day, the gap compounds.** AI-native repositories accumulate well-documented context with every commit. Legacy repositories continue operating the old way—implicit knowledge, terse commits, context in people's heads. The teams that benefit most from AI assistance are increasingly the ones who need it least.

Codebase Oracle exists to close this gap. Your git history already contains the decisions, the pivots, the lessons learned. It's just encoded in a format that AI tools can't easily access. The oracle reads between the lines of your commits, extracts the institutional knowledge, and makes it available in a way that actually helps.

You can't go back and rewrite five years of commit messages. But you can mine them for the wisdom they contain.

This is how legacy repositories catch up. Not by pretending the last five years didn't happen, but by extracting the value from them. Teams using modern AI-native toolchains like [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin) get the benefit of purpose-built context, documented decisions, and explicit conventions. Codebase Oracle lets older repositories gain similar benefits by deriving that context from their existing history.

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
