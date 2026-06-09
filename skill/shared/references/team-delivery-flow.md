# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a PM-led delivery process with dynamic role activation, readiness gates, implementation, validation, contract deltas, acceptance, and delivery.

## PM-led Agent Mode

The main agent starts with Product Manager. Product Manager owns requirement intake, agent roster decisions, readiness review, user communication, and acceptance.

The PM activates only the smallest useful set of optional single-responsibility agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: test strategy, validation, regression, bug reports, or retest.
- Coordinator: dependencies, handoffs, sequencing, and cross-agent status when coordination overhead is real.

Communication boundary:

- The main agent assigns the task to PM and communicates only with PM during Team Delivery Flow.
- PM controls optional specialists.
- Specialists report to PM, not to the main agent.
- Each active specialist needs one responsibility, one expected output, and one exit condition.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Use:

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Preparation before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts requirement scope, out-of-scope notes, function points, and acceptance criteria.
2. PM records active agents, skipped agents, and rationale.
3. PM activates optional specialists only when needed.
4. Active specialists produce focused outputs and report only to PM.
5. PM ensures architecture guidance or no-impact rationale exists.
6. PM ensures implementation plan or no-developer-needed rationale exists.
7. PM ensures test strategy is owned by QA or PM.
8. PM ensures AC-to-test/evidence expectations exist.
9. PM records important decisions, contract deltas, and risks.
10. PM performs readiness review.
11. The assistant summarizes readiness, risks, deltas, and open questions.
12. The user explicitly confirms implementation.

`11-readiness-gates.md` is enforceable. `Result` values must be `yes`, `no`, `not-needed`, or `blocked`. Implementation is blocked by any `no`, `blocked`, `unknown`, missing `not-needed` rationale, unresolved question, missing QA bugfix retest rule when QA is active, or empty `Confirmed at`.

## Living Contract Rule

The task contract is allowed to evolve during implementation.

Do not treat the initial plan as an immutable command. Treat silent drift as invalid.

The implementing tool may adapt implementation details, technical approach, tests, or the effective acceptance contract when real delivery constraints require it. The workflow protects consistency by requiring visible deltas and reviewable evidence, not by freezing every tactical choice.

Record a contract delta in `14-change-request-log.md` when a change affects:

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

`16-execution-contract.md` may summarize the latest effective contract for cross-tool handoff clarity, but it is optional and not a hard lock.

## Execution loop

After readiness and user confirmation:

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

QA must retest after every QA-reported bugfix. PM acceptance must not start while P0/P1 QA bugs remain open.

If QA was intentionally skipped, PM records the low-risk rationale and completes the PM-owned acceptance checklist.

## Required documents

Each task workspace should contain:

```text
00-index.md
01-product-requirement.md
02-development-plan.md
03-implementation-notes.md
04-test-plan.md
05-test-report.md
06-bugfix-log.md
07-acceptance-report.md
08-delivery-summary.md
09-feature-status-board.md
10-collaboration-log.md
11-readiness-gates.md
12-stage-user-report.md
13-decision-log.md
14-change-request-log.md
15-risk-register.md
16-execution-contract.md
```

`16-execution-contract.md` is an optional summary artifact for cross-tool or long-running tasks; do not make readiness depend on it when the rest of the task workspace is clear.

## Specialist Handoff Packet Protocol

Before activating an optional specialist, PM records a `Specialist Handoff Packet` in `10-collaboration-log.md`. The packet should define role, context files, decision needed, responsibility boundary, expected output, exit condition, sequencing, resolved PM questions, and questions still allowed.

Specialists stay inside the packet boundary. If they need decisions outside the boundary, they return the question to PM.

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Stage report

After readiness, implementation, QA, bugfix, acceptance, or delivery stages, update `12-stage-user-report.md` and summarize active agents, skipped agents, completed function points, tests, bugs, contract deltas, risks, acceptance result, and next action.
