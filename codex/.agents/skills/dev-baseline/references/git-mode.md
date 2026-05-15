# Git Mode

Use Git mode only when the user explicitly asks for Git operations.

## Trigger examples

- `dev-baseline-git status`
- `dev-baseline-git diff`
- `dev-baseline-git commit`
- `dev-baseline-git commit and push`
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

## Output

- Git status summary
- Files committed
- Commit message
- Commit hash
- Pushed to
- Skipped or suspicious files
- Notes
