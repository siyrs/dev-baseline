SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

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

run_check "Stack detection" bash "${SCRIPT_DIR}/detect-stack.sh"
run_check "Baseline docs" bash "${SCRIPT_DIR}/validate-baseline-docs.sh"
run_check "Doc sync" bash "${SCRIPT_DIR}/check-doc-sync.sh"
run_check "Secret scan" bash "${SCRIPT_DIR}/check-secrets.sh"

if $failed; then
  echo "Quality gate failed." >&2
  exit 1
fi

echo "Quality gate passed."
