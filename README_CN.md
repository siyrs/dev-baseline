# Dev Baseline

> 面向 Claude Code 和 Codex 的 agent-native 标准开发流程基线。

[English README](./README.md) · [命令地图](./docs/COMMAND_MAP_CN.md) · [场景手册](./docs/SCENARIO_GUIDE.md) · [许可证](./LICENSE)

Dev Baseline 把 AI 辅助开发变成一套可记录、可审查、可验收的团队交付流程。

现在可见 skill 命令保持聚焦：

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

其他能力都通过 `/dev-baseline` 主入口和仓库里的脚本/规则文档来路由，不再额外暴露一堆 `/dev-baseline-xxx`。

---

## 主要命令

| 命令 | 用途 |
|---|---|
| `/dev-baseline` | 通用流程：初始化、评审、规划、质量检查、Git、GitHub/GitLab、迭代、发版、指标、仪表盘 |
| `/dev-baseline-task` | PM / 架构师 / 研发 / QA 标准团队开发任务 |
| `/dev-baseline-report` | 项目和任务报告 |
| `/dev-baseline-git-sync` | 安全的一键 Git 同步：add、commit、fetch、merge、push |

---

## 标准团队开发流程

真实需求从这里开始：

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

流程：

1. 默认开启 Agent Mode，协同 PM、架构师、研发、QA 四个角色。
2. 产品经理写需求草案。
3. 架构师评审架构影响、约束、风险和备选方案。
4. 研发给出具体实现方案。
5. QA 和 PM 制定具体测试案例、通过/失败标准和复测规则。
6. PM 复审需求、架构意见、研发方案和测试计划。
7. AI 汇总准备情况，请用户确认是否开始实现。
8. 用户确认后研发开始实现。
9. 研发自测。
10. QA 测试并写报告。
11. 研发修 Bug。
12. QA 复测。
13. 产品验收或打回。
14. 生成交付总结和报告。

---

## 通过 `/dev-baseline` 执行通用操作

示例：

```text
/dev-baseline 提交并推送
/dev-baseline 检查 GitLab MR 和 Pipeline 状态
/dev-baseline 生成任务仪表盘
/dev-baseline 创建迭代 v0.3.9 sprint-1
/dev-baseline 创建发版计划 v0.4.0 rc1
/dev-baseline 生成项目指标
/dev-baseline 运行质量门禁
```

这些能力不需要单独暴露 skill 命令；Git 一键同步使用下面的专用入口。

---

## Git 一键同步

当你想把本地分支和远程分支一次性同步时使用：

```text
/dev-baseline-git-sync
```

它执行安全流程：

```text
git add -A -> git commit -> git fetch/pull remote -> git merge upstream -> git push
```

遇到疑似密钥文件、未完成 merge/rebase 或 merge 冲突时会停止，不会 force push。

---

## 报告

```text
/dev-baseline-report
/dev-baseline-report docs/tasks/<task-folder>
```

报告默认生成 HTML，更适合阅读和导航。

---

## 安装

Dev Baseline 现在使用 `skill/` 作为同一套标准 skill 包。Codex 和 Claude Code 安装的是同一份内容，只是目标目录不同。

个人安装会用全新的标准包替换现有 `dev-baseline` 目录，并备份旧的独立入口目录，例如 `dev-baseline-git-sync`，避免重装后继续出现重复命令。

`codex/` 和 `claude/` 目录现在只保留轻量适配说明。共享的 skills、agents、hooks、references 和 templates 都放在 `skill/`。

Codex 项目级 overlay 会先使用通用 `skill/agents`，再叠加很小的 `skill/codex-agent-overrides`。

官方安装器目前是 Bash 脚本。如果目标环境不能直接运行 `.sh`，可以让负责安装的 AI 先阅读
`scripts/install-dev-baseline.sh`，再按同样的文件操作逻辑使用本地 shell 执行，或自主生成该平台的等价脚本。
这个脚本刻意保持简单：把 `skill/` 复制到目标 skills 目录，把旧 `dev-baseline` 备份移出可见 skills 根目录，
并从同一份标准包生成项目级 overlay。

也可以直接让助手安装：

```text
我需要你安装这个 skill https://github.com/siyrs/dev-baseline，并检查 /dev-baseline 是否可用。

请把 https://github.com/siyrs/dev-baseline 里的标准 skill 安装到我的个人 Claude skills 目录，名称使用 dev-baseline，并检查 /dev-baseline 是否可用。
```

Codex 个人 skill：

```bash
bash scripts/install-dev-baseline.sh codex
```

Claude Code 个人 skill：

```bash
bash scripts/install-dev-baseline.sh claude
```

同时安装到两个个人目录：

```bash
bash scripts/install-dev-baseline.sh both-personal
```

Codex 项目级 overlay：

```bash
bash scripts/install-dev-baseline.sh codex-project /path/to/project
```

Codex + Claude Code 项目级 overlay：

```bash
bash scripts/install-dev-baseline.sh both-project /path/to/project
```

校验：

```bash
bash scripts/validate-skill.sh
```

---

## 适合谁

- Claude Code 用户
- Codex 用户
- 想要结构化流程的独立开发者
- 需要 PM / 架构师 / 研发 / QA 交付记录的小团队
- 容易上下文丢失、范围漂移的长期项目

---

## License

MIT
