# Release Train Mode

Release Train Mode coordinates multiple accepted tasks into a release candidate.

## Trigger examples

```text
/dev-baseline-release-train create v0.4.0 rc1
创建发版计划
发布列车
```

## Workspace

```text
docs/releases/YYYYMMDD-vX.Y.Z-release-slug/
```

## Purpose

A release workspace records:

- release scope
- included task workspaces
- release blockers
- QA status
- acceptance status
- deployment readiness
- rollback plan
- release notes
