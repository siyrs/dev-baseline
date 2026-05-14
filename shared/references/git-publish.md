# Git Publish Rules

## Purpose

Git publish mode is responsible for safely staging, committing, and pushing completed work.

## Required safety checks

Before any commit or push:

1. Inspect `git status --short`
2. Inspect `git diff --stat`
3. Detect current branch and upstream
4. Run secret scanning
5. Review suspicious local-only files

## Forbidden by default

- `git push --force`
- `git push --force-with-lease`
- creating tags
- creating releases
- staging ignored files with `git add -f`
- committing `.env`, private keys, or credential dumps

## Recommended commit message styles

- `feat:`
- `fix:`
- `docs:`
- `refactor:`
- `test:`
- `chore:`
