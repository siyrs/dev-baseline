---
name: dev-baseline-quality
description: Run project quality gate checks for documentation baseline, doc sync, secret scan, stack detection, and release readiness. Use for /dev-baseline-quality, 质量门禁, 自检, 项目健康检查, or quality gate.
disable-model-invocation: true
---

# Dev Baseline Quality Skill

Use this skill when the user asks for quality checks, self-check, health checks, or release readiness validation.

## Trigger examples

- `/dev-baseline-quality`
- `/dev-baseline-quality check`
- `质量门禁`
- `项目自检`
- `项目健康检查`
- `quality gate`

## Recommended command

```bash
bash shared/scripts/quality-gate.sh
```

## Checks

- stack detection
- baseline docs presence
- documentation sync hints
- secret scan
- quality gate summary

## Must not do

- do not modify source code
- do not commit or push
- do not treat warnings as implementation permission

## Output format

- Quality gate status:
- Passed checks:
- Failed checks:
- Warnings:
- Recommended next action:
