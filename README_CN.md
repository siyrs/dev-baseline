# Dev Baseline

> 面向 Claude Code 和 Codex 的 agent-native 标准开发流程基线。

[English README](./README.md) · [命令地图](./docs/COMMAND_MAP_CN.md) · [场景手册](./docs/SCENARIO_GUIDE.md) · [许可证](./LICENSE)

Dev Baseline 把 AI 辅助开发变成一套可记录、可审查、可验收的团队交付流程。

现在可见 skill 命令刻意精简为：

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
```

其他能力都通过 `/dev-baseline` 主入口和仓库里的脚本/规则文档来路由，不再额外暴露一堆 `/dev-baseline-xxx`。

---

## 主要命令

| 命令 | 用途 |
|---|---|
| `/dev-baseline` | 通用流程：初始化、评审、规划、质量检查、Git、GitHub/GitLab、迭代、发版、指标、仪表盘 |
| `/dev-baseline-task` | PM / 研发 / QA 标准团队开发任务 |
| `/dev-baseline-report` | 项目和任务报告 |

---

## 标准团队开发流程

真实需求从这里开始：

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

流程：

1. 产品经理写需求草案。
2. 研发评估可行性、难度、工时和风险。
3. PM/研发无法确定的问题，由 PM 问用户。
4. QA 和 PM 制定测试范围和通过/失败标准。
5. AI 汇总准备情况，请用户确认是否开始实现。
6. 用户确认后研发开始实现。
7. 研发自测。
8. QA 测试并写报告。
9. 研发修 Bug。
10. QA 复测。
11. 产品验收或打回。
12. 生成交付总结和报告。

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

这些能力不需要单独暴露 skill 命令。

---

## 报告

```text
/dev-baseline-report
/dev-baseline-report docs/tasks/<task-folder>
```

报告默认生成 HTML，更适合阅读和导航。

---

## 安装

Claude：

```bash
bash scripts/install-dev-baseline.sh claude ~/.claude/skills/dev-baseline
```

Codex：

```bash
bash scripts/install-dev-baseline.sh codex /path/to/project
```

同时安装：

```bash
bash scripts/install-dev-baseline.sh both /path/to/project
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
- 需要 PM / 研发 / QA 交付记录的小团队
- 容易上下文丢失、范围漂移的长期项目

---

## License

MIT
