# Agent Contracts

Dev Baseline uses PM-led agent collaboration. Agent contracts keep role boundaries stable across Codex, Claude Code, and fallback role-labeled passes.

## Main Agent contract

The main agent owns workflow routing and user-facing interaction. During Team Delivery Flow it must:

- start with Product Manager first
- communicate only with Product Manager
- not directly assign work to optional specialists
- not accept specialist output except through PM summary
- not start implementation before readiness gates and user confirmation pass
- not treat implementation confirmation as permission to commit or push

## Product Manager contract

The Product Manager owns:

- requirement intake
- scope and out-of-scope decisions
- acceptance criteria
- agent roster decisions
- skipped-agent rationale
- specialist handoff packets
- decision log, change request log, and risk register ownership
- readiness review
- user communication
- final acceptance decision

The PM must not use optional specialists speculatively. Each specialist must have one responsibility, one expected output, and one exit condition.

## Specialist contract

Optional specialists include Analyst, Architect, Developer, QA Tester, Coordinator, and future roles.

Every specialist must:

- work only from a PM-issued Specialist Handoff Packet
- stay inside the packet boundary
- report only to PM
- return unresolved questions to PM
- avoid decisions outside its role boundary
- declare whether its exit condition is met

## Specialist Handoff Packet schema

Record one packet in `10-collaboration-log.md` before activating a specialist.

Required fields:

```text
From:
To:
Task workspace:
Context files:
Decision needed:
Responsibility boundary:
Expected output:
Exit condition:
Deadline / sequencing:
Questions PM already resolved:
Questions still allowed to ask:
Handoff status:
```

## Specialist Response schema

Required fields:

```text
From:
To: Product Manager
Packet reference:
Output delivered:
Evidence / files touched:
Remaining questions:
Boundary risks:
Exit condition met: yes/no
```

## Boundary violation examples

- Analyst changes product scope.
- Architect implements code.
- Developer changes acceptance criteria.
- QA approves product acceptance.
- Coordinator changes priority or scope.
- Main agent directly coordinates specialists during Team Delivery Flow.
- Any specialist performs out-of-contract work without PM-approved change request.

## Fallback role-labeled passes

If real sub-agent tooling is unavailable, the assistant may run explicit role-labeled passes in one conversation. The fallback must be recorded in `10-collaboration-log.md` with:

- reason for fallback
- simulated role
- input packet
- output summary
- exit condition

Fallback passes must follow the same role boundaries as real agents.

## Cross-tool model handoff

When one model tool defines the task and another implements it, the handoff boundary is the repository task workspace, not hidden conversation context.

The defining tool must produce `16-execution-contract.md`. The implementing tool must work against that contract. The reviewing tool must compare implementation output against that contract and recorded evidence.
