# GitHub Integration Mode

GitHub Integration Mode links a Dev Baseline task workspace with GitHub execution artifacts.

## Purpose

A task workspace should connect planning and delivery documents with engineering artifacts:

- GitHub issue
- working branch
- pull request
- CI workflow runs
- review status
- merge status
- release or deployment reference

## Task document

Each task may include an optional file generated on demand by the GitHub summary
script:

```text
21-github-integration.md
```

This file is not part of the default task template set, keeping new task
workspaces focused on the core delivery flow.

## Trigger examples

```text
/dev-baseline-github docs/tasks/<task-folder>
关联 GitHub PR
同步 GitHub 状态
检查 PR 和 CI 状态
```

## Recommended command

```bash
bash shared/scripts/task-github-summary.sh docs/tasks/<task-folder>
```

## Safety

GitHub Integration Mode is read-oriented by default. It may update task documentation with issue, branch, PR, and CI links, but it must not merge PRs, close issues, create releases, or push code unless the user explicitly triggers Git or release mode.
