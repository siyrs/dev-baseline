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

The default list is not closed. PM may create an ad-hoc specialist when the task needs another perspective, such as Security Reviewer, Data Migration Reviewer, Performance Reviewer, Release Operator, Documentation Owner, UX Reviewer, or Domain Expert.

A custom specialist must have an initialization prompt recorded in `03-work-log.md`: role name, mission, boundaries, context files, expected output, exit condition, and what must be returned to PM. Custom specialists report only to PM.

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

A one-line requirement is enough for intake, but not enough for implementation.

Before coding starts:

1. PM drafts scope, function points, and acceptance criteria.
2. PM records active/skipped agents, custom specialists, and reasons.
3. PM gathers specialist outputs only when needed.
4. Architect and Developer collaborate through PM to produce a workable implementation approach when code changes are needed.
5. PM ensures plan, validation strategy, risks, and evidence expectations are clear.
6. PM records decisions, contract deltas, and risks.
7. PM completes readiness review in `06-readiness-acceptance.md`.
8. The user explicitly confirms implementation.

The plan should guide implementation without freezing exact code edits.

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
