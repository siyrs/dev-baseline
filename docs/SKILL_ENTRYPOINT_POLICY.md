# Skill Entrypoint Policy

Dev Baseline intentionally keeps the visible skill command surface small.

## Visible entrypoints

Only these skill entrypoints should be exposed:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
```

## Why

Most operations do not need their own visible skill command. A large list such as `/dev-baseline-git`, `/dev-baseline-github`, `/dev-baseline-quality`, `/dev-baseline-sprint`, and `/dev-baseline-metrics` creates command noise.

Claude Code and Codex can understand those intents through the main `/dev-baseline` skill. Detailed behavior should live in:

- `shared/scripts/`
- `shared/references/`
- `docs/`
- task workspace templates

## Routing policy

Use `/dev-baseline` for:

- project takeover
- backlog review
- optimization review
- quality checks
- Git status / commit / push
- GitHub or GitLab status sync
- sprint planning
- release train
- metrics
- dashboard
- general workflow requests

Use `/dev-baseline-task` for:

- standard team delivery task creation
- PM / Developer / QA collaboration
- readiness gates
- task lifecycle and task workspace management

Use `/dev-baseline-report` for:

- project reports
- task reports
- HTML report generation

## Implementation rule

Do not add a new standalone `claude/skills/dev-baseline-xxx/SKILL.md` unless the command is truly user-facing and frequently used.

Prefer adding:

```text
shared/references/<mode>.md
shared/scripts/<tool>.sh
docs/<MODE>.md
```

and route through `/dev-baseline`.
