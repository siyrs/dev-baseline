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

echo "dev-baseline skill package looks good."
