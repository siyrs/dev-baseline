---
name: dev-baseline-git-sync
description: Safely synchronize a Git repository with its remote. Use for /dev-baseline-git-sync, git同步, git sync, 自动同步仓库, or when the user wants local changes added, committed, pulled/merged from remote, and pushed in one step.
disable-model-invocation: true
---

# Dev Baseline Git Sync Skill

Use this skill when the user wants one-step repository synchronization.

## Command

Run:

```bash
bash shared/scripts/git-sync.sh [commit message]
```

## Required behavior

The sync sequence is:

```text
git add -A -> git commit -> git fetch/pull remote -> git merge upstream -> git push
```

If there are no local changes, skip the commit and still fetch, merge, and push.

## Safety

- Run the shared script instead of hand-writing the Git sequence.
- Never force push.
- Never create tags or releases.
- Stop if secret scanning reports suspicious files.
- Stop if the repository has unresolved conflicts or an unfinished merge/rebase.
- Stop if remote merge creates conflicts; report that the user must resolve them.

## Output format

- Branch:
- Commit created:
- Commit hash:
- Remote merged:
- Pushed to:
- Notes:
