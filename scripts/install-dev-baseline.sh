#!/usr/bin/env bash
set -euo pipefail

TARGET=${1:-both}

case "$TARGET" in
  claude)
    echo "Install Claude package: copy claude/ into ~/.claude/skills/dev-baseline/"
    ;;
  codex)
    echo "Install Codex package: copy codex/AGENTS.md and codex/.agents/"
    ;;
  both)
    echo "Install both Claude and Codex packages."
    ;;
  *)
    echo "Usage: bash scripts/install-dev-baseline.sh [claude|codex|both]"
    exit 1
    ;;
esac
