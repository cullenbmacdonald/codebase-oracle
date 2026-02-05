---
name: oracle:divine
description: Divine institutional knowledge from the complete git history
---

# Divine Repository History

Channel the oracle to divine institutional knowledge from this repository's complete git history.

**IMPORTANT: Execute these steps directly. Do NOT launch a background agent or use the Task tool. Process commits inline and show progress to the user.**

**CALIBRATION: For a mature repo, expect to document A LOT. A 6-year repo with 17k commits should yield 50-100+ history docs, not 12. When in doubt, document it. False positives are fine - false negatives mean lost institutional knowledge.**

**PHILOSOPHY: Don't summarize history. Recreate the documentation that WOULD EXIST if the team had been using compound-engineering from the beginning.**

Instead of "In 2023, we migrated to JWT," produce:
- A `docs/solutions/` entry about the JWT authentication pattern
- A gotcha doc about session migration edge cases
- A learning about why cookies didn't scale

Write documents as if you're the engineer who just finished the work and is documenting it for the next person. Use present tense for patterns that still apply. Be specific and actionable, not historical and summarizing.

## Step 1: Announce and Count

First, tell the user what you're doing and count commits:

```bash
git rev-list --count HEAD
```

Say: "Divining history from X commits. This will take a moment..."

## Step 2: Get All Commits

```bash
git log --reverse --format='%H|%aI|%an|%s'
```

Parse this into a list. Each line is: `SHA|DATE|AUTHOR|MESSAGE`

## Step 3: Process Each Commit (Show Progress)

For each commit, show the user what you're looking at:

```
[Oracle] 1/500: abc1234 (2023-01-15) "Initial commit"
[Oracle] 2/500: def5678 (2023-01-16) "Add user model"
[Oracle] 3/500: ghi9012 (2023-01-17) "Implement authentication" → SIGNIFICANT: introduces auth pattern
```

For commits that look significant, run:
```bash
git show --stat <sha>
```

**BE AGGRESSIVE about what's significant.** Document liberally. For a large repo, you should be flagging 5-10% of commits as worth documenting.

### Always Document:
- **Any deletion** of files/directories - someone removed something, why?
- **New directories/modules** - new capability added
- **Database migrations** - schema evolved
- **Config changes** - architectural decisions
- **Dependency changes** - especially major version bumps
- **Any commit with 10+ files** - something big happened
- **Any revert** - something didn't work
- **First commit by a new author** - team change
- **Commits mentioning**: refactor, migrate, remove, deprecate, breaking, introduce, fix, security, performance, upgrade

### Document by Time Period Too:
For large repos, also create yearly/quarterly summaries:
- What major things happened in 2019? 2020? 2021? etc.
- How did the team/architecture evolve year over year?
- What was the "era" of each time period?

### Look for Stories:
Multiple related commits tell a story:
- Feature introduced → bugs fixed → eventually removed = full lifecycle
- Multiple commits to same area = someone was iterating on something hard
- Commits by same author in short period = focused work session on something

## Step 4: Accumulate Findings

As you find significant commits, group them by:

**By Theme:**
- Architectural changes
- Bug fixes / gotchas discovered
- Things removed / abandoned
- Conventions established
- Performance improvements
- Security changes
- Team/ownership changes

**By Time Period:**
- What happened each year?
- What were the major "eras" of the codebase?
- When did major shifts occur?

**By Area:**
- Authentication/authorization evolution
- Database/data model changes
- API changes
- Frontend changes
- Infrastructure/deployment changes

**Target: For 17k commits, aim for 50-100 history docs minimum.**

## Step 5: Write Documentation (Compound-Engineering Style)

Create `docs/oracle/` directory if needed:
```bash
mkdir -p docs/oracle
```

**Write documents as if you're the engineer who just finished the work.** Not historical summaries, but actionable documentation that would exist if the team had been documenting all along.

### Document Types to Create:

**Solutions/Patterns** (how we do things):
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
- Store refresh tokens securely, not in localStorage

## Related Files
- `app/services/auth/jwt_service.rb`
- `app/middleware/authenticate.rb`
```

**Learnings** (things we discovered the hard way):
```markdown
---
title: Cookie Sessions Don't Scale
category: learning
tags: [sessions, scaling, cookies]
source_commits: [ghi789]
discovered: 2023-03-15
---

# Cookie Sessions Don't Scale Past 10K Concurrent Users

## The Problem
We hit session storage limits when traffic spiked during the product launch.

## What We Tried
- Sticky sessions (didn't help with deploys)
- Redis session store (added latency)

## What Worked
Migrated to stateless JWT tokens. See `docs/oracle/jwt-authentication.md`.

## Symptoms
- Random logouts during high traffic
- Session store timeouts in logs
```

**Removals/Deprecations** (what we stopped doing and why):
```markdown
---
title: GraphQL API Removal
category: abandoned
tags: [graphql, api, rest]
source_commits: [jkl012, mno345]
removed: 2024-06-01
---

# Why We Removed the GraphQL API

## What It Was
Experimental GraphQL endpoint at `/graphql` for mobile clients.

## Why We Removed It
- N+1 query problems were hard to solve
- Caching was complex
- Mobile team preferred REST with specific endpoints

## Migration Path
All mobile clients now use `/api/v2/` REST endpoints.

## Don't Repeat This
If considering GraphQL again, solve the N+1 problem first.
```

**Conventions** (how we name/structure things):
```markdown
---
title: Service Object Pattern
category: convention
tags: [services, patterns, ruby]
source_commits: [pqr678]
established: 2022-08-10
---

# Service Object Convention

## Pattern
All business logic goes in `app/services/`. One public method: `call`.

## Naming
`{Verb}{Noun}Service` - e.g., `CreateUserService`, `ProcessPaymentService`

## Structure
\`\`\`ruby
class CreateUserService
  def initialize(params)
    @params = params
  end

  def call
    # All logic here
  end
end
\`\`\`

## Why This Pattern
Keeps controllers thin, logic testable, dependencies explicit.
```

### Key Principles:
- **Present tense** for things that still apply
- **Specific and actionable**, not vague summaries
- **Include code examples** when relevant
- **Link to actual files** in the codebase
- **Cite source commits** but don't make the doc ABOUT the commits

### Updating Docs as History Unfolds

As you process commits chronologically, you'll encounter changes to things you've already documented. **Update the docs, but preserve history.**

**When a pattern changes:**
```markdown
---
title: Authentication Approach
status: current
supersedes: docs/oracle/cookie-sessions.md
---

# JWT Authentication (Current)

[Current approach details...]

## History
- **2024-03**: Migrated from cookie sessions due to scaling issues
- **2022-01**: Originally implemented cookie-based sessions

See also: [Cookie Sessions (Deprecated)](cookie-sessions.md)
```

**When something is removed/deprecated:**
Don't delete the doc. Add a status and keep it as a record:
```markdown
---
title: GraphQL API
status: removed
removed_date: 2024-06-01
removed_in: [commit_sha]
---

# GraphQL API (Removed)

> **Status:** This feature was removed in June 2024. See [Why We Removed GraphQL](#why-removed).

[Original documentation preserved...]

## Why Removed
[Explanation from the removal commits]

## What Replaced It
REST API v2. See [REST API docs](rest-api-v2.md).
```

**When a convention evolves:**
Show the evolution, don't erase the old way:
```markdown
## Naming Convention

**Current (2024+):** `{Verb}{Noun}Service` - e.g., `CreateUserService`

**Previous (2022-2024):** `{Noun}{Verb}er` - e.g., `UserCreator`

We changed because [reason]. Old code may still use the previous convention.
```

### Never Lose:
- When something was introduced
- When something was changed and why
- When something was removed and why
- What we learned from failures
- Links between related docs (supersedes, replaced-by, see-also)

## Step 6: Create Index

Write `docs/oracle/index.yaml`:
```yaml
version: 1
generated: [current timestamp]
last_commit: [most recent SHA processed]
entries:
  - file: [filename].md
    keywords: [relevant keywords]
    paths: [file patterns affected]
    category: [category]
    summary: [one line summary]
```

## Step 7: Update CLAUDE.md

Add or update a "Historical Context" section in CLAUDE.md with the most critical patterns.

## Step 8: Report Completion

```
[Oracle] Divination complete!
- Commits analyzed: 500
- Significant patterns: 12
- Docs written: docs/oracle/
- CLAUDE.md updated
```

## Remember

- **Execute inline** - no background agents
- **Show progress** - user should see each commit being processed
- **Dates from git** - never guess or infer dates
- **Deletions matter** - removed code is gold for institutional knowledge
