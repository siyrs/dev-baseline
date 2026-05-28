# Report Mode

Report mode generates a project-level report under `docs/report/`.

## Trigger examples

- `dev-baseline 输出项目报告`
- `generate project report`
- `输出项目报告`
- `生成项目报告`

## Default output

Use HTML by default:

```text
docs/report/YYYYMMDD-HHMMSS.html
```

Markdown may be generated only when explicitly requested.

## Recommended command

```bash
bash shared/scripts/generate-html-report.sh
```

## Content rule

The report home page should summarize current project facts and a basic
architecture snapshot. Markdown-backed sections should only be shown when the
source file exists; do not output placeholder content for missing plan,
architecture, API, config, deploy, testing, or changelog docs.

## Safety

Report mode may write report files under `docs/report/`, but must not modify source code and must not commit or push.
