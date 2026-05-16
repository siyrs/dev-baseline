---
name: dev-baseline
description: Documentation-first project workflow for Codex. Use when the user invokes /dev-baseline, /dev-baseline-task, or /dev-baseline-report; also use for standard development workflow, team delivery tasks, project reports, quality checks, Git/GitHub/GitLab requests, sprint/release planning, metrics, dashboards, and general project workflow requests.
---

# Dev Baseline

Use Dev Baseline as the main workflow router for Codex.

## Visible Entrypoints

Dev Baseline intentionally exposes only a small command surface:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
```

Do not require separate commands such as `/dev-baseline-git`, `/dev-baseline-github`, `/dev-baseline-quality`, `/dev-baseline-sprint`, or `/dev-baseline-metrics`.

Route those requests through `/dev-baseline` and the repository assets.

## Core Rules

- Choose one mode before acting.
- Keep `docs/PLAN.md` as a dashboard and index.
- Put detailed task records under `docs/tasks/<task-folder>/`.
- Do not implement multi-step work until the user approves a plan or task readiness gates are complete.
- Do not commit, push, merge, release, or deploy unless the user explicitly asks for that operation.
- Keep generated reports separate from production source changes.

## Routing

- Team delivery task: read `references/team-delivery-flow.md`.
- Task status and readiness: read `references/task-status-mode.md`.
- Reports: read `references/report-mode.md`.
- Quality gate: read `references/quality-mode.md`.
- Git/GitHub/GitLab/provider requests: use shared scripts and provider references.
- Sprint/release/metrics/dashboard requests: use shared scripts and docs.
- Git publish: follow `references/git-mode.md` and never force-push by default.

## Repository Assets

Prefer repository-provided scripts and templates when they exist:

- `shared/scripts/create-task-workspace.sh`
- `shared/scripts/validate-task-readiness.sh`
- `shared/scripts/advance-task-status.sh`
- `shared/scripts/generate-task-report.sh`
- `shared/scripts/generate-html-report.sh`
- `shared/scripts/generate-task-dashboard.sh`
- `shared/scripts/detect-git-provider.sh`
- `shared/scripts/task-git-provider-summary.sh`
- `shared/scripts/task-github-summary.sh`
- `shared/scripts/task-gitlab-summary.sh`
- `shared/scripts/create-sprint-workspace.sh`
- `shared/scripts/create-release-workspace.sh`
- `shared/scripts/generate-metrics-report.sh`
- `shared/scripts/quality-gate.sh`
- `shared/scripts/check-secrets.sh`

If a script is unavailable or cannot run, explain the blocker and perform the equivalent safe inspection or document update manually.

## Important

Most features are capabilities, not standalone visible skills. Use natural language under `/dev-baseline`.
