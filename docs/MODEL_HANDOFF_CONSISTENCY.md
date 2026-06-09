# Model Handoff Consistency

This document defines how Dev Baseline keeps task intent consistent when different model tools participate in one delivery flow.

Typical cross-tool chain:

```text
Tool 1 / Codex defines the task -> Tool 2 / Claude Code implements and validates -> Tool 1 / Codex reviews the result
```

Using the same Dev Baseline skill is necessary but not sufficient. Target consistency is guaranteed only when all tools work against the same recorded task contract, acceptance criteria, traceability records, and evidence.

## Required shared source of truth

Every cross-tool task must have a task workspace and an execution contract:

```text
docs/tasks/<task-folder>/16-execution-contract.md
```

The execution contract is the handoff artifact from the task-defining tool to the implementing tool and the later reviewing tool.

It must define:

- task identity and workspace
- defining tool / model and intended executor / reviewer
- requirement summary
- in scope and out of scope
- function points
- acceptance criteria
- architectural constraints or no-impact rationale
- implementation constraints
- test and evidence expectations
- files or modules expected to change when known
- explicit non-goals
- review checklist for the final reviewer

## Contract ownership

- The defining tool owns the initial task contract.
- The Product Manager owns contract completeness before implementation starts.
- The implementing tool must not reinterpret scope outside the contract.
- The reviewing tool validates implementation output against the contract rather than against conversation memory.

## When the contract is insufficient

If the contract lacks acceptance criteria, implementation boundaries, test expectations, or architecture constraints, the implementing tool must return the task to PM instead of guessing.

A cross-tool task is not ready for implementation when any of these are missing:

- at least one confirmed function point
- acceptance criteria for each required function point
- test strategy or PM-owned acceptance checklist
- evidence expectations for acceptance
- out-of-scope notes
- architecture impact decision or no-impact rationale

## Required implementation behavior

The implementing tool must record:

- which contract version it used
- which function points were implemented
- which files were changed
- which acceptance criteria were addressed
- which tests or evidence prove the work
- any deviation request before making out-of-contract changes

Out-of-contract work must be recorded as a change request in `14-change-request-log.md` and approved before implementation continues.

## Required review behavior

The reviewing tool must compare final work against:

- `16-execution-contract.md`
- `01-product-requirement.md`
- `02-development-plan.md`
- `04-test-plan.md`
- `05-test-report.md`
- `07-acceptance-report.md`
- `09-feature-status-board.md`
- `14-change-request-log.md`
- `15-risk-register.md`

The review result must answer:

```text
Did the implementation satisfy the defining tool's recorded task contract?
```

The answer must be `yes`, `no`, or `conditional`, with evidence.

## Same skill, different tools

When different tools use the same Dev Baseline skill, they share the workflow rules, but they do not automatically share hidden context. The repository documents are the synchronization boundary.

Therefore, do not rely on conversation memory across tools. Record the task contract, readiness gates, traceability, decisions, changes, risks, and evidence in the repository before handing off.

## Minimum cross-tool gate

Before a task moves from defining tool to implementing tool:

```text
Task contract complete -> readiness gates complete -> user confirms implementation
```

Before a task moves from implementing tool to reviewing tool:

```text
Implementation notes complete -> self-test evidence recorded -> QA/PM validation recorded -> traceability check passes
```

Before acceptance:

```text
Reviewer confirms contract alignment -> PM accepts or rejects
```
