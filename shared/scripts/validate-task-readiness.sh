SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

resolve_project_path() {
  local path="cd "$REPO_ROOT"
"
  case "$path" in
    /*|[A-Za-z]:*) printf '%s\n' "$path" ;;
    *) printf '%s/%s\n' "$REPO_ROOT" "$path" ;;
  esac
}

#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"
workspace=$(resolve_project_path "$workspace")

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

gate_file="$workspace/11-readiness-gates.md"

trim() {
  local value="$*"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

declare -A result_by_item=()
declare -A notes_by_item=()
errors=()

while IFS= read -r line; do
  [[ "$line" == \|* ]] || continue
  [[ "$line" == *"---"* ]] && continue

  IFS='|' read -r _ item result owner notes _ <<< "$line"
  item="$(trim "${item:-}")"
  result="$(lower "$(trim "${result:-}")")"
  notes="$(trim "${notes:-}")"

  [[ -n "$item" ]] || continue
  [[ "$item" == "Item" ]] && continue

  result_by_item["$item"]="$result"
  notes_by_item["$item"]="$notes"
done < "$gate_file"

fail() {
  errors+=("$1")
}

require_item() {
  local item="$1"
  if [[ -z "${result_by_item[$item]+x}" ]]; then
    fail "Missing readiness item: $item"
  fi
}

require_yes() {
  local item="$1"
  require_item "$item"
  [[ -n "${result_by_item[$item]+x}" ]] || return
  if [[ "${result_by_item[$item]}" != "yes" ]]; then
    fail "Expected '$item' to be yes, got '${result_by_item[$item]}'."
  fi
}

require_confirmation_value() {
  local key="$1"
  local expected="$2"
  local actual="$3"
  if [[ "$(lower "$(trim "$actual")")" != "$expected" ]]; then
    fail "Expected confirmation '$key' to be $expected, got '${actual:-<empty>}'."
  fi
}

valid_results=(yes no not-needed blocked)
for item in "${!result_by_item[@]}"; do
  result="${result_by_item[$item]}"
  valid=false
  for allowed in "${valid_results[@]}"; do
    if [[ "$result" == "$allowed" ]]; then
      valid=true
      break
    fi
  done

  if ! $valid; then
    fail "Invalid Result for '$item': '${result:-<empty>}'. Allowed values: yes, no, not-needed, blocked."
    continue
  fi

  case "$result" in
    no)
      fail "Gate item is not passed: $item"
      ;;
    blocked)
      fail "Gate item is blocked: $item"
      ;;
    not-needed)
      if [[ -z "${notes_by_item[$item]}" ]]; then
        fail "Gate item marked not-needed without rationale in Notes: $item"
      fi
      ;;
  esac
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
  require_yes "$item"
done

if [[ "${result_by_item["QA Tester needed"]:-}" == "yes" ]]; then
  require_yes "Bugfix retest rule"
fi

if grep -Eiq 'open question[^|]*(open|unresolved|pending)|unresolved open question|question[^|]*unresolved' "$gate_file"; then
  fail "Readiness gates contain unresolved open questions."
fi

declare -A confirmation_by_key=()
while IFS= read -r line; do
  [[ "$line" =~ ^[[:space:]]*-[[:space:]]*([^:]+):[[:space:]]*(.*)$ ]] || continue
  key="$(trim "${BASH_REMATCH[1]}")"
  value="$(trim "${BASH_REMATCH[2]}")"
  confirmation_by_key["$key"]="$value"
done < "$gate_file"

require_confirmation_value "Requirement confirmed" "yes" "${confirmation_by_key["Requirement confirmed"]:-}"
require_confirmation_value "Agent roster confirmed" "yes" "${confirmation_by_key["Agent roster confirmed"]:-}"
require_confirmation_value "Architecture guidance or no-impact rationale confirmed" "yes" "${confirmation_by_key["Architecture guidance or no-impact rationale confirmed"]:-}"
require_confirmation_value "Development plan or no-developer rationale confirmed" "yes" "${confirmation_by_key["Development plan or no-developer rationale confirmed"]:-}"
require_confirmation_value "Test plan or PM acceptance checklist confirmed" "yes" "${confirmation_by_key["Test plan or PM acceptance checklist confirmed"]:-}"
require_confirmation_value "Implementation may start" "yes" "${confirmation_by_key["Implementation may start"]:-}"

confirmed_at="$(trim "${confirmation_by_key["Confirmed at"]:-}")"
if [[ -z "$confirmed_at" ]]; then
  fail "Expected confirmation 'Confirmed at' to be non-empty."
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Task readiness gates are not approved:" >&2
  printf ' - %s\n' "${errors[@]}" >&2
  exit 1
fi

echo "Task readiness files are present: $workspace"
echo "Readiness gates are approved."
