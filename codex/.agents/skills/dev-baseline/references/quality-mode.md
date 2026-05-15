# Quality Mode

Use quality mode for project self-checks and quality gates.

## Trigger examples

- `dev-baseline-quality`
- `quality gate`
- `项目自检`
- `项目健康检查`
- `质量门禁`

## Recommended command

```bash
bash shared/scripts/quality-gate.sh
```

## Checks

- stack detection
- baseline docs presence
- doc sync hints
- secret scan
- quality gate summary

## Safety

Quality mode is read/check oriented. It must not modify source code, commit, or push.
