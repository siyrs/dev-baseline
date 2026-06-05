# Team Delivery Flow

Team Delivery Flow is the default Dev Baseline workflow for real product development.

It models a normal software delivery process with PM-led preparation, dynamic role activation, execution, testing, bugfixing, acceptance, and delivery.

## PM-led Agent Mode

Team Delivery Flow enables Agent Mode by default, but it does not spawn a full team by default.

The main agent must start with the Product Manager role first. The Product Manager owns the requirement and the agent roster. Additional agents are activated only when their single responsibility is needed.

Available role agents:

- Product Manager: always active; owns requirement intake, scope, agent roster decisions, readiness review, user communication, and acceptance.
- Analyst: optional; owns discovery, evidence gathering, metrics, logs, repo scan, or external research.
- Architect: optional; owns architecture boundaries, API/data/config/deploy/migration/security/performance impact, risks, alternatives, and constraints.
- Developer: optional until implementation is needed; owns implementation planning, code changes, self-test, and bugfix.
- QA Tester: optional until validation risk requires it; owns test strategy, QA execution, bug reports, and retest.
- Coordinator: optional; owns handoffs, dependencies, sequencing, and cross-agent status when multiple agents are active.

Use the smallest useful roster. Each active agent must have one responsibility, one expected output, and one exit condition. Record active agents, skipped agents, and rationale in `10-collaboration-log.md` and `11-readiness-gates.md`.

If real agent tooling is unavailable, the assistant must run explicit role-labeled passes in the same conversation and record the fallback in `10-collaboration-log.md`.

Communication boundary:

- The main agent assigns the task to the Product Manager.
- The main agent communicates only with the Product Manager during Team Delivery Flow.
- The Product Manager controls all optional specialist agents.
- Specialist agents report to the Product Manager, not to the main agent.
- The Product Manager returns consolidated decisions, risks, outputs, and next actions to the main agent and user.

## Core rule

Implementation must not start immediately after a user gives a feature idea.

Before development starts, the workflow must complete PM intake, PM roster decision, only the needed specialist loops, PM readiness review, and user confirmation.

Mandatory preparation outputs:

- requirement scope and acceptance criteria
- active agent roster and skipped-agent rationale
- main-agent-to-PM-only communication boundary
- architecture guidance or no-architecture-impact rationale
- implementation plan or no-developer-needed rationale
- test strategy owned by QA or PM
- AC to TC to evidence traceability
- readiness gate results using only `yes`, `no`, `not-needed`, or `blocked`
- decision, change request, and risk records
- PM readiness review
- explicit user confirmation before implementation

Treat `11-readiness-gates.md` as an enforceable gate. Implementation is blocked by any `no`, `blocked`, `unknown`, missing `not-needed` rationale, unresolved question, missing QA bugfix retest rule when QA is active, or empty `Confirmed at`.

## Preparation loop 0: PM intake and roster decision

The Product Manager first drafts the rough requirement, acceptance criteria, scope, and out-of-scope notes.

Then the PM decides the minimum agent roster:

- Activate Analyst if the task needs discovery before planning.
- Activate Architect if the task can affect system design, contracts, data, config, deployment, migrations, security, performance, or compatibility.
- Activate Developer if code implementation, technical decomposition, self-test, or bugfix work is needed.
- Activate QA Tester if user-visible behavior, regression risk, compliance, bug retest, or independent validation is needed.
- Activate Coordinator if more than two agents or parallel workstreams need handoff control.

If the PM cannot decide a roster item, the PM asks the user instead of spawning extra agents speculatively.

## Optional loop: PM ↔ Analyst

Use this loop only when evidence is needed before planning.

The Analyst reviews:

- repository or feature evidence
- logs, metrics, reports, traces, or external references
- ambiguity that blocks PM, Architect, Developer, or QA decisions

The Analyst must not decide product scope, architecture, implementation, or acceptance. The Analyst returns evidence and open questions to PM.

## Optional loop: PM ↔ Architect

Use this loop only when architecture impact exists or is unclear.

The Architect reviews:

- system boundaries and ownership impact
- data flow, API, config, deploy, migration, and compatibility impact
- security, performance, reliability, and operability risks
- technical constraints the Developer must follow
- implementation alternatives if the original approach is risky

If the Architect cannot determine an architecture impact, the Architect feeds questions back to PM. If PM cannot answer, PM asks the user before finalizing guidance.

## Conditional loop: PM ↔ Developer

Use this loop when the task needs implementation planning, source changes, self-test, or bugfix work.

The Developer reviews:

- whether the feature is technically feasible
- expected implementation difficulty
- rough effort estimate
- risky or unclear function points
- required interfaces, data, config, permissions, or external services
- concrete implementation order and file/module impact
- self-test plan

If the Developer cannot determine a function point, the Developer feeds questions back to PM. If PM cannot answer, PM asks the user before finalizing the development plan.

For documentation-only or planning-only tasks, PM may skip Developer but must record why no Developer is needed.

## Conditional loop: PM ↔ QA Tester

Use this loop when the task needs independent test strategy, validation, regression coverage, or bug retest.

QA should clarify:

- test scope
- test data needs
- required environment
- test cases and edge cases
- acceptance criteria mapping
- evidence link, screenshot, log, and command expectations
- pass/fail rules
- regression scope
- bugfix retest rule

If QA cannot define a pass/fail rule, QA feeds questions back to PM. If PM cannot answer, PM asks the user.

For low-risk documentation-only or planning-only tasks, PM may skip QA but must own and record the acceptance checklist.

## Optional loop: PM ↔ Coordinator

Use this loop only when coordination overhead is real.

The Coordinator tracks:

- active agent responsibilities and exit conditions
- dependencies and handoff order
- cross-agent blockers
- status summary for PM

The Coordinator must not own product scope, architecture, code, tests, or acceptance.

## PM readiness review

Before asking the user to approve implementation, the Product Manager must re-review:

- requirement scope and acceptance criteria
- active agents and skipped-agent rationale
- specialist outputs and unresolved risks
- implementation plan or no-developer-needed rationale
- test strategy or PM-owned acceptance checklist
- AC coverage by test cases and evidence
- open questions, blockers, and user-confirmation needs

If this PM review fails, the task must return to the relevant preparation loop.

## User confirmation gate

After PM readiness passes, the assistant must summarize:

- requirement scope
- active agents and why they were needed
- skipped agents and why they were not needed
- architecture guidance or no-impact rationale
- feasibility and rough effort when Developer is active
- development plan when implementation is needed
- test strategy and retest rule
- open questions
- risks

Then ask the user to confirm implementation.

Do not implement source code before explicit user confirmation.

## Standard execution loop

After readiness and user confirmation, Team Delivery Flow proceeds as:

```text
Developer implements -> Developer self-tests -> QA Tester tests when active -> Developer fixes QA bugs -> QA Tester retests when active -> PM accepts
```

QA must retest after every QA-reported bugfix. PM acceptance must not start while P0/P1 QA bugs remain open.

If QA was intentionally skipped, PM must record the low-risk rationale and complete the acceptance checklist before accepting.

## Task workspace

Every feature or requirement should have a dedicated workspace:

```text
docs/tasks/YYYYMMDD-vX.Y.Z-task-slug/
```

Example:

```text
docs/tasks/20260515-v0.3.2-team-delivery-flow/
```

## Required documents

Each task workspace should contain:

```text
00-index.md
01-product-requirement.md
02-development-plan.md
03-implementation-notes.md
04-test-plan.md
05-test-report.md
06-bugfix-log.md
07-acceptance-report.md
08-delivery-summary.md
09-feature-status-board.md
10-collaboration-log.md
11-readiness-gates.md
12-stage-user-report.md
13-decision-log.md
14-change-request-log.md
15-risk-register.md
```

## Role responsibilities

### Product Manager

Owns:
- rough requirement intake
- requirement clarification
- user value
- scope and out-of-scope
- agent roster decisions
- decision log ownership
- change request ownership
- risk register ownership
- skipped-agent rationale
- specialist question handling
- readiness re-review before implementation
- acceptance criteria
- final acceptance decision

### Analyst

Owns:
- discovery and evidence gathering
- logs, metrics, reports, traces, and repo scan summaries
- factual uncertainty reduction
- evidence-backed questions for PM

### Architect

Owns:
- architecture review
- technical direction and constraints
- system boundary and ownership checks
- API, data, config, deploy, migration, security, performance, and compatibility impact
- architecture risk and mitigation notes

### Developer

Owns:
- feasibility review
- difficulty and effort estimate
- technical decomposition
- concrete implementation plan
- implementation order
- code changes
- feature status updates
- self-test evidence
- bug fixes

### QA Tester

Owns:
- test strategy
- test scope
- test cases
- test data and environment needs
- pass/fail criteria
- feature test status updates
- regression status
- bugfix retest

### Coordinator

Owns:
- handoff map
- dependency tracking
- cross-agent sequencing
- blocker routing
- status rollup for PM

## Feature status board

Each feature point should have its own status.

Recommended feature statuses:

```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

If QA rejects a feature point:

```text
qa-testing -> bugfixing -> self-tested -> qa-testing
```

If Product Manager rejects acceptance:

```text
accepted? no -> bugfixing -> self-tested -> qa-testing -> acceptance
```

## PLAN.md role

`docs/PLAN.md` should not contain all task details. It should act as a dashboard and index:

- current task workspace path
- task status
- owner role
- progress summary
- links to task documents
- blockers
- next action

Detailed plans, implementation notes, test reports, feature status, collaboration logs, decision logs, change requests, risk registers, bugfix logs, and acceptance records belong in the task workspace.

## Overall status flow

Recommended task-level status values:

```text
intake -> roster-decision -> discovery -> architecture-review -> feasibility-review -> test-strategy -> pm-readiness-review -> ready-for-development -> in-development -> self-tested -> qa-testing -> bugfixing -> qa-passed -> acceptance -> accepted -> delivered
```

Skip optional statuses when the corresponding agent is not active, but record the skip rationale.

If rejected by QA or PM, move back to:

```text
bugfixing
```

## Stage report

After the task reaches readiness, `qa-passed`, `accepted`, or `delivered`, the assistant should output a concrete stage report to the user, summarizing:

- active agents and skipped agents
- completed feature points
- test status
- bugs found and fixed
- unresolved risks
- approved/rejected change requests
- important decisions
- acceptance result
- next recommended action

## Safety

Team Delivery Flow may create and update files under `docs/tasks/`, `docs/PLAN.md`, and related docs. It must not implement source code before the task workspace, product requirement, readiness gates, implementation plan or no-developer-needed rationale, test strategy, PM readiness review, and explicit user approval are complete.

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
