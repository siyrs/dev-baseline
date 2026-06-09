#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash scripts/validate-script-preambles.sh
bash scripts/validate-command-surface.sh

manifest_file="docs/dev-baseline-manifest.txt"
if [[ ! -f "$manifest_file" ]]; then
  echo "Missing Dev Baseline manifest: $manifest_file" >&2
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -n "$line" ]] || continue
  if [[ ! -f "$line" ]]; then
    echo "Missing manifest file: $line" >&2
    exit 1
  fi
done < "$manifest_file"

bash scripts/sync-skill-shared.sh check

grep -q "^name: dev-baseline" skill/SKILL.md || { echo "Missing canonical dev-baseline skill." >&2; exit 1; }
grep -q "^name: dev-baseline-task" skill/skills/dev-baseline-task/SKILL.md || { echo "Missing canonical task skill." >&2; exit 1; }
grep -q "^name: dev-baseline-report" skill/skills/dev-baseline-report/SKILL.md || { echo "Missing canonical report skill." >&2; exit 1; }
grep -q "^name: dev-baseline-git-sync" skill/skills/dev-baseline-git-sync/SKILL.md || { echo "Missing canonical git-sync skill." >&2; exit 1; }

for task_index in shared/templates/tasks/00-index.md skill/shared/templates/tasks/00-index.md; do
  for expected_doc in "13-decision-log.md" "14-change-request-log.md" "15-risk-register.md" "16-execution-contract.md"; do
    grep -q "$expected_doc" "$task_index" || { echo "Task index missing $expected_doc: $task_index" >&2; exit 1; }
  done
done

for contract in shared/templates/tasks/16-execution-contract.md skill/shared/templates/tasks/16-execution-contract.md; do
  grep -q "^# Execution Contract" "$contract" || { echo "Missing execution contract title: $contract" >&2; exit 1; }
  grep -q "Ready for implementation" "$contract" || { echo "Execution contract missing readiness decision: $contract" >&2; exit 1; }
done

grep -q "Specialist Handoff Packet" shared/templates/tasks/10-collaboration-log.md || { echo "Missing handoff packet template." >&2; exit 1; }
grep -q "Related AC" shared/templates/tasks/04-test-plan.md || { echo "Missing AC traceability in test plan." >&2; exit 1; }
grep -q "Evidence Link" shared/templates/tasks/05-test-report.md || { echo "Missing evidence fields in test report." >&2; exit 1; }
grep -q "AC Coverage Summary" shared/templates/tasks/07-acceptance-report.md || { echo "Missing AC coverage summary." >&2; exit 1; }

echo "dev-baseline standard skill package looks good."
