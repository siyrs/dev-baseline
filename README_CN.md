# Dev Baseline

> 面向 Claude Code 和 Codex 的 agent-native 标准开发流程基线。

[English README](./README.md) · [命令地图](./docs/COMMAND_MAP_CN.md) · [场景手册](./docs/SCENARIO_GUIDE.md) · [许可证](./LICENSE)

Dev Baseline 把 AI 辅助开发变成一套可记录、可追踪、可验收的团队交付流程。它支持项目接管、产品规划、研发实现、测试验证、Bug 修复、产品验收、项目报告、质量门禁、发版准备和安全 Git 发布。

它的目标不是让模型“多记一点”，而是把项目上下文从聊天记录中沉淀到结构化文档里，让项目长期可理解、可审查、可维护。

---

## 主要入口

| 入口 | 用途 |
|---|---|
| `/dev-baseline init` | 接管项目并建立文档基线 |
| `/dev-baseline-task create <version> <task>` | 创建标准团队开发任务 |
| `/dev-baseline-task-status <workspace>` | 检查准备门禁、功能点状态和任务报告 |
| `/dev-baseline-quality` | 执行质量门禁 |
| `/dev-baseline-report` | 生成项目级 HTML 报告 |
| `/dev-baseline-git` | 安全执行 Git 检查、提交、推送 |
| `/dev-baseline-release` | 发版准备和 release notes |

完整用法见 [命令地图](./docs/COMMAND_MAP_CN.md)。

---

## 标准团队开发流程

真实需求开发建议从这里开始：

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

它会创建任务工作区：

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

后续流程：

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
12. 生成交付总结和任务报告。

`docs/PLAN.md` 只作为总进度看板和索引。详细记录放在 `docs/tasks/<task-folder>/`。

---

## 报告

项目级报告：

```text
/dev-baseline-report
```

或：

```bash
bash shared/scripts/generate-html-report.sh
```

任务级报告：

```bash
bash shared/scripts/generate-task-report.sh docs/tasks/<task-folder>
```

默认生成 HTML，因为 HTML 更适合标签页、卡片、导航和长报告阅读。

---

## 质量门禁

```text
/dev-baseline-quality
```

或：

```bash
bash shared/scripts/quality-gate.sh
```

会检查技术栈、文档基线、文档同步提示和疑似密钥。

---

## 安全 Git

```text
/dev-baseline-git commit and push
```

Git 模式会检查 status/diff、运行 secret scan，并默认阻止 force push 等危险操作。

---

## 安装

安装 Claude 包：

```bash
bash scripts/install-dev-baseline.sh claude ~/.claude/skills/dev-baseline
```

安装 Codex 包到项目：

```bash
bash scripts/install-dev-baseline.sh codex /path/to/project
```

同时安装两者：

```bash
bash scripts/install-dev-baseline.sh both /path/to/project
```

校验：

```bash
bash scripts/validate-skill.sh
```

---

## 仓库结构

```text
claude/                 Claude skills、agents、hooks、templates
codex/                  Codex AGENTS、skills、agents、hooks、templates
shared/                 共享脚本、规则引用、任务模板
docs/                   命令地图、团队流程、报告说明
github-actions/         可选工作流示例
scripts/                安装器和包校验脚本
```

---

## 适合谁

- Claude Code 用户
- Codex 用户
- AI 辅助产品开发
- 需要结构化流程的独立开发者
- 需要 PM/研发/测试交付记录的小团队
- 容易上下文丢失、范围漂移的长期项目

---

## License

MIT
