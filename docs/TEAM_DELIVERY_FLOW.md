# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a normal software delivery process with role-based preparation, execution, testing, bugfixing, acceptance, and delivery.

## Core rule

Implementation must not start immediately after a user gives a feature idea.

Before development starts, the workflow must complete two preparation loops:

1. PM ↔ Developer requirement feasibility loop
2. PM ↔ QA test strategy loop

Only after both loops are ready may the assistant ask the user to confirm implementation.

## Preparation loop 1: PM ↔ Developer

The Product Manager first drafts the rough requirement, then the Developer reviews:

- whether the feature is technically feasible
- expected implementation difficulty
- rough effort estimate
- risky or unclear function points
- required interfaces, data, config, permissions, or external services
- implementation alternatives if the original idea is risky

If the Developer cannot determine a function point, the Developer must feed questions back to the PM.
If the PM cannot answer, the PM must ask the user before the development plan is finalized.

## Preparation loop 2: PM ↔ QA

The PM and QA must agree on how the requirement will be tested before implementation starts.

QA should clarify:

- test scope
- test data needs
- required environment
- test cases and edge cases
- acceptance criteria mapping
- pass/fail rules
- regression scope

If QA cannot define a pass/fail rule, QA must feed questions back to PM.
If PM cannot answer, PM must ask the user.

## User confirmation gate

After PM, Developer, and QA are ready, the assistant must summarize:

- requirement scope
- feasibility and rough effort
- development plan
- test strategy
- open questions
- risks

Then ask the user to confirm implementation.

Do not implement source code before explicit user confirmation.

## Task workspace

Every feature or requirement should have a dedicated workspace:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Example:

```text
docs/tasks/20260515-v0.3.2-team-delivery-flow/
```

## Required documents

Each task workspace should contain:

```text
00-index.md
01-product-requirement.md
02-development-plan.md
03-implementation-notes.md
04-test-plan.md
05-test-report.md
06-bugfix-log.md
07-acceptance-report.md
08-delivery-summary.md
09-feature-status-board.md
10-collaboration-log.md
11-readiness-gates.md
12-stage-user-report.md
```

## Role responsibilities

### Product Manager

Owns:
- rough requirement intake
- requirement clarification
- user value
- scope and out-of-scope
- PM ↔ Developer question handling
- PM ↔ QA test criteria alignment
- acceptance criteria
- final acceptance decision

### Developer

Owns:
- feasibility review
- difficulty and effort estimate
- technical decomposition
- implementation order
- code changes
- feature status updates
- self-test evidence
- bug fixes

### QA

Owns:
- test strategy
- test scope
- test cases
- test data and environment needs
- pass/fail criteria
- feature test status updates
- regression status

## Feature status board

Each feature point should have its own status.

Recommended feature statuses:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

If QA rejects a feature point:

```text
qa-testing -> bugfixing -> self-tested -> qa-testing
```

If Product Manager rejects acceptance:

```text
accepted? no -> bugfixing -> self-tested -> qa-testing -> acceptance
```

## PLAN.md role

`docs/PLAN.md` should not contain all task details. It should act as a dashboard and index:

- current task workspace path
- task status
- owner role
- progress summary
- links to task documents
- blockers
- next action

Detailed plans, implementation notes, test reports, feature status, bugfix logs, and acceptance records belong in the task workspace.

## Overall status flow

Recommended task-level status values:

```text
intake -> feasibility-review -> test-strategy -> ready-for-development -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
```

If rejected by QA or PM, move back to:

```text
bugfixing
```

## Stage report

After the task reaches `qa-passed`, `accepted`, or `delivered`, the assistant should output a concrete stage report to the user, summarizing:

- completed feature points
- test status
- bugs found and fixed
- unresolved risks
- acceptance result
- next recommended action

## Safety

Team Delivery Flow may create and update files under `docs/tasks/`, `docs/PLAN.md`, and related docs. It must not implement source code before the task workspace, product requirement, development plan, and test plan are ready and explicitly approved by the user.
