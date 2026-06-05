#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"


version="${1:-}"
sprint_name="${2:-}"

if [[ -z "$version" || -z "$sprint_name" ]]; then
  echo "Usage: bash shared/scripts/create-sprint-workspace.sh <version> <sprint-name>" >&2
  exit 1
fi

slug=$(printf '%s' "$sprint_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace="${REPO_ROOT}/docs/sprints/${date_part}-${version}-${slug}"

if [[ -e "$workspace" ]]; then
  echo "Sprint workspace already exists: $workspace" >&2
  exit 1
fi

template_file="${SHARED_ROOT}/templates/sprints/SPRINT.md"
if [[ ! -f "$template_file" ]]; then
  template_file="${REPO_ROOT}/shared/templates/sprints/SPRINT.md"
fi
[[ -f "$template_file" ]] || { echo "Sprint template not found: $template_file" >&2; exit 1; }

mkdir -p "$workspace"
cp "$template_file" "$workspace/SPRINT.md"

sed -i.bak "s/- Sprint name:/- Sprint name: ${sprint_name}/" "$workspace/SPRINT.md" || true
sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/SPRINT.md" || true
sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/SPRINT.md" || true
rm -f "$workspace/SPRINT.md.bak"

echo "Sprint workspace created: $workspace"
