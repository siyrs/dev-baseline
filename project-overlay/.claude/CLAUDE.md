# Project workflow rules

- For any new requirement or iteration planning, use `/dev-baseline` first.
- For first-time project takeover, use `/dev-baseline init`.
- For backlog questions, inspect `docs/PLAN.md` first and summarize remaining work before proposing implementation.
- For optimization requests, produce improvement candidates first; only add confirmed items into `docs/PLAN.md`.
- Do not start implementation for major multi-step tasks before planning is written to docs.
- Keep `README.md` and `docs/` aligned with the current project state.
- Treat `docs/PLAN.md` as the source of truth for task order and status.
- Do not run `git add`, `git commit`, or `git push` during normal planning or execution.
- Only commit and push when the user explicitly asks for Git publishing, such as `提交并推送`, `commit and push`, or `git push`.
- Before committing, inspect changed files and avoid staging secrets, local environment files, private keys, or unrelated local artifacts.
- Never force push, create tags, or create releases unless the user explicitly asks for that separate operation.
