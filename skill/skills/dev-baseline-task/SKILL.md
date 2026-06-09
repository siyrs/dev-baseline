---
name: dev-baseline-task
description: Create and manage a PM-led dynamic team delivery task workspace with readiness gates, minimal single-responsibility agents, feature status tracking, testing, bugfix, acceptance, and delivery records.
disable-model-invocation: true
---

# Dev Baseline Task Skill

Use this skill when a new development task should follow the standard team delivery flow.

Team delivery uses PM-led Agent Mode by default. The main agent starts the Product Manager first. The PM activates only the smallest useful set of single-responsibility agents. Do not spawn every role by default.

Communication boundary: the main agent assigns the task to PM and then only interacts with PM. PM controls all optional specialist agents. Specialists report to PM, not to the main agent.

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

Use `--update-plan` only when the user wants the task visible from `docs/PLAN.md`:

```bash
bash shared/scripts/create-task-workspace.sh <version> "<task-name>" --update-plan
```

## Agent roster rules

The required first role is Product Manager.

The PM owns the roster decision:

- Analyst: discovery, evidence, metrics, logs, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: independent test strategy, validation, regression, bug reporting, or retest.
- Coordinator: handoffs, dependency, sequencing, or cross-workstream status when coordination overhead is real.

Each active agent must have one responsibility, one expected output, and one exit condition. Skipped agents must be recorded with a reason.

## Living contract rule

Task documents are the shared source of truth across model tools.

The initial task plan is not an immutable command. It is the starting intent. During real implementation, the implementing tool may adjust details, technical approach, tests, or the effective acceptance contract when delivery constraints require it.

Do not block independent AI reasoning with overly detailed implementation rules. Instead, prevent silent drift:

- tactical implementation details may change freely when final acceptance does not change;
- changes that affect function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance must be recorded in the task workspace;
- final review uses the latest effective contract: initial requirement + recorded contract deltas + final acceptance evidence.

Use `14-change-request-log.md` as a lightweight contract delta log. Use `16-execution-contract.md` only when a cross-tool handoff needs a compact summary of the latest effective contract; it is optional, not a hard lock.

## Required preparation before implementation

Implementation must not start immediately after the user gives a feature idea.

Before implementation, complete:

1. PM drafts the requirement in `01-product-requirement.md`.
2. PM records the active/skipped agent roster and rationale in `10-collaboration-log.md` and `11-readiness-gates.md`.
3. Active specialists produce only their assigned outputs and report only to PM.
4. PM asks the user when PM or active specialists cannot resolve a question.
5. PM ensures architecture guidance or a no-impact rationale exists.
6. PM ensures an implementation plan or no-developer-needed rationale exists.
7. PM ensures test strategy is owned by QA or PM.
8. PM ensures acceptance criteria have related test/evidence expectations.
9. PM records important decisions, contract deltas, and risks in `13-decision-log.md`, `14-change-request-log.md`, and `15-risk-register.md`.
10. PM re-reviews requirement scope, specialist outputs, plan, tests, open questions, deltas, decisions, and risks.
11. The assistant summarizes readiness and asks the user to confirm starting implementation.

`11-readiness-gates.md` is enforceable: `Result` values must be `yes`, `no`, `not-needed`, or `blocked`. Implementation is blocked by any `no`, `blocked`, `unknown`, missing `not-needed` rationale, unresolved question, missing QA retest rule when QA is active, or empty `Confirmed at`.

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

Record PM, every active specialist agent, skipped-agent rationale, fallback passes, user communication, and specialist handoff packets in `10-collaboration-log.md`.

When PM activates an optional specialist, PM creates a `Specialist Handoff Packet` first. The main agent does not hand work directly to specialists.

## Stage report

After readiness, implementation, QA, bugfix, acceptance, or delivery stages, update `12-stage-user-report.md` and summarize progress to the user.

## Output format

- Task workspace:
- Current phase:
- Active agents:
- Skipped agents:
- PM readiness:
- Specialist readiness:
- Test readiness:
- Contract deltas:
- User confirmation required:
- Next action:
