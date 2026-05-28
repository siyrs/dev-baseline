# Claude Code Adapter

Claude Code uses the canonical Dev Baseline skill package from `../skill`.

Do not add duplicated skill files, agents, hooks, or templates here. Update `../skill` first, then let `scripts/install-dev-baseline.sh` generate Claude Code personal installs or project overlays from that package.

Useful commands:

```bash
bash scripts/install-dev-baseline.sh claude
bash scripts/install-dev-baseline.sh both-project /path/to/project
```
