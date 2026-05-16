#!/usr/bin/env bash
set -euo pipefail

required=(
  "shared/scripts/generate-task-dashboard.sh"
  "shared/scripts/task-dashboard-summary.sh"
  "shared/references/task-dashboard.md"
  "claude/skills/dev-baseline-dashboard/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/dashboard-mode.md"
  "docs/DASHBOARD_MODE.md"
  "docs/DASHBOARD_MODE_CN.md"
  "github-actions/task-dashboard.yml"
)

for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing dashboard asset: $file" >&2
    exit 1
  fi
done

echo "Dashboard assets look good."
