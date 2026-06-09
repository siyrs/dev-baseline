# Team Delivery Flow

Use this flow for real product development tasks.

## PM-led mode

The main agent starts with Product Manager and then only talks to PM. PM owns requirement intake, roster decisions, readiness review, acceptance, and user-facing summaries.

PM activates only the smallest useful set of optional specialists:

- Analyst: evidence and discovery.
- Architect: system impact and constraints.
- Developer: implementation, self-test, and bugfix.
- QA Tester: validation, regression, bug report, and retest.
- Coordinator: handoff and dependency control when coordination overhead is real.

Each active specialist needs one responsibility, one expected output, and one exit condition. Skipped specialists need a rationale.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Create it with:

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

Default documents:

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

## Before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts scope, function points, and acceptance criteria.
2. PM records active/skipped agents and reasons.
3. PM gathers specialist outputs only when needed.
4. PM ensures plan, validation strategy, risks, and evidence expectations are clear.
5. PM records decisions, contract deltas, and risks.
6. PM completes readiness review in `06-readiness-acceptance.md`.
7. The user explicitly confirms implementation.

## Living contract

The initial plan is the starting intent, not an immutable command. The implementer may adjust tactical details when final acceptance does not change.

Record a contract delta in `05-governance-log.md` only when a change affects function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance.

Final review uses:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

## Execution loop

```text
Developer implements -> Developer self-tests -> QA tests when active -> Developer fixes QA bugs -> QA retests when active -> PM accepts
```
