# Git Sync Mode

Git Sync Mode is a shortcut for keeping a local branch and its remote branch synchronized.

## Trigger

Use this mode when the user invokes:

```text
/dev-baseline-git-sync
```

This trigger is explicit approval to run the safe sync sequence.

## Sequence

Run the shared script:

```bash
bash shared/scripts/git-sync.sh [commit message]
```

The script performs:

1. Inspect current branch, status, and diff.
2. Run secret scanning with `shared/scripts/check-secrets.sh` when available.
3. Stage local changes with `git add -A`.
4. Commit local changes when present.
5. Fetch the remote.
6. Merge the configured upstream remote branch into the local branch.
7. Push to the configured upstream, or set `origin/<branch>` as upstream when no upstream exists.

## Safety

Git Sync Mode must not:

- force push
- create tags
- create releases
- stage ignored files with `git add -f`
- continue through suspicious secret files
- continue through unresolved conflicts
- auto-resolve merge conflicts

If merge conflicts occur, stop and report the files that need user action.
