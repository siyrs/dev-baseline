# Team Delivery Flow

Use this flow when starting or managing a real development task with PM, Architect, Developer, QA, bugfix, acceptance, and delivery stages.

## Default Agent Mode

Team Delivery Flow uses Agent Mode by default.

When Codex sub-agent tooling is available, coordinate separate role agents:

- Product Manager
- Architect
- Developer
- QA Tester

If sub-agent tooling is unavailable, perform explicit role-labeled passes and record the fallback in `10-collaboration-log.md`.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

## Preparation gates before implementation

Implementation must not start immediately after a feature idea.

Before coding starts:

1. PM drafts requirement and acceptance criteria.
2. Architect reviews architecture impact, boundaries, risks, alternatives, and technical constraints.
3. Developer reviews feasibility, difficulty, rough effort, risks, unclear function points, and gives a concrete implementation plan.
4. PM asks the user when PM/Architect/Developer cannot resolve a question.
5. QA and PM define concrete test cases, test scope, test data, environment, and pass/fail rules.
6. PM re-reviews requirement scope, Architect guidance, Developer plan, QA test plan, open questions, and risks.
7. The assistant summarizes scope, architecture guidance, feasibility, development plan, test strategy, open questions, and risks.
8. The user explicitly confirms implementation.

## Execution loop

After readiness and user confirmation:

```text
Developer implements -> Developer self-tests -> QA Tester tests -> Developer fixes QA bugs -> QA Tester retests -> PM accepts
```

Do not skip QA retest after bugfixes. Do not move to PM acceptance while P0/P1 QA bugs remain open.

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
- `09-feature-status-board.md`
- `10-collaboration-log.md`
- `11-readiness-gates.md`
- `12-stage-user-report.md`

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Feature status

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to `self-tested` and `qa-testing`.

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Safety

Do not implement source code before the readiness gates are complete and the user explicitly confirms implementation.
