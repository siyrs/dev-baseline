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

## Task states

- `todo`
- `doing`
- `done`
- `blocked`

## Workflow

### Initialization
- Check whether `README.md` and `docs/` exist
- Create baseline docs if missing
- Initialize version goal, scope, risks, and open questions

### Planning
- Review the requirement
- Decide whether it belongs to current iteration, next version, or open questions
- Update planning docs only
- Produce a concrete numbered task breakdown
- Ask for confirmation before implementation

### Execution
- Follow the numbered tasks
- Keep docs and code synchronized
- Report completed work and remaining tasks

## Success criteria

- Project docs are complete enough to guide work
- Current version goal is clear
- Interface, config, deploy, and change history are traceable
- README works as the project entry point
- Another contributor can quickly understand the repo state
