SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

#!/usr/bin/env bash
set -euo pipefail

# Detect whether code/config/deploy changes likely require docs updates.
# This script is intentionally conservative.

detect_changed_files() {
  local base_ref="${BASE_REF:-${GITHUB_BASE_REF:-}}"

  if [[ -z "$base_ref" && "${GITHUB_ACTIONS:-}" == "true" ]]; then
    base_ref="main"
  fi

  if [[ -n "$base_ref" ]]; then
    base_ref="${base_ref#refs/heads/}"
    base_ref="${base_ref#origin/}"

    if git remote get-url origin >/dev/null 2>&1; then
      local remote_ref="refs/remotes/origin/${base_ref}"
      if git fetch --no-tags origin "+refs/heads/${base_ref}:${remote_ref}" >/dev/null 2>&1; then
        local pr_changed
        if pr_changed=$(git diff --name-only "origin/${base_ref}...HEAD" 2>/dev/null); then
          echo "Documentation sync diff base: origin/${base_ref}...HEAD" >&2
          printf '%s\n' "$pr_changed"
          return 0
        fi

        echo "Warning: unable to diff origin/${base_ref}...HEAD; falling back to local HEAD diff." >&2
      else
        echo "Warning: unable to fetch origin/${base_ref}; falling back to local HEAD diff." >&2
      fi
    else
      echo "Warning: origin remote not found; falling back to local HEAD diff." >&2
    fi
  fi

  echo "Documentation sync diff base: HEAD working tree" >&2
  git diff --name-only HEAD 2>/dev/null || true
}

should_enforce() {
  case "${DOC_SYNC_ENFORCE:-}" in
    true|TRUE|1|yes|YES)
      return 0
      ;;
    false|FALSE|0|no|NO)
      return 1
      ;;
  esac

  [[ "${CI:-}" == "true" || "${GITHUB_ACTIONS:-}" == "true" ]]
}

changed=$(detect_changed_files)

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
elif should_enforce; then
  echo "Documentation sync check failed." >&2
  exit 1
else
  echo "Documentation sync check completed with warnings."
fi
