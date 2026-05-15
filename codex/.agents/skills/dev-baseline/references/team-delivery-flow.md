# Team Delivery Flow

Use this flow when starting or managing a real development task with PM, Developer, QA, bugfix, acceptance, and delivery stages.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

## Preparation gates before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts requirement and acceptance criteria.
2. Developer reviews feasibility, difficulty, rough effort, risks, and unclear function points.
3. PM asks the user when PM/Developer cannot resolve a question.
4. QA and PM define test scope, test cases, test data, environment, and pass/fail rules.
5. The assistant summarizes scope, feasibility, development plan, test strategy, open questions, and risks.
6. The user explicitly confirms implementation.

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

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Feature status

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to test.

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Safety

Do not implement source code before the readiness gates are complete and the user explicitly confirms implementation.
