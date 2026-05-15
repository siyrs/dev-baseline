---
name: dev-baseline-report
description: Generate a project report for the current repository. Use when the user asks to 输出项目报告, generate project report, or summarize the whole project into docs/report. Default to an HTML report with tabs under docs/report/<timestamp>.html.
disable-model-invocation: true
---

# Dev Baseline Report Skill

Use this skill when the user asks for a project report.

## Trigger examples

- `/dev-baseline 输出项目报告`
- `/dev-baseline generate project report`
- `输出项目报告`
- `生成项目报告`

## Output format

Default to HTML:

```text
docs/report/YYYYMMDD-HHMMSS.html
```

Only generate Markdown when the user explicitly asks for Markdown.

## Required behavior

1. Inspect project docs:
   - README.md
   - docs/PLAN.md
   - docs/API.md
   - docs/CONFIG.md
   - docs/DEPLOY.md
   - docs/CHANGELOG.md
   - docs/ARCHITECTURE.md
   - docs/TESTING.md
2. Inspect git state:
   - current branch
   - git status summary
   - diff stat
3. Generate a self-contained HTML report with tabs or clear sections.
4. Do not modify source code.
5. Do not commit or push unless Git publish mode is separately triggered.

## Recommended command

```bash
bash shared/scripts/generate-html-report.sh
```

## Final response

Report:
- path:
- sections included:
- missing docs:
- suggested next action:
