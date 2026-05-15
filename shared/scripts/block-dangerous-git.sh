#!/usr/bin/env bash
set -euo pipefail

# Block dangerous Git commands. Intended for hooks or manual preflight checks.
# Usage:
#   bash shared/scripts/block-dangerous-git.sh "git push --force"

cmd="${*:-}"

if [[ -z "$cmd" ]]; then
  echo "No command supplied. Nothing to check."
  exit 0
fi

blocked_patterns=(
  "git push --force"
  "git push -f"
  "git push --force-with-lease"
  "git reset --hard"
  "git clean -fd"
  "git clean -fdx"
  "git add -f"
  "git tag "
  "gh release create"
)

for pattern in "${blocked_patterns[@]}"; do
  if [[ "$cmd" == *"$pattern"* ]]; then
    echo "Blocked dangerous Git command: $cmd" >&2
    echo "Matched pattern: $pattern" >&2
    echo "If this is truly intended, handle it as a separate explicitly approved operation." >&2
    exit 1
  fi
done

echo "Git command looks safe: $cmd"
