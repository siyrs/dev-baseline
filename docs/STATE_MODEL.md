# Workflow State Model

Dev Baseline separates global workflow mode, task phase, feature status, gate results, and publish eligibility.

## State layers

| Layer | Scope | Examples |
|---|---|---|
| Global mode | Current assistant workflow | init, backlog-review, optimization-review, planning, execution, git-publish |
| Task phase | Task workspace lifecycle | intake, readiness, in-development, qa-testing, acceptance, delivered |
| Feature status | Function point lifecycle | not-started, in-progress, implemented, self-tested, qa-testing, qa-passed, accepted |
| Gate result | Gate item evaluation | yes, no, not-needed, blocked |
| Publish eligibility | Git publish safety | unknown, safe, blocked |

## Global mode rules

- `execution` requires an approved plan or approved task readiness gate.
- `git-publish` requires explicit user intent and does not imply permission to edit files.
- `planning` may update planning docs but must not implement production code.
- `optimization-review` may propose improvements but must not silently add them to the active plan.
- `report` generation must keep generated artifacts separate from production source changes.

## Task phase rules

Recommended task-level phase flow:

```text
intake -> roster-decision -> discovery -> architecture-review -> feasibility-review -> test-strategy -> pm-readiness-review -> ready-for-development -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
```

Optional phases may be skipped only when PM records a rationale.

## Feature status rules

Recommended function-point status flow:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected function points return to:

```text
bugfixing -> self-tested -> qa-testing
```

## Gate result rules

Gate results are not task phases. They describe whether specific transition conditions are satisfied.

Allowed readiness gate results:

```text
yes | no | not-needed | blocked
```

## Publish eligibility rules

Publish eligibility is separate from implementation and acceptance.

- A task can be accepted but not safe to publish.
- A branch can be safe to publish while a task remains unaccepted only when the user explicitly requests Git publish and the diff scope is intentional.
- Publish gate pass does not authorize source edits.

## Cross-session state

Use `docs/WORKFLOW_STATE.md` to reduce ambiguity across long-running sessions.

When the user says `continue`, `start`, or `提交并推送`, the assistant should resolve intent using:

- current mode
- approved plan source
- task workspace status
- last execution record
- publish eligibility

## Cross-tool state

When different tools participate, they must rely on repository state:

- `16-execution-contract.md` for target consistency
- `11-readiness-gates.md` for implementation authorization
- `09-feature-status-board.md` for function-point progress
- `05-test-report.md` and `07-acceptance-report.md` for validation and acceptance evidence
- `14-change-request-log.md` and `15-risk-register.md` for deviations and blockers
