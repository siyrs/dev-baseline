# Dev Baseline

> Agent-native standard development workflow baseline for Claude Code and Codex.

[中文文档](./README_CN.md) · [Command Map](./docs/COMMAND_MAP.md) · [Scenario Guide](./docs/SCENARIO_GUIDE.md) · [License](./LICENSE)

Dev Baseline turns AI-assisted coding into a documented, reviewable, team-style delivery workflow.

It intentionally keeps the visible skill surface focused:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

Everything else is routed through the main `/dev-baseline` command and repository scripts/references.

---

## Main Commands

| Command | Use it for |
|---|---|
| `/dev-baseline` | General workflow: init, review, planning, quality, Git, GitHub/GitLab, sprint, release, metrics, dashboard |
| `/dev-baseline-task` | PM-led dynamic team delivery task workflow with minimal single-responsibility agents |
| `/dev-baseline-report` | Project and task reports |
| `/dev-baseline-git-sync` | Safe one-step Git sync: add, commit, fetch, merge, push |

---

## Team Delivery Flow

Start real feature work with:

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

The workflow follows:

1. The main agent assigns the task to the Product Manager agent first.
2. PM drafts the requirement and acceptance criteria.
3. PM records the minimum agent roster: active agents, skipped agents, and rationale.
4. PM activates Analyst only when discovery or evidence is needed.
5. PM activates Architect only when architecture or cross-cutting technical impact exists.
6. PM activates Developer only when implementation planning, code, self-test, or bugfix is needed.
7. PM activates QA Tester only when validation, regression, or retest needs an independent pass.
8. PM activates Coordinator only when multiple agents create handoff or dependency risk.
9. Active agents produce focused single-responsibility outputs and report only to PM.
10. PM re-reviews requirement, roster, specialist outputs, plan, tests, risks, and open questions.
11. The assistant asks the user to confirm implementation.
12. Developer implements after confirmation when Developer is active.
13. Developer self-tests.
14. QA tests and retests when QA is active; otherwise PM records a low-risk acceptance checklist.
15. PM accepts or rejects.
16. Delivery summary and reports are generated.

During team delivery, the main agent interacts only with PM. PM controls specialist agents and returns consolidated progress, risks, and results.

---

## General Operations Through `/dev-baseline`

Examples:

```text
/dev-baseline 提交并推送
/dev-baseline 检查 GitLab MR 和 Pipeline 状态
/dev-baseline 生成任务仪表盘
/dev-baseline 创建迭代 v0.3.9 sprint-1
/dev-baseline 创建发版计划 v0.4.0 rc1
/dev-baseline 生成项目指标
/dev-baseline 运行质量门禁
```

No separate visible skill command is required for these, except the dedicated Git sync shortcut below.

---

## Git Sync Shortcut

Use this when you want the local branch and remote branch synchronized in one step:

```text
/dev-baseline-git-sync
```

It runs the safe sequence:

```text
git add -A -> git commit -> git fetch/pull remote -> git merge upstream -> git push
```

The shortcut stops on suspicious secret files, unfinished merges/rebases, or merge conflicts. It never force-pushes.

---

## Reports

```text
/dev-baseline-report
/dev-baseline-report docs/tasks/<task-folder>
```

Reports are generated as HTML by default for better navigation and readability.

---

## Install

Dev Baseline now ships one standard skill package under `skill/`. Codex and Claude Code install the same package; only the destination directory differs.

Personal installs replace the existing `dev-baseline` skill directory with a fresh copy and back up old Dev Baseline standalone entrypoints such as `dev-baseline-git-sync`, so duplicated commands do not remain after reinstall.

The `codex/` and `claude/` directories are thin adapter notes only. Shared skills, agents, hooks, references, and templates live in `skill/`.

Codex project overlays are generated from common `skill/agents` plus the small `skill/codex-agent-overrides` directory.

The official installer is a Bash script. If the target environment cannot run
`.sh` files, ask the installing AI agent to read
`scripts/install-dev-baseline.sh` and perform the same filesystem operations in
the local shell or generate an equivalent script for that platform. The script
is intentionally plain: copy `skill/` to the target skills directory, archive
old `dev-baseline` backups outside the visible skills root, and generate project
overlays from the same canonical package.

Codex personal skill:

```bash
bash scripts/install-dev-baseline.sh codex
```

Claude Code personal skill:

```bash
bash scripts/install-dev-baseline.sh claude
```

Both personal skill directories:

```bash
bash scripts/install-dev-baseline.sh both-personal
```

Project overlay for Codex:

```bash
bash scripts/install-dev-baseline.sh codex-project /path/to/project
```

Project overlay for both Codex and Claude Code:

```bash
bash scripts/install-dev-baseline.sh both-project /path/to/project
```

Validate:

```bash
bash scripts/validate-skill.sh
```

---

## Best For

- Claude Code users
- Codex users
- solo developers who want structure
- small teams that need auditable PM-led role records without unnecessary agents
- long-running projects where context loss and scope drift are common

---

## License

MIT
