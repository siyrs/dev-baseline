---
name: dev-baseline-task
description: Create and manage a team delivery task workspace using PM, developer, QA, bugfix, acceptance, and delivery documents. Use when starting a development task, creating a task workspace, 团队开发流程, 标准开发流程, or 产品/研发/测试协作.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill when a new development task or requirement should follow the standard team delivery flow.

## Trigger examples

- `/dev-baseline-task create v0.3.2 team delivery flow`
- `/dev-baseline-task 新建开发任务`
- `/dev-baseline 开始开发任务`
- `标准开发流程`
- `产品研发测试流程`

## Default workspace

Create one task workspace per requirement:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

## Required documents

- `00-index.md`
- `01-product-requirement.md`
- `02-development-plan.md`
- `03-implementation-notes.md`
- `04-test-plan.md`
- `05-test-report.md`
- `06-bugfix-log.md`
- `07-acceptance-report.md`
- `08-delivery-summary.md`

## Recommended command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Role flow

1. Product Manager writes product requirement and acceptance criteria.
2. Developer writes detailed development plan and execution order.
3. Developer implements and records implementation notes.
4. Developer self-tests and records evidence.
5. QA writes test plan and test report.
6. Developer fixes QA bugs and records bugfix log.
7. QA retests until passed.
8. Product Manager performs acceptance.
9. Delivery summary is recorded.

## PLAN.md role

`docs/PLAN.md` is only a dashboard and index. Detailed task documents belong in the task workspace.

## Safety

Do not implement source code before the product requirement and development plan are ready and approved.
Do not commit or push unless Git mode is explicitly triggered.

## Output format

- Task workspace:
- Documents created:
- Current stage:
- Current owner role:
- Next action:
