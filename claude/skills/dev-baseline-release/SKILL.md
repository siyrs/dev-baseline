---
name: dev-baseline-release
description: Prepare release readiness checks and release notes. Use when the user asks for release prep, 发布准备, 发版检查, release notes, or pre-release validation.
disable-model-invocation: true
---

# Dev Baseline Release Skill

Use this skill before publishing or releasing a version.

## Trigger examples

- `/dev-baseline-release check`
- `/dev-baseline-release notes`
- `/dev-baseline 发布准备`
- `发版检查`
- `生成 release notes`

## Responsibilities

- inspect docs/CHANGELOG.md
- inspect docs/DEPLOY.md
- inspect docs/TESTING.md
- inspect docs/QUALITY_GATE.md
- summarize completed work
- identify missing validation
- draft release notes

## Must not do

- do not modify source code
- do not create tags unless explicitly requested
- do not create GitHub releases unless explicitly requested
- do not push unless Git mode is separately triggered

## Output format

- Release readiness:
- Missing items:
- Validation status:
- Draft release notes:
- Recommended next action:
