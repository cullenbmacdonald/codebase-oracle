# Mine Repository History

Mine the complete git history of this repository to extract institutional knowledge.

This command performs a full traversal of the commit history, identifies significant patterns, and generates:
- Historical documentation in `docs/history/`
- A routing index for on-demand retrieval
- A historical context section in CLAUDE.md

## Prerequisites

- Must be in a git repository
- Repository must have commit history
- For shallow clones, run `git fetch --unshallow` first

## Process

1. **Detect Workflow** - Determine if repo uses merge, squash, or rebase workflow
2. **Traverse History** - Walk commits from oldest to newest
3. **Evaluate Significance** - Use LLM to judge each commit's importance
4. **Document Findings** - Write history docs as context accumulates
5. **Generate Index** - Create routing manifest for on-demand retrieval
6. **Update CLAUDE.md** - Add critical patterns section

## Execution

Launch the history-miner agent to perform the mining:

```
Task history-miner("Mine the complete git history of this repository. Start from the first commit and work forward chronologically. Evaluate each commit for significance and document important patterns. Generate the routing index and update CLAUDE.md when complete.")
```

## Output

When complete, you will have:
- `docs/history/*.md` - Detailed documentation for significant patterns
- `docs/history/index.yaml` - Routing manifest for retrieval
- Updated `CLAUDE.md` - Critical patterns section added
- `.claude/oracle-checkpoint.json` - Progress marker for future updates

## Notes

- Large repositories may take significant time to process
- Progress updates will be shown periodically
- Processing can be resumed if interrupted (checkpoint saved)
- Run `/oracle:update` after initial mining to process new commits
