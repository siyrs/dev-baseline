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
  "claude/skills/dev-baseline-report/SKILL.md"
  "claude/agents/docs-auditor.md"
  "claude/agents/security-guard.md"
  "claude/agents/report-writer.md"
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
  "codex/.codex/hooks.json"
  "codex/.codex/agents/release-manager.md"
  "codex/.codex/agents/report-writer.md"
  "shared/scripts/check-secrets.sh"
  "shared/scripts/check-doc-sync.sh"
  "shared/scripts/summarize-diff.sh"
  "shared/scripts/generate-html-report.sh"
  "shared/references/git-publish.md"
  "shared/references/report-mode.md"
  "github-actions/codex-doc-sync-check.yml"
  "scripts/install-dev-baseline.sh"
  "docs/REPORT_MODE.md"
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

if ! grep -q "# Dev Baseline for Codex" codex/AGENTS.md; then
  echo "Missing Codex AGENTS heading in codex/AGENTS.md" >&2
  exit 1
fi

if ! grep -q "Git publish mode" codex/AGENTS.md; then
  echo "Missing Git publish mode rules in codex/AGENTS.md" >&2
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

if ! diff -q claude/templates/docs/PLAN.md codex/templates/docs/PLAN.md >/dev/null; then
  echo "Warning: Claude and Codex PLAN templates differ." >&2
fi

echo "dev-baseline Claude and Codex package looks good."
