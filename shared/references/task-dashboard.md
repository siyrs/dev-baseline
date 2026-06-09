# Task Dashboard Mode

Use Task Dashboard Mode to generate a project-level HTML dashboard for compact task workspaces.

## Inputs

Compact task inputs:

- `docs/tasks/*/00-index.md`
- `docs/tasks/*/01-task-contract.md`
- `docs/tasks/*/03-work-log.md`
- `docs/tasks/*/05-governance-log.md`
- task stage reports

Legacy task workspaces may still be read by fallback scripts, but new tasks use the compact 00 + 01-07 document set.

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
- function point count
- bug count
- risk count
- contract delta count
- latest stage report link
- recommended next action

## Safety

Do not alter task content or source code. Only generate dashboard output.
