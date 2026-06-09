---
name: dev-baseline-task
description: Create and manage a PM-led dynamic team delivery task workspace with readiness gates, minimal single-responsibility agents, feature status tracking, testing, bugfix, acceptance, and delivery records.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill for real development work that should follow the PM-led team delivery flow.

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

Use `--update-plan` only when the task should appear in `docs/PLAN.md`.

## Operating model

The main agent starts with Product Manager. PM owns requirement intake, scope, agent roster decisions, readiness review, user communication, and acceptance.

PM activates the smallest useful set of optional specialists:

- Analyst: evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: test strategy, validation, regression, bug reports, or retest.
- Coordinator: handoffs, dependencies, sequencing, or cross-workstream status when coordination overhead is real.

Communication boundary: main agent talks to PM. PM controls optional specialists. Specialists report to PM.

Each active specialist needs one responsibility, one expected output, and one exit condition. Skipped specialists need a recorded reason.

## Living contract rule

Task documents are the shared source of truth across tools and sessions.

The initial task plan is the starting intent. Implementation may adapt tactics, technical approach, tests, or acceptance wording when real delivery constraints require it.

Target-changing deltas must be recorded in `14-change-request-log.md` when they affect:

- function points
- acceptance criteria or pass rules
- architecture constraints
- test scope or evidence expectations
- delivery risk
- final acceptance

Tactical changes that leave final acceptance unchanged do not need extra process.

Final review uses the latest effective contract:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

## Preparation before implementation

Implementation starts only after:

1. PM drafts requirement, scope, function points, and acceptance criteria.
2. PM records active/skipped agents and rationale.
3. Active specialists produce focused outputs and report only to PM.
4. PM ensures architecture guidance or no-impact rationale exists.
5. PM ensures implementation plan or no-developer-needed rationale exists.
6. PM ensures test strategy and AC-to-evidence expectations exist.
7. PM records decisions, contract deltas, and risks.
8. PM performs readiness review.
9. User confirms implementation.

`11-readiness-gates.md` is enforceable. Valid `Result` values are `yes`, `no`, `not-needed`, and `blocked`.

## Execution loop

```text
Developer implements -> Developer self-tests -> QA tests when active -> Developer fixes QA bugs -> QA retests when active -> PM accepts
```

QA retests QA-reported bugfixes. When QA is skipped for a low-risk task, PM records the rationale and owns the acceptance checklist.

## Required records

- product requirement and acceptance criteria
- agent roster and handoff notes
- development plan or no-developer-needed rationale
- test plan or PM checklist
- feature status board
- readiness gates
- decision log
- contract delta log
- risk register
- test report and acceptance report
- stage user report

## Output format

- Task workspace:
- Current phase:
- Active agents:
- Skipped agents:
- PM readiness:
- Test readiness:
- Contract deltas:
- User confirmation required:
- Next action:
