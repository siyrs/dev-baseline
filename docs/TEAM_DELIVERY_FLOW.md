# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a PM-led delivery process with dynamic role activation, readiness, implementation, validation, contract deltas, acceptance, and delivery.

## PM-led Agent Mode

The main agent starts with Product Manager. Product Manager owns requirement intake, roster decisions, readiness review, user communication, and acceptance.

PM activates only the smallest useful set of optional single-responsibility agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: test strategy, validation, regression, bug reports, or retest.
- Coordinator: dependencies, handoffs, sequencing, and cross-agent status when coordination overhead is real.

Communication boundary: main agent talks to PM; PM controls optional specialists; specialists report to PM.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Use:

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

The default workspace uses a compact 8-file docset.

## Compact documents

```text
00-index.md
01-task-contract.md
02-delivery-plan.md
03-work-log.md
04-validation.md
05-governance-log.md
06-readiness-acceptance.md
07-delivery-summary.md
```

| File | Purpose |
|---|---|
| `00-index.md` | Entry, status, next action |
| `01-task-contract.md` | Scope, FP, AC, latest target |
| `02-delivery-plan.md` | Architecture, implementation, self-test, rollback |
| `03-work-log.md` | Agent roster, handoffs, feature status, implementation, bugfix |
| `04-validation.md` | Test plan, results, evidence, retest |
| `05-governance-log.md` | Decisions, contract deltas, risks |
| `06-readiness-acceptance.md` | Readiness gate, user confirmation, PM acceptance |
| `07-delivery-summary.md` | Stage report, delivered scope, follow-up |

## Preparation before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts requirement scope, out-of-scope notes, function points, and acceptance criteria.
2. PM records active agents, skipped agents, and rationale.
3. PM activates optional specialists only when needed.
4. Active specialists produce focused outputs and report only to PM.
5. PM ensures architecture guidance or no-impact rationale exists.
6. PM ensures implementation plan or no-developer-needed rationale exists.
7. PM ensures test strategy and AC-to-evidence expectations exist.
8. PM records important decisions, contract deltas, and risks.
9. PM performs readiness review.
10. The user explicitly confirms implementation.

`06-readiness-acceptance.md` is enforceable. Readiness result values are `yes`, `no`, `not-needed`, or `blocked`.

## Living Contract Rule

The task contract is allowed to evolve during implementation.

Do not treat the initial plan as an immutable command. Treat silent drift as invalid.

The implementing tool may adapt implementation details, technical approach, tests, or the effective acceptance contract when real delivery constraints require it. The workflow protects consistency by requiring visible deltas and reviewable evidence, not by freezing every tactical choice.

Record a contract delta in `05-governance-log.md` when a change affects:

- function points or acceptance criteria
- out-of-scope boundaries
- architecture, API, data, config, deploy, migration, security, performance, or compatibility impact
- test scope or evidence expectations
- delivery risk or final acceptance

Tactical implementation changes that do not affect final acceptance do not need extra process.

Final review compares delivery against the latest effective contract:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

## Execution loop

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

QA retests QA-reported bugfixes. If QA is skipped for a low-risk task, PM records the rationale and owns the acceptance checklist.

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Stage report

After readiness, implementation, validation, bugfix, acceptance, or delivery stages, update `07-delivery-summary.md` and summarize active agents, skipped agents, completed function points, validation, bugs, contract deltas, risks, acceptance result, and next action.
