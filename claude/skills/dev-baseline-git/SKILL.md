---
name: dev-baseline-git
description: Safely inspect, stage, commit, and push repository changes when the user explicitly asks for Git operations. Use for /dev-baseline-git, git 提交, 提交并推送, commit and push, publish changes, or Git status/report requests.
disable-model-invocation: true
---

# Dev Baseline Git Skill

Use this skill only for explicit Git operations.

## Trigger examples

- `/dev-baseline-git status`
- `/dev-baseline-git diff`
- `/dev-baseline-git commit`
- `/dev-baseline-git commit and push`
- `/dev-baseline-git 提交`
- `/dev-baseline-git 提交并推送`
- `git 提交`
- `提交并推送`
- `commit and push`

## Scope

This skill may:

- inspect git status
- inspect diff summary
- run secret checks
- stage safe changes
- generate a concise commit message
- commit
- push to the configured upstream

This skill must not:

- modify source code
- force push by default
- create tags by default
- create releases by default
- stage ignored files with `git add -f` unless explicitly requested
- commit secret or local-only files

## Safety checks before commit or push

1. Run:

```bash
git status --short
git diff --stat
bash shared/scripts/check-secrets.sh
```

2. Stop if suspicious files are detected.
3. Stop if there are no changes to commit.
4. Prefer `git add -A` after checks pass.
5. Use a concise Conventional Commit style message when possible.
6. Push with `git push` if upstream exists.
7. If no upstream exists and `origin` exists, use `git push -u origin <current-branch>`.
8. Never use `--force` or `--force-with-lease` unless the user explicitly asks for that separate dangerous operation.

## Output format

- Git status summary:
- Files committed:
- Commit message:
- Commit hash:
- Pushed to:
- Skipped or suspicious files:
- Notes:
