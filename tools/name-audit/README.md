# name-audit

Audit candidate CLI/tool names for collision risk across common ecosystems.

## What it does

For each candidate name, the tool checks:

- Homebrew exact match (formula/cask)
- APT exact match
- npm package existence and same-name executable risk
- PyPI package existence and same-name executable risk

The output is designed for fast decisions:

- `RISK: HIGH` when a blocking collision exists
- `RISK: LOW` otherwise
- `BLOCKERS` section only when risk is high
- `CONTEXT` section with per-ecosystem evidence

## Risk policy

- `HIGH`
  - Homebrew/APT exact match
  - npm same-name executable with `downloads/week >= NPM_FAIL_WEEKLY`
  - PyPI same-name executable with `downloads/month >= PYPI_FAIL_MONTHLY`
- `LOW`
  - same-name executable exists but popularity is below threshold or unknown
  - package exists but no same-name executable is created
- `CLEAR` (ecosystem-level context status)
  - no relevant collision found in that ecosystem

## Build (Docker recommended)

Docker is recommended to minimize environment differences (for example, availability of `apt-cache`, Homebrew, npm, and Python tooling) and run checks in a consistent runtime.

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

Run with names passed directly as arguments:

```bash
docker run --rm name-audit <candidate-name> <candidate-name>
```

## Output example

```text
== kra ==
Checking Homebrew...... done (4s)
Checking APT... done (0s)
Checking npm... done (0s)
Checking PyPI.... done (2s)

RISK: LOW
CONTEXT:
- Homebrew: CLEAR (no exact match)
- APT: SKIPPED (apt-cache not installed)
- npm: CLEAR (package not found)
- PyPI: FOUND
  Risk: LOW
  Evidence:
    package exists
    wheel has no console scripts
    downloads/month: 29
```

## Environment variables

- `TIMEOUT_SECS` (default: `25`)
- `PYPI_RETRY_TIMEOUT_SECS` (default: `90`)
- `NPM_FAIL_WEEKLY` (default: `1000`)
- `PYPI_FAIL_MONTHLY` (default: `2000`)
- `PYPI_LOW_MONTHLY` (default: `100`)
- `KEEP_TMP` (default: `0`; set `1` to keep temp directories)
- `NO_COLOR` (default: `0`; set `1` to disable color output)

## Notes

- Network access is required for npm/PyPI popularity checks.
- On macOS, APT checks are expected to be `SKIPPED`.
- Progress output is shown during checks (`Checking ...`) with elapsed time.
- The process currently exits with `0` even when risk is high.
