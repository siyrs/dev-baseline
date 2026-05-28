# Release Mode

Use release mode for release readiness checks and release notes.

## Trigger examples

- `dev-baseline-release check`
- `dev-baseline 发布准备`
- `发版检查`
- `生成 release notes`

## Inputs

- docs/CHANGELOG.md
- docs/DEPLOY.md
- docs/TESTING.md
- docs/QUALITY_GATE.md
- git diff summary

## Output

- release readiness
- missing items
- validation status
- draft release notes
- recommended next action

## Safety

Do not create tags, releases, or pushes unless explicitly requested as separate Git operations.
