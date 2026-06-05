# Report Mode

Report mode generates a project-level report under `docs/report/`.

## Trigger examples

- `/dev-baseline 输出项目报告`
- `/dev-baseline generate project report`
- `输出项目报告`
- `生成项目报告`

## Default output

Use HTML by default:

```text
docs/report/YYYYMMDD-HHMMSS.html
```

Markdown may be generated only when the user explicitly asks for Markdown.

## Why HTML by default

HTML can present large project reports with tabs, cards, visual grouping, and compact navigation. This makes long project summaries easier to scan than a single long Markdown page.

## Required sections

- project overview
- basic project information
- basic architecture snapshot
- git state
- file structure
- risks and next actions

Only include Markdown-backed sections when the corresponding file exists. For
example, do not render empty tabs for `docs/PLAN.md`, `docs/ARCHITECTURE.md`,
or next-plan/current-plan content when those files do not exist.

## Safety

Report mode is read-oriented. It may create report output files under `docs/report/`, but must not modify source code or publish git changes.
