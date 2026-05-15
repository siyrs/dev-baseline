# Dev Baseline

> An agent-native development workflow baseline for Claude Code and Codex.

[中文文档](./README_CN.md) · [Command Map](./docs/COMMAND_MAP.md) · [Scenario Guide](./docs/SCENARIO_GUIDE.md) · [License](./LICENSE)

Dev Baseline turns AI-assisted coding into a documented team delivery workflow. It supports project takeover, product planning, developer implementation, QA testing, bugfix loops, product acceptance, project reports, quality gates, release readiness, and safe Git publishing.

Its goal is not to make the model “remember more.” Its goal is to move project context out of chat history and into structured files, so work remains understandable, reviewable, and maintainable.

---

## Main Entry Points

| Entry | Use it for |
|---|---|
| `/dev-baseline init` | Project takeover and baseline docs |
| `/dev-baseline-task create <version> <task>` | Start a real team delivery task |
| `/dev-baseline-task-status <workspace>` | Check readiness, feature status, and task reports |
| `/dev-baseline-quality` | Run quality gate checks |
| `/dev-baseline-report` | Generate project-level HTML report |
| `/dev-baseline-git` | Safe Git status, commit, and push |
| `/dev-baseline-release` | Release readiness and release notes |

See [Command Map](./docs/COMMAND_MAP.md) for full usage.

---

## Team Delivery Flow

For real feature development, start with:

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

This creates a task workspace:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

The workflow then follows:

1. Product Manager drafts the requirement.
2. Developer reviews feasibility, difficulty, effort, and risks.
3. PM asks the user if PM/Developer cannot resolve unclear points.
4. QA and PM define test strategy and pass/fail rules.
5. The assistant asks the user to confirm implementation.
6. Developer implements after confirmation.
7. Developer self-tests.
8. QA tests and reports.
9. Developer fixes bugs.
10. QA retests.
11. PM accepts or rejects.
12. Delivery summary and task report are generated.

`docs/PLAN.md` acts only as a dashboard and index. Detailed work lives under `docs/tasks/<task-folder>/`.

---

## Reports

Project-level report:

```text
/dev-baseline-report
```

or:

```bash
bash shared/scripts/generate-html-report.sh
```

Task-level report:

```bash
bash shared/scripts/generate-task-report.sh docs/tasks/<task-folder>
```

Reports are HTML by default for better navigation, tabs, cards, and readability.

---

## Quality Gate

```text
/dev-baseline-quality
```

or:

```bash
bash shared/scripts/quality-gate.sh
```

Checks include stack detection, baseline docs, doc sync hints, and secret scanning.

---

## Safe Git

```text
/dev-baseline-git commit and push
```

Git mode runs status/diff checks, secret scanning, and blocks dangerous operations such as force push by default.

---

## Install

Install Claude package:

```bash
bash scripts/install-dev-baseline.sh claude ~/.claude/skills/dev-baseline
```

Install Codex package into a project:

```bash
bash scripts/install-dev-baseline.sh codex /path/to/project
```

Install both into a project:

```bash
bash scripts/install-dev-baseline.sh both /path/to/project
```

Validate package:

```bash
bash scripts/validate-skill.sh
```

---

## Repository Structure

```text
claude/                 Claude skills, agents, hooks, templates
codex/                  Codex AGENTS, skills, agents, hooks, templates
shared/                 shared scripts, references, task templates
docs/                   command map, team flow docs, report docs
github-actions/         optional workflow examples
scripts/                installer and package validation
```

---

## Best For

- Claude Code users
- Codex users
- AI-assisted product development
- solo developers who want structured workflows
- small teams that need PM/Developer/QA style delivery records
- long-running projects where context loss and scope drift are common

---

## License

MIT
