# Team Delivery Flow

Use this flow when starting or managing a real development task with PM-led dynamic agents, readiness gates, bugfix, acceptance, delivery, and contract deltas.

## PM-led Agent Mode

The main agent starts with Product Manager. Product Manager owns requirement intake, agent roster decisions, readiness review, user communication, and acceptance.

The PM activates only the smallest useful set of optional single-responsibility agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: test strategy, validation, regression, bug reports, or retest.
- Coordinator: handoffs, dependencies, sequencing, and cross-agent status when coordination overhead is real.

Communication boundary: the main agent assigns the task to PM and only interacts with PM. PM controls optional specialists, and specialists report to PM.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

## Preparation gates before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts requirement, scope, function points, and acceptance criteria.
2. PM records active agents, skipped agents, and reasons.
3. PM activates optional specialists only when needed.
4. Active specialists produce focused outputs and report only to PM.
5. PM ensures architecture guidance or no-impact rationale exists.
6. PM ensures implementation plan or no-developer-needed rationale exists.
7. PM ensures test strategy and AC-to-evidence expectations exist.
8. PM records decisions, contract deltas, and risks.
9. PM performs readiness review.
10. The user explicitly confirms implementation.

`11-readiness-gates.md` is enforceable. `Result` values must be `yes`, `no`, `not-needed`, or `blocked`.

## Living Contract Rule

The initial task plan is the starting intent, not an immutable command. The task contract may evolve during implementation.

The implementer may adjust tactical details freely when final acceptance does not change. Changes that affect function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance must be recorded in `14-change-request-log.md` as contract deltas.

Final review uses the latest effective contract:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

`16-execution-contract.md` may summarize the latest effective contract for cross-tool handoff clarity, but it is optional and not a hard lock.

## Execution loop

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

Do not skip QA retest after QA-reported bugfixes. If QA is skipped for a low-risk task, PM records the rationale and owns the acceptance checklist.

## Documents

- `00-index.md`
- `01-product-requirement.md`
- `02-development-plan.md`
- `03-implementation-notes.md`
- `04-test-plan.md`
- `05-test-report.md`
- `06-bugfix-log.md`
- `07-acceptance-report.md`
- `08-delivery-summary.md`
- `09-feature-status-board.md`
- `10-collaboration-log.md`
- `11-readiness-gates.md`
- `12-stage-user-report.md`
- `13-decision-log.md`
- `14-change-request-log.md`
- `15-risk-register.md`
- `16-execution-contract.md` optional latest-effective-contract summary

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Safety

Do not implement source code before readiness gates are complete and the user explicitly confirms implementation.
