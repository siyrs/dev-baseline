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
- PM requirement draft created
- Developer feasibility review requested
- QA test strategy requested
- user confirmation gate prepared

## Scenario 3: Check if development can start

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

Expected result:
- readiness gates inspected
- missing PM/Developer/QA preparation identified
- next action recommended

## Scenario 4: Implement after confirmation

Use a normal implementation confirmation only after the readiness gates are complete.

```text
开始实现
```

Expected result:
- Developer follows the approved development plan
- feature statuses are updated
- implementation notes and self-test evidence are recorded

## Scenario 5: QA feedback and bugfix loop

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

Expected result:
- QA report is reviewed
- bugs move to `bugfixing`
- developer records bugfix log
- QA retests

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

## Scenario 8: Publish completed work

```text
/dev-baseline-git commit and push
```

Expected result:
- secret scan runs
- diff is summarized
- commit message is generated
- push is performed only when safe
