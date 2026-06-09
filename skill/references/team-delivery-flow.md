# Team Delivery Flow

Use this flow when starting or managing a real development task with PM-led dynamic agents, readiness, validation, acceptance, delivery, and contract deltas.

## PM-led Agent Mode

The main agent starts with Product Manager. PM owns requirement intake, roster decisions, readiness review, user communication, and acceptance.

PM activates the smallest useful set of optional single-responsibility agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: validation, regression, bug reports, or retest.
- Coordinator: handoffs, dependencies, sequencing, and cross-agent status when coordination overhead is real.

Communication boundary: the main agent assigns the task to PM and only interacts with PM. PM controls optional specialists, and specialists report to PM.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

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

## Preparation before implementation

1. PM drafts requirement, scope, function points, and acceptance criteria.
2. PM records active agents, skipped agents, and reasons.
3. PM gathers focused specialist outputs only when needed.
4. PM ensures plan, validation strategy, risks, and evidence expectations are clear.
5. PM records decisions, contract deltas, and risks.
6. PM completes readiness review in `06-readiness-acceptance.md`.
7. The user explicitly confirms implementation.

## Living Contract Rule

The initial task plan is the starting intent, not an immutable command. The task contract may evolve during implementation.

The implementer may adjust tactical details freely when final acceptance does not change. Changes that affect function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance must be recorded in `05-governance-log.md` as contract deltas.

Final review uses:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

## Execution loop

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

Do not implement source code before readiness is complete and the user explicitly confirms implementation.
