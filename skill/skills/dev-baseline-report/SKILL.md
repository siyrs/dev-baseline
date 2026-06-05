---
name: dev-baseline-report
description: Generate a project report for the current repository. Use for /dev-baseline-report, 输出项目报告, generate project report, or summarize the whole project into docs/report. Default to a timestamped HTML report with tabs under docs/report.
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

1. Inspect project facts:
   - project name
   - detected stack/package signals
   - top-level directory structure
   - basic architecture snapshot from docs or repository structure
2. Inspect existing project docs only when present:
   - README.md
   - docs/PLAN.md
   - docs/API.md
   - docs/CONFIG.md
   - docs/DEPLOY.md
   - docs/CHANGELOG.md
   - docs/ARCHITECTURE.md
   - docs/TESTING.md
3. Inspect git state:
   - current branch
   - git status summary
   - diff stat
4. Generate a self-contained HTML report with tabs or clear sections.
5. Do not render placeholder sections for missing Markdown files.
6. Do not modify source code.
7. Do not commit or push unless Git publish mode is separately triggered.

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
