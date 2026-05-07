# Dev Baseline

> A Claude Code and Codex development baseline for documentation-first project delivery.

[中文文档](./README_CN.md) · [License](./LICENSE)

Dev Baseline is an open-source workflow baseline for Claude Code and Codex. It helps you take over existing repositories, establish project memory, review backlog, propose structural improvements, plan new requirements, implement work only after explicit confirmation, and publish completed repository changes only when explicitly requested.

Its goal is not to make the model “remember more.” Its goal is to move critical project context out of chat history and into structured files, so work remains understandable, reviewable, and maintainable over time.

---

## Supported assistants

Dev Baseline now provides two equivalent workflow packages:

- `claude/` — Claude Code skill package, centered on `claude/SKILL.md`.
- `codex/` — Codex instruction package, centered on `codex/AGENTS.md`.

Both versions follow the same operating modes, document templates, safety guardrails, and Git publish rules.

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

## What it solves

Dev Baseline is designed to help AI coding assistants:

- take over a project cleanly
- build or repair the documentation baseline
- inspect remaining tasks from `PLAN.md`
- review a project and suggest improvements
- convert confirmed work into an iteration plan
- avoid coding before planning
- keep docs and code synchronized during implementation
- commit and push completed changes only after an explicit Git publish request

---

## Install for Claude Code

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

### Recommended Claude project configuration

Copy the contents of `project-overlay/.claude/` into:

```text
project-root/.claude/
```

This adds:

- `CLAUDE.md` for persistent project workflow rules
- `settings.json` for plan-first behavior

---

## Install for Codex

Codex uses repository instructions instead of Claude skill frontmatter.

### Project install

Copy `codex/AGENTS.md` into the target project root:

```text
project-root/AGENTS.md
```

Then copy the Codex templates if you want Codex to initialize or repair the documentation baseline from local files:

```text
project-root/.codex/dev-baseline/templates/
```

Expected result:

```text
project-root/
├─ AGENTS.md
└─ .codex/
   └─ dev-baseline/
      └─ templates/
         ├─ README.md
         └─ docs/
```

A minimal install can use only `AGENTS.md`; a full install should include `codex/templates/` as the template source.

---

## Main commands

Claude-style commands:

```text
/dev-baseline init
/dev-baseline what remains
/dev-baseline show pending tasks
/dev-baseline review this project for improvements
/dev-baseline add user login
start
/dev-baseline commit and push
```

Codex-style prompts:

```text
dev-baseline init
dev-baseline what remains
review this project for improvements
add user login
start
commit and push
```

Chinese prompts also work well:

```text
/dev-baseline 看看还有什么开发任务
/dev-baseline 帮我优化下项目
/dev-baseline 新增支付模块
开始工作
/dev-baseline 提交并推送
```

---

## Git publish mode

Git publish mode is separate from normal implementation. Dev Baseline will not commit or push as a side effect of `init`, review, planning, or execution.

Use it only when you want the assistant to publish the current repository changes:

```text
/dev-baseline commit and push
/dev-baseline git commit and push
/dev-baseline publish changes
/dev-baseline 提交并推送
commit and push
```

When triggered, the workflow should:

- inspect `git status`, diff summary, current branch, and upstream state
- stop if there are no changes
- stop before staging if suspicious secret or local-only files are present
- run `git add -A` only after safety checks pass
- generate a concise commit message from the actual diff
- run `git commit -m "..."`
- push to the configured upstream, or safely set upstream to `origin/<current-branch>` when needed

It must never force push, create tags, or create releases unless the user explicitly asks for that separate operation.

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
├─ codex/
│  ├─ AGENTS.md
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

## Package validation

Before publishing or copying the packages, run:

```bash
bash scripts/validate-skill.sh
```

The script checks both Claude and Codex packages, including the Claude skill entry, Codex `AGENTS.md`, and all required templates.

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
- Codex users
- solo developers
- small engineering teams
- long-running AI-assisted development
- repositories where scope drift and context loss are common

---

## License

MIT
