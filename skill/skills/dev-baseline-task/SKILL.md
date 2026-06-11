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

PM may define a custom specialist when the default roles do not cover the task need. Record the custom specialist prompt in `03-work-log.md` before activation. The prompt must include role name, mission, boundaries, context files, expected output, exit condition, and what to return to PM.

Communication boundary: main agent talks to PM. PM controls optional specialists. Specialists report to PM.

Each active specialist needs one responsibility, one expected output, and one exit condition. Skipped specialists need a recorded reason.

## Requirement elaboration

A one-line requirement is enough for task intake, but implementation requires a workable plan.

When code changes are needed, Architect and Developer should collaborate through PM before implementation starts. Their output goes into `02-delivery-plan.md` and should cover:

- architecture impact or no-impact rationale
- implementation approach and sequencing
- likely files, modules, or areas to change
- assumptions, constraints, dependencies, and risks
- self-test and validation expectations

This should be concrete enough to guide work, but it does not need to prescribe exact code edits. Implementation can still adapt tactics under the Living Contract Rule.

## Living contract rule

Task documents are the shared source of truth across tools and sessions.

The initial task plan is the starting intent. Implementation may adapt tactics, technical approach, tests, or acceptance wording when real delivery constraints require it.

Target-changing deltas must be recorded in `05-governance-log.md` when they affect:

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
2. PM records active/skipped agents, custom specialists, and rationale.
3. Active specialists produce focused outputs and report only to PM.
4. PM ensures architecture guidance or no-impact rationale exists.
5. PM ensures Architect/Developer elaboration produced a workable implementation approach when code changes are needed.
6. PM ensures test strategy and AC-to-evidence expectations exist.
7. PM records decisions, contract deltas, and risks.
8. PM performs readiness review.
9. User confirms implementation.

`06-readiness-acceptance.md` is enforceable. Valid `Result` values are `yes`, `no`, `not-needed`, and `blocked`.

## Execution loop

```text
Developer implements -> Developer self-tests -> QA tests when active -> Developer fixes QA bugs -> QA retests when active -> PM accepts
```

QA retests QA-reported bugfixes. When QA is skipped for a low-risk task, PM records the rationale and owns the acceptance checklist.

## Required records

- product requirement and acceptance criteria
- agent roster, custom specialist prompts, and handoff notes
- delivery plan or no-developer-needed rationale
- test plan or PM checklist
- feature status board
- readiness gates
- decision log
- contract delta log
- risk register
- validation and acceptance evidence
- stage user report

## Output format

- Task workspace:
- Current phase:
- Active agents:
- Custom specialists:
- Skipped agents:
- PM readiness:
- Test readiness:
- Contract deltas:
- User confirmation required:
- Next action:
