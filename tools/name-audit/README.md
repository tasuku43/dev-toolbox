# name-audit

Audit candidate command/tool names for collisions across common ecosystems.

## What it checks

For each candidate name, the script checks:

- `PATH` command collision
- Homebrew exact match (formula/cask)
- APT exact match (skips on non-Debian systems)
- npm package and same-name binary collision
- PyPI package and same-name console script collision

It outputs a final verdict per name: `OK`, `WARN`, or `FAIL`.

## Usage

Run with inline candidates:

```bash
tools/name-audit/name_audit hako koya kura
```

Run from a file:

```bash
tools/name-audit/name_audit --file candidates.txt
```

`candidates.txt` can include blank lines and comment lines (`# ...`).

## Verdict behavior (summary)

- `FAIL`:
  - exact Homebrew/APT match
  - npm/PyPI same-name executable with popularity above threshold
- `WARN`:
  - name already exists on `PATH`
  - npm/PyPI same-name executable with low/unknown popularity
- `OK`:
  - no blocking collisions found

## Environment variables

- `TIMEOUT_SECS` (default: `25`)
- `PYPI_RETRY_TIMEOUT_SECS` (default: `90`)
- `NPM_FAIL_WEEKLY` (default: `1000`)
- `PYPI_FAIL_MONTHLY` (default: `2000`)
- `KEEP_TMP` (default: `0`, set `1` to keep temp dirs)

## Docker

Build:

```bash
docker build -t name-audit tools/name-audit
```

Run with direct names:

```bash
docker run --rm name-audit hako koya kura
```

Run with file input:

```bash
docker run --rm -v "$PWD:/work" name-audit --file /work/candidates.txt
```

## Notes

- Network access is required for npm/PyPI popularity checks.
- On macOS, APT checks are expected to be skipped.
