#!/usr/bin/env bash
set -euo pipefail

# Create a Dev Baseline team delivery task workspace.
# Usage:
#   bash shared/scripts/create-task-workspace.sh <version> <task-name>
# Example:
#   bash shared/scripts/create-task-workspace.sh v0.3.2 "team delivery flow"

version="${1:-}"
task_name="${2:-}"

if [[ -z "$version" || -z "$task_name" ]]; then
  echo "Usage: bash shared/scripts/create-task-workspace.sh <version> <task-name>" >&2
  exit 1
fi

slug=$(printf '%s' "$task_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace="docs/tasks/${date_part}-${version}-${slug}"
template_dir="shared/templates/tasks"

if [[ -e "$workspace" ]]; then
  echo "Task workspace already exists: $workspace" >&2
  exit 1
fi

mkdir -p "$workspace"
cp "$template_dir"/*.md "$workspace"/

# Fill basic placeholders in index when possible.
if [[ -f "$workspace/00-index.md" ]]; then
  sed -i.bak "s/- Task name:/- Task name: ${task_name}/" "$workspace/00-index.md" || true
  sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/00-index.md" || true
  sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/00-index.md" || true
  rm -f "$workspace/00-index.md.bak"
fi

echo "Task workspace created: $workspace"
