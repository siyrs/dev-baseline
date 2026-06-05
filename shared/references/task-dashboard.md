# Task Dashboard Mode

Use Task Dashboard Mode to generate a project-level HTML dashboard for task workspaces.

## Inputs

- `docs/tasks/*/00-index.md`
- `docs/tasks/*/09-feature-status-board.md`
- `docs/tasks/*/05-test-report.md`
- optional `docs/tasks/*/14-change-request-log.md`
- optional `docs/tasks/*/15-risk-register.md`
- task stage reports

## Output

```text
docs/tasks/dashboard.html
```

## Recommended command

```bash
bash shared/scripts/generate-task-dashboard.sh
```

## What to show

- task folder
- task name
- version
- current status
- current owner
- feature status count
- bug count
- risk count
- change request count
- latest stage report link
- recommended next action

## Safety

Do not alter task content or source code. Only generate dashboard output.
