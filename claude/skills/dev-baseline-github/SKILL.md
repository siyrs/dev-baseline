---
name: dev-baseline-github
description: Link a Dev Baseline task workspace with GitHub issue, branch, pull request, CI, review, merge, and release status. Use for GitHub integration, PR status, CI status, or 关联 GitHub PR.
disable-model-invocation: true
---

# Dev Baseline GitHub Integration Skill

Use this skill to inspect or document GitHub execution status for a task workspace.

## Trigger examples

- `/dev-baseline-github docs/tasks/<task-folder>`
- `关联 GitHub PR`
- `同步 GitHub 状态`
- `检查 PR 和 CI 状态`

## Recommended command

```bash
bash shared/scripts/task-github-summary.sh <task-workspace>
```

## Writes

May create or update:

```text
docs/tasks/<task-folder>/21-github-integration.md
```

## Must not do

- do not merge PRs
- do not close issues
- do not create releases
- do not push code
- do not bypass Git mode or release mode

## Output

- Issue:
- Branch:
- PR:
- CI:
- Review:
- Merge readiness:
- Next action:
