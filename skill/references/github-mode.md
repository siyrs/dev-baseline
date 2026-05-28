# GitHub Integration Mode

Use this mode to connect a task workspace with GitHub artifacts.

## Command

```bash
bash shared/scripts/task-github-summary.sh <task-workspace>
```

## Task document

```text
21-github-integration.md
```

This file is optional and created on demand by
`shared/scripts/task-github-summary.sh`; it is not part of the default task
template set.

## Safety

Read-oriented by default. Do not merge, close issues, release, or push unless explicitly requested through the correct mode.
