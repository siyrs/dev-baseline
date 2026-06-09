# Quality and Release Gates

Dev Baseline keeps project quality, publish safety, task readiness, and traceability as separate gates.

## 1. Project quality gate

```bash
bash shared/scripts/quality-gate.sh
```

Checks stack detection, baseline docs, mirror sync, sensitive-file scan, and documentation sync.

## 2. Publish gate

```bash
bash shared/scripts/publish-gate.sh "git push"
```

Checks sensitive files, intended Git command safety, branch/upstream state, conflict state, and diff scope before publishing.

## 3. Task readiness gate

```bash
bash shared/scripts/validate-task-readiness.sh docs/tasks/<task-folder>
```

Checks the task workspace, PM-led readiness review, active/skipped agent decisions, QA retest rules, open blockers, traceability, and explicit user confirmation.

## 4. Task traceability gate

```bash
bash shared/scripts/validate-task-traceability.sh docs/tasks/<task-folder>
```

Checks FP, AC, test coverage, acceptance report coverage, contract deltas, and risks.

## 5. Packaging and command-surface gates

```bash
bash scripts/validate-command-surface.sh
bash scripts/validate-script-preambles.sh
bash scripts/validate-skill.sh
```

Checks visible command policy, script syntax, resolver integrity, manifest assets, and packaged mirror sync.

## Recommended order

1. Before implementation: task readiness gate.
2. Before cross-tool review or acceptance: task traceability gate.
3. Before closing project-quality work: project quality gate.
4. Before publishing: publish gate with the intended command.
