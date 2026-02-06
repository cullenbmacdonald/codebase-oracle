---
name: oracle:consult
description: Consult the oracle about a topic or file's history
argument-hint: "<topic> or --file <path> or --list"
---

# Consult the Oracle

Seek the oracle's wisdom about the history of a topic or area of the codebase.

## Usage

```
/oracle:consult <topic>
/oracle:consult --file <path>
/oracle:consult --list
```

## Arguments

- `<topic>` - A word of power to seek (e.g., "auth", "checkout", "api")
- `--file <path>` - Divine the history of a specific artifact
- `--list` - Reveal all prophecies in the codex

## Examples

```
/oracle:consult auth
→ The oracle speaks of authentication's journey...

/oracle:consult --file src/checkout/cart.ts
→ The oracle reveals wisdom touching this artifact...

/oracle:consult --list
→ The codex contains these prophecies...
```

## The Ritual

1. **Open the Codex** - Read `docs/oracle/index.yaml`
2. **Seek the Relevant** - Find entries matching the seeker's query
3. **Retrieve the Prophecies** - Read matching wisdom documents
4. **Speak the Truth** - Present the historical context

## Execution

### For topic seeking:

```
[Oracle] Consulting the codex for wisdom of "{topic}"...

Read docs/oracle/index.yaml
Search entries for keyword match in 'keywords' array
For each match, read the corresponding prophecy from docs/oracle/
Present the wisdom to the seeker
```

### For artifact seeking:

```
[Oracle] Divining the history of this artifact...

Read docs/oracle/index.yaml
For each entry, check if the given path matches any glob in 'paths'
For each match, read the corresponding prophecy from docs/oracle/
Present the wisdom to the seeker
```

### For listing:

```
[Oracle] Revealing the contents of the codex...

Read docs/oracle/index.yaml
For each entry, display: file, category, summary
Format as a scannable scroll
```

## Output Format

When wisdom is found:

```
[Oracle] The spirits speak of "{topic}"...

## {Title from prophecy}

{Content from the prophecy document}

---
Prophecy source: docs/oracle/{filename}.md
Anchored to commits: {sha1}, {sha2}
```

When no wisdom exists:

```
[Oracle] The waters are dark for "{topic}". No prophecies speak of this.

The codex contains wisdom of:
  • auth, authentication, jwt
  • checkout, cart, payment
  • api, graphql, rest

Seek /oracle:consult --list for all known prophecies.
```

## Notes

- Requires `/oracle:divine` to have awakened the oracle first
- Multiple matches reveal all relevant prophecies
- Specific words of power yield clearer visions
- Each prophecy links to original commits for the complete record
