# Team Delivery Flow

Use Team Delivery Flow when starting or managing a real development task with PM, Developer, QA, bugfix, acceptance, and delivery stages.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

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

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Safety

Do not implement source code before the product requirement and development plan are ready and approved.
