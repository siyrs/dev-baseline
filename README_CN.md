# Dev Baseline

> 面向 Claude Code 的开发基线，用于文档先行的项目交付。

[English README](./README.md) · [许可证](./LICENSE)

Dev Baseline 是一套面向 Claude Code 工作流的开源开发基线，用于帮助你接管现有项目、建立项目记忆、查看剩余任务、审查项目优化方向、规划新需求，并且只在用户明确确认后才进入真正实现；当用户明确要求时，也可以提交并推送已经完成的仓库变更。

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
- 已完成的变更没有被稳定地提交、推送并配上清晰的提交说明

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
- 仅在明确触发 Git 发布时提交并推送已完成变更

---

## 核心工作流

Dev Baseline 围绕六种工作模式展开：

1. `init`：扫描项目并建立文档基线
2. `backlog review`：查看 `PLAN.md` 中未完成任务和后续规划
3. `optimization review`：从结构、代码质量、文档、测试、部署等维度给出优化建议
4. `planning`：把确认的新需求转化为具体任务计划
5. `execution`：只有在用户确认且存在已批准的编号计划后才开始实现
6. `git publish`：只有在用户明确触发时，才执行 `git add`、生成提交说明、commit 和 push

---

## v0.1.1 质量增强

这个版本不改变 skill 的核心定位，主要增强执行边界、模板质量和发布前自检能力。

- 执行模式增加更强的安全规则：如果当前没有已批准的编号计划，`start`、`go ahead`、`继续` 等继续类命令必须回退到规划或待办审查。
- `SKILL.md` 增加 Mode 文件边界矩阵，明确每种模式必须读取、可以写入、禁止写入的内容。
- `PLAN.md` 增加 `Iteration Decision Log`，用于记录范围、优先级和迭代决策。
- `CHANGELOG.md` 增加迁移说明和发布验证清单。
- `DEPLOY.md` 增加运行拓扑和健康检查命令占位。
- `API.md` 增加接口变更记录表。
- `scripts/validate-skill.sh` 用于检查 skill 入口和必需模板是否齐全。

在仓库根目录运行自检：

```bash
bash scripts/validate-skill.sh
```

---

## Git 发布模式

Git 发布模式和普通实现模式是分开的。Dev Baseline 不会在 `init`、审查、规划或执行过程中顺手 commit/push。

只有当你明确要求发布当前仓库变更时才会触发，例如：

```text
/dev-baseline commit and push
/dev-baseline git commit and push
/dev-baseline publish changes
/dev-baseline 提交并推送
/dev-baseline 帮我提交代码并 push
```

触发后，skill 应当：

- 检查 `git status`、diff 摘要、当前分支和 upstream 状态
- 没有变更时停止
- 发现疑似密钥、本地环境文件或本地私有文件时，在 stage 前停止
- 安全检查通过后执行 `git add -A`
- 根据真实 diff 生成简洁 commit message
- 执行 `git commit -m "..."`
- 推送到已配置 upstream；没有 upstream 但存在 `origin` 时，安全设置到 `origin/<current-branch>`

除非用户单独明确要求，否则不得 force push、打 tag 或创建 release。

---

## 主要命令

```text
/dev-baseline init
/dev-baseline 看看还有什么开发任务
/dev-baseline 帮我优化下项目
/dev-baseline 新增用户登录
开始工作
/dev-baseline 提交并推送
```

也支持英文：

```text
/dev-baseline what remains
/dev-baseline review this project for improvements
/dev-baseline add payment module
start
/dev-baseline commit and push
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

这个模式应当扫描项目、识别技术栈和运行线索、生成或补全 `CLAUDE.md`、创建缺失的 docs 基础骨架，并输出项目摘要和建议下一步。它不会直接开始实现，不会默认写详细任务拆解，也不会提交或推送。

### Mode A：待办审查模式

使用：

```text
/dev-baseline 看看还有什么开发任务
```

这个模式应当读取 `docs/PLAN.md`，展示未完成任务、进行中与阻塞项、待确认事项、下一迭代候选项与未来版本规划。这个模式用于“看现状”，不是“开始实现”。

### Mode B：优化审查模式

使用：

```text
/dev-baseline 帮我优化下项目
```

这个模式会从项目结构、功能组织、代码质量、文档基线、测试与验证、部署与可运维性等维度给出改进建议。它会先输出优化候选项，再等你决定哪些应进入下一轮开发。

### Mode C：规划模式

使用：

```text
/dev-baseline 新增支付模块
```

这个模式应当检查 docs 覆盖情况，缺失则补齐，更新规划相关文档，判断该需求属于当前迭代、下一轮迭代还是待确认事项，输出编号任务清单，并询问是否开始实现。

### Mode D：执行模式

只有在计划已展示之后，再明确回复：

```text
开始工作
```

或者：

```text
请完成
```

这样 Claude 才会确认存在已批准的编号计划、按任务顺序开始实现、保持文档与代码同步、将完成项移入 `PLAN.md` 的已完成区并写入完成时间。它不会自动 commit/push，除非你单独触发 Git 发布模式。

### Mode E：Git 发布模式

只有在明确 Git 发布请求后触发，例如：

```text
/dev-baseline 提交并推送
/dev-baseline commit and push
```

这个模式会检查仓库变更、stage 安全文件、生成提交说明、commit 并 push。默认拒绝空提交、疑似密钥文件、force push、tag 和 release。

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
├─ scripts/
│  └─ validate-skill.sh
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
迭代驾驶舱。负责当前活跃工作、已完成事项、待确认项、下一迭代候选项、未来版本规划和迭代决策记录。

### `docs/CHANGELOG.md`
面向发布的版本变更历史。说明每个版本改了什么、迁移说明、验证状态以及有没有运维影响。

### `docs/DEPLOY.md`
运行手册。说明如何构建、配置、启动、验证、排障、回滚和健康检查。

### `docs/API.md`
接口事实来源和接口变更记录。

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

### 场景 5：发布已完成变更

```text
/dev-baseline 提交并推送
```

---

## 包自检

发布或复制 skill 前，建议运行：

```bash
bash scripts/validate-skill.sh
```

这个脚本会检查 Claude skill 入口文件、所有必需模板是否存在，并检查 skill frontmatter 是否包含必需字段。

---

## 最佳实践

- 第一次进入仓库先跑 `init`
- 想知道下一步做什么，先看 backlog review
- 做大清理、大重构前先跑 optimize review
- 让 `PLAN.md` 成为当前和下一轮工作的事实源
- 在计划可见且已确认之前，不直接开始实现
- 想提交并推送时，明确触发 Git 发布模式
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
