#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"


# Validate required baseline docs for a project using Dev Baseline.

required_docs=(
  "README.md"
  "docs/PLAN.md"
  "docs/API.md"
  "docs/DEPLOY.md"
  "docs/CHANGELOG.md"
  "docs/CONFIG.md"
  "docs/ARCHITECTURE.md"
  "docs/TESTING.md"
)

missing=()
empty=()

for file in "${required_docs[@]}"; do
  if [[ ! -f "$file" ]]; then
    missing+=("$file")
  elif [[ ! -s "$file" ]]; then
    empty+=("$file")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing baseline docs:" >&2
  printf ' - %s\n' "${missing[@]}" >&2
fi

if [[ ${#empty[@]} -gt 0 ]]; then
  echo "Empty baseline docs:" >&2
  printf ' - %s\n' "${empty[@]}" >&2
fi

if [[ ${#missing[@]} -gt 0 || ${#empty[@]} -gt 0 ]]; then
  exit 1
fi

echo "Baseline docs look complete."
