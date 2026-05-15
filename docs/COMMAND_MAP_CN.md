# 命令地图

这份文档说明 Dev Baseline 每个命令适合什么时候使用。

## 命令总览

| 命令 | 用途 | 会改源码吗 | 会写文档吗 |
|---|---|---:|---:|
| `/dev-baseline init` | 接管项目并建立文档基线 | 否 | 是 |
| `/dev-baseline what remains` | 查看剩余任务和待办 | 否 | 否 |
| `/dev-baseline review this project for improvements` | 审查项目结构、文档、测试、部署和优化项 | 否 | 默认否 |
| `/dev-baseline-task create <version> <task>` | 创建标准团队开发任务 | 否 | 是 |
| `/dev-baseline-task-status <workspace>` | 检查准备门禁、功能点状态和任务报告 | 否 | 只写状态/报告 |
| `/dev-baseline-quality` | 执行质量门禁检查 | 否 | 否 |
| `/dev-baseline-report` | 生成项目级 HTML 报告 | 否 | 只写报告 |
| `/dev-baseline-git` | 安全执行 Git 检查、提交、推送 | 否 | Git 操作 |
| `/dev-baseline-release` | 检查发版准备并草拟 release notes | 否 | 可能 |

## 真实功能开发推荐流程

从这里开始：

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

然后按这个流程推进：

1. 产品经理写需求草案。
2. 研发评估可行性、难度、工时和风险。
3. PM/研发无法确定的问题，由 PM 问用户。
4. QA 和 PM 制定测试策略和通过/失败标准。
5. AI 汇总准备情况，请用户确认是否开始实现。
6. 用户确认后研发开始实现。
7. 研发自测。
8. QA 测试并写测试报告。
9. 研发修 Bug。
10. QA 复测。
11. 产品经理验收或打回。
12. 生成交付总结和阶段报告。

## 常用脚本

| 脚本 | 用途 |
|---|---|
| `shared/scripts/create-task-workspace.sh` | 从模板创建任务工作区 |
| `shared/scripts/validate-task-readiness.sh` | 检查任务是否可以开始实现 |
| `shared/scripts/advance-task-status.sh` | 追加功能点状态事件 |
| `shared/scripts/generate-task-report.sh` | 生成单个任务 HTML 报告 |
| `shared/scripts/generate-html-report.sh` | 生成项目级 HTML 报告 |
| `shared/scripts/quality-gate.sh` | 执行项目质量门禁 |
| `shared/scripts/check-secrets.sh` | Git 发布前检查疑似密钥 |
| `shared/scripts/check-doc-sync.sh` | 检查文档是否可能未同步 |
| `shared/scripts/block-dangerous-git.sh` | 阻断危险 Git 命令 |

## 常见场景

### 开始一个新需求

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

### 检查是否可以开始开发

```text
/dev-baseline-task-status docs/tasks/<task-folder>
```

### 生成任务阶段报告

```bash
bash shared/scripts/generate-task-report.sh docs/tasks/<task-folder>
```

### 生成项目报告

```text
/dev-baseline-report
```

### 执行项目自检

```text
/dev-baseline-quality
```

### 安全提交并推送

```text
/dev-baseline-git commit and push
```

### 发版准备

```text
/dev-baseline-release notes
```

## PLAN.md 的职责

`docs/PLAN.md` 现在只作为总进度看板和索引，不再承载所有任务细节。

详细记录放在：

```text
docs/tasks/<task-folder>/
```
