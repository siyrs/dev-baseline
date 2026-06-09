# Model Handoff Consistency

This document defines how Dev Baseline keeps task intent consistent when different model tools participate in one delivery flow.

Typical cross-tool chain:

```text
Tool 1 / Codex defines the task -> Tool 2 / Claude Code implements and validates -> Tool 1 / Codex reviews the result
```

Using the same Dev Baseline skill gives all tools the same workflow language, templates, and gates. It does not automatically share hidden conversation context. The repository task workspace is the synchronization boundary.

## Core principle: living contract

The task contract is allowed to evolve during implementation.

Do not treat the initial plan as an immutable command. Treat silent drift as invalid.

An implementing tool may adjust implementation details, technical approach, tests, or even the effective acceptance contract when real delivery constraints require it. The responsibility is to keep the user goal, final acceptance standard, and evidence trail reviewable.

## Shared source of truth

For cross-tool work, the task workspace is the source of truth:

```text
docs/tasks/<task-folder>/
```

The minimum shared target is:

- requirement scope and out-of-scope notes
- function points
- acceptance criteria and pass rules
- architecture constraints or no-impact rationale
- test strategy or PM-owned checklist
- contract deltas when the target changes
- evidence for the final accepted behavior

`16-execution-contract.md` may summarize the latest effective contract when a handoff needs extra clarity, but it is a summary artifact, not a hard lock.

## What may change freely

The implementing tool may decide tactical details without extra process when they do not change the effective acceptance target:

- internal implementation approach
- local refactoring
- file-internal structure
- equivalent test command or test data adjustment
- implementation order
- wording that does not change scope or acceptance

These changes can be recorded in implementation notes when useful, but they do not need a change request.

## What must be recorded as a contract delta

Any change that affects the final review target must be recorded before acceptance:

- function point added, removed, split, or merged
- acceptance criteria or pass rule changed
- out-of-scope work pulled into scope
- architecture, API, data, config, deploy, migration, security, performance, or compatibility impact changed
- test scope reduced or evidence expectation changed
- delivery risk changes materially

Record these in `14-change-request-log.md` as a contract delta. Approval may be explicit, deferred to PM acceptance, or documented as implementer-applied when delivery constraints required immediate action. The key rule is that the change must not be silent.

## Review rule

The reviewing tool validates the result against the latest effective contract:

```text
initial task contract
+ recorded contract deltas
+ final acceptance report
+ test and evidence records
= latest effective contract
```

The final review should answer:

```text
Does the delivered work satisfy the latest effective contract, and are any target changes visible and justified?
```

Valid review results are `yes`, `no`, or `conditional` with evidence.

## Minimal cross-tool flow

```text
Defining tool records initial intent, FP, AC, and major constraints.
Implementing tool can adapt, but records contract deltas when FP/AC/scope/risk/evidence changes.
Reviewing tool checks the latest effective contract and evidence, not hidden conversation memory.
```

This keeps rules lightweight while preserving target consistency across tools.
