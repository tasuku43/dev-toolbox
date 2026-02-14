# dev-toolbox

English | [日本語](README.ja.md)

A lightweight repository for managing reusable developer tools.

Instead of treating everything as a flat `bin/` directory, this repository
organizes assets by tool. Each tool can include scripts, a Dockerfile, and
tool-specific notes as needed.

## Goals

- Keep practical utility tools in one place
- Organize by tool name, not by file type
- Allow each tool to carry only what it needs

## Directory layout

```text
tools/
  codex-notify/
    README.md
    codex-notify
  name-audit/
    README.md
    name-audit
    Dockerfile
```

## Usage

- `./tools/codex-notify/codex-notify "<payload>"`
- `docker build -t name-audit tools/name-audit && docker run --rm name-audit <candidate-name> <candidate-name>`

## Tool docs

- `tools/codex-notify/README.md`
- `tools/name-audit/README.md`

## Conventions

- One tool per directory under `tools/`
- Keep executable entrypoints versioned in the tool directory
- Add a `Dockerfile` only for tools that need a containerized runtime
