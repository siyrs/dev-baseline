# Dev Baseline

> A Claude Code development baseline for documentation-first project delivery.

[中文文档](./README_CN.md) · [License](./LICENSE)

Dev Baseline is an open-source baseline repository for Claude Code workflows. It helps you start new projects and iterate on existing ones with a stable documentation structure, explicit scope management, and a repeatable planning-first process.

Its purpose is not to make the model “remember more.” Its purpose is to move critical project context out of chat history and into structured files, so work stays understandable, traceable, and maintainable over time.

---

## Why Dev Baseline exists

In many AI coding workflows, the main problem is not code generation itself. The real problems are usually:

- Requirements are not decomposed before implementation
- Current scope and future scope get mixed together
- APIs change but docs do not
- Deployment steps change but nobody records them
- Important project context gets lost as conversations grow
- New contributors cannot quickly understand the repository

Dev Baseline solves these problems by making documentation, planning, and update discipline part of the delivery workflow.

---

## What this repository provides

- A **platform-neutral baseline** in `core/BASELINE.md`
- A **Claude Code adaptation layer** in `claude/`
- A recommended **project overlay** in `project-overlay/.claude/`
- Ready-to-use **project templates** for documentation-first development

---

## Repository structure

```text
dev-baseline/
├─ README.md
├─ README_CN.md
├─ LICENSE
├─ .gitignore
├─ core/
│  └─ BASELINE.md
├─ claude/
│  ├─ SKILL.md
│  └─ templates/
│     ├─ README.md
│     └─ docs/
│        ├─ PLAN.md
│        ├─ API.md
│        ├─ DEPLOY.md
│        ├─ CHANGELOG.md
│        ├─ CONFIG.md
│        ├─ ARCHITECTURE.md
│        └─ TESTING.md
├─ project-overlay/
│  └─ .claude/
│     ├─ CLAUDE.md
│     └─ settings.json
└─ examples/
   └─ demo-project-structure.md
```

---

## Core philosophy

### Documentation first
Do not start with code alone. Start with project structure, iteration scope, interface contracts, configuration rules, deployment notes, and version history.

### Project memory should live in files
Important context should not depend on chat history. It should live in `README.md` and `docs/`.

### Scope must stay explicit
Current work, deferred work, and future plans must remain clearly separated.

### Docs are part of delivery
Documentation is not an afterthought. It is a first-class project artifact.

### Handoff should be easy
Anyone should be able to read the repo and understand the current state within minutes.

---

## Install as a Claude Code skill

Claude Code supports custom skills placed in either the personal skill directory or the project skill directory.

### Personal install

Copy the contents of `claude/` into:

```text
~/.claude/skills/dev-baseline/
```

Expected result:

```text
~/.claude/skills/dev-baseline/
├─ SKILL.md
└─ templates/
```

On Windows, this is typically:

```text
C:\Users\<your-user>\.claude\skills\dev-baseline\
```

### Project install

Alternatively, copy the same files into:

```text
project-root/.claude/skills/dev-baseline/
```

### Recommended project configuration

Copy the contents of `project-overlay/.claude/` into:

```text
project-root/.claude/
```

This adds:

- `CLAUDE.md` for persistent project workflow rules
- `settings.json` for plan-first behavior

---

## How to use

### 1. Review remaining work

Use this when you want Claude to inspect `docs/PLAN.md` and summarize unfinished tasks, blockers, open questions, and next-version items.

```text
/dev-baseline what remains
```

You can also ask in natural language:

```text
/dev-baseline show pending tasks
/dev-baseline what future requirements are planned
```

### 2. Plan a new requirement

Use this when a new feature or iteration request arrives.

```text
/dev-baseline add user login and role-based access control
```

The skill should:

1. Inspect repo docs coverage
2. Create missing baseline docs if needed
3. Update planning docs only
4. Produce a numbered task breakdown
5. Ask whether implementation should start

### 3. Start implementation

Only after the plan is shown, confirm with something like:

```text
start
```

or

```text
go ahead
```

or

```text
开始工作
```

Then Claude should implement tasks in the planned order and keep docs and code in sync.

---

## Skill behavior

The Claude skill supports three modes:

### Mode A: Backlog review mode
Used for requests like “what remains” or “show pending work”.

It should:

- read `docs/PLAN.md`
- list unfinished tasks (`todo`, `doing`, `blocked`)
- list open questions
- list deferred or next-version items
- recommend the best next task
- ask whether one item should move into active execution

### Mode B: Planning mode
Used for new requirements.

It should:

- inspect `README.md` and docs coverage
- create missing docs from templates
- update existing planning docs without destructive overwrite
- classify the requirement into current iteration, next version, or open question
- produce a numbered implementation plan
- ask for confirmation before implementation

### Mode C: Execution mode
Used only after explicit confirmation.

It should:

- implement the numbered plan
- keep docs and code synchronized
- report completed work, doc updates, and remaining tasks

---

## Included baseline docs

The default project baseline includes:

- `PLAN.md` for scope, tasks, priorities, risks, and open questions
- `API.md` for current and planned interfaces
- `DEPLOY.md` for environment, build, startup, release, and rollback steps
- `CHANGELOG.md` for version history and visible changes
- `CONFIG.md` for environment variables, runtime configuration, logs, and caches
- `ARCHITECTURE.md` for system boundaries and design decisions
- `TESTING.md` for validation, self-checks, and release checks

---

## Recommended workflow

1. Initialize documentation baseline
2. Define the current version goal
3. Split in-scope and out-of-scope work
4. Record open questions and risks
5. Review or update `PLAN.md`
6. Confirm before implementation
7. Update docs together with code
8. Validate before release
9. Update changelog and current status

---

## Best for

- Claude Code users
- Solo developers
- Small engineering teams
- Long-running AI-assisted development
- Repositories where scope drift and context loss are common

---

## License

MIT
