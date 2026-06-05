# Command Map

Dev Baseline keeps the visible command surface focused.

The same command map is shipped in the standard `skill/` package for both Codex and Claude Code.

## Primary Commands

| Command | Purpose |
|---|---|
| `/dev-baseline` | General workflow entrypoint: init, review, planning, quality, Git, GitHub/GitLab, sprint, release, metrics, dashboard |
| `/dev-baseline-task` | PM-led dynamic team delivery workflow: minimal single-responsibility agents, readiness gates, bugfix, acceptance, delivery |
| `/dev-baseline-report` | Project or task reports, especially HTML reports |
| `/dev-baseline-git-sync` | Safe one-step Git sync: add, commit, fetch, merge, push |

## Recommended Usage

### Start or manage a project

```text
/dev-baseline init
/dev-baseline what remains
/dev-baseline review this project for improvements
```

### Start a real team delivery task

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

### Check task status

```text
/dev-baseline-task docs/tasks/<task-folder> 检查状态
```

### Generate reports

```text
/dev-baseline-report
/dev-baseline-report docs/tasks/<task-folder>
```

### Sync Git local and remote

```text
/dev-baseline-git-sync
```

### Git, GitHub, GitLab, sprint, release, metrics, dashboard

Use the main command with natural language:

```text
/dev-baseline 提交并推送
/dev-baseline 检查 GitLab MR 和 Pipeline 状态
/dev-baseline 生成任务仪表盘
/dev-baseline 创建迭代 v0.3.9 sprint-1
/dev-baseline 创建发版计划 v0.4.0 rc1
/dev-baseline 生成项目指标
/dev-baseline 运行质量门禁
```

These do not need separate visible skill commands. Use `/dev-baseline-git-sync` only for the full add/commit/fetch/merge/push shortcut.

## Useful Scripts

| Script | Purpose |
|---|---|
| `shared/scripts/create-task-workspace.sh` | Create a task workspace from templates |
| `shared/scripts/git-sync.sh` | Safely add, commit, fetch, merge, and push |
| `shared/scripts/validate-task-readiness.sh` | Check whether a task can start implementation |
| `shared/scripts/advance-task-status.sh` | Append feature status events |
| `shared/scripts/generate-task-report.sh` | Generate an HTML report for one task |
| `shared/scripts/generate-html-report.sh` | Generate a project-level HTML report |
| `shared/scripts/generate-task-dashboard.sh` | Generate a task dashboard |
| `shared/scripts/quality-gate.sh` | Run project quality gate checks |
| `shared/scripts/check-secrets.sh` | Detect likely secrets before Git publish |
| `shared/scripts/check-doc-sync.sh` | Detect likely missing doc sync |

## PLAN.md Role

`docs/PLAN.md` is a dashboard and index. It should not contain all task details.

Detailed task records belong in:

```text
docs/tasks/<task-folder>/
```
