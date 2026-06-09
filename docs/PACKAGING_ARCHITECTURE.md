# Packaging Architecture

Dev Baseline is packaged as one canonical skill package with thin platform adapters.

## Source tree roles

| Path | Role |
|---|---|
| `skill/` | Canonical installable skill package |
| `shared/` | Repository-level authoring source for scripts, references, and templates |
| `skill/shared/` | Packaged mirror copied into the installable skill |
| `skill/agents/` | Common role prompts |
| `skill/codex-agent-overrides/` | Codex-only prompt overlays layered during project install |
| `codex/` | Thin Codex notes only |
| `claude/` | Thin Claude Code notes only |
| `project-overlay/` | Project-level overlay assets |
| `docs/dev-baseline-manifest.txt` | Minimum standard asset manifest |

## Mirror rule

Do not edit `shared/` and `skill/shared/` independently.

Author changes in `shared/`, then sync the packaged mirror:

```bash
bash scripts/sync-skill-shared.sh sync
bash scripts/sync-skill-shared.sh check
```

## Manifest rule

Any file required for the standard development flow must be listed in `docs/dev-baseline-manifest.txt`.

This includes:

- canonical skill entrypoints
- role agents
- team-flow references
- team-flow scripts
- task workspace templates
- gate scripts
- packaging validation scripts
- cross-tool consistency model documents when they are required by the process

## Installation targets

| Mode | Target |
|---|---|
| `codex` | Personal Codex skill directory |
| `claude` | Personal Claude Code skill directory |
| `both-personal` | Both personal skill directories |
| `codex-project` | Project Codex overlay |
| `both-project` | Project Codex and Claude Code overlays |

## Validation chain

Before release or install, run:

```bash
bash scripts/validate-skill.sh
```

This should cover:

- manifest asset existence
- script preambles and Bash syntax
- shared mirror sync
- command surface policy
- required template structures
- role and flow markers
- legacy duplicate platform directories

## Platform adaptation rule

Platform-specific behavior should be added only when the platform requires a different adapter. The default is shared behavior from `skill/`.

Do not add platform-specific entrypoints unless they are necessary and documented in `docs/SKILL_ENTRYPOINT_POLICY.md`.

## Generated assets

Reports, dashboards, and task workspaces are output artifacts. They should not redefine package behavior.

Keep generated reports separate from production source changes and skill package files unless the user explicitly asks to commit those artifacts.
