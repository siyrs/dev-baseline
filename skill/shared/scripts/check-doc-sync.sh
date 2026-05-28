#!/usr/bin/env bash
set -euo pipefail

# Detect whether code/config/deploy changes likely require docs updates.
# This script is intentionally conservative.

changed=$(git diff --name-only HEAD 2>/dev/null || true)

needs_api=false
needs_config=false
needs_deploy=false
needs_changelog=false

while IFS= read -r file; do
  [[ -n "$file" ]] || continue

  case "$file" in
    *Controller.java|*Api*.java|*routes.ts|*router.ts|*openapi*|*swagger*)
      needs_api=true
      ;;
  esac

  case "$file" in
    *.yml|*.yaml|*.env|*.properties|docker-compose*.yml|Dockerfile)
      needs_config=true
      ;;
  esac

  case "$file" in
    nginx/*|deploy/*|k8s/*|helm/*|Dockerfile|docker-compose*.yml)
      needs_deploy=true
      ;;
  esac

  case "$file" in
    src/*|app/*|backend/*|frontend/*)
      needs_changelog=true
      ;;
  esac

done <<< "$changed"

warn=false

if $needs_api && ! grep -q 'docs/API.md' <<< "$changed"; then
  echo "Warning: API-related files changed but docs/API.md was not updated." >&2
  warn=true
fi

if $needs_config && ! grep -q 'docs/CONFIG.md' <<< "$changed"; then
  echo "Warning: config-related files changed but docs/CONFIG.md was not updated." >&2
  warn=true
fi

if $needs_deploy && ! grep -q 'docs/DEPLOY.md' <<< "$changed"; then
  echo "Warning: deploy-related files changed but docs/DEPLOY.md was not updated." >&2
  warn=true
fi

if $needs_changelog && ! grep -q 'docs/CHANGELOG.md' <<< "$changed"; then
  echo "Warning: source files changed but docs/CHANGELOG.md was not updated." >&2
  warn=true
fi

if ! $warn; then
  echo "Documentation sync check passed."
fi
