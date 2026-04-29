# Development Baseline

## Core goal

When entering any new project or new iteration, establish and maintain a stable documentation baseline before implementation.

## Required files

- `README.md`
- `docs/PLAN.md`
- `docs/API.md`
- `docs/DEPLOY.md`
- `docs/CHANGELOG.md`
- `docs/CONFIG.md`
- `docs/ARCHITECTURE.md`
- `docs/TESTING.md`

## Rules

1. Documentation first, implementation second.
2. Keep docs and code synchronized.
3. Keep current scope and future scope separate.
4. Record unclear requirements in `docs/PLAN.md` under open questions.
5. Update `docs/API.md` for interface changes.
6. Update `docs/CONFIG.md` for config changes.
7. Update `docs/DEPLOY.md` for deployment changes.
8. Update `docs/CHANGELOG.md` for user-visible completed changes.
9. Update `README.md` when project status, usage, or scope changes.
10. Docs must reflect the real state of the project.
11. Do not run `git add`, `git commit`, or `git push` unless the user explicitly triggers Git publish mode.
12. Never force push, create tags, or create releases as part of normal execution.

## Workflow

### Init
- scan the repository
- establish baseline docs
- enrich project memory
- do not create detailed iteration tasks by default
- do not commit or push changes

### Review
- inspect `PLAN.md`
- summarize unfinished, blocked, and future work
- do not commit or push changes

### Optimize
- propose improvement candidates
- only add confirmed items into planning
- do not commit or push changes

### Plan
- turn confirmed work into structured tasks
- ask for confirmation before implementation
- do not commit or push changes

### Execute
- implement confirmed tasks
- keep docs and code synchronized
- record completed timestamps
- do not commit or push changes unless the user separately triggers Git publish mode

### Git publish
- only run when the user explicitly asks to commit and/or push
- inspect `git status`, branch, upstream, and diff summary first
- stop if there are no changes
- stop if suspicious secret or local-only files are present
- stage safe changes with `git add -A`
- generate a concise commit message from the actual diff
- commit once
- push to the configured upstream, or set upstream to `origin/<current-branch>` when safe
- never force push, tag, or create releases

## Success criteria

- Project docs are complete enough to guide work
- Current and future work are clearly separated
- Interface, config, deploy, and change history are traceable
- README works as the project entry point
- Another contributor can quickly understand the repo state
- Repository changes are committed and pushed only after explicit user intent
