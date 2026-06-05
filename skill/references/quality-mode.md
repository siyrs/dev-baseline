# Quality Mode Reference

Quality mode keeps three gates distinct instead of treating every safety check as one generic checklist.

## Project quality gate

Run when the user asks for a project quality pass, documentation/package validation, or repository hygiene checks.

```bash
bash shared/scripts/quality-gate.sh
```

Expected coverage:

- stack detection
- baseline docs validation
- shared/package mirror sync
- PR-aware documentation sync via `BASE_REF` or `GITHUB_BASE_REF`, with local `HEAD` fallback
- changed-file secret scan

Do not use this gate as a substitute for publish safety. It does not evaluate the intended Git command, branch/upstream state, or publish diff scope.

## Publish gate

Run before a push, upstream-setting push, tag, release, or other publish action.

```bash
bash shared/scripts/publish-gate.sh "git push"
```

If the branch has no upstream yet, pass the actual intended upstream-setting command:

```bash
bash shared/scripts/publish-gate.sh "git push -u origin <branch>"
```

Expected coverage:

- secret scan
- dangerous Git command guard for the intended command
- named branch and upstream readiness
- merge/rebase/conflict safety
- diff scope summary for publisher review

## Task readiness gate

Run before implementation starts in a PM-led task workspace.

```bash
bash shared/scripts/validate-task-readiness.sh docs/tasks/<task-folder>
```

Expected coverage:

- required task workspace documents
- readiness gate result enums
- active agent readiness
- skipped agent rationale
- QA retest rule when QA is active
- explicit user confirmation
