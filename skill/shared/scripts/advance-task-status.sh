#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"
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
printf '| %s | %s | %s | %s | %s | %s |\n' "$now" "$function_point" "$from_status" "$to_status" "$owner" "$note" >> "$board"

echo "Status event appended to $board"
