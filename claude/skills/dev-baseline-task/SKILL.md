---
name: dev-baseline-task
description: Create and manage a team delivery task workspace with PM, Developer, QA, readiness gates, feature status tracking, testing, bugfix, acceptance, and delivery records.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill when a new development task should follow the standard team delivery flow.

## Triggers

- `/dev-baseline-task create v0.3.2 用户登录功能`
- `/dev-baseline-task 新建开发任务`
- `标准开发流程`
- `产品研发测试流程`

## Workspace

Create one workspace per requirement:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Recommended command:

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Required preparation before implementation

Implementation must not start immediately after the user gives a feature idea.

Before implementation, complete:

1. PM drafts the requirement in `01-product-requirement.md`.
2. Developer reviews feasibility, risk, difficulty, and rough effort in `02-development-plan.md` and `11-readiness-gates.md`.
3. PM and Developer resolve unclear function points. Questions that cannot be answered must go back to the user.
4. QA and PM define test scope, test cases, data, environment, and pass/fail rules in `04-test-plan.md` and `11-readiness-gates.md`.
5. The assistant summarizes scope, feasibility, plan, tests, open questions, and risks, then asks the user to confirm starting implementation.

## Feature status tracking

Track every function point in `09-feature-status-board.md`.

Allowed status flow:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to test.

## Collaboration log

Record PM, Developer, QA, and user communication in `10-collaboration-log.md`.

## Stage report

After readiness, implementation, QA, bugfix, acceptance, or delivery stages, update `12-stage-user-report.md` and summarize progress to the user.

## PLAN.md role

`docs/PLAN.md` is only a dashboard and index. Detailed records belong in the task workspace.

## Output format

- Task workspace:
- Current phase:
- PM readiness:
- Developer feasibility:
- QA readiness:
- User confirmation required:
- Next action:
