#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "claude/SKILL.md"
  "claude/skills/dev-baseline-task/SKILL.md"
  "claude/skills/dev-baseline-report/SKILL.md"
  "codex/AGENTS.md"
  "codex/.agents/skills/dev-baseline/SKILL.md"
  "docs/SKILL_ENTRYPOINT_POLICY.md"
  "docs/COMMAND_MAP.md"
  "docs/COMMAND_MAP_CN.md"
  "docs/SCENARIO_GUIDE.md"
  "docs/TEAM_DELIVERY_FLOW.md"
  "docs/REPORT_MODE.md"
  "shared/references/team-delivery-flow.md"
  "shared/references/report-mode.md"
  "shared/scripts/create-task-workspace.sh"
  "shared/scripts/generate-html-report.sh"
  "shared/scripts/generate-task-report.sh"
  "shared/scripts/quality-gate.sh"
  "shared/templates/tasks/00-index.md"
  "shared/templates/tasks/01-product-requirement.md"
  "shared/templates/tasks/02-development-plan.md"
  "shared/templates/tasks/04-test-plan.md"
  "shared/templates/tasks/05-test-report.md"
  "shared/templates/tasks/08-delivery-summary.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

if ! grep -q "^name: dev-baseline" claude/SKILL.md; then
  echo "Missing or invalid skill name in claude/SKILL.md" >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-task" claude/skills/dev-baseline-task/SKILL.md; then
  echo "Missing dev-baseline-task skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-report" claude/skills/dev-baseline-report/SKILL.md; then
  echo "Missing dev-baseline-report skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline" codex/.agents/skills/dev-baseline/SKILL.md; then
  echo "Missing Codex dev-baseline skill." >&2
  exit 1
fi

allowed=(
  "dev-baseline-task"
  "dev-baseline-report"
)

for skill_dir in claude/skills/dev-baseline-*; do
  [[ -d "$skill_dir" ]] || continue
  name=$(basename "$skill_dir")
  ok=false
  for item in "${allowed[@]}"; do
    if [[ "$name" == "$item" ]]; then
      ok=true
      break
    fi
  done
  if ! $ok; then
    echo "Redundant visible skill entrypoint remains: $skill_dir" >&2
    echo "Only dev-baseline-task and dev-baseline-report should remain under claude/skills/." >&2
    exit 1
  fi
done

echo "dev-baseline simplified skill package looks good."
