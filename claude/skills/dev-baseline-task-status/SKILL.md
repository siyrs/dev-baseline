---
name: dev-baseline-task-status
description: Update or inspect task workflow status, feature status, readiness gates, and stage reports for a Dev Baseline task workspace. Use for task status, 状态流转, 更新功能点状态, 阶段报告, or readiness checks.
disable-model-invocation: true
---

# Dev Baseline Task Status Skill

Use this skill to inspect or update task workspace status.

## Trigger examples

- `/dev-baseline-task-status`
- `/dev-baseline-task-status docs/tasks/20260515-v0.3.2-login`
- `更新功能点状态`
- `阶段报告`
- `检查任务是否可以开始开发`

## Commands

Validate readiness:

```bash
bash shared/scripts/validate-task-readiness.sh <task-workspace>
```

Append a feature status event:

```bash
bash shared/scripts/advance-task-status.sh <task-workspace> FP-001 not-started in-progress Developer "started implementation"
```

Generate HTML stage report:

```bash
bash shared/scripts/generate-task-report.sh <task-workspace>
```

## Rules

- Do not change source code.
- Do not skip readiness gates.
- Do not mark a feature as accepted unless QA passed and PM acceptance exists.
- Do not commit or push unless Git mode is explicitly triggered.
