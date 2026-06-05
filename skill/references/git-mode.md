# Git Mode

Use Git mode only when the user explicitly asks for Git operations.

## Trigger examples

- `dev-baseline-git status`
- `dev-baseline-git diff`
- `dev-baseline-git commit`
- `dev-baseline-git commit and push`
- `/dev-baseline-git-sync`
- `dev-baseline-git 提交`
- `dev-baseline-git 提交并推送`
- `git 提交`
- `提交并推送`
- `commit and push`

## Safety

Before staging, committing, or pushing:

```bash
git status --short
git diff --stat
bash shared/scripts/check-secrets.sh
```

Do not force push, tag, release, or stage ignored files unless explicitly requested as a separate operation.

For one-step local/remote synchronization, prefer:

```bash
bash shared/scripts/git-sync.sh [commit message]
```

That script stages local changes, commits when needed, fetches, merges the upstream remote branch, and pushes.

## Output

- Git status summary
- Files committed
- Commit message
- Commit hash
- Pushed to
- Skipped or suspicious files
- Notes
