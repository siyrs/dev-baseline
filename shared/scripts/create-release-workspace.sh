#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"
release_name="${2:-}"

if [[ -z "$version" || -z "$release_name" ]]; then
  echo "Usage: bash shared/scripts/create-release-workspace.sh <version> <release-name>" >&2
  exit 1
fi

slug=$(printf '%s' "$release_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace="docs/releases/${date_part}-${version}-${slug}"

if [[ -e "$workspace" ]]; then
  echo "Release workspace already exists: $workspace" >&2
  exit 1
fi

mkdir -p "$workspace"
cp shared/templates/releases/RELEASE_TRAIN.md "$workspace/RELEASE_TRAIN.md"

sed -i.bak "s/- Release name:/- Release name: ${release_name}/" "$workspace/RELEASE_TRAIN.md" || true
sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/RELEASE_TRAIN.md" || true
sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/RELEASE_TRAIN.md" || true
rm -f "$workspace/RELEASE_TRAIN.md.bak"

echo "Release workspace created: $workspace"
