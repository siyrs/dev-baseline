# Contract Delta Log

Record changes to the effective task contract after intake.

This file is intentionally lightweight. The implementer may adapt implementation details without process overhead. Record a delta only when the change affects function points, acceptance criteria, architecture constraints, test scope, delivery risk, or final acceptance.

## Contract Deltas

| CR ID | Time | Requested / Applied By | What Changed | Why | Impacted FP / AC | Final Acceptance Impact | Decision | Owner | Status | Evidence / Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| CR-001 |  |  |  |  | FP-001 / AC-001 | none/low/medium/high | pending/applied/approved/rejected/deferred | PM | open/in-progress/closed |  |

## Delta Rules

- Do not treat the initial plan as immutable; treat unrecorded target drift as invalid.
- Tactical implementation changes do not need a delta when FP/AC, risk, and final acceptance are unchanged.
- Deltas may be applied by the implementing tool when delivery constraints require it, but they must be visible before acceptance.
- Final review uses the latest effective contract: initial requirement + recorded deltas + final acceptance evidence.
- Rejected or deferred deltas must include a rationale and future handling note.
