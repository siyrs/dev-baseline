# Git Mode

Use Git mode only when the user explicitly asks for Git operations through `/dev-baseline` or invokes `/dev-baseline-git-sync`.

## Trigger examples

- `/dev-baseline git status`
- `/dev-baseline 查看 diff`
- `/dev-baseline 提交`
- `/dev-baseline 提交并推送`
- `/dev-baseline commit and push`
- `/dev-baseline-git-sync`
- `git 提交`
- `提交并推送`
- `commit and push`

Do not expose or require a standalone Git skill command other than `/dev-baseline-git-sync`.

## Safety

Before staging, committing, or pushing:

```bash
git status --short
git diff --stat
bash shared/scripts/check-secrets.sh
```

For publish-style operations, run the publish gate before pushing:

```bash
bash shared/scripts/publish-gate.sh "git push"
```

Do not create tags, releases, or destructive Git operations unless the user explicitly requests that separate operation.

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
