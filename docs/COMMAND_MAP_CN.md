# 命令地图

Dev Baseline 现在刻意精简可见命令，避免 `/dev-baseline-xxx` 过多造成干扰。

Codex 和 Claude Code 都使用 `skill/` 标准包里的同一套命令地图。

## 主要命令

| 命令 | 用途 |
|---|---|
| `/dev-baseline` | 通用入口：初始化、评审、规划、质量检查、Git、GitHub/GitLab、迭代、发版、指标、仪表盘 |
| `/dev-baseline-task` | PM 主导的动态团队流程：最少单一职责 agent、准备门禁、Bug 修复、验收、交付 |
| `/dev-baseline-report` | 项目或任务报告，尤其是 HTML 报告 |
| `/dev-baseline-git-sync` | 安全的一键 Git 同步：add、commit、fetch、merge、push |

## 推荐用法

### 项目管理

```text
/dev-baseline init
/dev-baseline what remains
/dev-baseline review this project for improvements
```

### 开始真实团队开发任务

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

### 检查任务状态

```text
/dev-baseline-task docs/tasks/<task-folder> 检查状态
```

### 生成报告

```text
/dev-baseline-report
/dev-baseline-report docs/tasks/<task-folder>
```

### 同步 Git 本地和远程

```text
/dev-baseline-git-sync
```

### Git、GitHub、GitLab、迭代、发版、指标、仪表盘

统一用 `/dev-baseline` 加自然语言即可：

```text
/dev-baseline 提交并推送
/dev-baseline 检查 GitLab MR 和 Pipeline 状态
/dev-baseline 生成任务仪表盘
/dev-baseline 创建迭代 v0.3.9 sprint-1
/dev-baseline 创建发版计划 v0.4.0 rc1
/dev-baseline 生成项目指标
/dev-baseline 运行质量门禁
```

这些不需要单独暴露一个 skill 命令。完整 add/commit/fetch/merge/push 同步使用 `/dev-baseline-git-sync`。

## 常用脚本

| 脚本 | 用途 |
|---|---|
| `shared/scripts/create-task-workspace.sh` | 创建任务工作区 |
| `shared/scripts/validate-task-readiness.sh` | 检查任务是否可以开始实现 |
| `shared/scripts/validate-task-traceability.sh` | 检查 FP、AC、TC、证据和验收链路 |
| `shared/scripts/advance-task-status.sh` | 追加功能点状态事件 |
| `shared/scripts/generate-task-report.sh` | 生成单任务 HTML 报告 |
| `shared/scripts/generate-html-report.sh` | 生成项目 HTML 报告 |
| `shared/scripts/generate-task-dashboard.sh` | 生成任务仪表盘 |
| `shared/scripts/quality-gate.sh` | 执行项目质量门禁 |
| `shared/scripts/publish-gate.sh` | 执行发布前检查：密钥、Git 命令安全、分支/upstream、diff 范围 |
| `shared/scripts/git-sync.sh` | 安全执行 add、commit、fetch、merge、push |
| `shared/scripts/check-secrets.sh` | Git 发布前检查疑似密钥 |
| `shared/scripts/check-doc-sync.sh` | 检查文档同步风险 |
| `scripts/validate-command-surface.sh` | 校验允许暴露的命令面 |
| `scripts/validate-script-preambles.sh` | 校验脚本 shebang、Bash 语法和路径解析器 |

## PLAN.md 职责

`docs/PLAN.md` 只作为总进度看板和索引。

详细记录放在：

```text
docs/tasks/<task-folder>/
```
