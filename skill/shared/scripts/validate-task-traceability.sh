#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

workspace_arg="${1:-}"
if [[ -z "$workspace_arg" ]]; then
  echo "Usage: bash shared/scripts/validate-task-traceability.sh <task-workspace>" >&2
  exit 1
fi

case "$workspace_arg" in
  /*|[A-Za-z]:*) workspace="$workspace_arg" ;;
  *) workspace="$REPO_ROOT/$workspace_arg" ;;
esac

errors=()
fail() { errors+=("$1"); }

required=(
  "01-product-requirement.md"
  "04-test-plan.md"
  "05-test-report.md"
  "07-acceptance-report.md"
  "09-feature-status-board.md"
  "13-decision-log.md"
  "14-change-request-log.md"
  "15-risk-register.md"
)

for file in "${required[@]}"; do
  [[ -f "$workspace/$file" ]] || fail "Missing traceability file: $file"
done

if [[ ${#errors[@]} -eq 0 ]]; then
  mapfile -t ac_ids < <(grep -Eo 'AC-[0-9]+' "$workspace/01-product-requirement.md" | sort -u)
  mapfile -t fp_ids < <(grep -Eo 'FP-[0-9]+' "$workspace/01-product-requirement.md" | sort -u)

  [[ ${#fp_ids[@]} -gt 0 ]] || fail "No function points found in 01-product-requirement.md."
  [[ ${#ac_ids[@]} -gt 0 ]] || fail "No acceptance criteria found in 01-product-requirement.md."

  for ac in "${ac_ids[@]}"; do
    grep -q "$ac" "$workspace/04-test-plan.md" || fail "Acceptance criterion $ac has no related test case in 04-test-plan.md."
    grep -q "$ac" "$workspace/07-acceptance-report.md" || fail "Acceptance criterion $ac is missing from 07-acceptance-report.md."
    if [[ -f "$workspace/16-execution-contract.md" ]]; then
      grep -q "$ac" "$workspace/16-execution-contract.md" || echo "Warning: $ac is not summarized in optional 16-execution-contract.md" >&2
    fi
  done

  if [[ -f "$workspace/16-execution-contract.md" ]]; then
    for fp in "${fp_ids[@]}"; do
      grep -q "$fp" "$workspace/16-execution-contract.md" || echo "Warning: $fp is not summarized in optional 16-execution-contract.md" >&2
    done
  fi

  if grep -Eq '^\|[[:space:]]*CR-[0-9]+.*\|[[:space:]]*(pending|applied|approved)[[:space:]]*\|.*\|[[:space:]]*(open|in-progress)[[:space:]]*\|' "$workspace/14-change-request-log.md"; then
    fail "Contract deltas that affect final acceptance must be closed or reconciled before acceptance."
  fi

  if grep -Eq '^\|[[:space:]]*RISK-[0-9]+.*\|[[:space:]]*high[[:space:]]*\|[[:space:]]*high[[:space:]]*\|[[:space:]]*\|' "$workspace/15-risk-register.md"; then
    fail "High/high risk exists without mitigation."
  fi
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Task traceability check failed:" >&2
  printf ' - %s\n' "${errors[@]}" >&2
  exit 1
fi

echo "Task traceability check passed: $workspace"
