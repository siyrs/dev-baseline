# Dev Baseline

> A Claude Code development baseline for documentation-first project delivery.

[中文文档](./README_CN.md) · [License](./LICENSE)

Dev Baseline is an open-source workflow baseline for Claude Code. It helps you take over existing repositories, establish project memory, review backlog, propose structural improvements, plan new requirements, implement work only after explicit confirmation, and publish completed repository changes only when explicitly requested.

Its goal is not to make the model “remember more.” Its goal is to move critical project context out of chat history and into structured files, so work remains understandable, reviewable, and maintainable over time.

---

## Why this exists

In many AI-assisted coding workflows, the main problem is not code generation itself. The real problems are usually:

- requirements are not decomposed before implementation
- current scope and future scope get mixed together
- APIs change but docs do not
- deployment steps change but nobody records them
- important project context gets lost as conversations grow
- new contributors cannot quickly understand the repository
- improvement ideas never get turned into a clean next iteration plan
- completed changes are not consistently committed and pushed with clear messages

Dev Baseline solves these problems by making documentation, planning, review, confirmation, and explicit Git publishing part of the delivery workflow.

---

## What it solves

Dev Baseline is designed to help Claude Code:

- take over a project cleanly
- build or repair the documentation baseline
- inspect remaining tasks from `PLAN.md`
- review a project and suggest improvements
- convert confirmed work into an iteration plan
- avoid coding before planning
- keep docs and code synchronized during implementation
- commit and push completed changes only after an explicit Git publish request

---

## Core workflow

Dev Baseline is built around six operating modes:

1. `init` — inspect the repository and establish the documentation baseline
2. `backlog review` — show unfinished tasks and future work from `PLAN.md`
3. `optimization review` — suggest improvements across structure, code quality, docs, testing, and deployment
4. `planning` — convert confirmed requirements into a concrete task plan
5. `execution` — implement work only after user confirmation and after an approved numbered plan exists
6. `git publish` — run `git add`, generate a commit message, commit, and push only when explicitly requested

---

## v0.1.1 quality enhancements

This version strengthens the workflow guardrails and template quality without changing the core positioning of the skill.

- Execution mode now has a stronger safety rule: if no approved numbered plan exists, continuation commands such as `start`, `go ahead`, or `继续` must fall back to planning or backlog review.
- `SKILL.md` now includes a mode file-boundary matrix that defines what each mode must read, may write, and must not write.
- `PLAN.md` includes an `Iteration Decision Log` section for recording scope and priority decisions.
- `CHANGELOG.md` includes migration notes and a release validation checklist.
- `DEPLOY.md` includes runtime topology and health check command placeholders.
- `API.md` includes an API change log table.
- `scripts/validate-skill.sh` checks that the skill entry and required templates exist.

Run the package check from the repository root:

```bash
bash scripts/validate-skill.sh
```

---

## Git publish mode

Git publish mode is separate from normal implementation. Dev Baseline will not commit or push as a side effect of `init`, review, planning, or execution.

Use it only when you want Claude Code to publish the current repository changes:

```text
/dev-baseline commit and push
/dev-baseline git commit and push
/dev-baseline publish changes
/dev-baseline 提交并推送
/dev-baseline 帮我提交代码并 push
```

When triggered, the skill should:

- inspect `git status`, diff summary, current branch, and upstream state
- stop if there are no changes
- stop before staging if suspicious secret or local-only files are present
- run `git add -A` only after safety checks pass
- generate a concise commit message from the actual diff
- run `git commit -m "..."`
- push to the configured upstream, or safely set upstream to `origin/<current-branch>` when needed

It must never force push, create tags, or create releases unless the user explicitly asks for that separate operation.

---

## Main commands

```text
/dev-baseline init
/dev-baseline what remains
/dev-baseline show pending tasks
/dev-baseline review this project for improvements
/dev-baseline add user login
start
/dev-baseline commit and push
```

Natural language Chinese prompts also work well, for example:

```text
/dev-baseline 看看还有什么开发任务
/dev-baseline 帮我优化下项目
/dev-baseline 新增支付模块
开始工作
/dev-baseline 提交并推送
```

---

## Install as a Claude Code skill

Claude Code supports custom skills placed in either the personal skill directory or the project skill directory.

### Quick install with Claude

If Claude Code can access this repository and your local Claude skill directory, you can often ask Claude to install this skill for you directly.

Example:

```text
Please install the Claude skill from https://github.com/siyrs/dev-baseline into my personal Claude skills directory as dev-baseline, and verify that /dev-baseline is available.
```

This is a convenient workflow when Claude can access the repo and your local filesystem. The documented fallback remains the manual install method below.

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

## How it works

### Mode 0: Init mode

Use:

```text
/dev-baseline init
```

This mode should inspect the repository, detect stack/runtime clues, generate or enrich `CLAUDE.md`, create missing baseline docs, and summarize the project. It should not start implementation, create detailed iteration tasks by default, commit, or push.

### Mode A: Backlog review mode

Use:

```text
/dev-baseline what remains
```

This mode should read `docs/PLAN.md`, show unfinished tasks, in-progress work, blockers, open questions, next iteration candidates, and future version items. It is for visibility, not implementation.

### Mode B: Optimization review mode

Use:

```text
/dev-baseline review this project for improvements
```

This mode reviews project structure, feature organization, code quality, docs, testing, deployment, and operability. It produces improvement candidates first and waits for the user to decide what enters planning.

### Mode C: Planning mode

Use:

```text
/dev-baseline add user login
```

This mode checks docs coverage, creates missing baseline files if needed, updates planning-related docs, classifies the requirement, produces a numbered task plan, and asks whether implementation should begin.

### Mode D: Execution mode

Use only after confirmation such as:

```text
start
```

or

```text
开始工作
```

This mode verifies that an approved numbered plan exists, executes the approved plan, keeps docs and code in sync, moves completed work into `PLAN.md`, and records completion timestamps. It does not commit or push unless Git publish mode is separately triggered.

### Mode E: Git publish mode

Use only after an explicit Git publishing request such as:

```text
/dev-baseline commit and push
/dev-baseline 提交并推送
```

This mode checks repository changes, stages safe files, generates a commit message, commits, and pushes. It refuses empty commits, suspicious secret files, force pushes, tags, and releases by default.

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
├─ scripts/
│  └─ validate-skill.sh
└─ examples/
   └─ demo-project-structure.md
```

---

## Documents

### `README.md`
The repository entry point. It explains what the project is, how to install it, how to use it, and how the workflow is structured.

### `claude/SKILL.md`
The workflow orchestrator. It decides which mode to use and what Claude should do in each mode.

### `project-overlay/.claude/CLAUDE.md`
Persistent project-level rules. It tells Claude how to behave in the repository over time.

### `docs/PLAN.md`
The iteration control panel. It tracks active work, completed work, open questions, next iteration candidates, future versions, and iteration decisions.

### `docs/CHANGELOG.md`
The release-facing change history. It explains what changed in each version, migration notes, validation status, and any operational impact.

### `docs/DEPLOY.md`
The runbook. It explains how to build, configure, run, verify, troubleshoot, roll back, and health-check the project.

### `docs/API.md`
The interface contract record and API change history.

### `docs/CONFIG.md`
The configuration and environment record.

### `docs/ARCHITECTURE.md`
The system boundary and design decision record.

### `docs/TESTING.md`
The validation, self-check, and release checklist record.

---

## Recommended usage flow

### Scenario 1: Taking over an existing project

```text
/dev-baseline init
/dev-baseline review this project for improvements
```

### Scenario 2: Checking what is left

```text
/dev-baseline what remains
```

### Scenario 3: Starting a new requirement

```text
/dev-baseline add payment module
start
```

### Scenario 4: Turning approved improvements into iteration work

```text
/dev-baseline review this project for improvements
Please add items 1, 3, and 5 to the next iteration
start
```

### Scenario 5: Publishing completed work

```text
/dev-baseline commit and push
```

---

## Package validation

Before publishing or copying the skill, run:

```bash
bash scripts/validate-skill.sh
```

The script checks whether the Claude skill entry file and all required templates exist, and whether the skill frontmatter contains the required fields.

---

## Best practices

- Use `init` when first entering a repository
- Use backlog review before asking “what should we do next”
- Use optimization review before large cleanup or refactor work
- Keep `PLAN.md` as the source of truth for active and upcoming work
- Only start implementation after the plan is visible and confirmed
- Trigger Git publish mode explicitly when you want changes committed and pushed
- Keep release-facing changes in `CHANGELOG.md`
- Keep operational truth in `DEPLOY.md`

---

## Best for

- Claude Code users
- solo developers
- small engineering teams
- long-running AI-assisted development
- repositories where scope drift and context loss are common

---

## License

MIT
