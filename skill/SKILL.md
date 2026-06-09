---
name: dev-baseline
description: Documentation-first project workflow for Codex and Claude Code. Use when the user invokes /dev-baseline, /dev-baseline-task, /dev-baseline-report, or /dev-baseline-git-sync; also use for PM-led dynamic team delivery tasks, project reports, quality checks, Git/GitHub/GitLab requests, sprint/release planning, metrics, dashboards, and general project workflow requests.
---

# Dev Baseline

Use Dev Baseline as the main workflow router for Codex and Claude Code.

This is the canonical standard skill package. Install the same `skill/` directory into either Codex or Claude Code; do not maintain separate behavior by platform unless a platform-specific adapter is truly required.

## Visible Entrypoints

Dev Baseline intentionally exposes only a small command surface:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

Do not require separate standalone commands for Git, GitHub, quality, sprint, release, or metrics operations.

Route those requests through `/dev-baseline` and the repository assets.
Use `/dev-baseline-git-sync` only for the safe add/commit/fetch/merge/push shortcut.

## Core Rules

- Choose one mode before acting.
- Keep `docs/PLAN.md` as a dashboard and index.
- Put detailed task records under `docs/tasks/<task-folder>/`.
- Team delivery tasks use PM-led Agent Mode by default: the main agent starts the Product Manager first, then the PM activates only the smallest set of single-responsibility agents needed for the task.
- Do not spawn Architect, Developer, QA Tester, Coordinator, Analyst, or other specialist agents without a concrete reason recorded in `10-collaboration-log.md` and `11-readiness-gates.md`.
- Do not implement multi-step work until the user approves a plan or task readiness gates are complete.
- Do not commit, push, merge, release, or deploy unless the user explicitly asks for that operation or invokes `/dev-baseline-git-sync`.
- Keep generated reports separate from production source changes.

## PM-led Agent Mode

When routing to Team Delivery Flow, use real Codex sub-agent tooling when it is available.

The main agent must start with exactly one required role:

- Product Manager: requirement intake, scope, agent roster decisions, readiness review, acceptance, and final user-facing summary.

Communication boundary:

- The main agent assigns the task to the Product Manager and then communicates only with the Product Manager during Team Delivery Flow.
- The Product Manager controls all optional specialist agents, including Analyst, Architect, Developer, QA Tester, Coordinator, or any future specialist role.
- Optional specialist agents report to the Product Manager, not to the main agent.
- The main agent must not directly prompt, coordinate, or accept deliverables from specialist agents except through the Product Manager's summary.

The Product Manager decides whether to activate additional single-responsibility agents. Prefer the minimum viable roster:

- Analyst: activate only for discovery, evidence gathering, repo scan, logs, metrics, or external research.
- Architect: activate only for architecture, API, data, config, deploy, migration, security, performance, or compatibility impact.
- Developer: activate only when implementation planning, code changes, self-test, or bugfix work is needed.
- QA Tester: activate only when test strategy, user-visible validation, regression risk, or bug retest requires an independent validation pass.
- Coordinator: activate only when multiple active agents create handoff, dependency, scheduling, or cross-workstream risk.

Do not create all agents by default. Each active agent must have one responsibility, one expected output, and an exit condition. If real sub-agent tooling is unavailable, perform explicit role-labeled passes in the same conversation and record the fallback in `docs/tasks/<task-folder>/10-collaboration-log.md`.

Before implementation starts, the required sequence is:

1. Product Manager drafts and clarifies the requirement.
2. Product Manager records the agent roster: active agents, skipped agents, and the reason for each decision.
3. Product Manager activates optional Analyst, Architect, Developer, QA Tester, or Coordinator agents only when their responsibility is needed.
4. Active specialist agents produce their single-responsibility outputs.
5. Product Manager receives all specialist outputs and resolves cross-agent questions.
6. Product Manager re-reviews scope, specialist outputs, open questions, risks, test strategy, and readiness.
7. Only after PM review passes and the user approves implementation may implementation start.

After coding starts, the required execution loop is:

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

If the PM intentionally skips QA for a low-risk task, the PM must record the rationale and own the acceptance checklist. Do not skip QA retest when QA has reported bugs.

For cross-tool delivery, the defining tool must record `16-execution-contract.md`; the implementing tool works against that contract; the reviewing tool validates the result against the contract, traceability records, and evidence.

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

Prefer repository-provided scripts, templates, references, and governance docs when they exist.

Task scripts:

- `shared/scripts/create-task-workspace.sh`
- `shared/scripts/validate-task-readiness.sh`
- `shared/scripts/validate-task-traceability.sh`
- `shared/scripts/advance-task-status.sh`
- `shared/scripts/generate-task-report.sh`
- `shared/scripts/generate-task-dashboard.sh`
- `shared/scripts/task-github-summary.sh`
- `shared/scripts/task-dashboard-summary.sh`

Git and gate scripts:

- `shared/scripts/git-sync.sh`
- `shared/scripts/git-summarize-diff.sh`
- `shared/scripts/git-block-dangerous.sh`
- `shared/scripts/quality-gate.sh`
- `shared/scripts/publish-gate.sh`
- `shared/scripts/check-secrets.sh`
- `shared/scripts/check-doc-sync.sh`
- `shared/scripts/validate-baseline-docs.sh`

Packaging validation scripts:

- `scripts/validate-skill.sh`
- `scripts/validate-command-surface.sh`
- `scripts/validate-script-preambles.sh`
- `scripts/sync-skill-shared.sh`

Governance docs:

- `docs/AGENT_CONTRACTS.md`
- `docs/ARCHITECTURE_GOVERNANCE.md`
- `docs/GATE_MODEL.md`
- `docs/MODEL_HANDOFF_CONSISTENCY.md`
- `docs/PACKAGING_ARCHITECTURE.md`
- `docs/STATE_MODEL.md`
- `docs/TRACEABILITY_MODEL.md`

If a script is unavailable or cannot run, explain the blocker and perform the equivalent safe inspection or document update manually.

## Important

Most features are capabilities, not standalone visible skills. Use natural language under `/dev-baseline`.
