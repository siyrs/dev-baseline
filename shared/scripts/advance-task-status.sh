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
function_point="${2:-}"
from_status="${3:-}"
to_status="${4:-}"
owner="${5:-}"
note="${6:-}"

if [[ -z "$workspace" || -z "$function_point" || -z "$from_status" || -z "$to_status" || -z "$owner" ]]; then
  echo "Usage: bash shared/scripts/advance-task-status.sh <workspace> <function-point> <from> <to> <owner> [note]" >&2
  exit 1
fi

board="$workspace/09-feature-status-board.md"
if [[ ! -f "$board" ]]; then
  echo "Missing feature status board: $board" >&2
  exit 1
fi

now=$(date '+%Y-%m-%d %H:%M:%S')

if ! grep -q '^## Status Event Log' "$board"; then
  {
    printf '\n## Status Event Log\n\n'
    printf '| Time | Function Point | From | To | Owner | Note |\n'
    printf '|---|---|---|---|---|---|\n'
  } >> "$board"
fi

tmp="${board}.tmp.$$"
awk -v event="| $now | $function_point | $from_status | $to_status | $owner | $note |" '
  BEGIN { in_log=0; inserted=0 }
  /^## Status Event Log[[:space:]]*$/ { in_log=1; print; next }
  in_log && /^## / {
    if (!inserted) {
      print event
      inserted=1
    }
    in_log=0
    print
    next
  }
  { print }
  END {
    if (in_log && !inserted) {
      print event
    }
  }
' "$board" > "$tmp"
mv "$tmp" "$board"

echo "Status event appended to $board"
