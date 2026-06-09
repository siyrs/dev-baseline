# Traceability Model

Dev Baseline uses repository task documents as the source of truth for delivery traceability.

## Core chain

```text
FP -> AC -> TC -> Evidence -> Acceptance
```

| Object | Meaning | Compact file |
|---|---|---|
| FP | Function point | `01-task-contract.md`, `03-work-log.md` |
| AC | Acceptance criterion | `01-task-contract.md`, `06-readiness-acceptance.md` |
| TC | Test case | `04-validation.md` |
| Evidence | Link, screenshot, log, command, or checklist evidence | `04-validation.md`, `06-readiness-acceptance.md` |
| Acceptance | PM acceptance result | `06-readiness-acceptance.md` |

## Supporting chain

```text
DEC / CR / RISK / BUG -> affected FP / AC -> updated plan and evidence
```

| Object | Meaning | Compact file |
|---|---|---|
| DEC | Decision | `05-governance-log.md` |
| CR | Contract delta / change record | `05-governance-log.md` |
| RISK | Risk | `05-governance-log.md` |
| BUG | Bug found during validation or review | `03-work-log.md`, `04-validation.md` |
| RTC | Retest case | `04-validation.md` |

## Traceability rules

- Every in-scope function point should have at least one acceptance criterion.
- Every acceptance criterion should map to at least one test case or a PM-owned acceptance checklist with a low-risk rationale.
- Every passed test case should include evidence when the task is cross-tool, user-visible, or regression-sensitive.
- Every accepted acceptance criterion should have coverage evidence or an explicit PM rationale.
- Contract deltas that affect FP, AC, tests, risks, or final acceptance should update the affected records before acceptance.
- Implementation details do not need delta records when final acceptance is unchanged.
- Every open high-impact risk should have an owner and mitigation before implementation starts.
- Every accepted risk should be visible in the delivery summary.

## Cross-tool consistency rule

When one tool defines a task and another tool implements it, repository task documents are the review boundary.

The reviewer validates the latest effective contract:

```text
initial requirement + recorded contract deltas + final acceptance report + test and evidence records
```

Compact workspaces keep that evidence in `01-task-contract.md`, `04-validation.md`, `05-governance-log.md`, and `06-readiness-acceptance.md`.

## Minimum validation questions

1. Are all required function points represented?
2. Does each function point have acceptance criteria?
3. Does each acceptance criterion have validation coverage or a PM checklist rationale?
4. Does evidence exist for passed criteria?
5. Are contract-changing deltas recorded and reconciled?
6. Were risks mitigated, closed, or explicitly accepted?
7. Does PM acceptance match the recorded evidence and latest effective contract?
