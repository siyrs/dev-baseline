---
name: dev-baseline
description: Documentation-first project workflow for Codex and Claude Code. Use when the user invokes /dev-baseline, /dev-baseline-task, /dev-baseline-report, or /dev-baseline-git-sync; also use for PM-led dynamic team delivery tasks, project reports, quality checks, Git/GitHub/GitLab requests, sprint/release planning, metrics, dashboards, and general project workflow requests.
---

# Dev Baseline

Use Dev Baseline as the main workflow router for Codex and Claude Code.

This is the canonical standard skill package. Install the same `skill/` directory into either Codex or Claude Code; do not maintain separate behavior by platform unless a platform-specific adapter is truly required.

## Visible Entrypoints

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

Route Git, GitHub/GitLab, quality, sprint, release, metrics, and dashboard requests through `/dev-baseline`. Use `/dev-baseline-git-sync` only for the safe add/commit/fetch/merge/push shortcut.

## Core Rules

- Choose one mode before acting.
- Keep `docs/PLAN.md` as a dashboard and index.
- Put detailed task records under `docs/tasks/<task-folder>/`.
- Team delivery tasks use PM-led Agent Mode by default: the main agent starts the Product Manager first, then the PM activates only the smallest set of single-responsibility agents needed for the task.
- Keep generated reports separate from production source changes.

## PM-led Agent Mode

The main agent assigns the task to the Product Manager and then communicates only with the Product Manager during Team Delivery Flow.

Product Manager owns requirement intake, agent roster decisions, readiness review, user communication, and acceptance. Product Manager controls optional specialist agents. Specialists report to PM, not to the main agent.

Optional agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, or compatibility impact.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: independent test strategy, validation, regression, bug reporting, or retest.
- Coordinator: handoff, dependency, sequencing, or cross-workstream status when coordination overhead is real.

Each active agent needs one responsibility, one expected output, and one exit condition.

Before implementation starts, PM drafts the requirement, records the roster, receives specialist outputs, reviews scope/risks/tests/readiness, and asks the user to approve implementation.

After coding starts:

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

## Living Contract Rule

For cross-tool or long-running delivery, task documents are the shared source of truth.

The initial task plan is the starting intent, not an immutable command. The implementing tool may adapt tactical details when final acceptance does not change. Changes that affect function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance must be recorded as contract deltas in `14-change-request-log.md`.

Final review uses the latest effective contract: initial requirement + recorded contract deltas + final acceptance evidence. `16-execution-contract.md` may summarize the latest effective contract for handoff clarity, but it is optional and not a hard lock.

## Routing

- Team delivery task: read `references/team-delivery-flow.md`.
- Task status and readiness: read `references/task-status-mode.md`.
- Reports: read `references/report-mode.md`.
- Quality gate: read `references/quality-mode.md`.
- Git/GitHub/GitLab/provider requests: use shared scripts and provider references.
- Git sync shortcut: use `/dev-baseline-git-sync` and run `shared/scripts/git-sync.sh`.
- Sprint/release/metrics/dashboard requests: use shared scripts and docs.
- Git publish: follow `references/git-mode.md`.

## Repository Assets

Prefer repository-provided scripts, templates, references, and governance docs when they exist.

Task scripts: `create-task-workspace.sh`, `validate-task-readiness.sh`, `validate-task-traceability.sh`, `advance-task-status.sh`, `generate-task-report.sh`, `generate-task-dashboard.sh`.

Git and gate scripts: `git-sync.sh`, `git-summarize-diff.sh`, `git-block-dangerous.sh`, `quality-gate.sh`, `publish-gate.sh`, `check-secrets.sh`, `check-doc-sync.sh`, `validate-baseline-docs.sh`.

Packaging validation: `validate-skill.sh`, `validate-command-surface.sh`, `validate-script-preambles.sh`, `sync-skill-shared.sh`.

Governance docs: `AGENT_CONTRACTS.md`, `ARCHITECTURE_GOVERNANCE.md`, `GATE_MODEL.md`, `MODEL_HANDOFF_CONSISTENCY.md`, `PACKAGING_ARCHITECTURE.md`, `STATE_MODEL.md`, `TRACEABILITY_MODEL.md`.

## Important

Most features are capabilities, not standalone visible skills. Use natural language under `/dev-baseline`.
