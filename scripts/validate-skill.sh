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

compact_docs=(
  "01-task-contract.md"
  "02-delivery-plan.md"
  "03-work-log.md"
  "04-validation.md"
  "05-governance-log.md"
  "06-readiness-acceptance.md"
  "07-delivery-summary.md"
)

for task_index in shared/templates/tasks/00-index.md skill/shared/templates/tasks/00-index.md; do
  for expected_doc in "${compact_docs[@]}"; do
    grep -q "$expected_doc" "$task_index" || { echo "Task index missing $expected_doc: $task_index" >&2; exit 1; }
  done
done

for contract in shared/templates/tasks/01-task-contract.md skill/shared/templates/tasks/01-task-contract.md; do
  grep -q "Function Points" "$contract" || { echo "Task contract missing function points: $contract" >&2; exit 1; }
  grep -q "Acceptance Criteria" "$contract" || { echo "Task contract missing acceptance criteria: $contract" >&2; exit 1; }
done

for validation in shared/templates/tasks/04-validation.md skill/shared/templates/tasks/04-validation.md; do
  grep -q "Related AC" "$validation" || { echo "Validation template missing AC mapping: $validation" >&2; exit 1; }
  grep -q "Evidence" "$validation" || { echo "Validation template missing evidence fields: $validation" >&2; exit 1; }
done

for governance in shared/templates/tasks/05-governance-log.md skill/shared/templates/tasks/05-governance-log.md; do
  grep -q "Contract Deltas" "$governance" || { echo "Governance log missing contract deltas: $governance" >&2; exit 1; }
  grep -q "Risks" "$governance" || { echo "Governance log missing risks: $governance" >&2; exit 1; }
done

grep -q "Living contract" skill/skills/dev-baseline-task/SKILL.md || { echo "Task skill missing living contract rule." >&2; exit 1; }

echo "dev-baseline standard skill package looks good."
