# Query Repository History

Retrieve historical context for a specific topic or area of the codebase.

## Usage

```
/history <topic>
/history --file <path>
/history --list
```

## Arguments

- `<topic>` - Keyword to search for (e.g., "auth", "checkout", "api")
- `--file <path>` - Get history for a specific file path
- `--list` - Show all available history topics

## Examples

```
/history auth
→ Loads docs/history/2024-03-auth-migration.md

/history --file src/checkout/cart.ts
→ Loads any history docs that match src/checkout/**

/history --list
→ Shows all entries in the routing index with summaries
```

## Process

1. **Load Index** - Read `docs/history/index.yaml`
2. **Search** - Find entries matching topic/path
3. **Load Docs** - Read matching history documents
4. **Present** - Show relevant historical context

## Execution

### For topic search:

```
Read docs/history/index.yaml
Search entries for keyword match in 'keywords' array
For each match, read the corresponding file from docs/history/
Present the historical context to the user
```

### For file search:

```
Read docs/history/index.yaml
For each entry, check if the given path matches any glob in 'paths'
For each match, read the corresponding file from docs/history/
Present the historical context to the user
```

### For list:

```
Read docs/history/index.yaml
For each entry, display: file, category, summary
Format as a scannable list
```

## Output Format

When history is found:

```
## Historical Context: [Topic]

[Content from the history doc]

---
Source: docs/history/[filename].md
Related commits: [sha1], [sha2]
```

When no history is found:

```
No historical context found for "[topic]".

Available topics (run /history --list):
- auth, authentication, jwt
- checkout, cart
- api, graphql
```

## Notes

- Requires `/oracle:mine` to have been run at least once
- Multiple matches will show all relevant history docs
- Use specific terms for better results
- History docs contain links to original commits for full details
