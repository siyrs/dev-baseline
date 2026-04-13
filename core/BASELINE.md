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

## Workflow

### Init
- scan the repository
- establish baseline docs
- enrich project memory
- do not create detailed iteration tasks by default

### Review
- inspect `PLAN.md`
- summarize unfinished, blocked, and future work

### Optimize
- propose improvement candidates
- only add confirmed items into planning

### Plan
- turn confirmed work into structured tasks
- ask for confirmation before implementation

### Execute
- implement confirmed tasks
- keep docs and code synchronized
- record completed timestamps

## Success criteria

- Project docs are complete enough to guide work
- Current and future work are clearly separated
- Interface, config, deploy, and change history are traceable
- README works as the project entry point
- Another contributor can quickly understand the repo state
