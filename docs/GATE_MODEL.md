# Gate Model

Dev Baseline uses gates to prevent ambiguous or unsafe workflow transitions.

## Gate schema

Every gate should define:

| Field | Meaning |
|---|---|
| Gate name | Human-readable gate name |
| Scope | What the gate protects |
| Entry condition | When the gate should run |
| Required files | Files that must exist before evaluation |
| Blocking results | Conditions that fail the gate |
| Non-blocking warnings | Conditions that should be reported but do not fail by default |
| Required evidence | Evidence needed to pass |
| Exit condition | What must be true after the gate passes |
| Script | Script that evaluates the gate when available |
| Human approval | Whether explicit user or PM approval is required |

## Existing gates

| Gate | Scope | Script |
|---|---|---|
| Project quality gate | Project documentation and package integrity | `shared/scripts/quality-gate.sh` |
| Publish gate | Git publish safety | `shared/scripts/publish-gate.sh` |
| Task readiness gate | Start of implementation | `shared/scripts/validate-task-readiness.sh` |
| Traceability gate | Contract, FP, AC, TC, evidence, risk, and acceptance coverage | `shared/scripts/validate-task-traceability.sh` |
| Command surface gate | Visible command policy | `scripts/validate-command-surface.sh` |
| Script preamble gate | Script syntax and path resolver integrity | `scripts/validate-script-preambles.sh` |

## Blocking-result convention

A gate must fail when:

- required files are missing
- required evidence is missing
- a blocking status is present
- a required approval is absent
- a forbidden command or unsafe operation is detected
- a required rationale is missing

## Task readiness result convention

Readiness gate table results must use only:

```text
yes | no | not-needed | blocked
```

- `yes`: gate item passed
- `no`: gate item is not passed yet
- `not-needed`: intentionally skipped with rationale
- `blocked`: implementation must not proceed

## Gate separation rule

Do not merge project quality, task readiness, traceability, and publish safety into one checklist.

- Project quality does not imply task readiness.
- Task readiness does not imply publish eligibility.
- Acceptance does not imply Git publish permission.
- Git publish permission does not imply source-edit permission.

## Cross-tool gate rule

For cross-tool workflows, the task contract and traceability gate are mandatory. The implementing tool cannot rely on the defining tool's hidden context.
