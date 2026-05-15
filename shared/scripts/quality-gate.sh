#!/usr/bin/env bash
set -euo pipefail

# Run Dev Baseline quality gate checks.

failed=false

run_check() {
  local name="$1"
  shift
  echo "==> $name"
  if "$@"; then
    echo "PASS: $name"
  else
    echo "FAIL: $name" >&2
    failed=true
  fi
  echo
}

run_check "Stack detection" bash shared/scripts/detect-stack.sh
run_check "Baseline docs" bash shared/scripts/validate-baseline-docs.sh
run_check "Doc sync" bash shared/scripts/check-doc-sync.sh
run_check "Secret scan" bash shared/scripts/check-secrets.sh

if $failed; then
  echo "Quality gate failed." >&2
  exit 1
fi

echo "Quality gate passed."
