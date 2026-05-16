# Dev Baseline

> Agent-native standard development workflow baseline for Claude Code and Codex.

[中文文档](./README_CN.md) · [Command Map](./docs/COMMAND_MAP.md) · [Scenario Guide](./docs/SCENARIO_GUIDE.md) · [License](./LICENSE)

Dev Baseline turns AI-assisted coding into a documented, reviewable, team-style delivery workflow.

It intentionally keeps the visible skill surface small:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
```

Everything else is routed through the main `/dev-baseline` command and repository scripts/references.

---

## Main Commands

| Command | Use it for |
|---|---|
| `/dev-baseline` | General workflow: init, review, planning, quality, Git, GitHub/GitLab, sprint, release, metrics, dashboard |
| `/dev-baseline-task` | PM / Developer / QA team delivery task workflow |
| `/dev-baseline-report` | Project and task reports |

---

## Team Delivery Flow

Start real feature work with:

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

The workflow follows:

1. PM drafts the requirement.
2. Developer reviews feasibility, difficulty, rough effort, and risks.
3. PM asks the user if unclear points cannot be resolved internally.
4. QA and PM define test scope and pass/fail rules.
5. The assistant asks the user to confirm implementation.
6. Developer implements after confirmation.
7. Developer self-tests.
8. QA tests and reports.
9. Developer fixes bugs.
10. QA retests.
11. PM accepts or rejects.
12. Delivery summary and reports are generated.

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

No separate visible skill command is required for these.

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
- small teams that need PM / Developer / QA records
- long-running projects where context loss and scope drift are common

---

## License

MIT
