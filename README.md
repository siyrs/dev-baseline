# Dev Baseline

> Agent-native standard development workflow baseline for Claude Code and Codex.

[中文文档](./README_CN.md) · [Command Map](./docs/COMMAND_MAP.md) · [Scenario Guide](./docs/SCENARIO_GUIDE.md) · [License](./LICENSE)

Dev Baseline turns AI-assisted coding into a documented, reviewable, PM-led delivery workflow.

Visible skill commands:

```text
/dev-baseline
/dev-baseline-task
/dev-baseline-report
/dev-baseline-git-sync
```

## Main Commands

| Command | Use it for |
|---|---|
| `/dev-baseline` | General routing: init, review, planning, quality, Git, providers, sprint, release, metrics, dashboard |
| `/dev-baseline-task` | PM-led team delivery with compact task records and minimal agents |
| `/dev-baseline-report` | Project and task reports |
| `/dev-baseline-git-sync` | Safe one-step local/remote synchronization |

## Skill Flow Diagrams

### `/dev-baseline`: general router

```mermaid
flowchart TD
  A[User request] --> B{Intent}
  B --> C[Init / review / planning]
  B --> D[Quality / provider / sprint / release / metrics / dashboard]
  B --> E[Git publish intent]
  C --> F[Read repo and docs]
  D --> G[Use shared scripts and references]
  E --> H[Run publish gate]
  F --> I[Report next action]
  G --> I
  H --> I
```

### `/dev-baseline-task`: PM-led team delivery

```mermaid
flowchart TD
  A[Create compact task workspace] --> B[PM drafts contract: scope, FP, AC]
  B --> C[PM chooses minimal agent roster]
  C --> D{Need specialists?}
  D -->|yes| E[PM issues scoped handoff packets]
  D -->|no| F[PM records skip rationale]
  E --> G[Specialists report only to PM]
  F --> H[PM readiness review]
  G --> H
  H --> I{User confirms implementation?}
  I -->|no| B
  I -->|yes| J[Implement and self-test]
  J --> K[Validate evidence]
  K --> L[Record contract deltas if target changed]
  L --> M[PM acceptance]
  M --> N[Delivery summary]
```

Living contract rule:

```text
Initial plan is the starting intent, not an immutable command.
Tactical changes are allowed.
Target-changing changes are recorded as contract deltas in 05-governance-log.md.
Final review uses the latest effective contract plus evidence.
```

Compact team task documents:

| File | Purpose |
|---|---|
| `00-index.md` | Entry, status, next action |
| `01-task-contract.md` | Scope, FP, AC, latest target |
| `02-delivery-plan.md` | Architecture, implementation, self-test, rollback |
| `03-work-log.md` | Agent roster, handoffs, feature status, implementation, bugfix |
| `04-validation.md` | Test plan, results, evidence, retest |
| `05-governance-log.md` | Decisions, contract deltas, risks |
| `06-readiness-acceptance.md` | Readiness gate, user confirmation, PM acceptance |
| `07-delivery-summary.md` | Stage report, delivered scope, follow-up |

### `/dev-baseline-report`: project or task report

```mermaid
flowchart TD
  A[Report request] --> B{Target}
  B -->|Project| C[Inspect repo facts, docs, and state]
  B -->|Task| D[Inspect task workspace records]
  C --> E[Generate HTML report]
  D --> E
  E --> F[Return path, sections, missing docs, next action]
```

### `/dev-baseline-git-sync`: safe sync

```mermaid
flowchart TD
  A[Sync request] --> B[Check worktree]
  B --> C[Safety scan]
  C --> D{Safe?}
  D -->|no| E[Stop and report blocker]
  D -->|yes| F[Record local changes when present]
  F --> G[Fetch and merge remote]
  G --> H{Conflict?}
  H -->|yes| E
  H -->|no| I[Publish synchronized branch]
  I --> J[Report branch, commit, remote, notes]
```

## Start a Team Delivery Task

```text
/dev-baseline-task create v0.3.2 用户登录功能
```

During team delivery, the main agent interacts only with PM. PM controls specialists, readiness, contract deltas, validation evidence, risks, and acceptance.

## Install

```bash
bash scripts/install-dev-baseline.sh codex
bash scripts/install-dev-baseline.sh claude
bash scripts/install-dev-baseline.sh both-personal
bash scripts/install-dev-baseline.sh codex-project /path/to/project
bash scripts/install-dev-baseline.sh both-project /path/to/project
```

Validate:

```bash
bash scripts/validate-skill.sh
```

## License

MIT
