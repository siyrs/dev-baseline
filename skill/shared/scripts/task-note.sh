#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
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


workspace="${1:-}"
workspace="$(resolve_project_path "$workspace")"
note="${2:-}"

if [[ -z "$workspace" || -z "$note" ]]; then
  echo "Usage: bash shared/scripts/task-note.sh <workspace> <note>" >&2
  exit 1
fi

file="$workspace/10-collaboration-log.md"
now=$(date '+%Y-%m-%d %H:%M:%S')
printf '| %s | PM |  | Note | open | %s |\n' "$now" "$note" >> "$file"

echo "Updated $file"
