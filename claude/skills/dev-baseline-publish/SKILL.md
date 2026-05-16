---
name: dev-baseline-publish
description: Safely publish repository changes with explicit user approval. Use for /dev-baseline-publish, dev-baseline-publish, commit and push, publish changes, Git release handoff, and safe Git publishing requests.
disable-model-invocation: true
---

# Dev Baseline Publish Skill

Use this skill only when the user explicitly asks to commit and/or push.

Responsibilities:
- inspect git status and diff summary
- block suspicious secret files
- generate concise commit messages
- commit and push safely
- never force push unless explicitly requested
