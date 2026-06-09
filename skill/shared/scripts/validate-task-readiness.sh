#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

resolve_project_path() {
  local path="${1:-}"
  if [[ -z "$path" ]]; then
    printf '\n'
    return 0
  fi
  case "$path" in
    /*|[A-Za-z]:*) printf '%s\n' "$path" ;;
    *) printf '%s/%s\n' "$REPO_ROOT" "$path" ;;
  esac
}

trim() {
  local value="$*"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

workspace="$(resolve_project_path "${1:-}")"
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
  "13-decision-log.md"
  "14-change-request-log.md"
  "15-risk-register.md"
  "16-execution-contract.md"
)

errors=()
fail() { errors+=("$1"); }

for file in "${required[@]}"; do
  [[ -f "$workspace/$file" ]] || fail "Missing readiness file: $file"
done

if [[ ${#errors[@]} -eq 0 ]]; then
  gate_file="$workspace/11-readiness-gates.md"
  contract_file="$workspace/16-execution-contract.md"

  declare -A result_by_item=()
  declare -A notes_by_item=()

  while IFS= read -r line; do
    [[ "$line" == \|* ]] || continue
    [[ "$line" == *"---"* ]] && continue
    IFS='|' read -r _ item result owner notes _ <<< "$line"
    item="$(trim "${item:-}")"
    result="$(lower "$(trim "${result:-}")")"
    notes="$(trim "${notes:-}")"
    [[ -n "$item" && "$item" != "Item" ]] || continue
    result_by_item["$item"]="$result"
    notes_by_item["$item"]="$notes"
  done < "$gate_file"

  valid_results=(yes no not-needed blocked)
  for item in "${!result_by_item[@]}"; do
    result="${result_by_item[$item]}"
    valid=false
    for allowed in "${valid_results[@]}"; do
      [[ "$result" == "$allowed" ]] && valid=true
    done
    $valid || fail "Invalid Result for '$item': '${result:-<empty>}'."
    [[ "$result" != "no" ]] || fail "Gate item is not passed: $item"
    [[ "$result" != "blocked" ]] || fail "Gate item is blocked: $item"
    if [[ "$result" == "not-needed" && -z "${notes_by_item[$item]}" ]]; then
      fail "Gate item marked not-needed without rationale in Notes: $item"
    fi
  done

  required_yes_items=(
    "Product Manager agent active first"
    "Main agent only interacts with PM"
    "Main agent delegated roster decisions to PM"
    "Specialist agents report only to PM"
    "Active agents recorded"
    "Skipped agents recorded with rationale"
    "Each active agent has one responsibility"
    "Each active agent has expected output and exit condition"
    "Real agent tooling used or fallback recorded"
    "Requirement reviewed"
    "Agent roster reviewed"
    "Specialist outputs reviewed"
    "Developer plan or no-developer rationale reviewed"
    "Test strategy reviewed"
    "Ready to ask user for implementation approval"
  )

  for item in "${required_yes_items[@]}"; do
    if [[ "${result_by_item[$item]:-}" != "yes" ]]; then
      fail "Expected '$item' to be yes, got '${result_by_item[$item]:-<missing>}'."
    fi
  done

  if [[ "${result_by_item["QA Tester needed"]:-}" == "yes" && "${result_by_item["Bugfix retest rule"]:-}" != "yes" ]]; then
    fail "Expected 'Bugfix retest rule' to be yes when QA Tester is active."
  fi

  if grep -Eiq 'open question.*(open|unresolved|pending)|unresolved open question|question.*unresolved' "$gate_file"; then
    fail "Readiness gates contain unresolved open questions."
  fi

  declare -A confirmation_by_key=()
  while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*-[[:space:]]*([^:]+):[[:space:]]*(.*)$ ]] || continue
    key="$(trim "${BASH_REMATCH[1]}")"
    value="$(trim "${BASH_REMATCH[2]}")"
    confirmation_by_key["$key"]="$value"
  done < "$gate_file"

  for key in \
    "Requirement confirmed" \
    "Agent roster confirmed" \
    "Architecture guidance or no-impact rationale confirmed" \
    "Development plan or no-developer rationale confirmed" \
    "Test plan or PM acceptance checklist confirmed" \
    "Implementation may start"; do
    if [[ "$(lower "${confirmation_by_key[$key]:-}")" != "yes" ]]; then
      fail "Expected confirmation '$key' to be yes."
    fi
  done

  [[ -n "$(trim "${confirmation_by_key["Confirmed at"]:-}")" ]] || fail "Expected confirmation 'Confirmed at' to be non-empty."

  grep -qi 'Ready for implementation:[[:space:]]*yes' "$contract_file" || fail "Execution contract is not marked ready for implementation."

  if [[ -f "$SCRIPT_DIR/validate-task-traceability.sh" ]]; then
    bash "$SCRIPT_DIR/validate-task-traceability.sh" "$workspace" || fail "Task traceability check failed."
  fi
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Task readiness gates are not approved:" >&2
  printf ' - %s\n' "${errors[@]}" >&2
  exit 1
fi

echo "Task readiness files are present: $workspace"
echo "Readiness gates are approved."
