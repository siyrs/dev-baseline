#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"


version="${1:-}"
release_name="${2:-}"

if [[ -z "$version" || -z "$release_name" ]]; then
  echo "Usage: bash shared/scripts/create-release-workspace.sh <version> <release-name>" >&2
  exit 1
fi

slug=$(printf '%s' "$release_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace="${REPO_ROOT}/docs/releases/${date_part}-${version}-${slug}"

if [[ -e "$workspace" ]]; then
  echo "Release workspace already exists: $workspace" >&2
  exit 1
fi

template_file="${SHARED_ROOT}/templates/releases/RELEASE_TRAIN.md"
if [[ ! -f "$template_file" ]]; then
  template_file="${REPO_ROOT}/shared/templates/releases/RELEASE_TRAIN.md"
fi
[[ -f "$template_file" ]] || { echo "Release template not found: $template_file" >&2; exit 1; }

mkdir -p "$workspace"
cp "$template_file" "$workspace/RELEASE_TRAIN.md"

sed -i.bak "s/- Release name:/- Release name: ${release_name}/" "$workspace/RELEASE_TRAIN.md" || true
sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/RELEASE_TRAIN.md" || true
sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/RELEASE_TRAIN.md" || true
rm -f "$workspace/RELEASE_TRAIN.md.bak"

echo "Release workspace created: $workspace"
