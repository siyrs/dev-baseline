#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

workspace_arg="${1:-}"
if [[ -z "$workspace_arg" ]]; then
  echo "Usage: bash shared/scripts/validate-task-readiness.sh <task-workspace>" >&2
  exit 1
fi

case "$workspace_arg" in
  /*|[A-Za-z]:*) workspace="$workspace_arg" ;;
  *) workspace="$REPO_ROOT/$workspace_arg" ;;
esac

errors=()
fail() { errors+=("$1"); }

if [[ -f "$workspace/01-task-contract.md" ]]; then
  required=(00-index.md 01-task-contract.md 02-delivery-plan.md 03-work-log.md 04-validation.md 05-governance-log.md 06-readiness-acceptance.md 07-delivery-summary.md)
  gate_file="$workspace/06-readiness-acceptance.md"
else
  required=(00-index.md 01-product-requirement.md 02-development-plan.md 04-test-plan.md 09-feature-status-board.md 10-collaboration-log.md 11-readiness-gates.md 13-decision-log.md 14-change-request-log.md 15-risk-register.md)
  gate_file="$workspace/11-readiness-gates.md"
fi

for file in "${required[@]}"; do
  [[ -f "$workspace/$file" ]] || fail "Missing readiness file: $file"
done

if [[ -f "$gate_file" ]]; then
  grep -q "Implementation may start: yes" "$gate_file" || fail "User implementation confirmation is not yes."
  grep -Eq "Confirmed at:[[:space:]]*[^[:space:]]" "$gate_file" || fail "Confirmed at is empty."
else
  fail "Missing readiness gate file: $(basename "$gate_file")"
fi

if [[ -f "$SCRIPT_DIR/validate-task-traceability.sh" ]]; then
  bash "$SCRIPT_DIR/validate-task-traceability.sh" "$workspace" || fail "Task traceability check failed."
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Task readiness gates are not approved:" >&2
  printf ' - %s\n' "${errors[@]}" >&2
  exit 1
fi

echo "Task readiness files are present: $workspace"
echo "Readiness gates are approved."
