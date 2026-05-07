# Dev Baseline

> 面向 Claude Code 和 Codex 的文档先行开发基线。

[English README](./README.md) · [许可证](./LICENSE)

Dev Baseline 是一套面向 Claude Code 和 Codex 的开源开发流程基线，用于帮助你接管现有项目、建立项目记忆、查看剩余任务、审查项目优化方向、规划新需求，并且只在用户明确确认后才进入真正实现；当用户明确要求时，也可以提交并推送已经完成的仓库变更。

它的目标不是让模型“多记一点”，而是把项目的关键上下文从对话中抽离出来，沉淀为结构化文件，让项目在长周期迭代、多人协作、上下文压缩之后，依然可以稳定推进。

---

## 支持的助手

Dev Baseline 现在提供两套等价工作流包：

- `claude/`：Claude Code skill 包，核心入口是 `claude/SKILL.md`。
- `codex/`：Codex 指令包，核心入口是 `codex/AGENTS.md`。

两套版本遵循相同的工作模式、文档模板、安全边界和 Git 发布规则。

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

## 它解决什么问题

Dev Baseline 主要帮助 AI 编程助手：

- 干净地接管一个项目
- 建立或修复文档基线
- 从 `PLAN.md` 读取当前剩余工作
- 对项目做结构化优化审查
- 把确认的新需求或优化项转化为开发计划
- 避免“还没规划就开始写代码”
- 保持文档与代码同步演进
- 仅在明确触发 Git 发布时提交并推送已完成变更

---

## 安装到 Claude Code

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

### 推荐 Claude 项目叠加配置

将 `project-overlay/.claude/` 中的文件复制到：

```text
project-root/.claude/
```

这样会增加：

- `CLAUDE.md`：项目级长期规则
- `settings.json`：默认先规划再执行

---

## 安装到 Codex

Codex 使用仓库级指令文件，而不是 Claude skill frontmatter。

### 项目安装

将 `codex/AGENTS.md` 复制到目标项目根目录：

```text
project-root/AGENTS.md
```

如果希望 Codex 可以基于本地模板初始化或修复文档基线，再复制 Codex 模板：

```text
project-root/.codex/dev-baseline/templates/
```

目录结果：

```text
project-root/
├─ AGENTS.md
└─ .codex/
   └─ dev-baseline/
      └─ templates/
         ├─ README.md
         └─ docs/
```

最小安装只需要 `AGENTS.md`；完整安装建议同时包含 `codex/templates/`。

---

## 主要命令

Claude 风格命令：

```text
/dev-baseline init
/dev-baseline 看看还有什么开发任务
/dev-baseline 帮我优化下项目
/dev-baseline 新增用户登录
开始工作
/dev-baseline 提交并推送
```

Codex 风格提示：

```text
dev-baseline init
dev-baseline what remains
review this project for improvements
add user login
start
commit and push
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
commit and push
```

触发后，工作流应当：

- 检查 `git status`、diff 摘要、当前分支和 upstream 状态
- 没有变更时停止
- 发现疑似密钥、本地环境文件或本地私有文件时，在 stage 前停止
- 安全检查通过后执行 `git add -A`
- 根据真实 diff 生成简洁 commit message
- 执行 `git commit -m "..."`
- 推送到已配置 upstream；没有 upstream 但存在 `origin` 时，安全设置到 `origin/<current-branch>`

除非用户单独明确要求，否则不得 force push、打 tag 或创建 release。

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
├─ codex/
│  ├─ AGENTS.md
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

## 包自检

发布或复制包前，建议运行：

```bash
bash scripts/validate-skill.sh
```

这个脚本会同时检查 Claude 和 Codex 两套包，包括 Claude skill 入口、Codex `AGENTS.md` 和所有必需模板。

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
- Codex 用户
- 使用 AI 辅助开发的独立开发者
- 小型工程团队
- 长周期迭代项目
- 希望把提示词经验沉淀成工程化流程的人

---

## License

MIT
