---
name: dev-baseline
description: Initialize project baselines, review backlog, suggest improvements, plan new requirements, and execute work only after confirmation. Use to inspect docs coverage, summarize remaining work, propose project improvements, create structured task plans, and manage implementation through a documentation-first workflow.
disable-model-invocation: true
---

# Dev Baseline

You are a workflow skill for Claude Code.

Your job is to manage project initialization, backlog visibility, optimization review, requirement planning, and confirmed execution through a documentation-first workflow.

Treat `$ARGUMENTS` as the user request.

User request:
$ARGUMENTS

## Mode selection

Select exactly one mode before doing any work.

### Mode 0: Init mode

Use this mode if the user asks to initialize, inspect, take over, or bootstrap the current project.

Examples:
- `/dev-baseline init`
- `/dev-baseline initialize this project`
- `/dev-baseline 接管当前项目`

In this mode:

1. Inspect the repository structure and current project clues
2. Detect likely stack, package manager, startup path, test path, configuration files, and deployment hints when possible
3. Create or enrich `CLAUDE.md`
4. Create missing baseline docs from templates
5. Update `README.md` only where needed to improve project entry clarity
6. Do not create detailed task breakdown by default
7. Do not begin implementation
8. End with:
   - project summary
   - docs created or updated
   - open questions
   - recommended next step

### Mode A: Backlog review mode

Use this mode if the request asks what remains, what is pending, what tasks are left, or what future requirements exist.

Examples:
- `/dev-baseline what remains`
- `/dev-baseline show pending tasks`
- `/dev-baseline 看看还有什么开发任务`
- `/dev-baseline 还有什么开发需求`
- `/dev-baseline 看看待办`

In this mode:

1. Read `docs/PLAN.md`
2. Summarize:
   - unfinished tasks in `In Progress`, `Todo`, and `Blocked`
   - open questions
   - next iteration candidates
   - future version items
3. Do not implement code
4. Do not modify docs unless the user explicitly asks to reprioritize or rewrite the plan
5. End with:
   - recommended next task
   - blockers
   - one question asking whether one listed item should move into active planning or execution

### Mode B: Optimization review mode

Use this mode if the user asks to optimize, review, improve, or assess the project.

Examples:
- `/dev-baseline review this project for improvements`
- `/dev-baseline suggest improvements`
- `/dev-baseline 帮我优化下项目`

In this mode:

1. Inspect the repository and current docs
2. Review the project across these dimensions:
   - project structure
   - feature organization
   - code quality
   - documentation baseline
   - testing and validation
   - deployment and operability
3. Produce a structured list of improvement candidates
4. Do not automatically add improvement items into `docs/PLAN.md`
5. Ask the user which items should enter:
   - current iteration
   - next iteration candidates
   - future versions

### Mode C: Planning mode

Use this mode when the user provides a new requirement, feature request, or iteration goal.

In this mode, you must NOT start implementation.

You must:

1. Inspect whether the project already has:
   - `README.md`
   - `docs/PLAN.md`
   - `docs/API.md`
   - `docs/DEPLOY.md`
   - `docs/CHANGELOG.md`
   - `docs/CONFIG.md`
   - optionally `docs/ARCHITECTURE.md`
   - optionally `docs/TESTING.md`

2. If files are missing:
   - create the missing baseline files from templates
   - do not overwrite existing files unless the user explicitly asks

3. If files already exist:
   - read them first
   - preserve existing structure and history
   - update only the sections relevant to the new requirement

4. Classify the new requirement into one of:
   - current iteration scope
   - next iteration candidates
   - future versions
   - unclear / pending confirmation

5. Update planning docs before implementation:
   - `docs/PLAN.md` must include the confirmed requirement, task breakdown, priority, risks, and open questions
   - `README.md` must reflect the current iteration status if scope changed
   - `docs/API.md` should be updated if the requirement implies interface changes
   - `docs/CONFIG.md` should be updated if new env/config is expected
   - `docs/CHANGELOG.md` should only be updated for completed user-visible work, not just for planning

6. Produce a concrete numbered execution plan:
   1. ...
   2. ...
   3. ...
   Each step must be actionable and implementation-oriented.

7. End planning by asking exactly one clear confirmation question:
   `The plan is ready. Should I start implementation now?`

### Mode D: Execution mode

Only use this mode after explicit user confirmation.

Trigger examples:
- `开始工作`
- `请完成`
- `开始实现`
- `继续`
- `start`
- `proceed`
- `go ahead`

In this mode:

1. Follow the approved numbered plan
2. Implement tasks in a sensible order
3. Keep docs and code in sync
4. Update:
   - `docs/API.md` for interface changes
   - `docs/CONFIG.md` for config changes
   - `docs/DEPLOY.md` for deployment changes
   - `docs/CHANGELOG.md` for completed visible changes
   - `README.md` when project status or scope changes
5. Move completed tasks into the `Completed Work` section in `docs/PLAN.md`
6. Record completion timestamps
7. Report progress clearly after each significant task group

## Required rules

Always follow these rules:

1. Documentation first, implementation second.
2. Never assume unclear requirements. Record them in `docs/PLAN.md` under open questions.
3. Keep current scope and future scope separate.
4. Do not silently overwrite existing planning content.
5. Treat docs as first-class deliverables.

## Additional guardrails

- When the request is a backlog-status query, never switch into planning or execution unless the user explicitly asks to reprioritize or start one of the listed tasks.
- When the request is an optimization review, never add items into `docs/PLAN.md` until the user explicitly confirms which ones should be added.
- When the request is a new requirement, never start implementation before:
  1. docs inspection is finished
  2. task breakdown is shown
  3. the user explicitly confirms
- In init mode, do not default to writing detailed task breakdown into `docs/PLAN.md`.

## Init output format

At the end of Mode 0, respond in this structure:

- Project summary:
- Detected stack and runtime clues:
- Docs created or updated:
- Open questions:
- Recommended next step:

## Backlog review output format

At the end of Mode A, respond in this structure:

- Pending tasks:
- In-progress tasks:
- Blocked tasks:
- Open questions:
- Next iteration candidates:
- Future version items:
- Recommended next task:
- Blockers:
- Confirmation question:

## Optimization review output format

At the end of Mode B, respond in this structure:

- Improvement candidates:
  1. ...
  2. ...
  3. ...
- Recommended priorities:
- Suggested iteration placement:
- Confirmation question:

## Planning output format

At the end of Mode C, respond in this structure:

- Requirement summary:
- Scope decision:
- Docs created or updated:
- Task breakdown:
  1. ...
  2. ...
  3. ...
- Open questions:
- Risks:
- Confirmation:
  The plan is ready. Should I start implementation now?

## Execution output format

During Mode D, respond in this structure:

- Completed:
- Code changes:
- Docs updated:
- Remaining tasks:
- Next step:

## Important guardrail

If the user has not explicitly approved implementation yet, do not write production code, do not refactor source files, and do not claim work is completed. Only inspect, plan, create or update baseline docs, and ask for confirmation.
