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
/dev-baseline-git-sync
```

Do not require separate commands such as `/dev-baseline-git`, `/dev-baseline-github`, `/dev-baseline-quality`, `/dev-baseline-sprint`, or `/dev-baseline-metrics`.

Route those requests through `/dev-baseline` and the repository assets.
Use `/dev-baseline-git-sync` only for the safe add/commit/fetch/merge/push shortcut.

## Core Rules

- Choose one mode before acting.
- Keep `docs/PLAN.md` as a dashboard and index.
- Put detailed task records under `docs/tasks/<task-folder>/`.
- Team delivery tasks enable Agent Mode by default: coordinate Product Manager, Architect, Developer, and QA Tester roles before implementation.
- Do not implement multi-step work until the user approves a plan or task readiness gates are complete.
- Do not commit, push, merge, release, or deploy unless the user explicitly asks for that operation or invokes `/dev-baseline-git-sync`.
- Keep generated reports separate from production source changes.

## Default Agent Mode

When routing to Team Delivery Flow, use real Codex sub-agent tooling when it is available. Spawn or coordinate distinct role agents for:

- Product Manager: requirement intake, scope, acceptance, and final review.
- Architect: architecture impact, boundaries, risks, and technical direction.
- Developer: concrete implementation plan, execution, self-test, and bugfix.
- QA Tester: concrete test cases, QA execution, bug reports, and retest.

If real sub-agent tooling is unavailable, perform explicit role-labeled passes in the same conversation and record the fallback in `docs/tasks/<task-folder>/10-collaboration-log.md`.

Before implementation starts, the required role sequence is:

1. Product Manager drafts and clarifies the requirement.
2. Architect gives architecture guidance and risk review.
3. Developer gives a concrete implementation plan.
4. QA Tester gives concrete test cases and pass/fail rules.
5. Product Manager re-reviews scope, architecture guidance, development plan, and test plan.
6. Only after PM review passes and the user approves implementation may Developer start coding.

After coding starts, the required execution loop is:

```text
Developer implements -> Developer self-tests -> QA Tester tests -> Developer fixes QA bugs -> QA Tester retests -> PM accepts
```

## Routing

- Team delivery task: read `references/team-delivery-flow.md`.
- Task status and readiness: read `references/task-status-mode.md`.
- Reports: read `references/report-mode.md`.
- Quality gate: read `references/quality-mode.md`.
- Git/GitHub/GitLab/provider requests: use shared scripts and provider references.
- Git sync shortcut: use `/dev-baseline-git-sync` and run `shared/scripts/git-sync.sh`.
- Sprint/release/metrics/dashboard requests: use shared scripts and docs.
- Git publish: follow `references/git-mode.md` and never force-push by default.

## Repository Assets

Prefer repository-provided scripts and templates when they exist:

- `shared/scripts/create-task-workspace.sh`
- `shared/scripts/validate-task-readiness.sh`
- `shared/scripts/advance-task-status.sh`
- `shared/scripts/git-sync.sh`
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
