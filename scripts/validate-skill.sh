#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "skill/SKILL.md"
  "skill/skills/dev-baseline-task/SKILL.md"
  "skill/skills/dev-baseline-report/SKILL.md"
  "skill/skills/dev-baseline-git-sync/SKILL.md"
  "skill/AGENTS.md"
  "skill/agents/architect.md"
  "skill/agents/developer.md"
  "skill/agents/product-manager.md"
  "skill/agents/qa-tester.md"
  "skill/codex-agent-overrides/git-manager.md"
  "skill/codex-agent-overrides/quality-auditor.md"
  "skill/references/team-delivery-flow.md"
  "skill/references/git-mode.md"
  "skill/references/report-mode.md"
  "skill/shared/references/team-delivery-flow.md"
  "skill/shared/references/report-mode.md"
  "skill/shared/references/git-sync.md"
  "skill/shared/scripts/create-task-workspace.sh"
  "skill/shared/scripts/git-sync.sh"
  "skill/shared/scripts/generate-html-report.sh"
  "skill/shared/scripts/generate-task-report.sh"
  "skill/shared/scripts/quality-gate.sh"
  "skill/shared/templates/tasks/00-index.md"
  "skill/shared/templates/tasks/01-product-requirement.md"
  "skill/shared/templates/tasks/02-development-plan.md"
  "skill/shared/templates/tasks/04-test-plan.md"
  "skill/shared/templates/tasks/05-test-report.md"
  "skill/shared/templates/tasks/08-delivery-summary.md"
  "codex/README.md"
  "claude/README.md"
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
  "scripts/sync-skill-shared.sh"
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

bash scripts/sync-skill-shared.sh check

if ! grep -q "^name: dev-baseline" skill/SKILL.md; then
  echo "Missing or invalid skill name in canonical skill/SKILL.md" >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-task" skill/skills/dev-baseline-task/SKILL.md; then
  echo "Missing canonical dev-baseline-task skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-report" skill/skills/dev-baseline-report/SKILL.md; then
  echo "Missing canonical dev-baseline-report skill." >&2
  exit 1
fi

if ! grep -q "^name: dev-baseline-git-sync" skill/skills/dev-baseline-git-sync/SKILL.md; then
  echo "Missing canonical dev-baseline-git-sync skill." >&2
  exit 1
fi

if ! grep -q "Team delivery tasks enable Agent Mode by default" skill/SKILL.md; then
  echo "Canonical dev-baseline skill does not enable team delivery Agent Mode by default." >&2
  exit 1
fi

if ! grep -q "Architect" skill/shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing Architect role guidance." >&2
  exit 1
fi

if ! grep -q "PM readiness review" skill/shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing PM readiness review." >&2
  exit 1
fi

allowed=(
  "dev-baseline-task"
  "dev-baseline-report"
  "dev-baseline-git-sync"
)

for skill_dir in skill/skills/dev-baseline-*; do
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
    echo "Only dev-baseline-task, dev-baseline-report, and dev-baseline-git-sync should remain under skill/skills/." >&2
    exit 1
  fi
done

for legacy_dir in \
  "codex/.agents" \
  "codex/.codex" \
  "codex/templates" \
  "claude/agents" \
  "claude/hooks" \
  "claude/skills" \
  "claude/templates"; do
  if [[ -e "$legacy_dir" ]]; then
    echo "Legacy duplicate platform directory remains: $legacy_dir" >&2
    echo "Move shared assets into skill/ and keep platform directories as thin documentation only." >&2
    exit 1
  fi
done

if [[ -f "claude/SKILL.md" ]]; then
  echo "Legacy duplicate Claude SKILL.md remains; use skill/SKILL.md as the canonical package." >&2
  exit 1
fi

if [[ -f "codex/AGENTS.md" ]]; then
  echo "Legacy duplicate Codex AGENTS.md remains; use skill/AGENTS.md as the canonical package." >&2
  exit 1
fi

if [[ -e "skill/codex-agents" ]]; then
  echo "Duplicate full Codex agent directory remains; use skill/agents plus skill/codex-agent-overrides." >&2
  exit 1
fi

echo "dev-baseline standard skill package looks good."
