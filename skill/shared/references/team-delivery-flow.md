# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a normal software delivery process with role-based preparation, architecture review, execution, testing, bugfixing, acceptance, and delivery.

## Default Agent Mode

Team Delivery Flow enables Agent Mode by default.

When the runtime provides real agent or sub-agent tooling, the assistant must coordinate distinct role agents for:

- Product Manager
- Architect
- Developer
- QA Tester

If real agent tooling is unavailable, the assistant must run explicit role-labeled passes in the same conversation and record the fallback in `10-collaboration-log.md`.

## Core rule

Implementation must not start immediately after a user gives a feature idea.

Before development starts, the workflow must complete three preparation loops plus PM review:

1. PM ↔ Architect architecture review loop
2. PM ↔ Developer requirement feasibility and implementation planning loop
3. PM ↔ QA test strategy loop
4. PM readiness review loop

Only after these loops are ready may the assistant ask the user to confirm implementation.

## Preparation loop 0: PM ↔ Architect

The Product Manager first drafts the rough requirement, then the Architect reviews:

- system boundaries and ownership impact
- data flow, API, config, deploy, migration, and compatibility impact
- technical constraints the Developer must follow
- architecture risks and mitigation options
- implementation alternatives if the original approach is risky

If the Architect cannot determine an architecture impact, the Architect must feed questions back to the PM.
If the PM cannot answer, the PM must ask the user before the architecture guidance is finalized.

## Preparation loop 1: PM ↔ Developer

After Architect guidance exists, the Developer reviews:

- whether the feature is technically feasible
- expected implementation difficulty
- rough effort estimate
- risky or unclear function points
- required interfaces, data, config, permissions, or external services
- implementation alternatives if the original idea is risky
- concrete implementation order and file/module impact

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

## Preparation loop 3: PM readiness review

Before asking the user to approve implementation, the Product Manager must re-review:

- requirement scope and acceptance criteria
- Architect guidance and unresolved architecture risks
- Developer implementation plan and self-test plan
- QA test cases, pass/fail rules, and regression scope
- open questions, blockers, and user-confirmation needs

If this PM review fails, the task must return to the relevant preparation loop.

## User confirmation gate

After PM, Architect, Developer, and QA are ready, the assistant must summarize:

- requirement scope
- architecture guidance
- feasibility and rough effort
- development plan
- test strategy
- open questions
- risks

Then ask the user to confirm implementation.

Do not implement source code before explicit user confirmation.

## Standard execution loop

After readiness and user confirmation, Team Delivery Flow proceeds as:

```text
Developer implements -> Developer self-tests -> QA Tester tests -> Developer fixes QA bugs -> QA Tester retests -> PM accepts
```

QA must retest after every bugfix. PM acceptance must not start while P0/P1 QA bugs remain open.

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
- PM ↔ Architect question handling
- PM ↔ Developer question handling
- PM ↔ QA test criteria alignment
- readiness re-review before implementation
- acceptance criteria
- final acceptance decision

### Architect

Owns:
- architecture review
- technical direction and constraints
- system boundary and ownership checks
- API, data, config, deploy, migration, and compatibility impact
- architecture risk and mitigation notes

### Developer

Owns:
- feasibility review
- difficulty and effort estimate
- technical decomposition
- concrete implementation plan
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
intake -> architecture-review -> feasibility-review -> test-strategy -> pm-readiness-review -> ready-for-development -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
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
