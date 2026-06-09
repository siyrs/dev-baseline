# Workflow State Model

Dev Baseline separates global workflow mode, task phase, feature status, gate results, contract deltas, and publish eligibility.

## State layers

| Layer | Scope | Examples |
|---|---|---|
| Global mode | Current assistant workflow | init, backlog-review, optimization-review, planning, execution, git-publish |
| Task phase | Task workspace lifecycle | intake, readiness, in-development, validation, acceptance, delivered |
| Feature status | Function point lifecycle | not-started, in-progress, implemented, self-tested, qa-testing, qa-passed, accepted |
| Gate result | Gate item evaluation | yes, no, not-needed, blocked |
| Contract delta | Change to final review target | pending, applied, approved, rejected, deferred, closed |
| Publish eligibility | Git publish safety | unknown, safe, blocked |

## Global mode rules

- `execution` requires an approved plan or approved task readiness gate.
- `git-publish` requires explicit user intent.
- `planning` may update planning docs but must not implement production code.
- `optimization-review` may propose improvements but must not silently add them to the active plan.
- `report` generation keeps generated artifacts separate from production source changes.

## Task phase rules

Recommended compact task-level phase flow:

```text
intake -> readiness -> in-development -> self-tested -> validation -> bugfixing -> accepted -> delivered
```

Optional specialist phases may be skipped only when PM records a rationale.

## Feature status rules

Recommended function-point status flow:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected function points return to:

```text
bugfixing -> self-tested -> validation
```

## Gate result rules

Gate results are not task phases. They describe whether transition conditions are satisfied.

Allowed readiness gate results:

```text
yes | no | not-needed | blocked
```

## Living contract rules

The latest effective contract is the current review target:

```text
initial requirement + recorded contract deltas + final acceptance evidence
```

The latest effective contract lives in the compact task workspace records. It does not require a separate frozen contract file.

## Cross-session state

Use `docs/WORKFLOW_STATE.md` to reduce ambiguity across long-running sessions.

When the user says `continue`, `start`, or `提交并推送`, the assistant should resolve intent using:

- current mode
- approved plan source
- task workspace status
- last execution record
- publish eligibility

## Cross-tool state

When different tools participate, they rely on compact task records:

- `01-task-contract.md` for scope, FP, AC, and effective target
- `03-work-log.md` for agent activity, feature status, implementation, and bugfix
- `04-validation.md` for validation coverage and evidence
- `05-governance-log.md` for decisions, contract deltas, risks, and blockers
- `06-readiness-acceptance.md` for implementation authorization and PM acceptance
