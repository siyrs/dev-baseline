# Task Workspace Index

## Task Info
- Task name:
- Version:
- Created at:
- Current status: intake
- Current owner:
- Related branch:
- Related issue/PR:

## Document Index
- [01 Task Contract](./01-task-contract.md)
- [02 Delivery Plan](./02-delivery-plan.md)
- [03 Work Log](./03-work-log.md)
- [04 Validation](./04-validation.md)
- [05 Governance Log](./05-governance-log.md)
- [06 Readiness and Acceptance](./06-readiness-acceptance.md)
- [07 Delivery Summary](./07-delivery-summary.md)

## Task Status Flow
```text
intake -> readiness -> in-development -> self-tested -> validation -> bugfixing -> accepted -> delivered
```

## Feature Status Values
```text
not-started -> in-progress -> implemented -> self-tested -> qa-testing -> qa-passed -> accepted
```

Rejected feature points return to `bugfixing` before validation resumes.

## Compact Document Roles
| File | Role |
|---|---|
| 01 Task Contract | Scope, FP, AC, and living contract target |
| 02 Delivery Plan | Architecture, implementation, self-test, rollback |
| 03 Work Log | Agent roster, custom prompts, handoffs, feature status, implementation, bugfix |
| 04 Validation | Test plan, test results, evidence, retest |
| 05 Governance Log | Decisions, contract deltas, risks |
| 06 Readiness and Acceptance | Readiness gate, user confirmation, PM acceptance |
| 07 Delivery Summary | Stage report, delivered scope, follow-up |

## Preparation Gates
| Gate | Owner | Required Result | Status | Notes |
|---|---|---|---|---|
| Task contract | Product Manager | Scope, FP, AC, pass rules, and evidence expectations drafted | todo |  |
| PM-led agent roster | Product Manager | Active/skipped agents and rationale recorded | todo |  |
| Custom specialist prompts | Product Manager | Custom specialists defined or marked not-needed | todo |  |
| Delivery plan | PM or active specialists | Architecture, implementation, test, and rollback notes ready | todo |  |
| Architect + Developer elaboration | PM / Architect / Developer | Workable implementation approach ready or not-needed rationale recorded | todo |  |
| Governance review | PM | Decisions, contract deltas, and risks reviewed | todo |  |
| Traceability review | PM or QA | FP -> AC -> validation -> acceptance chain checked | todo |  |
| User implementation confirmation | User | Explicit approval to start development | todo |  |

## Progress Summary
| Stage | Owner | Status | Updated at | Notes |
|---|---|---|---|---|
| Contract | PM | todo |  |  |
| Planning | PM + specialists | todo |  |  |
| Implementation | Developer when active | todo |  |  |
| Validation | QA or PM | todo |  |  |
| Governance | PM | todo |  |  |
| Acceptance | PM | todo |  |  |
| Delivery | Team | todo |  |  |

## Current Blockers
- 

## Next Action
- 
