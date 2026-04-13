# Dev Baseline

> 面向 Claude Code 的开发基线，用于文档先行的项目交付。

[English README](./README.md) · [许可证](./LICENSE)

Dev Baseline 是一套面向 Claude Code 工作流的开源开发基线，用于帮助你接管现有项目、建立项目记忆、查看剩余任务、审查项目优化方向、规划新需求，并且只在用户明确确认后才进入真正实现。

它的目标不是让模型“多记一点”，而是把项目的关键上下文从对话中抽离出来，沉淀为结构化文件，让项目在长周期迭代、多人协作、上下文压缩之后，依然可以稳定推进。

---

## 为什么要做这个仓库

在很多 AI 辅助开发场景里，真正的问题往往不是模型不会写代码，而是：

- 需求没有在开发前被拆解清楚
- 当前版本和后续版本混在一起
- 接口已经变了，但文档没有同步
- 部署方式已经调整，却没人记录
- 对话一长，前置约束和背景信息开始丢失
- 后来接手的人很难快速理解项目现状
- 项目优化建议没有被结构化地转入下一轮开发计划

Dev Baseline 的目标，就是把这些高频问题工程化地解决掉。

---

## 它解决什么问题

Dev Baseline 主要帮助 Claude Code：

- 干净地接管一个项目
- 建立或修复文档基线
- 从 `PLAN.md` 读取当前剩余工作
- 对项目做结构化优化审查
- 把确认的新需求或优化项转化为开发计划
- 避免“还没规划就开始写代码”
- 保持文档与代码同步演进

---

## 核心工作流

Dev Baseline 围绕五种工作模式展开：

1. `init`：扫描项目并建立文档基线
2. `backlog review`：查看 `PLAN.md` 中未完成任务和后续规划
3. `optimization review`：从结构、代码质量、文档、测试、部署等维度给出优化建议
4. `planning`：把确认的新需求转化为具体任务计划
5. `execution`：只有在用户确认后才开始实现

---

## 主要命令

```text
/dev-baseline init
/dev-baseline 看看还有什么开发任务
/dev-baseline 帮我优化下项目
/dev-baseline 新增用户登录
开始工作
```

也支持英文：

```text
/dev-baseline what remains
/dev-baseline review this project for improvements
/dev-baseline add payment module
start
```

---

## 作为 Claude Code Skill 安装

Claude Code 支持把自定义 skill 放到个人目录或项目目录中。

### 快捷安装方式

如果 Claude Code 当前可以访问这个仓库，并且有权限写入你本地的 Claude skills 目录，你也可以直接让 Claude 帮你安装这个 skill。

示例：

```text
请把 https://github.com/siyrs/dev-baseline 里的 Claude skill 安装到我的个人 Claude skills 目录，名称使用 dev-baseline，并检查 /dev-baseline 是否可用。
```

这种方式在 Claude 能访问仓库和本地文件系统时通常更省事。稳定兜底方式仍然是下面的手动安装。

### 个人安装

将仓库中的 `claude/` 目录内容复制到：

```text
~/.claude/skills/dev-baseline/
```

目录结果应为：

```text
~/.claude/skills/dev-baseline/
├─ SKILL.md
└─ templates/
```

在 Windows 上，通常对应：

```text
C:\Users\<你的用户名>\.claude\skills\dev-baseline\
```

### 项目安装

也可以复制到当前项目目录：

```text
project-root/.claude/skills/dev-baseline/
```

### 推荐叠加配置

将 `project-overlay/.claude/` 中的文件复制到：

```text
project-root/.claude/
```

这样会增加：

- `CLAUDE.md`：项目级长期规则
- `settings.json`：默认先规划再执行

---

## 它是怎么工作的

### Mode 0：Init 模式

使用：

```text
/dev-baseline init
```

这个模式应当：

- 扫描项目结构和技术栈
- 尽量识别包管理器、启动方式、测试路径、配置文件和部署线索
- 生成或补全 `CLAUDE.md`
- 创建缺失的 docs 基础骨架
- 按需更新 `README.md` 的项目概览与索引
- 输出项目摘要和建议下一步

这个模式 **不会直接开始实现**，也 **不会默认写详细任务拆解**。

### Mode A：待办审查模式

使用：

```text
/dev-baseline 看看还有什么开发任务
```

这个模式应当：

- 读取 `docs/PLAN.md`
- 展示未完成任务
- 展示进行中与阻塞项
- 展示待确认事项
- 展示下一迭代候选项与未来版本规划
- 推荐最适合优先推进的下一项

这个模式用于“看现状”，不是“开始实现”。

### Mode B：优化审查模式

使用：

```text
/dev-baseline 帮我优化下项目
```

这个模式会从以下维度给出改进建议：

- 项目结构
- 功能组织
- 代码质量
- 文档基线
- 测试与验证
- 部署与可运维性

它会先输出优化候选项，再等你决定哪些应进入下一轮开发。

### Mode C：规划模式

使用：

```text
/dev-baseline 新增支付模块
```

这个模式应当：

- 检查 docs 覆盖情况
- 缺失则补齐
- 更新规划相关文档
- 判断该需求属于当前迭代、下一轮迭代还是待确认事项
- 输出编号任务清单
- 询问是否开始实现

### Mode D：执行模式

只有在计划已展示之后，再明确回复：

```text
开始工作
```

或者：

```text
请完成
```

这样 Claude 才会：

- 按任务顺序开始实现
- 保持文档与代码同步
- 将完成项移入 `PLAN.md` 的已完成区
- 写入完成时间
- 汇报已完成内容、文档更新情况和剩余任务

---

## 仓库结构

```text
dev-baseline/
├─ README.md
├─ README_CN.md
├─ LICENSE
├─ .gitignore
├─ core/
│  └─ BASELINE.md
├─ claude/
│  ├─ SKILL.md
│  └─ templates/
│     ├─ README.md
│     └─ docs/
│        ├─ PLAN.md
│        ├─ API.md
│        ├─ DEPLOY.md
│        ├─ CHANGELOG.md
│        ├─ CONFIG.md
│        ├─ ARCHITECTURE.md
│        └─ TESTING.md
├─ project-overlay/
│  └─ .claude/
│     ├─ CLAUDE.md
│     └─ settings.json
└─ examples/
   └─ demo-project-structure.md
```

---

## 文档职责

### `README.md`
项目入口页。说明它是什么、如何安装、如何使用、工作流怎么跑。

### `claude/SKILL.md`
工作流调度器。决定进入哪种模式，以及 Claude 在每种模式下该做什么。

### `project-overlay/.claude/CLAUDE.md`
项目级长期规则。告诉 Claude 在这个仓库里长期应该怎么工作。

### `docs/PLAN.md`
迭代驾驶舱。负责当前活跃工作、已完成事项、待确认项、下一迭代候选项和未来版本规划。

### `docs/CHANGELOG.md`
面向发布的版本变更历史。说明每个版本改了什么，有没有运维影响。

### `docs/DEPLOY.md`
运行手册。说明如何构建、配置、启动、验证、排障和回滚。

### `docs/API.md`
接口事实来源。

### `docs/CONFIG.md`
配置与环境事实来源。

### `docs/ARCHITECTURE.md`
系统边界与关键设计决策来源。

### `docs/TESTING.md`
验证、自测与发布前检查来源。

---

## 推荐使用流

### 场景 1：接手一个旧项目

```text
/dev-baseline init
/dev-baseline 帮我优化下项目
```

### 场景 2：查看当前还剩什么

```text
/dev-baseline 看看还有什么开发任务
```

### 场景 3：开始一个新需求

```text
/dev-baseline 新增支付模块
开始工作
```

### 场景 4：把已确认的优化项转入下一迭代

```text
/dev-baseline 帮我优化下项目
把第 1、3、5 项加入下一轮开发
开始工作
```

---

## 最佳实践

- 第一次进入仓库先跑 `init`
- 想知道下一步做什么，先看 backlog review
- 做大清理、大重构前先跑 optimize review
- 让 `PLAN.md` 成为当前和下一轮工作的事实源
- 在计划可见且已确认之前，不直接开始实现
- 把面向交付的变化写进 `CHANGELOG.md`
- 把运行与部署事实写进 `DEPLOY.md`

---

## 适合谁使用

这套基线特别适合：

- Claude Code 用户
- 使用 AI 辅助开发的独立开发者
- 小型工程团队
- 长周期迭代项目
- 希望把提示词经验沉淀成工程化流程的人

---

## License

MIT
