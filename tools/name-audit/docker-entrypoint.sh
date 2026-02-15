#!/usr/bin/env bash
set -euo pipefail

# Refresh package metadata at run time for fresher collision signals.
# Set NAME_AUDIT_REFRESH=0 to skip refresh when low latency is preferred.
NAME_AUDIT_REFRESH="${NAME_AUDIT_REFRESH:-1}"

if [[ "$NAME_AUDIT_REFRESH" == "1" ]]; then
  if command -v brew >/dev/null 2>&1; then
    brew update --force --quiet >/dev/null 2>&1 || true
  fi

  if command -v apt-file >/dev/null 2>&1; then
    apt-file update >/dev/null 2>&1 || true
  fi
fi

exec name-audit "$@"
