# Skill Runtime References

Files in this directory are compact routing references loaded directly by
`skill/SKILL.md`.

They are intentionally shorter than the full repository assets under:

- `shared/references/`
- `skill/shared/references/`

Use `shared/references/` as the authoring source for complete workflow
references, then run:

```bash
bash scripts/sync-skill-shared.sh sync
```

to refresh the packaged mirror under `skill/shared/references/`.

Do not duplicate full shared reference content here unless the main skill needs
that content during its first routing pass.
