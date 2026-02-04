# Significance Criteria

How commits are evaluated for institutional knowledge value.

## Categories

### Architectural Pivot

Commits that change how the codebase is structured or how components interact.

**Indicators:**
- New directories/modules created
- Framework or library migrations
- Design pattern introductions
- Database schema redesigns
- API contract changes

**Example commit messages:**
- "Migrate from REST to GraphQL"
- "Introduce service object pattern"
- "Split monolith into packages"
- "Add caching layer with Redis"

### Bug Pattern

Commits that fix non-trivial bugs, especially those that reveal gotchas.

**Indicators:**
- Race condition fixes
- Edge case handling added
- Security vulnerability patches
- Performance problem resolutions
- Data integrity fixes

**Example commit messages:**
- "Fix race condition in checkout"
- "Handle null user in permission check"
- "Prevent SQL injection in search"
- "Fix N+1 query in dashboard"

### Abandoned Approach

Commits that remove or replace previous implementations.

**Indicators:**
- Revert commits
- "Replace X with Y" messages
- Deprecation removals
- Failed experiment cleanups

**Example commit messages:**
- "Revert: Add feature flags"
- "Replace custom ORM with ActiveRecord"
- "Remove unused GraphQL experiment"
- "Switch from polling to WebSockets"

### Convention Emergence

Commits that establish or change project conventions.

**Indicators:**
- Linting rule additions
- Directory restructuring
- Naming convention changes
- Test pattern establishments
- Documentation standards

**Example commit messages:**
- "Add ESLint with Airbnb config"
- "Reorganize components by feature"
- "Establish test naming convention"
- "Add JSDoc to all public APIs"

## Scoring Heuristics

When using heuristic-based detection (alternative to LLM judgment):

| Signal | Score |
|--------|-------|
| Message > 100 chars with "why" | +3 |
| Touches migration files | +3 |
| Touches config files | +2 |
| Changes > 10 files | +2 |
| Message contains "refactor" | +2 |
| Message contains "fix" + issue ref | +2 |
| Message contains "migrate" | +3 |
| Message contains "revert" | +3 |
| Single test file only | -2 |
| Message < 20 chars | -2 |
| Only whitespace/formatting | -5 |

**Threshold:** Score >= 3 = significant

## Edge Cases

### Large Refactors

A commit touching 100+ files might be:
- Significant (major restructuring)
- Not significant (automated formatting)

Check message and diff patterns to distinguish.

### Merge Commits

Merge commits themselves may have minimal messages, but they represent reviewed units of work. Check for linked PR descriptions.

### Squash Commits

Squash-merged PRs lose individual commit context. The squash message should contain the "why"—if not, infer from diff.

### Rebase Workflows

Linear history without merge commits. Evaluate each commit individually; significant ones stand out by message and content.
