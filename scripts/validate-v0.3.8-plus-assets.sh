#!/usr/bin/env bash
set -euo pipefail

required=(
  "docs/GITHUB_INTEGRATION.md"
  "shared/templates/tasks/21-github-integration.md"
  "shared/scripts/task-github-summary.sh"
  "claude/skills/dev-baseline-github/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/github-mode.md"
  "docs/SPRINT_MODE.md"
  "shared/templates/sprints/SPRINT.md"
  "shared/scripts/create-sprint-workspace.sh"
  "claude/skills/dev-baseline-sprint/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/sprint-mode.md"
  "docs/RELEASE_TRAIN.md"
  "shared/templates/releases/RELEASE_TRAIN.md"
  "shared/scripts/create-release-workspace.sh"
  "claude/skills/dev-baseline-release-train/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/release-train-mode.md"
  "docs/METRICS_MODE.md"
  "shared/scripts/generate-metrics-report.sh"
  "claude/skills/dev-baseline-metrics/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/metrics-mode.md"
  "docs/ROADMAP.md"
)

for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing v0.3.8+ asset: $file" >&2
    exit 1
  fi
done

echo "v0.3.8+ assets look good."
