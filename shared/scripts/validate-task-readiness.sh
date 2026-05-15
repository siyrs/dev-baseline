#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"

if [[ -z "$workspace" ]]; then
  echo "Usage: bash shared/scripts/validate-task-readiness.sh <task-workspace>" >&2
  exit 1
fi

required=(
  "00-index.md"
  "01-product-requirement.md"
  "02-development-plan.md"
  "04-test-plan.md"
  "09-feature-status-board.md"
  "10-collaboration-log.md"
  "11-readiness-gates.md"
)

missing=()
for file in "${required[@]}"; do
  if [[ ! -f "$workspace/$file" ]]; then
    missing+=("$file")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing readiness files in $workspace:" >&2
  printf ' - %s\n' "${missing[@]}" >&2
  exit 1
fi

echo "Task readiness files are present: $workspace"

if grep -qi "Implementation may start: yes" "$workspace/11-readiness-gates.md"; then
  echo "Implementation gate appears approved."
else
  echo "Implementation gate is not approved yet."
  echo "Expected marker: Implementation may start: yes"
  exit 2
fi
