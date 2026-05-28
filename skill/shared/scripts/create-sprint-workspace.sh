#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"
sprint_name="${2:-}"

if [[ -z "$version" || -z "$sprint_name" ]]; then
  echo "Usage: bash shared/scripts/create-sprint-workspace.sh <version> <sprint-name>" >&2
  exit 1
fi

slug=$(printf '%s' "$sprint_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace="docs/sprints/${date_part}-${version}-${slug}"

if [[ -e "$workspace" ]]; then
  echo "Sprint workspace already exists: $workspace" >&2
  exit 1
fi

mkdir -p "$workspace"
cp shared/templates/sprints/SPRINT.md "$workspace/SPRINT.md"

sed -i.bak "s/- Sprint name:/- Sprint name: ${sprint_name}/" "$workspace/SPRINT.md" || true
sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/SPRINT.md" || true
sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/SPRINT.md" || true
rm -f "$workspace/SPRINT.md.bak"

echo "Sprint workspace created: $workspace"
