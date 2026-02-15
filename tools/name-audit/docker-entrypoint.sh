#!/usr/bin/env bash
set -euo pipefail

# Refresh package metadata at run time for fresher collision signals.
# Set NAME_AUDIT_REFRESH=0 to skip refresh when low latency is preferred.
NAME_AUDIT_REFRESH="${NAME_AUDIT_REFRESH:-1}"

log() {
  printf '[name-audit] %s\n' "$*" >&2
}

run_refresh_step() {
  local label="$1"
  shift
  local start end elapsed
  start="$(date +%s)"
  log "${label}..."
  "$@" >/dev/null 2>&1 || true
  end="$(date +%s)"
  elapsed=$((end - start))
  log "${label} done (${elapsed}s)"
}

if [[ "$NAME_AUDIT_REFRESH" == "1" ]]; then
  if command -v brew >/dev/null 2>&1; then
    run_refresh_step "Refreshing Homebrew metadata" brew update --force --quiet
  fi

  if command -v apt-file >/dev/null 2>&1; then
    run_refresh_step "Refreshing apt-file index" apt-file update
  fi
fi

exec name-audit "$@"
