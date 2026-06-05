#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"
INTENDED_COMMAND="${*:-git push}"
failed=false

run_check() {
  local name="$1"
  shift
  echo "-- ${name}"
  if "$@"; then
    echo "PASS: ${name}"
  else
    echo "FAIL: ${name}"
    failed=true
  fi
  echo
}

ensure_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

check_secret_scan() {
  bash "${SCRIPT_DIR}/check-secrets.sh"
}

check_dangerous_git_guard() {
  bash "${SCRIPT_DIR}/git-block-dangerous.sh" "${INTENDED_COMMAND}"
}

check_branch_upstream() {
  if ! ensure_git_repo; then
    echo "Not inside a Git worktree."
    return 1
  fi

  local branch
  branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -z "${branch}" ]; then
    echo "Detached HEAD detected; publish from a named branch."
    return 1
  fi

  local git_dir
  git_dir="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -f "${git_dir}/MERGE_HEAD" ] || [ -d "${git_dir}/rebase-merge" ] || [ -d "${git_dir}/rebase-apply" ]; then
    echo "Merge or rebase is in progress; finish it before publishing."
    return 1
  fi

  if git diff --name-only --diff-filter=U | grep -q .; then
    echo "Unresolved conflict files are present."
    git diff --name-only --diff-filter=U
    return 1
  fi

  local upstream
  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
  if [ -z "${upstream}" ]; then
    case " ${INTENDED_COMMAND} " in
      *" -u "*|*" --set-upstream "*)
        if ! git remote get-url origin >/dev/null 2>&1; then
          echo "No upstream is configured and origin remote is missing."
          return 1
        fi
        echo "Branch: ${branch}"
        echo "Upstream: not configured yet; intended command sets upstream."
        return 0
        ;;
      *)
        echo "No upstream configured for ${branch}. Use an explicit upstream-setting publish command after review, for example: git push -u origin ${branch}"
        return 1
        ;;
    esac
  fi

  local remote
  remote="${upstream%%/*}"
  if ! git remote get-url "${remote}" >/dev/null 2>&1; then
    echo "Configured upstream remote '${remote}' is not available."
    return 1
  fi

  echo "Branch: ${branch}"
  echo "Upstream: ${upstream}"

  local counts
  counts="$(git rev-list --left-right --count "${upstream}"...HEAD 2>/dev/null || true)"
  if [ -n "${counts}" ]; then
    set -- ${counts}
    echo "Ahead: ${2:-0}, Behind: ${1:-0}"
  fi
}

check_diff_scope() {
  if ! ensure_git_repo; then
    echo "Not inside a Git worktree."
    return 1
  fi

  echo "Changed files:"
  local status
  status="$(git status --short 2>/dev/null || true)"
  if [ -n "${status}" ]; then
    printf '%s\n' "${status}"
  else
    echo "Working tree is clean."
  fi

  echo
  echo "Unstaged diff stat:"
  if ! git diff --quiet -- .; then
    git diff --stat -- .
  else
    echo "No unstaged tracked-file diff."
  fi

  echo
  echo "Staged diff stat:"
  if ! git diff --cached --quiet -- .; then
    git diff --cached --stat -- .
  else
    echo "No staged diff."
  fi
}

echo "== Dev Baseline publish gate =="
echo "Intended command: ${INTENDED_COMMAND}"
echo

run_check "Secret scan" check_secret_scan
run_check "Dangerous Git command guard" check_dangerous_git_guard
run_check "Branch/upstream state" check_branch_upstream
run_check "Diff scope summary" check_diff_scope

if [ "${failed}" = true ]; then
  echo "Publish gate failed. Resolve the failed checks before publishing."
  exit 1
fi

echo "Publish gate passed."