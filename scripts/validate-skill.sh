#!/usr/bin/env bash
set -euo pipefail

VALIDATE_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$VALIDATE_SCRIPT_DIR/validate-script-preambles.sh"

manifest_file="docs/dev-baseline-manifest.txt"
manifest_required_files=()

if [[ ! -f "$manifest_file" ]]; then
  echo "Missing Dev Baseline manifest: $manifest_file" >&2
  exit 1
fi

while IFS= read -r manifest_line || [[ -n "$manifest_line" ]]; do
  manifest_line="${manifest_line%%#*}"
  manifest_line="${manifest_line#"${manifest_line%%[![:space:]]*}"}"
  manifest_line="${manifest_line%"${manifest_line##*[![:space:]]}"}"
  [[ -n "$manifest_line" ]] || continue
  manifest_required_files+=("$manifest_line")
done < "$manifest_file"

required_files=(
  "skill/SKILL.md"
  "skill/skills/dev-baseline-task/SKILL.md"
  "skill/skills/dev-baseline-report/SKILL.md"
  "skill/skills/dev-baseline-git-sync/SKILL.md"
  "skill/AGENTS.md"
  "skill/agents/analyst.md"
  "skill/agents/architect.md"
  "skill/agents/coordinator.md"
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
  "skill/shared/scripts/git-block-dangerous.sh"
  "skill/shared/scripts/git-summarize-diff.sh"
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
  "shared/scripts/git-block-dangerous.sh"
  "shared/scripts/git-summarize-diff.sh"
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

required_files+=("${manifest_required_files[@]}")

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

if ! grep -q "Team delivery tasks use PM-led Agent Mode by default" skill/SKILL.md; then
  echo "Canonical dev-baseline skill does not use PM-led team delivery Agent Mode by default." >&2
  exit 1
fi

if ! grep -q "main agent assigns the task to the Product Manager" skill/SKILL.md; then
  echo "Canonical dev-baseline skill is missing main-agent-to-PM communication boundary." >&2
  exit 1
fi

if ! grep -q "Product Manager.*agent roster" skill/shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing PM-led roster guidance." >&2
  exit 1
fi

if ! grep -q "Architect" skill/shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing optional Architect role guidance." >&2
  exit 1
fi

if ! grep -q "PM readiness review" skill/shared/references/team-delivery-flow.md; then
  echo "Team delivery flow is missing PM readiness review." >&2
  exit 1
fi

for status_board in shared/templates/tasks/09-feature-status-board.md skill/shared/templates/tasks/09-feature-status-board.md; do
  if ! grep -q "^## Status Event Log" "$status_board"; then
    echo "Feature status board is missing Status Event Log section: $status_board" >&2
    exit 1
  fi

  if ! grep -q "| Time | Function Point | From | To | Owner | Note |" "$status_board"; then
    echo "Feature status board is missing Status Event Log table header: $status_board" >&2
    exit 1
  fi
done

for test_plan in shared/templates/tasks/04-test-plan.md skill/shared/templates/tasks/04-test-plan.md; do
  if ! grep -F -q "| ID | Function Point | Related AC | Scenario | Steps | Expected Result | Priority | Status |" "$test_plan"; then
    echo "Test plan template is missing Related AC traceability column: $test_plan" >&2
    exit 1
  fi
done

for test_report in shared/templates/tasks/05-test-report.md skill/shared/templates/tasks/05-test-report.md; do
  if ! grep -F -q "| Case ID | Related AC | Scenario | Result | Evidence Link | Screenshot | Log | Command | Notes |" "$test_report"; then
    echo "Test report template is missing AC-to-evidence result columns: $test_report" >&2
    exit 1
  fi

  if ! grep -F -q "| Bug ID | Retest Case ID | Related AC | Result | Evidence Link | Screenshot | Log | Command | Notes |" "$test_report"; then
    echo "Test report template is missing AC-to-evidence retest columns: $test_report" >&2
    exit 1
  fi
done

for acceptance_report in shared/templates/tasks/07-acceptance-report.md skill/shared/templates/tasks/07-acceptance-report.md; do
  if ! grep -F -q "| AC ID | Criteria | Related Function Point | Covered By TC | Evidence Link | Screenshot | Log | Command | Result | Notes |" "$acceptance_report"; then
    echo "Acceptance report template is missing AC evidence coverage review columns: $acceptance_report" >&2
    exit 1
  fi

  if ! grep -q "^## AC Coverage Summary" "$acceptance_report"; then
    echo "Acceptance report template is missing AC Coverage Summary section: $acceptance_report" >&2
    exit 1
  fi
done

for task_index in shared/templates/tasks/00-index.md skill/shared/templates/tasks/00-index.md; do
  for expected_doc in "13-decision-log.md" "14-change-request-log.md" "15-risk-register.md"; do
    if ! grep -q "$expected_doc" "$task_index"; then
      echo "Task workspace index is missing standard team-flow document $expected_doc: $task_index" >&2
      exit 1
    fi
  done
done

for change_log in shared/templates/tasks/14-change-request-log.md skill/shared/templates/tasks/14-change-request-log.md; do
  if ! grep -q '^| CR-' "$change_log"; then
    echo "Change request log template is missing CR-prefixed row for dashboard counting: $change_log" >&2
    exit 1
  fi
done

for risk_register in shared/templates/tasks/15-risk-register.md skill/shared/templates/tasks/15-risk-register.md; do
  if ! grep -q '^| RISK-' "$risk_register"; then
    echo "Risk register template is missing RISK-prefixed row for dashboard counting: $risk_register" >&2
    exit 1
  fi
done

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

deprecated_commands=(
  "/dev-baseline-quality"
  "/dev-baseline-task-status"
  "/dev-baseline-github"
  "/dev-baseline-sprint"
  "/dev-baseline-release-train"
  "/dev-baseline-metrics"
)

for command in "${deprecated_commands[@]}"; do
  matches=$(grep -R -n -F --exclude="validate-skill.sh" "$command" \
    README.md README_CN.md docs skill shared scripts .github 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    echo "Deprecated visible command remains: $command" >&2
    echo "$matches" >&2
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
