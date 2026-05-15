#!/usr/bin/env bash
set -euo pipefail

# Install Dev Baseline assets into a target project or Claude personal skill directory.
#
# Usage:
#   bash scripts/install-dev-baseline.sh claude [target-dir]
#   bash scripts/install-dev-baseline.sh codex  <project-root>
#   bash scripts/install-dev-baseline.sh both   <project-root>
#
# Examples:
#   bash scripts/install-dev-baseline.sh claude ~/.claude/skills/dev-baseline
#   bash scripts/install-dev-baseline.sh codex  /path/to/project
#   bash scripts/install-dev-baseline.sh both   /path/to/project

MODE=${1:-help}
TARGET=${2:-}
SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

copy_dir() {
  local src="$1"
  local dst="$2"
  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
  echo "Copied $src -> $dst"
}

install_claude() {
  local dst="${TARGET:-$HOME/.claude/skills/dev-baseline}"
  copy_dir "$SOURCE_ROOT/claude" "$dst"
  echo "Claude package installed at: $dst"
}

install_codex() {
  if [[ -z "$TARGET" ]]; then
    echo "Codex install requires a project root." >&2
    echo "Usage: bash scripts/install-dev-baseline.sh codex /path/to/project" >&2
    exit 1
  fi

  mkdir -p "$TARGET"
  cp "$SOURCE_ROOT/codex/AGENTS.md" "$TARGET/AGENTS.md"
  copy_dir "$SOURCE_ROOT/codex/.agents" "$TARGET/.agents"
  copy_dir "$SOURCE_ROOT/codex/.codex" "$TARGET/.codex"
  copy_dir "$SOURCE_ROOT/codex/templates" "$TARGET/.codex/dev-baseline/templates"
  copy_dir "$SOURCE_ROOT/shared" "$TARGET/shared"
  echo "Codex package installed into project: $TARGET"
}

install_docs_templates() {
  if [[ -z "$TARGET" ]]; then
    return 0
  fi
  mkdir -p "$TARGET/.dev-baseline/templates"
  copy_dir "$SOURCE_ROOT/claude/templates" "$TARGET/.dev-baseline/templates"
}

case "$MODE" in
  claude)
    install_claude
    ;;
  codex)
    install_codex
    ;;
  both)
    if [[ -z "$TARGET" ]]; then
      echo "Both install requires a project root." >&2
      echo "Usage: bash scripts/install-dev-baseline.sh both /path/to/project" >&2
      exit 1
    fi
    install_codex
    mkdir -p "$TARGET/.claude/skills/dev-baseline"
    copy_dir "$SOURCE_ROOT/claude" "$TARGET/.claude/skills/dev-baseline"
    copy_dir "$SOURCE_ROOT/project-overlay/.claude" "$TARGET/.claude"
    install_docs_templates
    echo "Both Claude and Codex packages installed into project: $TARGET"
    ;;
  help|-h|--help)
    sed -n '1,35p' "$0"
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    echo "Usage: bash scripts/install-dev-baseline.sh [claude|codex|both] [target]" >&2
    exit 1
    ;;
esac
