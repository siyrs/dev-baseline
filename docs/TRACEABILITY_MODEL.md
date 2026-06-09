# Traceability Model

Dev Baseline uses repository documents as the source of truth for cross-agent and cross-tool delivery traceability.

## Core chain

```text
FP -> AC -> TC -> Evidence -> Acceptance
```

| Object | Meaning | Primary file |
|---|---|---|
| FP | Function point | `01-product-requirement.md`, `09-feature-status-board.md` |
| AC | Acceptance criterion | `01-product-requirement.md`, `07-acceptance-report.md` |
| TC | Test case | `04-test-plan.md`, `05-test-report.md` |
| Evidence | Link, screenshot, log, command, or PM checklist evidence | `05-test-report.md`, `07-acceptance-report.md` |
| Acceptance | PM acceptance result | `07-acceptance-report.md` |

## Supporting chain

```text
DEC / CR / RISK / BUG -> affected FP / AC -> updated plan and evidence
```

| Object | Meaning | Primary file |
|---|---|---|
| DEC | Decision | `13-decision-log.md` |
| CR | Change request | `14-change-request-log.md` |
| RISK | Risk | `15-risk-register.md` |
| BUG | Bug found during QA or review | `05-test-report.md`, `06-bugfix-log.md` |
| RTC | Retest case | `04-test-plan.md`, `05-test-report.md` |

## Traceability rules

- Every in-scope function point should have at least one acceptance criterion.
- Every acceptance criterion should map to at least one test case or a PM-owned acceptance checklist with a low-risk rationale.
- Every passed test case should include evidence when the task is cross-tool, user-visible, or regression-sensitive.
- Every accepted acceptance criterion should have coverage evidence or an explicit PM rationale.
- Every approved change request must update affected FP, AC, TC, plan, and acceptance coverage records.
- Every open high-impact risk must have an owner and mitigation before implementation starts.
- Every accepted risk must be visible in the stage user report.

## Cross-tool consistency rule

When one tool defines a task and another tool implements it, hidden conversation context must not be used as the source of truth.

The reviewer must validate the implementation against:

```text
16-execution-contract.md
01-product-requirement.md
04-test-plan.md
05-test-report.md
07-acceptance-report.md
09-feature-status-board.md
13-decision-log.md
14-change-request-log.md
15-risk-register.md
```

## Minimum validation questions

A traceability review must answer:

1. Are all required function points represented?
2. Does each function point have acceptance criteria?
3. Does each acceptance criterion have test coverage or a PM checklist rationale?
4. Does evidence exist for passed criteria?
5. Were out-of-contract changes approved as change requests?
6. Were risks mitigated, closed, or explicitly accepted?
7. Does PM acceptance match the recorded evidence?
