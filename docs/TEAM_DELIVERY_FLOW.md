# Team Delivery Flow

Dev Baseline now treats real product development as a team delivery workflow instead of a single long planning document.

## Core idea

Each requirement gets a dedicated task workspace:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

`docs/PLAN.md` should act as a dashboard and index only. Detailed requirement, development, test, bugfix, acceptance and delivery records belong inside the task workspace.

## Roles

### Product Manager

Owns:
- requirement background
- user value
- scope and out-of-scope
- acceptance criteria
- final acceptance decision

### Developer

Owns:
- technical decomposition
- implementation order
- implementation notes
- self-test evidence
- bugfix records

### QA Tester

Owns:
- test plan
- test cases
- test report
- bug feedback
- retest result

## Required task documents

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

## Recommended command

```bash
bash shared/scripts/create-task-workspace.sh v0.3.2 "team delivery flow"
```

## Status flow

```text
planned -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
```

If QA or Product Manager rejects the result, the task returns to `bugfixing`.

## Safety

Implementation should not start until:

- `01-product-requirement.md` is clear
- `02-development-plan.md` is written
- user explicitly approves implementation
