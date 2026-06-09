#!/usr/bin/env bash
set -euo pipefail

allowed_commands=(
  "/dev-baseline"
  "/dev-baseline-task"
  "/dev-baseline-report"
  "/dev-baseline-git-sync"
)

deprecated_patterns=(
  "/dev-baseline-quality"
  "/dev-baseline-task-status"
  "/dev-baseline-github"
  "/dev-baseline-sprint"
  "/dev-baseline-release-train"
  "/dev-baseline-metrics"
  "dev-baseline-git "
  "dev-baseline-git status"
  "dev-baseline-git diff"
  "dev-baseline-git commit"
  "dev-baseline-quality"
  "dev-baseline-task-status"
  "dev-baseline-github"
  "dev-baseline-sprint"
  "dev-baseline-release-train"
  "dev-baseline-metrics"
)

search_roots=(README.md README_CN.md docs skill shared scripts .github)

for pattern in "${deprecated_patterns[@]}"; do
  matches=$(grep -R -n -F \
    --exclude="validate-command-surface.sh" \
    --exclude="validate-skill.sh" \
    "$pattern" "${search_roots[@]}" 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    echo "Deprecated visible command remains: $pattern" >&2
    echo "$matches" >&2
    exit 1
  fi
done

if find skill/skills -maxdepth 1 -type d -name 'dev-baseline-*' 2>/dev/null | grep -v -E 'dev-baseline-(task|report|git-sync)$' | grep -q .; then
  echo "Unexpected visible skill entrypoint found under skill/skills." >&2
  find skill/skills -maxdepth 1 -type d -name 'dev-baseline-*' | grep -v -E 'dev-baseline-(task|report|git-sync)$' >&2
  exit 1
fi

echo "Command surface looks good. Allowed commands: ${allowed_commands[*]}"
