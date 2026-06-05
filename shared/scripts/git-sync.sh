#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"


# Safely synchronize the current Git branch with its remote.
#
# Sequence:
#   1. Check status and obvious secret/local-only files
#   2. Stage local changes
#   3. Commit local changes when present
#   4. Fetch remote
#   5. Merge the configured upstream remote branch
#   6. Push to the configured upstream, or set origin/<branch> as upstream
#
# Usage:
#   bash shared/scripts/git-sync.sh [commit message]

commit_message="$*"

die() {
  echo "git-sync: $*" >&2
  exit 1
}

inside_work_tree=$(git rev-parse --is-inside-work-tree 2>/dev/null || true)
[[ "$inside_work_tree" == "true" ]] || die "not inside a Git work tree"

repo_root="$REPO_ROOT"
cd "$repo_root"

git_dir=$(git rev-parse --git-dir)

if [[ -f "$git_dir/MERGE_HEAD" || -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
  die "repository has an unfinished merge or rebase; resolve it before syncing"
fi

if git diff --name-only --diff-filter=U | grep -q .; then
  die "repository has unresolved conflicts; resolve them before syncing"
fi

branch=$(git branch --show-current)
[[ -n "$branch" ]] || die "detached HEAD is not supported"

remote=$(git config --get "branch.${branch}.remote" || true)
merge_ref=$(git config --get "branch.${branch}.merge" || true)
upstream_configured=true

if [[ -z "$remote" || -z "$merge_ref" ]]; then
  upstream_configured=false
  if git remote get-url origin >/dev/null 2>&1; then
    remote="origin"
    remote_branch="$branch"
  else
    die "no upstream configured and no origin remote found"
  fi
else
  remote_branch="${merge_ref#refs/heads/}"
fi

echo "Git sync starting."
echo "Repository: $repo_root"
echo "Branch: $branch"
echo "Remote target: ${remote}/${remote_branch}"
echo

git status --short --branch
echo
git diff --stat || true
echo

secret_scan="${SCRIPT_DIR}/check-secrets.sh"
if [[ ! -f "$secret_scan" ]]; then
  secret_scan="${REPO_ROOT}/shared/scripts/check-secrets.sh"
fi

if [[ -f "$secret_scan" ]]; then
  bash "$secret_scan"
else
  echo "Secret scan skipped: check-secrets.sh not found in script or repository shared paths."
fi

if [[ -n "$(git status --porcelain)" ]]; then
  git add -A

  if git diff --cached --quiet; then
    echo "No staged changes to commit after git add -A."
  else
    if [[ -z "$commit_message" ]]; then
      commit_message="chore: sync local changes"
    fi
    git commit -m "$commit_message"
  fi
else
  echo "No local changes to commit."
fi

echo
echo "Fetching $remote..."
git fetch "$remote"

remote_ref="refs/remotes/${remote}/${remote_branch}"
if git show-ref --verify --quiet "$remote_ref"; then
  echo "Merging ${remote}/${remote_branch} into ${branch}..."
  if ! git merge --no-edit "${remote}/${remote_branch}"; then
    die "merge failed; resolve conflicts, then rerun git sync"
  fi
else
  echo "Remote branch ${remote}/${remote_branch} does not exist yet; push will create it."
fi

echo
if [[ "$upstream_configured" == "true" ]]; then
  git push
else
  git push -u "$remote" "$branch"
fi

echo
echo "Git sync completed."
echo "Branch: $branch"
echo "HEAD: $(git rev-parse --short HEAD)"
