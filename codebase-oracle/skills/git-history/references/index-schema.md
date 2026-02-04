# Index Schema

The routing index at `docs/history/index.yaml` enables on-demand loading of historical documentation.

## Schema Definition

```yaml
# Version of the index schema
version: 1

# When this index was last generated/updated
generated: 2026-02-04T12:00:00Z

# SHA of the last commit processed
last_commit: abc123def456

# Total number of history documents
total_docs: 12

# Array of document entries
entries:
  - file: string           # Filename in docs/history/
    keywords: [string]     # Terms for keyword matching
    paths: [string]        # Glob patterns for file routing
    commits: [string]      # SHA references (short form)
    category: string       # One of the four categories
    summary: string        # One-line description
```

## Field Details

### `file`

The markdown filename within `docs/history/`.

Format: `YYYY-MM-topic-slug.md`

Examples:
- `2024-03-auth-migration.md`
- `2024-07-checkout-race-fix.md`

### `keywords`

Array of terms that should trigger loading this document.

Extracted from:
- Commit messages (nouns and verbs)
- File paths (directory names)
- Manually added relevant terms

Guidelines:
- Include synonyms (auth, authentication, login)
- Include technical terms (jwt, oauth, session)
- Include domain terms (checkout, payment, user)
- Lowercase, no special characters

### `paths`

Glob patterns matching files related to this history.

Used for file-based routing: when a user is editing a file matching a pattern, the history doc is loaded.

Examples:
- `src/auth/**` - matches any file under src/auth/
- `lib/session.ts` - matches exact file
- `**/*controller*.ts` - matches controllers anywhere

### `commits`

Array of commit SHAs (short form, 7 chars) referenced in the history doc.

Used for:
- Linking to original commits
- Detecting if history needs updates
- Cross-referencing between docs

### `category`

One of:
- `architectural_pivot`
- `bug_pattern`
- `abandoned_approach`
- `convention_emergence`

### `summary`

One-line description (< 100 chars) for quick scanning.

Used in:
- Index listings
- CLAUDE.md references
- Search result previews

## Example Index

```yaml
version: 1
generated: 2026-02-04T15:30:00Z
last_commit: f8e9d0c
total_docs: 3

entries:
  - file: 2024-03-auth-migration.md
    keywords:
      - auth
      - authentication
      - jwt
      - token
      - session
      - login
      - oauth
    paths:
      - "src/auth/**"
      - "lib/session.ts"
      - "config/auth.yaml"
    commits:
      - abc123
      - def456
    category: architectural_pivot
    summary: "Migration from cookie sessions to JWT authentication"

  - file: 2024-05-checkout-race.md
    keywords:
      - checkout
      - cart
      - race
      - async
      - save
    paths:
      - "src/checkout/**"
      - "src/cart/**"
    commits:
      - ghi789
    category: bug_pattern
    summary: "Fixed race condition when saving cart before redirect"

  - file: 2024-06-remove-graphql.md
    keywords:
      - graphql
      - api
      - rest
      - revert
    paths:
      - "src/api/**"
      - "schema.graphql"
    commits:
      - jkl012
      - mno345
    category: abandoned_approach
    summary: "Removed GraphQL experiment, returned to REST-only API"
```

## Routing Logic

### Keyword Matching

1. Parse user message into tokens
2. For each token, check if it matches any entry's keywords
3. If match, load the corresponding history doc
4. Multiple matches → load all (up to limit)

### File-Based Routing

1. When user edits a file, get its path
2. For each entry, check if path matches any glob in `paths`
3. If match, load the corresponding history doc
4. Use micromatch or similar for glob matching

### Explicit Command

`/history <topic>`:
1. Search keywords for matches to `<topic>`
2. Also search summaries for substring match
3. Load matching docs
4. If no match, report "No history found for <topic>"

## Index Updates

### Incremental

When new history docs are added:
1. Read existing index
2. Append new entries
3. Update `generated`, `last_commit`, `total_docs`
4. Write updated index

### Rebuild

If index is corrupted or missing:
1. Glob `docs/history/*.md`
2. Parse frontmatter from each file
3. Build entries from frontmatter fields
4. Write fresh index
