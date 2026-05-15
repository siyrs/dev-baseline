# Task Status Mode

Use task status mode to inspect or update a task workspace.

## Commands

```bash
bash shared/scripts/validate-task-readiness.sh <task-workspace>
bash shared/scripts/advance-task-status.sh <task-workspace> FP-001 not-started in-progress Developer "started implementation"
bash shared/scripts/generate-task-report.sh <task-workspace>
```

## Responsibilities

- inspect readiness gates
- update feature status events
- generate task stage reports
- summarize current blockers and next actions

## Safety

Do not modify source code. Do not skip readiness gates. Do not commit or push.
