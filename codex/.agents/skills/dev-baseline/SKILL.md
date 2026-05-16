---
name: dev-baseline
description: Documentation-first project workflow for Codex. Use when the user invokes dev-baseline, /dev-baseline, /dev-baseline-task, /dev-baseline-task-status, /dev-baseline-quality, /dev-baseline-report, /dev-baseline-git, /dev-baseline-release, /dev-baseline-dashboard, /dev-baseline-github, /dev-baseline-sprint, /dev-baseline-release-train, /dev-baseline-metrics, or the same commands without a leading slash; also use for project takeover, backlog review, planning before implementation, team delivery task workspaces, quality gates, reports, release readiness, safe Git publishing, sprint/release coordination, GitHub task linkage, and delivery metrics.
---

# Dev Baseline

Use Dev Baseline to manage Codex work through a documentation-first workflow. The goal is to keep project context in files, keep scope explicit, and avoid mixing planning, implementation, and Git publishing.

## Core Rules

- Choose exactly one mode before acting.
- Inspect existing project docs before writing new planning content.
- Keep `docs/PLAN.md` as a dashboard and index; put detailed task records under `docs/tasks/<task-folder>/`.
- Do not start implementation for multi-step work until the user has approved a numbered plan or completed task readiness gates.
- Do not commit, push, tag, merge, release, or force-push unless the user explicitly asks for that operation.
- Keep generated reports and workflow docs separate from production source changes.

## Mode Selection

- **Init**: Use for project takeover or baseline setup such as `dev-baseline init`. Inspect the repository, create or enrich `AGENTS.md`, and create missing baseline docs from templates.
- **Backlog review**: Use for "what remains" or "pending tasks". Read `docs/PLAN.md` and summarize remaining work without editing by default.
- **Optimization review**: Use for improvement reviews. Inspect structure, docs, testing, deployment, and operability; do not add items to `docs/PLAN.md` until the user confirms.
- **Planning**: Use for new requirements. Update planning docs first, produce a numbered implementation plan, then ask for confirmation before coding.
- **Execution**: Use only after explicit confirmation and an approved numbered plan or completed task readiness gates.
- **Task workflow**: Use for `/dev-baseline-task` or `dev-baseline-task` and real feature work with PM, Developer, QA, bugfix, acceptance, and delivery records. Read `references/team-delivery-flow.md`.
- **Task status**: Use for `/dev-baseline-task-status` or `dev-baseline-task-status`, readiness checks, feature status updates, and task stage reports. Read `references/task-status-mode.md`.
- **Quality**: Use for `/dev-baseline-quality` or `dev-baseline-quality`, quality gate, project self-check, or health check. Read `references/quality-mode.md`.
- **Report**: Use for `/dev-baseline-report` or `dev-baseline-report` project report generation. Read `references/report-mode.md`.
- **Dashboard**: Use for `/dev-baseline-dashboard` or `dev-baseline-dashboard` task dashboard requests. Read `references/dashboard-mode.md`.
- **GitHub integration**: Use for `/dev-baseline-github` or `dev-baseline-github`, linking task workspaces to GitHub issues, branches, PRs, CI, or review state. Read `references/github-mode.md`.
- **Git publish**: Use for `/dev-baseline-git` or `dev-baseline-git`, commit, push, or publish requests. Read `references/git-mode.md`.
- **Release readiness**: Use for `/dev-baseline-release` or `dev-baseline-release`, release checks, or release notes. Read `references/release-mode.md`.
- **Sprint**: Use for `/dev-baseline-sprint` or `dev-baseline-sprint`, sprint planning, iteration workspaces, and grouped task progress. Read `references/sprint-mode.md`.
- **Release train**: Use for `/dev-baseline-release-train` or `dev-baseline-release-train`, release candidate coordination, blockers, rollback plans, and release workspaces. Read `references/release-train-mode.md`.
- **Metrics**: Use for `/dev-baseline-metrics` or `dev-baseline-metrics`, project delivery metrics, and metrics reports. Read `references/metrics-mode.md`.

## Repository Assets

Prefer repository-provided scripts and templates when they exist:

- `shared/scripts/create-task-workspace.sh`
- `shared/scripts/validate-task-readiness.sh`
- `shared/scripts/advance-task-status.sh`
- `shared/scripts/generate-task-report.sh`
- `shared/scripts/generate-html-report.sh`
- `shared/scripts/generate-task-dashboard.sh`
- `shared/scripts/task-github-summary.sh`
- `shared/scripts/create-sprint-workspace.sh`
- `shared/scripts/create-release-workspace.sh`
- `shared/scripts/generate-metrics-report.sh`
- `shared/scripts/quality-gate.sh`
- `shared/scripts/check-secrets.sh`

If a script is unavailable or cannot run in the current environment, explain the blocker and perform the equivalent safe inspection or document update manually.

## Output Style

End each mode with the relevant result summary:

- Init: project summary, detected stack, docs created or updated, open questions, recommended next step.
- Backlog: pending, in-progress, blocked, open questions, next candidates, blockers, recommended next task.
- Planning: requirement summary, scope decision, docs changed, numbered task breakdown, open questions, risks, confirmation question.
- Execution: completed work, code changes, docs updated, remaining tasks, next step.
- Git publish: status summary, files committed, commit message, hash, push target, skipped or suspicious files.
- Reports, dashboards, metrics, sprint, release train, and GitHub integration: generated or updated paths, key findings, blockers, and recommended next action.
