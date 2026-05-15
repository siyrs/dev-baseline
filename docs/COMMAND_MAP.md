# Command Map

This document explains when to use each Dev Baseline command.

## Command Overview

| Command | Purpose | Writes Source Code? | Writes Docs? |
|---|---|---:|---:|
| `/dev-baseline init` | Take over a repository and establish baseline docs | No | Yes |
| `/dev-baseline what remains` | Review backlog and remaining work | No | No |
| `/dev-baseline review this project for improvements` | Review structure, docs, testing, deployment, and improvement candidates | No | No by default |
| `/dev-baseline-task create <version> <task>` | Create a standard team delivery task workspace | No | Yes |
| `/dev-baseline-task-status <workspace>` | Inspect readiness gates, feature status, and task reports | No | Yes, status/report only |
| `/dev-baseline-quality` | Run quality gate checks | No | No |
| `/dev-baseline-report` | Generate a project-level HTML report | No | Yes, report only |
| `/dev-baseline-git` | Safely inspect, commit, and push Git changes | No | Git only |
| `/dev-baseline-release` | Check release readiness and draft release notes | No | Maybe |

## Recommended Flow for a Real Feature

Start with:

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

Then follow:

1. Product Manager drafts the requirement.
2. Developer reviews feasibility, risk, difficulty, and rough effort.
3. Product Manager asks the user when PM/Developer cannot resolve unclear points.
4. QA and PM define test strategy and pass/fail rules.
5. The assistant asks the user to confirm implementation.
6. Developer implements after confirmation.
7. Developer self-tests.
8. QA tests and writes reports.
9. Developer fixes bugs.
10. QA retests.
11. Product Manager accepts or rejects.
12. Delivery summary and stage report are generated.

## Useful Scripts

| Script | Purpose |
|---|---|
| `shared/scripts/create-task-workspace.sh` | Create a task workspace from templates |
| `shared/scripts/validate-task-readiness.sh` | Check whether a task can start implementation |
| `shared/scripts/advance-task-status.sh` | Append feature status events |
| `shared/scripts/generate-task-report.sh` | Generate an HTML report for one task |
| `shared/scripts/generate-html-report.sh` | Generate a project-level HTML report |
| `shared/scripts/quality-gate.sh` | Run project quality gate checks |
| `shared/scripts/check-secrets.sh` | Detect likely secrets before Git publish |
| `shared/scripts/check-doc-sync.sh` | Detect likely missing doc sync |
| `shared/scripts/block-dangerous-git.sh` | Guard against dangerous Git commands |

## Common Scenarios

### Start a new feature

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

### Check whether implementation can start

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

### Generate a task stage report

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

or run:

```bash
bash shared/scripts/generate-task-report.sh docs/tasks/<task-folder>
```

### Generate a project report

```text
/dev-baseline-report
```

or run:

```bash
bash shared/scripts/generate-html-report.sh
```

### Run project quality checks

```text
/dev-baseline-quality
```

or run:

```bash
bash shared/scripts/quality-gate.sh
```

### Commit and push safely

```text
/dev-baseline-git commit and push
```

### Prepare release notes

```text
/dev-baseline-release notes
```

## PLAN.md Role

`docs/PLAN.md` is now a dashboard and index. It should not contain all task details.

Detailed task records belong in:

```text
docs/tasks/<task-folder>/
```
