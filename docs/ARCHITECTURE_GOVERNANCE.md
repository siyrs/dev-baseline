# Architecture Governance

Dev Baseline treats architecture decisions as first-class delivery artifacts. This document defines when architecture review is required and what output level is expected.

## Architecture impact levels

| Level | Meaning | Required output |
|---|---|---|
| A0 | No architecture impact | No-impact rationale in `02-development-plan.md` and `11-readiness-gates.md` |
| A1 | Local module impact | Module boundary note, touched modules, implementation constraints |
| A2 | Cross-module, API, data, config, or contract impact | Architecture guidance, compatibility notes, affected contracts, test impact |
| A3 | Deploy, migration, security, performance, reliability, or operability impact | Risk and mitigation, rollback plan, migration/deploy notes, QA/regression scope |
| A4 | Irreversible, high-risk, release-blocking, or strategic architecture impact | ADR-style decision, release blocker review, explicit rollback/recovery strategy, PM/user approval |

## Architect activation rules

Activate Architect when any of these are true:

- architecture impact level is A1 or higher
- architecture impact is unclear
- API, data, config, deploy, migration, security, performance, compatibility, reliability, or operability may change
- implementation touches shared libraries, public contracts, cross-module boundaries, or release behavior
- rollback is non-trivial

Do not activate Architect for A0 tasks. PM must record the no-impact rationale instead.

## Required architecture review output

Architect output must include:

- impact level
- affected boundaries
- affected data/API/config/deploy surfaces
- compatibility or migration impact
- security/performance/reliability concerns
- technical constraints for Developer
- alternatives considered when risk exists
- decision and rationale
- risks that must appear in `15-risk-register.md`
- documentation updates required

## ADR requirement

An ADR-style decision is required when:

- impact level is A4
- a public API or persistent data model is changed incompatibly
- migration or rollback requires coordinated release work
- security or compliance posture changes
- performance or reliability trade-offs are accepted
- a decision supersedes a prior architecture decision

ADR content can be recorded in `13-decision-log.md` for small tasks. For project-level architecture changes, update `docs/ARCHITECTURE.md` or create a dedicated ADR document when the host project has an ADR convention.

## Change request interaction

If a change request affects architecture, the task must return to architecture review before implementation continues.

Architecture-affecting changes include:

- new API/data/config/deploy surface
- changed compatibility behavior
- changed security/performance/reliability constraints
- modified rollback or migration strategy
- changed cross-module ownership

## Exit criteria

Architect review exits only when:

- impact level is recorded
- Developer constraints are clear
- risks and mitigations are recorded
- PM has no unresolved architecture questions
- required documentation updates are identified
