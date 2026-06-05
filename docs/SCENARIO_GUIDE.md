# Scenario Guide

This guide describes common Dev Baseline workflows.

## Scenario 1: Take over an existing repository

```text
/dev-baseline init
/dev-baseline-quality
/dev-baseline-report
```

Expected result:
- baseline docs created or repaired
- stack detected
- quality gate run
- project report generated

## Scenario 2: Start a new product feature

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

Expected result:
- task workspace created under `docs/tasks/`
- main agent assigned the task to PM first
- main agent only interacts with PM during team delivery
- PM requirement draft created
- minimum agent roster recorded with active/skipped rationale
- Analyst, Architect, Developer, QA Tester, and Coordinator activated only when needed
- specialist outputs recorded with single responsibility and exit condition
- PM readiness review prepared
- user confirmation gate prepared

## Scenario 3: Check if development can start

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

Expected result:
- readiness gates inspected
- missing PM roster, specialist output, test strategy, or user confirmation identified
- skipped-agent rationale checked instead of requiring every role
- next action recommended

## Scenario 4: Implement after confirmation

Use a normal implementation confirmation only after the readiness gates are complete.

```text
开始实现
```

Expected result:
- Developer follows the approved development plan when Developer is active
- feature statuses are updated
- implementation notes and self-test evidence are recorded

## Scenario 5: QA feedback and bugfix loop

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

Expected result:
- QA report is reviewed when QA is active
- bugs move to `bugfixing`
- developer records bugfix log
- QA retests when QA reported the bug

## Scenario 6: Product acceptance

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

Expected result:
- acceptance criteria reviewed
- PM acceptance result recorded
- rejected items return to bugfixing
- accepted items move toward delivery

## Scenario 7: Generate reports

Project report:

```text
/dev-baseline-report
```

Task report:

```bash
bash shared/scripts/generate-task-report.sh docs/tasks/<task-folder>
```

## Scenario 8: Sync Git local and remote

```text
/dev-baseline-git-sync
```

Expected result:
- secret scan runs
- diff is summarized
- local changes are staged and committed when present
- remote branch is fetched and merged
- synchronized branch is pushed only when safe
