#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"

if [[ -z "$workspace" ]]; then
  echo "Usage: bash shared/scripts/task-github-summary.sh <task-workspace>" >&2
  exit 1
fi

if [[ ! -d "$workspace" ]]; then
  echo "Task workspace not found: $workspace" >&2
  exit 1
fi

file="$workspace/21-github-integration.md"
if [[ ! -f "$file" ]]; then
  cat > "$file" <<'EOF'
# GitHub Integration

## Links
- Issue:
- Branch:
- Pull request:
- CI run:
- Release/deploy reference:

## Status
- Review status:
- Merge status:
- Notes:
EOF
fi

echo "# GitHub Task Summary"
echo
echo "- Workspace: $workspace"
echo "- Current branch: $(git branch --show-current 2>/dev/null || echo unknown)"
echo "- Remote: $(git remote get-url origin 2>/dev/null || echo unknown)"

if command -v gh >/dev/null 2>&1; then
  echo
  echo "## GitHub CLI"
  gh repo view --json nameWithOwner,url,defaultBranchRef 2>/dev/null || true
  echo
  echo "## Current PR"
  gh pr status 2>/dev/null || true
else
  echo
  echo "GitHub CLI not found. Install gh for live issue/PR/CI lookup."
fi

echo
echo "Integration file: $file"
