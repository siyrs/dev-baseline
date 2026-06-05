# Readiness Gates

This file records gates that must pass before implementation starts.

Allowed `Result` values:

- `yes`: gate item passed.
- `no`: gate item is not passed yet.
- `not-needed`: gate item is intentionally skipped; `Notes` must include the rationale.
- `blocked`: gate item is blocked and implementation must not start.

Do not use `unknown`. Resolve all questions before setting `Implementation may start: yes`.

## Gate 0: PM-led Agent Roster

| Item | Result | Owner | Notes |
|---|---|---|---|
| Product Manager agent active first | no | PM |  |
| Main agent only interacts with PM | no | PM |  |
| Main agent delegated roster decisions to PM | no | PM |  |
| Specialist agents report only to PM | no | PM |  |
| Active agents recorded | no | PM |  |
| Skipped agents recorded with rationale | no | PM |  |
| Each active agent has one responsibility | no | PM |  |
| Each active agent has expected output and exit condition | no | PM |  |
| Real agent tooling used or fallback recorded | no | PM |  |

## Gate 1: Discovery / Analysis

| Item | Result | Owner | Notes |
|---|---|---|---|
| Analyst needed | no | PM | yes/not-needed |
| Evidence gathered or skip rationale documented | no | PM or Analyst |  |
| Analysis questions resolved | no | PM |  |

## Gate 2: Architecture Review

| Item | Result | Owner | Notes |
|---|---|---|---|
| Architecture impact triaged | no | PM |  |
| Architect needed | no | PM | yes/not-needed |
| Architecture guidance or no-impact rationale documented | no | PM or Architect |  |
| Technical constraints documented when needed | no | Architect when active |  |
| Risks and alternatives documented when needed | no | Architect when active |  |
| Architecture questions resolved | no | PM + Architect when active |  |

## Gate 3: Feasibility

| Item | Result | Owner | Notes |
|---|---|---|---|
| Developer needed | no | PM | yes/not-needed |
| Can implement | no | Developer when active |  |
| Difficulty | no | Developer when active |  |
| Rough effort | no | Developer when active |  |
| Risks | no | Developer when active |  |
| Concrete implementation plan or PM no-developer rationale | no | PM or Developer |  |
| Need user confirmation | no | PM |  |

## Gate 4: Test Strategy

| Item | Result | Owner | Notes |
|---|---|---|---|
| QA Tester needed | no | PM | yes/not-needed |
| Test strategy owner assigned | no | PM | QA or PM |
| Test scope | no | PM or QA |  |
| Concrete test cases or PM acceptance checklist | no | PM or QA |  |
| Test data | no | PM or QA |  |
| Environment | no | PM or QA |  |
| Pass rule | no | PM or QA |  |
| Regression scope | no | QA when active |  |
| Bugfix retest rule | no | QA when active |  |

## Gate 5: Coordination

| Item | Result | Owner | Notes |
|---|---|---|---|
| Coordinator needed | no | PM | yes/not-needed |
| Handoffs documented or skip rationale recorded | no | PM or Coordinator |  |
| Cross-agent blockers routed | no | PM or Coordinator |  |

## Gate 6: PM Readiness Review

| Item | Result | Owner | Notes |
|---|---|---|---|
| Requirement reviewed | no | PM |  |
| Agent roster reviewed | no | PM |  |
| Specialist outputs reviewed | no | PM |  |
| Developer plan or no-developer rationale reviewed | no | PM |  |
| Test strategy reviewed | no | PM |  |
| Ready to ask user for implementation approval | no | PM |  |

## Gate 7: User Confirmation

- Requirement confirmed: no
- Agent roster confirmed: no
- Architecture guidance or no-impact rationale confirmed: no
- Development plan or no-developer rationale confirmed: no
- Test plan or PM acceptance checklist confirmed: no
- Implementation may start: no
- Confirmed at:
