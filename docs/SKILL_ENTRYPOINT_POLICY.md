# Skill Entrypoint Policy

Dev Baseline intentionally keeps the visible skill command surface focused.

## Canonical package

`skill/` is the single standard skill package for both Codex and Claude Code.

Platform folders such as `codex/` and `claude/` are thin adapter notes only. Visible skill behavior, agents, hooks, references, templates, and installable files should be sourced from `skill/` first. Do not add a Codex-only or Claude-only entrypoint unless the platform requires a different adapter.

Common role prompts live in `skill/agents/`. Codex-only role prompt differences live in `skill/codex-agent-overrides/` and are layered on top during Codex project overlay installation.

## Visible entrypoints

Only these skill entrypoints should be exposed:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

## Why

Most operations do not need their own visible skill command. A large list of standalone Git, GitHub, quality, sprint, release, or metrics commands creates command noise.

`/dev-baseline-git-sync` is the one explicit Git shortcut because it represents a repeatable full synchronization operation: add, commit, fetch, merge, and push.

Claude Code and Codex can understand those intents through the main `/dev-baseline` skill. Detailed behavior should live in the standard skill package:

- `shared/scripts/`
- `shared/references/`
- `docs/`
- task workspace templates

When packaged for install, those assets are copied under `skill/shared/`. Platform folders should mirror or adapt this package, not redefine a second command model.

## Shared asset mirror

`shared/` is the repository-level authoring source for scripts, references, and task templates.

`skill/shared/` is the packaged mirror included inside the installable skill. It is intentionally duplicated so personal skill installs are self-contained.

Do not edit both trees by hand. Update `shared/` first, then refresh or check the packaged mirror with:

```bash
bash scripts/sync-skill-shared.sh sync
bash scripts/sync-skill-shared.sh check
```

The validation script runs the check mode so source/mirror drift is caught before release.

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
- PM-led dynamic role collaboration
- readiness gates
- task lifecycle and task workspace management

Use `/dev-baseline-report` for:

- project reports
- task reports
- HTML report generation

Use `/dev-baseline-git-sync` for:

- safely staging local changes
- committing local changes when present
- fetching and merging the configured remote branch
- pushing the synchronized branch

## Implementation rule

Do not add a new standalone `skill/skills/dev-baseline-xxx/SKILL.md` unless the command is truly user-facing and frequently used. Current allowed sub-skills are only:

```text
skill/skills/dev-baseline-task/
skill/skills/dev-baseline-report/
skill/skills/dev-baseline-git-sync/
```

Prefer adding:

```text
shared/references/<mode>.md
shared/scripts/<tool>.sh
docs/<MODE>.md
```

and route through `/dev-baseline`.
