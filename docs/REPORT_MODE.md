# Report Mode

Dev Baseline can generate project reports under `docs/report/`.

## Default report format

HTML is the default because it can provide tabs, cards, grouped sections, and a more readable visual layout.

```text
docs/report/YYYYMMDD-HHMMSS.html
```

## Trigger examples

```text
/dev-baseline 输出项目报告
/dev-baseline generate project report
输出项目报告
生成项目报告
```

## Generation command

```bash
bash shared/scripts/generate-html-report.sh
```

## Report sections

- Overview
- Development Plan
- Architecture
- API
- Config
- Deployment
- Testing
- Changelog
- Git status
- File structure
- Recommendations

## Safety

Report mode is read-oriented. It may create files under `docs/report/`, but it must not modify source code and must not commit or push changes.
