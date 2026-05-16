#!/usr/bin/env bash
set -euo pipefail

tasks_dir="${1:-docs/tasks}"

if [[ ! -d "$tasks_dir" ]]; then
  echo "Task directory not found: $tasks_dir" >&2
  exit 1
fi

echo "# Task Dashboard Summary"
echo

find "$tasks_dir" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r dir; do
  index="$dir/00-index.md"
  [[ -f "$index" ]] || continue
  name=$(grep -E '^- Task name:' "$index" | sed -E 's/^- Task name:[[:space:]]*//' | head -n 1)
  status=$(grep -E '^- Current status:' "$index" | sed -E 's/^- Current status:[[:space:]]*//' | head -n 1)
  owner=$(grep -E '^- Current owner:' "$index" | sed -E 's/^- Current owner:[[:space:]]*//' | head -n 1)
  echo "- $(basename "$dir"): ${name:-unknown} | status=${status:-unknown} | owner=${owner:-unknown}"
done
