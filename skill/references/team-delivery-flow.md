# Team Delivery Flow

Use this flow when starting or managing a real development task with PM-led dynamic agents, readiness gates, bugfix, acceptance, and delivery stages.

## PM-led Agent Mode

Team Delivery Flow uses Agent Mode by default, but the full team is not spawned by default.

The main agent starts the Product Manager first. The PM then activates the smallest useful set of single-responsibility agents:

- Analyst: discovery, evidence, logs, metrics, repo scan, or research.
- Architect: architecture, API, data, config, deploy, migration, security, performance, compatibility, risks, or constraints.
- Developer: implementation planning, code changes, self-test, or bugfix.
- QA Tester: test strategy, validation, regression, bug reports, or retest.
- Coordinator: dependencies, handoffs, sequencing, and status when multiple agents are active.

Record active agents, skipped agents, and rationale in `10-collaboration-log.md` and `11-readiness-gates.md`. Each active agent must have one responsibility, one expected output, and one exit condition.

If sub-agent tooling is unavailable, perform explicit role-labeled passes and record the fallback in `10-collaboration-log.md`.

Communication boundary: the main agent assigns the task to PM and only interacts with PM. PM controls all optional specialist agents, and specialists report to PM rather than the main agent.

## Workspace

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

## Preparation gates before implementation

Implementation must not start immediately after a feature idea.

`11-readiness-gates.md` is enforceable. Table `Result` values must be `yes`, `no`, `not-needed`, or `blocked`. Implementation is blocked by any `no`, `blocked`, `unknown`, missing `not-needed` rationale, unresolved question, missing QA bugfix retest rule when QA is active, or empty `Confirmed at`.

Before coding starts:

1. PM drafts requirement and acceptance criteria.
2. PM records active agents, skipped agents, and reasons.
3. PM activates optional specialist agents only when needed.
4. Active specialists produce focused outputs.
5. Active specialists report only to PM.
6. PM asks the user when PM or active specialists cannot resolve a question.
7. PM ensures architecture guidance or no-architecture-impact rationale exists.
8. PM ensures implementation plan or no-developer-needed rationale exists.
9. PM ensures test strategy is owned by QA or PM.
10. PM ensures every Acceptance Criteria item has related test cases and evidence fields ready for acceptance coverage review.
11. PM re-reviews requirement scope, specialist outputs, test plan, open questions, and risks.
12. The assistant summarizes scope, active agents, skipped agents, readiness, plan, test strategy, open questions, and risks.
13. The user explicitly confirms implementation.

## Execution loop

After readiness and user confirmation:

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

Do not skip QA retest after QA-reported bugfixes. If QA is skipped for a low-risk task, PM must record the rationale and own the acceptance checklist.

## Documents

- `00-index.md`
- `01-product-requirement.md`
- `02-development-plan.md`
- `03-implementation-notes.md`
- `04-test-plan.md`
- `05-test-report.md`
- `06-bugfix-log.md`
- `07-acceptance-report.md`
- `08-delivery-summary.md`
- `09-feature-status-board.md`
- `10-collaboration-log.md`
- `11-readiness-gates.md`
- `12-stage-user-report.md`
- `13-decision-log.md`
- `14-change-request-log.md`
- `15-risk-register.md`

## Command

```bash
bash shared/scripts/create-task-workspace.sh <version> <task-name>
```

## Feature status

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected items move to `bugfixing` before returning to `self-tested` and `qa-testing`.

## PLAN.md role

`docs/PLAN.md` is a dashboard and index only. Detailed task documents belong in the task workspace.

## Safety

Do not implement source code before the readiness gates are complete and the user explicitly confirms implementation.

## Specialist Handoff Packet Protocol

Before activating any optional specialist agent, the Product Manager must record a `Specialist Handoff Packet` in `10-collaboration-log.md`. The packet is the only assignment contract between PM and the specialist.

The packet must include:

- From: Product Manager
- To: the single specialist role being activated
- Task workspace
- Context files
- Decision needed
- Responsibility boundary
- Expected output
- Exit condition
- Deadline / sequencing
- Questions PM already resolved
- Questions still allowed to ask

Specialists must answer only inside the packet boundary and report back to the Product Manager. If they need scope, architecture, implementation, validation, or acceptance decisions outside the packet, they must return the question to PM instead of deciding independently.
