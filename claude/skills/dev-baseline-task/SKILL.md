---
name: dev-baseline-task
description: Create and manage a team delivery task workspace with PM, Architect, Developer, QA, readiness gates, feature status tracking, testing, bugfix, acceptance, and delivery records.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill when a new development task should follow the standard team delivery flow.

Team delivery uses Agent Mode by default. Use real role agents when available; otherwise run explicit PM, Architect, Developer, and QA role-labeled passes and record the fallback in `10-collaboration-log.md`.

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
2. Architect reviews architecture impact, constraints, risks, and alternatives in `02-development-plan.md` and `11-readiness-gates.md`.
3. Developer reviews feasibility, risk, difficulty, rough effort, and gives a concrete implementation plan in `02-development-plan.md` and `11-readiness-gates.md`.
4. PM, Architect, and Developer resolve unclear function points. Questions that cannot be answered must go back to the user.
5. QA and PM define concrete test cases, scope, data, environment, pass/fail rules, and bugfix retest rules in `04-test-plan.md` and `11-readiness-gates.md`.
6. PM re-reviews the requirement, Architect guidance, Developer plan, QA test plan, open questions, and risks.
7. The assistant summarizes scope, architecture guidance, feasibility, plan, tests, open questions, and risks, then asks the user to confirm starting implementation.

## Required execution loop

After readiness and user confirmation:

```text
Developer implements -> Developer self-tests -> QA tests -> Developer fixes QA bugs -> QA retests -> PM accepts
```

Do not skip QA retest after bugfixes.

## Feature status tracking

Track every function point in `09-feature-status-board.md`.

Allowed status flow:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to self-test and QA test.

## Collaboration log

Record PM, Architect, Developer, QA, and user communication in `10-collaboration-log.md`.

## Stage report

After readiness, implementation, QA, bugfix, acceptance, or delivery stages, update `12-stage-user-report.md` and summarize progress to the user.

## PLAN.md role

`docs/PLAN.md` is only a dashboard and index. Detailed records belong in the task workspace.

## Output format

- Task workspace:
- Current phase:
- PM readiness:
- Architect readiness:
- Developer feasibility:
- QA readiness:
- User confirmation required:
- Next action:
