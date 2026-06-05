# Quality and Release Gates

Dev Baseline uses three separate gates. Keep them separate so project quality, publish safety, and task implementation readiness do not blur into one checklist.

## 1. Project quality gate

Use this before finishing normal project work, documentation updates, template changes, or skill packaging changes.

```bash
bash shared/scripts/quality-gate.sh
```

This gate checks:

- Stack detection can run.
- Baseline documentation structure is valid.
- Shared docs, scripts, references, and templates stay synchronized with the packaged skill mirror.
- Secret scan passes for changed files.
- Documentation sync uses `origin/${BASE_REF:-$GITHUB_BASE_REF}...HEAD` in PR/CI runs and falls back to `git diff --name-only HEAD` for local working-tree checks.

This gate intentionally does not decide whether a Git publish action is safe. Publish safety belongs to `publish-gate.sh`.

## 2. Publish gate

Use this immediately before pushing, setting upstream, creating tags, or preparing a release.

```bash
bash shared/scripts/publish-gate.sh "git push"
```

For a first push that intentionally sets upstream, pass the intended command explicitly:

```bash
bash shared/scripts/publish-gate.sh "git push -u origin <branch>"
```

This gate checks:

- Secret scan passes.
- Dangerous Git command guard passes for the intended publish command.
- Current branch is named and has an upstream, or the intended command explicitly sets one.
- No merge, rebase, or unresolved conflict state is active.
- Diff scope is printed so the publisher can review changed files, staged diff, and unstaged diff before publishing.

Commands such as force push, hard reset, clean, manual tag creation, and release creation are blocked by `git-block-dangerous.sh` unless the workflow is intentionally changed and reviewed.

## 3. Task readiness gate

Use this before implementation starts in a task workspace.

```bash
bash shared/scripts/validate-task-readiness.sh docs/tasks/<task-folder>
```

This gate checks the task workspace, PM-led readiness review, active/skipped agent decisions, QA retest rules, open blockers, and explicit user confirmation.

## Recommended order

- Before implementation: run `validate-task-readiness.sh` for the task workspace.
- Before closing project-quality work: run `quality-gate.sh`.
- Before publishing to a remote or release surface: run `publish-gate.sh` with the intended Git or GitHub command.
