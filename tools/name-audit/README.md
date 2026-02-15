# name-audit

Audit candidate CLI/tool names for collision risk across common ecosystems.

## What it does

For each candidate name, the tool checks:

- Homebrew exact match (formula/cask)
- apt-file command-path collision
- dnf command-path collision
- npm same-name executable collision
- PyPI same-name executable collision

The output is designed for fast decisions:

- `RISK: HIGH` when a blocking collision is found
- `RISK: CAUTION` when a same-name executable exists but popularity is low/unknown
- `RISK: CLEAR` when no blocking collision is found
- `Why` section explains why the risk was assigned (per candidate)
- `CONTEXT` section shows evidence by ecosystem

Important:
- Package existence alone (library-only, no same-name executable) does not raise risk by itself.

## Use via GHCR (recommended)

Use the published image directly:

```bash
docker run --rm ghcr.io/tasuku43/name-audit:latest <candidate-name> <candidate-name>
```

If you prefer lower latency, disable runtime metadata refresh:

```bash
docker run --rm -e NAME_AUDIT_REFRESH=0 ghcr.io/tasuku43/name-audit:latest <candidate-name>
```

## Build locally (optional)

Clone the repository and move to the repo root:

```bash
git clone https://github.com/tasuku43/dev-toolbox.git
cd dev-toolbox
```

Build the image from the repo root:

```bash
docker build -t name-audit tools/name-audit
```

## Run

If you built the image locally, run with names passed directly as arguments:

```bash
docker run --rm name-audit <candidate-name> <candidate-name>
```

At container start, metadata is refreshed (`brew update`, `apt-file update`) so checks use fresh indexes.
If you prefer lower latency, disable refresh per run:

```bash
docker run --rm -e NAME_AUDIT_REFRESH=0 name-audit <candidate-name>
```

## Optional: AI-assisted review

After running `name-audit`, you can ask an LLM tool (for example Codex CLI or Claude Code) for additional naming feedback.

Use AI feedback as a secondary opinion:

- Treat `name-audit` output as the primary risk signal.
- Use AI feedback for naming quality questions (readability, memorability, alternatives).

Prompt template:

```text
I ran name-audit for these candidates:
<PASTE OUTPUT>

Please:
1. summarize collision risk,
2. suggest safer alternatives,
3. explain trade-offs (clarity, uniqueness, future conflict risk).
```

## Output example

```text
docker run --rm ghcr.io/tasuku43/name-audit:latest git den semverx

[name-audit] Refreshing Homebrew metadata...
[name-audit] Refreshing Homebrew metadata done (18s)
[name-audit] Refreshing apt-file index...
[name-audit] Refreshing apt-file index done (0s)
== git ==
Checking Homebrew...... done (4s)
Checking apt-file... done (0s)
Checking dnf... done (0s)
Checking npm... done (1s)
Checking PyPI... done (1s)

RISK: HIGH
Why:
  ✗ Homebrew: exact match exists
CONTEXT:
- Homebrew: HIGH
  Evidence:
    exact match
    formula: YES
    cask: NO
- apt-file: CLEAR
- dnf: CLEAR
- npm: CLEAR (package not found)
- PyPI: CLEAR (package not found)

== den ==
Checking Homebrew...... done (4s)
Checking apt-file... done (0s)
Checking dnf... done (0s)
Checking npm... done (0s)
Checking PyPI.... done (2s)

RISK: CAUTION
Why:
  - PyPI: same-name executable 'den' exists (low/unknown popularity: unknown/month)
CONTEXT:
- Homebrew: CLEAR (no exact match)
- apt-file: CLEAR
- dnf: CLEAR
- npm: CLEAR (package not found)
- PyPI: CAUTION
  Evidence:
    same-name script 'den' created
    downloads/month: unknown

== semverx ==
Checking Homebrew...... done (4s)
Checking apt-file... done (0s)
Checking dnf... done (0s)
Checking npm... done (0s)
Checking PyPI... done (0s)

RISK: CLEAR
Why:
  - no blocking collision found in checked ecosystems
CONTEXT:
- Homebrew: CLEAR (no exact match)
- apt-file: CLEAR
- dnf: CLEAR
- npm: CLEAR (package not found)
- PyPI: CLEAR (package not found)
```

## Environment variables

- `TIMEOUT_SECS` (default: `25`)
- `PYPI_RETRY_TIMEOUT_SECS` (default: `90`)
- `NPM_FAIL_WEEKLY` (default: `1000`)
- `PYPI_FAIL_MONTHLY` (default: `2000`)
- `KEEP_TMP` (default: `0`; set `1` to keep temp directories)
- `NO_COLOR` (default: `0`; set `1` to disable color output)

## Notes

- Network access is required for npm/PyPI popularity checks.
- Runtime metadata refresh (`brew update`, `apt-file update`) also needs network access.
- `apt-file` results depend on local apt-file index freshness.
- `dnf` checks require available rpm repositories in the runtime environment.
- Progress output is shown during checks (`Checking ...`) with elapsed time.
- If popularity data cannot be fetched, collision checks still run and popularity is treated as `unknown`.
- The process currently exits with `0` even when risk is high.
