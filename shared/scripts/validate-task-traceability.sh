#!/usr/bin/env bash
set -euo pipefail

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

if [[ -f "$workspace/01-task-contract.md" ]]; then
  contract_file="$workspace/01-task-contract.md"
  validation_file="$workspace/04-validation.md"
  acceptance_file="$workspace/06-readiness-acceptance.md"
  governance_file="$workspace/05-governance-log.md"
  risk_file="$workspace/05-governance-log.md"
  required=(01-task-contract.md 04-validation.md 05-governance-log.md 06-readiness-acceptance.md)
else
  contract_file="$workspace/01-product-requirement.md"
  validation_file="$workspace/04-test-plan.md"
  acceptance_file="$workspace/07-acceptance-report.md"
  governance_file="$workspace/14-change-request-log.md"
  risk_file="$workspace/15-risk-register.md"
  required=(01-product-requirement.md 04-test-plan.md 07-acceptance-report.md 14-change-request-log.md 15-risk-register.md)
fi

for file in "${required[@]}"; do
  [[ -f "$workspace/$file" ]] || fail "Missing traceability file: $file"
done

if [[ ${#errors[@]} -eq 0 ]]; then
  mapfile -t ac_ids < <(grep -Eo 'AC-[0-9]+' "$contract_file" | sort -u)
  mapfile -t fp_ids < <(grep -Eo 'FP-[0-9]+' "$contract_file" | sort -u)

  [[ ${#fp_ids[@]} -gt 0 ]] || fail "No function points found in contract file."
  [[ ${#ac_ids[@]} -gt 0 ]] || fail "No acceptance criteria found in contract file."

  for ac in "${ac_ids[@]}"; do
    grep -q "$ac" "$validation_file" || fail "Acceptance criterion $ac has no validation coverage."
    grep -q "$ac" "$acceptance_file" || fail "Acceptance criterion $ac is missing from acceptance review."
  done

  if grep -Eq '^\|[[:space:]]*CR-[0-9]+.*\|[[:space:]]*(pending|applied|approved)[[:space:]]*\|.*\|[[:space:]]*(open|in-progress)[[:space:]]*\|' "$governance_file"; then
    fail "Contract deltas that affect final acceptance must be closed or reconciled before acceptance."
  fi

  if grep -Eq '^\|[[:space:]]*RISK-[0-9]+.*\|[[:space:]]*high[[:space:]]*\|[[:space:]]*high[[:space:]]*\|[[:space:]]*\|' "$risk_file"; then
    fail "High/high risk exists without mitigation."
  fi
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Task traceability check failed:" >&2
  printf ' - %s\n' "${errors[@]}" >&2
  exit 1
fi

echo "Task traceability check passed: $workspace"
