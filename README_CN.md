# Dev Baseline

> 面向 Claude Code 的开发基线，用于文档先行的项目交付。

[English README](./README.md) · [许可证](./LICENSE)

Dev Baseline 是一套面向 Claude Code 工作流的开源开发基线，用于帮助你在新项目启动、旧项目迭代、需求变更和长期维护过程中，建立统一的文档体系、开发节奏与交付纪律。

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

Dev Baseline 的目标，就是把这些高频问题工程化地解决掉。

---

## 这个仓库提供了什么

- 一份**平台无关的核心基线**：`core/BASELINE.md`
- 一套 **Claude Code 适配层**：`claude/`
- 一套推荐的 **项目覆盖配置**：`project-overlay/.claude/`
- 一组可直接复用的**项目模板**

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

## 核心理念

### 先文档，后开发
不要一上来就开始写代码。应该先明确项目结构、当前迭代范围、接口约束、配置说明、部署方式和版本记录。

### 把项目记忆外置
重要信息不应该只存在于聊天上下文中，而应该稳定地存在于 `README.md` 和 `docs/` 中。

### 范围必须显式管理
本次要做什么、本次不做什么、后续什么时候做，必须明确写出来，避免范围失控。

### 文档是交付物的一部分
文档不是“做完再补”的附属品，而是工程交付过程中的一等产物。

### 任何人都应该能快速接手
一个好的项目仓库，应该让后来者在几分钟内理解项目当前状态、边界和下一步方向。

---

### 快捷安装方式

如果 Claude Code 当前可以访问这个仓库，并且有权限写入你本地的 Claude skills 目录，你也可以直接让 Claude 帮你安装这个 skill。

示例：

```text
请把 https://github.com/siyrs/dev-baseline 里的 Claude skill 安装到我的个人 Claude skills 目录，名称使用 dev-baseline，并检查 /dev-baseline 是否可用。
```

## 作为 Claude Code Skill 安装

Claude Code 支持把自定义 skill 放到个人目录或项目目录中。

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

## 如何使用

### 1. 查看还有哪些开发任务

当你想让 Claude 检查 `docs/PLAN.md` 中还剩哪些任务、阻塞项、待确认事项和下版本规划时，使用：

```text
/dev-baseline 看看还有什么开发任务
```

也可以这样说：

```text
/dev-baseline 还有什么开发需求
/dev-baseline 看看待办
```

### 2. 规划一个新需求

当新需求到来时，使用：

```text
/dev-baseline 新增用户登录和角色权限控制
```

这个 skill 应该：

1. 检查仓库中的 README 和 docs 覆盖情况
2. 如果缺少文档，按模板创建
3. 只更新规划相关文档，不直接开始实现
4. 输出编号任务清单
5. 询问你是否开始工作

### 3. 开始真正实现

只有在计划展示完之后，再明确回复：

```text
开始工作
```

或者：

```text
请完成
```

然后 Claude 才按任务顺序开始实现，并保持文档与代码同步更新。

---

## Skill 的工作模式

这个 Claude skill 支持三种模式：

### 模式 A：待办审查模式
用于“还有什么没做”“看看剩余任务”这类问题。

它应当：

- 读取 `docs/PLAN.md`
- 罗列未完成任务（`todo`、`doing`、`blocked`）
- 罗列待确认事项
- 罗列后续版本任务
- 推荐最适合先做的下一项
- 询问是否将其中某项转入当前执行

### 模式 B：规划模式
用于新需求进入时。

它应当：

- 检查 `README.md` 和 docs 覆盖情况
- 缺失则按模板创建
- 已存在则增量更新，不破坏原有历史
- 判断该需求属于当前版本、下个版本还是待确认事项
- 输出编号执行计划
- 在开始实现前征求确认

### 模式 C：执行模式
只有在用户明确确认后才进入。

它应当：

- 按编号任务执行
- 保持文档与代码同步
- 汇报已完成内容、文档更新情况和剩余任务

---

## 默认文档基线

默认情况下，这套基线会要求项目具备以下文档：

- `PLAN.md`：记录当前版本目标、任务拆解、优先级、风险与待确认事项
- `API.md`：记录当前与后续版本接口设计
- `DEPLOY.md`：记录环境要求、构建、启动、发布、回滚步骤
- `CHANGELOG.md`：记录版本历史与用户可感知的变更
- `CONFIG.md`：记录环境变量、运行配置、日志和缓存目录
- `ARCHITECTURE.md`：记录系统边界、模块划分与关键设计决策
- `TESTING.md`：记录测试范围、自测清单与发布前检查项

---

## 推荐工作流

1. 初始化文档基线
2. 明确当前版本目标
3. 划清本次范围与非本次范围
4. 记录风险、依赖与待确认事项
5. 审查或更新 `PLAN.md`
6. 在真正实现前先确认
7. 代码变更时同步更新文档
8. 发布前完成验证
9. 更新变更记录与当前状态

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
