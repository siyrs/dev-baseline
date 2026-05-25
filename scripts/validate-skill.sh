#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "claude/SKILL.md"
  "claude/skills/dev-baseline-task/SKILL.md"
  "claude/skills/dev-baseline-report/SKILL.md"
  "claude/skills/dev-baseline-git-sync/SKILL.md"
  "codex/AGENTS.md"
  "codex/.agents/skills/dev-baseline/SKILL.md"
  "codex/.agents/skills/dev-baseline-git-sync/SKILL.md"
  "codex/.codex/agents/architect.md"
  "codex/.codex/agents/developer.md"
  "codex/.codex/agents/product-manager.md"
  "codex/.codex/agents/qa-tester.md"
  "claude/agents/architect.md"
  "docs/SKILL_ENTRYPOINT_POLICY.md"
  "docs/COMMAND_MAP.md"
  "docs/COMMAND_MAP_CN.md"
  "docs/SCENARIO_GUIDE.md"
  "docs/TEAM_DELIVERY_FLOW.md"
  "docs/REPORT_MODE.md"
  "shared/references/team-delivery-flow.md"
  "shared/references/report-mode.md"
  "shared/references/git-sync.md"
  "shared/scripts/create-task-workspace.sh"
  "shared/scripts/git-sync.sh"
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

if ! grep -q "^name: dev-baseline-git-sync" claude/skills/dev-baseline-git-sync/SKILL.md; then
  echo "Missing dev-baseline-git-sync skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline" codex/.agents/skills/dev-baseline/SKILL.md; then
  echo "Missing Codex dev-baseline skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-git-sync" codex/.agents/skills/dev-baseline-git-sync/SKILL.md; then
  echo "Missing Codex dev-baseline-git-sync skill." >&2
  exit 1
fi

if ! grep -q "Team delivery tasks enable Agent Mode by default" codex/.agents/skills/dev-baseline/SKILL.md; then
  echo "Codex dev-baseline skill does not enable team delivery Agent Mode by default." >&2
  exit 1
fi

if ! grep -q "Architect" shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing Architect role guidance." >&2
  exit 1
fi

if ! grep -q "PM readiness review" shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing PM readiness review." >&2
  exit 1
fi

allowed=(
  "dev-baseline-task"
  "dev-baseline-report"
  "dev-baseline-git-sync"
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
    echo "Only dev-baseline-task, dev-baseline-report, and dev-baseline-git-sync should remain under claude/skills/." >&2
    exit 1
  fi
done

echo "dev-baseline simplified skill package looks good."
