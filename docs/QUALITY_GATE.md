# Quality Gate

Use this checklist before finishing an implementation or publishing changes.

## Required Checks

- [ ] Approved numbered plan exists
- [ ] Implementation matches approved scope
- [ ] README updated when project usage or scope changed
- [ ] docs/PLAN.md updated
- [ ] docs/API.md updated for API changes
- [ ] docs/CONFIG.md updated for config changes
- [ ] docs/DEPLOY.md updated for deployment changes
- [ ] docs/CHANGELOG.md updated for user-visible completed work
- [ ] docs/TESTING.md updated or validation notes recorded
- [ ] Secret scan passed
- [ ] Dangerous Git command guard passed
- [ ] Report generated when requested

## Suggested Commands

```bash
bash shared/scripts/validate-baseline-docs.sh
bash shared/scripts/check-doc-sync.sh
bash shared/scripts/check-secrets.sh
```

## Publish Readiness

Only publish when:

- no suspicious secret files are present
- changes are intentional and scoped
- commit message is concise and meaningful
- remote/upstream is known
- no force push is required
