---
name: dev-baseline-task
description: Create and manage a PM-led dynamic team delivery task workspace with readiness gates, minimal single-responsibility agents, feature status tracking, testing, bugfix, acceptance, and delivery records.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill when a new development task should follow the standard team delivery flow.

Team delivery uses PM-led Agent Mode by default. The main agent starts the Product Manager first. The PM then activates only the smallest useful set of single-responsibility agents, such as Architect, Developer, QA Tester, Coordinator, or Analyst. Do not spawn every role by default.

Use real role agents when available; otherwise run explicit role-labeled passes and record the fallback in `10-collaboration-log.md`.

Communication boundary: the main agent assigns the task to PM and then only interacts with PM. PM controls all optional specialist agents. Specialist agents report to PM, not to the main agent.

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

## Agent roster rules

The required first role is Product Manager.

The PM owns the roster decision:

- Activate Analyst only for discovery, evidence, metrics, logs, repo scan, or research.
- Activate Architect only for architecture, API, data, config, deploy, migration, security, performance, or compatibility impact.
- Activate Developer only when implementation planning, code changes, self-test, or bugfix work is needed.
- Activate QA Tester only when independent test strategy, validation, regression, or bug retest is needed.
- Activate Coordinator only when multiple active agents create handoff, dependency, sequencing, or cross-workstream risk.

Each active agent must have exactly one responsibility, one expected output, and one exit condition. Skipped agents must be recorded with a reason.

## Required preparation before implementation

Implementation must not start immediately after the user gives a feature idea.

`11-readiness-gates.md` is an enforceable gate, not only a checklist. `Result` values must be `yes`, `no`, `not-needed`, or `blocked`. Use `not-needed` only with a rationale in `Notes`. Implementation is blocked by any `no`, `blocked`, `unknown`, missing rationale, unresolved question, missing QA retest rule when QA is active, or empty `Confirmed at`.

Before implementation, complete:

1. PM drafts the requirement in `01-product-requirement.md`.
2. PM records the active/skipped agent roster and rationale in `10-collaboration-log.md` and `11-readiness-gates.md`.
3. Active specialist agents produce only their assigned outputs.
4. Active specialist agents report only to PM.
5. PM asks the user when PM or active specialists cannot resolve a question.
6. PM ensures architecture guidance or a no-architecture-impact rationale exists in `02-development-plan.md` and `11-readiness-gates.md`.
7. PM ensures an implementation plan or a no-developer-needed rationale exists in `02-development-plan.md` and `11-readiness-gates.md`.
8. PM ensures test strategy is owned by QA or PM in `04-test-plan.md` and `11-readiness-gates.md`.
9. PM ensures every Acceptance Criteria item has related test cases and evidence fields ready for acceptance coverage review.
10. PM records important decisions, scope changes, and risks in `13-decision-log.md`, `14-change-request-log.md`, and `15-risk-register.md`.
11. PM re-reviews requirement scope, specialist outputs, test plan, open questions, changes, decisions, and risks.
12. The assistant summarizes scope, active agents, skipped agents, readiness, plan, tests, open questions, changes, decisions, and risks, then asks the user to confirm starting implementation.

## Required execution loop

After readiness and user confirmation:

```text
Developer implements -> Developer self-tests -> QA tests when active -> Developer fixes QA bugs -> QA retests when active -> PM accepts
```

Do not skip QA retest after QA-reported bugfixes. If QA is intentionally skipped for a low-risk task, PM must record the rationale and own the acceptance checklist.

## Feature status tracking

Track every function point in `09-feature-status-board.md`.

Allowed status flow:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to self-test and QA test.

## Collaboration log

Record PM, every active specialist agent, skipped-agent rationale, fallback passes, and user communication in `10-collaboration-log.md`.

## Stage report

After readiness, implementation, QA, bugfix, acceptance, or delivery stages, update `12-stage-user-report.md` and summarize progress to the user.

## PLAN.md role

`docs/PLAN.md` is only a dashboard and index. Detailed records belong in the task workspace.

## Output format

- Task workspace:
- Current phase:
- Active agents:
- Skipped agents:
- PM readiness:
- Specialist readiness:
- Test readiness:
- User confirmation required:
- Next action:

## Specialist Handoff Packet

When the Product Manager activates an optional specialist, PM must first create a `Specialist Handoff Packet` in `docs/tasks/<task-folder>/10-collaboration-log.md`. The main agent does not hand work directly to specialists.

Each packet must define the specialist role, context files, decision needed, responsibility boundary, expected output, exit condition, sequencing, resolved PM questions, and questions the specialist is still allowed to ask. Specialists report only to PM and must stay within the packet boundary.
## Task Creation Plan Index

When creating a task workspace, keep `docs/PLAN.md` as the project dashboard when the user wants the task visible from the main index:

```bash
bash shared/scripts/create-task-workspace.sh <version> "<task-name>" --update-plan
```

The optional `--update-plan` flag appends a task index row with workspace, status, owner, and next action. Do not use the flag when the user explicitly wants a workspace-only draft.
