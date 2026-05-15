#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"
note="${2:-}"

if [[ -z "$workspace" || -z "$note" ]]; then
  echo "Usage: bash shared/scripts/task-note.sh <workspace> <note>" >&2
  exit 1
fi

file="$workspace/10-collaboration-log.md"
now=$(date '+%Y-%m-%d %H:%M:%S')
printf '| %s |  |  |  | %s | open |  |\n' "$now" "$note" >> "$file"

echo "Updated $file"
