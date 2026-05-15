#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "claude/SKILL.md"
  "claude/templates/README.md"
  "claude/templates/docs/PLAN.md"
  "claude/templates/docs/API.md"
  "claude/templates/docs/DEPLOY.md"
  "claude/templates/docs/CHANGELOG.md"
  "claude/templates/docs/CONFIG.md"
  "claude/templates/docs/ARCHITECTURE.md"
  "claude/templates/docs/TESTING.md"
  "claude/skills/dev-baseline-init/SKILL.md"
  "claude/skills/dev-baseline-plan/SKILL.md"
  "claude/skills/dev-baseline-publish/SKILL.md"
  "claude/skills/dev-baseline-git/SKILL.md"
  "claude/skills/dev-baseline-report/SKILL.md"
  "claude/skills/dev-baseline-release/SKILL.md"
  "claude/skills/dev-baseline-quality/SKILL.md"
  "claude/skills/dev-baseline-task/SKILL.md"
  "claude/agents/docs-auditor.md"
  "claude/agents/security-guard.md"
  "claude/agents/report-writer.md"
  "claude/agents/code-reviewer.md"
  "claude/agents/release-manager.md"
  "claude/agents/product-manager.md"
  "claude/agents/developer.md"
  "claude/agents/qa-tester.md"
  "claude/hooks/settings.example.json"
  "codex/AGENTS.md"
  "codex/templates/README.md"
  "codex/templates/docs/PLAN.md"
  "codex/templates/docs/API.md"
  "codex/templates/docs/DEPLOY.md"
  "codex/templates/docs/CHANGELOG.md"
  "codex/templates/docs/CONFIG.md"
  "codex/templates/docs/ARCHITECTURE.md"
  "codex/templates/docs/TESTING.md"
  "codex/.agents/skills/dev-baseline/SKILL.md"
  "codex/.agents/skills/dev-baseline/references/report-mode.md"
  "codex/.agents/skills/dev-baseline/references/git-mode.md"
  "codex/.agents/skills/dev-baseline/references/release-mode.md"
  "codex/.agents/skills/dev-baseline/references/quality-mode.md"
  "codex/.agents/skills/dev-baseline/references/team-delivery-flow.md"
  "codex/.codex/hooks.json"
  "codex/.codex/agents/release-manager.md"
  "codex/.codex/agents/report-writer.md"
  "codex/.codex/agents/git-manager.md"
  "codex/.codex/agents/docs-auditor.md"
  "codex/.codex/agents/security-guard.md"
  "codex/.codex/agents/code-reviewer.md"
  "codex/.codex/agents/quality-auditor.md"
  "codex/.codex/agents/product-manager.md"
  "codex/.codex/agents/developer.md"
  "codex/.codex/agents/qa-tester.md"
  "shared/scripts/check-secrets.sh"
  "shared/scripts/check-doc-sync.sh"
  "shared/scripts/summarize-diff.sh"
  "shared/scripts/generate-html-report.sh"
  "shared/scripts/block-dangerous-git.sh"
  "shared/scripts/validate-baseline-docs.sh"
  "shared/scripts/detect-stack.sh"
  "shared/scripts/quality-gate.sh"
  "shared/scripts/create-task-workspace.sh"
  "shared/scripts/task-note.sh"
  "shared/references/git-publish.md"
  "shared/references/report-mode.md"
  "shared/references/team-delivery-flow.md"
  "shared/templates/tasks/00-index.md"
  "shared/templates/tasks/01-product-requirement.md"
  "shared/templates/tasks/02-development-plan.md"
  "shared/templates/tasks/03-implementation-notes.md"
  "shared/templates/tasks/04-test-plan.md"
  "shared/templates/tasks/05-test-report.md"
  "shared/templates/tasks/06-bugfix-log.md"
  "shared/templates/tasks/07-acceptance-report.md"
  "shared/templates/tasks/08-delivery-summary.md"
  "shared/templates/tasks/09-feature-status-board.md"
  "shared/templates/tasks/10-collaboration-log.md"
  "shared/templates/tasks/11-readiness-gates.md"
  "shared/templates/tasks/12-stage-user-report.md"
  "docs/REPORT_MODE.md"
  "docs/WORKFLOW_STATE.md"
  "docs/QUALITY_GATE.md"
  "docs/TEAM_DELIVERY_FLOW.md"
  "github-actions/codex-doc-sync-check.yml"
  "scripts/install-dev-baseline.sh"
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

if ! grep -q "^description:" claude/SKILL.md; then
  echo "Missing skill description in claude/SKILL.md" >&2
  exit 1
fi

if ! grep -q "^disable-model-invocation:" claude/SKILL.md; then
  echo "Missing disable-model-invocation field in claude/SKILL.md" >&2
  exit 1
fi

for skill in dev-baseline-git dev-baseline-release dev-baseline-quality dev-baseline-task dev-baseline-report; do
  if ! grep -q "name: ${skill}" "claude/skills/${skill}/SKILL.md"; then
    echo "Missing Claude skill: ${skill}" >&2
    exit 1
  fi
done

if ! grep -q "# Dev Baseline for Codex" codex/AGENTS.md; then
  echo "Missing Codex AGENTS heading in codex/AGENTS.md" >&2
  exit 1
fi

if ! grep -q "# Team Delivery Flow" shared/references/team-delivery-flow.md; then
  echo "Missing team delivery flow reference." >&2
  exit 1
fi

if ! grep -q "create-task-workspace" shared/scripts/create-task-workspace.sh; then
  echo "Missing task workspace creation script." >&2
  exit 1
fi

if ! grep -q "# Team Delivery Flow" codex/.agents/skills/dev-baseline/references/team-delivery-flow.md; then
  echo "Missing Codex team delivery flow reference." >&2
  exit 1
fi

if ! grep -q "Feature Status Board" shared/templates/tasks/09-feature-status-board.md; then
  echo "Missing feature status board template." >&2
  exit 1
fi

if ! grep -q "Readiness Gates" shared/templates/tasks/11-readiness-gates.md; then
  echo "Missing readiness gates template." >&2
  exit 1
fi

if ! grep -q "Stage User Report" shared/templates/tasks/12-stage-user-report.md; then
  echo "Missing stage user report template." >&2
  exit 1
fi

if ! grep -q "Report Mode" shared/references/report-mode.md; then
  echo "Missing report mode reference." >&2
  exit 1
fi

if ! grep -q "generate-html-report" shared/scripts/generate-html-report.sh; then
  echo "Missing HTML report generator." >&2
  exit 1
fi

if ! grep -q "Blocked dangerous Git command" shared/scripts/block-dangerous-git.sh; then
  echo "Missing dangerous git guard." >&2
  exit 1
fi

if ! grep -q "Quality gate" shared/scripts/quality-gate.sh; then
  echo "Missing quality gate script." >&2
  exit 1
fi

if ! diff -q claude/templates/docs/PLAN.md codex/templates/docs/PLAN.md >/dev/null; then
  echo "Warning: Claude and Codex PLAN templates differ." >&2
fi

echo "dev-baseline Claude and Codex package looks good."
