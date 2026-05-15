# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a normal software delivery process:

1. Product Manager defines product requirements and acceptance criteria.
2. Developer decomposes the requirement into implementation tasks and execution order.
3. Developer implements each stage and records implementation notes.
4. QA prepares test plan and test cases.
5. QA tests the delivered stage and writes a test report.
6. Developer fixes QA feedback and records bugfix logs.
7. QA retests until the requirement is satisfied.
8. Product Manager performs acceptance review.
9. Developer fixes acceptance feedback if needed.
10. Final delivery summary is recorded.

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
```

## Role responsibilities

### Product Manager

Owns:
- requirement background
- user value
- scope and out-of-scope
- acceptance criteria
- acceptance decision

### Developer

Owns:
- technical decomposition
- implementation order
- code changes
- self-test evidence
- bug fixes

### QA

Owns:
- test scope
- test cases
- test data
- test results
- regression status

## PLAN.md role

`docs/PLAN.md` should not contain all task details. It should act as a dashboard and index:

- current task workspace path
- task status
- owner role
- progress summary
- links to task documents
- blockers
- next action

Detailed plans, implementation notes, test reports, and acceptance records belong in the task workspace.

## Status flow

Recommended status values:

```text
planned -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
```

If rejected by QA or PM, move back to:

```text
bugfixing
```

## Safety

Team Delivery Flow may create and update files under `docs/tasks/`, `docs/PLAN.md`, and related docs. It must not implement source code before the task workspace and development plan are ready and approved.
