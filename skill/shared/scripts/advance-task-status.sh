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

workspace="$(resolve_project_path "${1:-}")"
function_point="${2:-}"
from_status="${3:-}"
to_status="${4:-}"
owner="${5:-}"
note="${6:-}"

if [[ -z "$workspace" || -z "$function_point" || -z "$from_status" || -z "$to_status" || -z "$owner" ]]; then
  echo "Usage: bash shared/scripts/advance-task-status.sh <workspace> <function-point> <from> <to> <owner> [note]" >&2
  exit 1
fi

if [[ -f "$workspace/03-work-log.md" ]]; then
  board="$workspace/03-work-log.md"
  section_title="## Status Event Log"
  table_header="| Time | FP ID | From | To | Owner | Note |"
else
  board="$workspace/09-feature-status-board.md"
  section_title="## Status Event Log"
  table_header="| Time | Function Point | From | To | Owner | Note |"
fi

if [[ ! -f "$board" ]]; then
  echo "Missing task status board/work log: $board" >&2
  exit 1
fi

now=$(date '+%Y-%m-%d %H:%M:%S')
event="| $now | $function_point | $from_status | $to_status | $owner | $note |"

if ! grep -q "^${section_title}$" "$board"; then
  {
    printf '\n%s\n\n' "$section_title"
    printf '%s\n' "$table_header"
    printf '|---|---|---|---|---|---|\n'
  } >> "$board"
fi

tmp="${board}.tmp.$$"
awk -v section="$section_title" -v event="$event" '
  BEGIN { in_log=0; inserted=0 }
  $0 == section { in_log=1; print; next }
  in_log && /^## / {
    if (!inserted) { print event; inserted=1 }
    in_log=0
    print
    next
  }
  { print }
  END {
    if (in_log && !inserted) { print event }
  }
' "$board" > "$tmp"
mv "$tmp" "$board"

echo "Status event appended to $board"
