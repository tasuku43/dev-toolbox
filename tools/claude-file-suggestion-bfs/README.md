# BFS file suggestions for Claude Code

A tiny `sh` script that powers Claude Code’s `@` file/path completion using **pure BFS** over the filesystem.

## Why

I ran into cases where `@` completion felt “Git-shaped” (likely tied to `.git` context), which caused surprising behavior when:
- launching Claude Code in a directory that isn’t Git-managed, or
- working under nested/unusual repo layouts.

Using Git-based file listing (e.g. `git ls-files`) can also produce awkward path behavior for interactive completion, since it’s optimized for repo state rather than “what’s in this directory tree right now”.

So I wanted something predictable:
- just walk the filesystem,
- return relative paths,
- no hidden dependency on Git metadata.

## Design

- **Breadth-first search (BFS)** is fast enough for completions (and we only need the first ~15 hits).
- **No caching, no indexing**
- **No `.git` metadata reads**
- Optional pruning of heavy directories like `.git`, `node_modules`, `.venv`

## Requirements

- `bfs` (https://github.com/tavianator/bfs)
- `jq`
- standard `sh`, `awk`, `sed`

## Usage with Claude Code

Add this to `~/.claude/settings.json` (or `.claude/settings.local.json`):

```json
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion-bfs.sh"
  }
}
````

Claude Code calls the script with a JSON payload on stdin like:

```json
{"query":"..."}
```

The script should print candidate paths (one per line). This implementation outputs **relative paths** and caps results to **15**.

## Notes

This intentionally does **not** rely on `git ls-files` or Git root detection. The filesystem is the source of truth.
