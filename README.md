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
| `/dev-baseline-task` | PM / Architect / Developer / QA team delivery task workflow |
| `/dev-baseline-report` | Project and task reports |
| `/dev-baseline-git-sync` | Safe one-step Git sync: add, commit, fetch, merge, push |

---

## Team Delivery Flow

Start real feature work with:

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

The workflow follows:

1. Agent Mode is enabled by default for PM, Architect, Developer, and QA.
2. PM drafts the requirement.
3. Architect reviews architecture impact, constraints, risks, and alternatives.
4. Developer gives a concrete implementation plan.
5. QA and PM define concrete test cases, pass/fail rules, and retest expectations.
6. PM re-reviews requirement, architecture guidance, development plan, and test plan.
7. The assistant asks the user to confirm implementation.
8. Developer implements after confirmation.
9. Developer self-tests.
10. QA tests and reports.
11. Developer fixes bugs.
12. QA retests.
13. PM accepts or rejects.
14. Delivery summary and reports are generated.

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

Claude:

```bash
bash scripts/install-dev-baseline.sh claude ~/.claude/skills/dev-baseline
```

Codex:

```bash
bash scripts/install-dev-baseline.sh codex /path/to/project
```

Both:

```bash
bash scripts/install-dev-baseline.sh both /path/to/project
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
- small teams that need PM / Architect / Developer / QA records
- long-running projects where context loss and scope drift are common

---

## License

MIT
