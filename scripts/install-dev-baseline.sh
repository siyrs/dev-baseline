#!/usr/bin/env bash
set -euo pipefail

# Install Dev Baseline as one standard skill package for Codex or Claude Code.
#
# Usage:
#   bash scripts/install-dev-baseline.sh codex        [target-dir]
#   bash scripts/install-dev-baseline.sh claude       [target-dir]
#   bash scripts/install-dev-baseline.sh both-personal
#   bash scripts/install-dev-baseline.sh codex-project <project-root>
#   bash scripts/install-dev-baseline.sh both-project  <project-root>
#
# Examples:
#   bash scripts/install-dev-baseline.sh codex
#   bash scripts/install-dev-baseline.sh claude
#   bash scripts/install-dev-baseline.sh both-personal
#   bash scripts/install-dev-baseline.sh codex-project /path/to/project
#   bash scripts/install-dev-baseline.sh both-project  /path/to/project

MODE=${1:-help}
TARGET=${2:-}
SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_manifest_assets() {
  local manifest="$SOURCE_ROOT/docs/dev-baseline-manifest.txt"
  local missing=()
  local line

  if [[ ! -f "$manifest" ]]; then
    echo "Missing Dev Baseline manifest: $manifest" >&2
    exit 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] || continue

    if [[ ! -e "$SOURCE_ROOT/$line" ]]; then
      missing+=("$line")
    fi
  done < "$manifest"

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Dev Baseline manifest assets are missing:" >&2
    printf ' - %s\n' "${missing[@]}" >&2
    exit 1
  fi
}

timestamp() {
  date +%Y%m%d-%H%M%S
}

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-dev-baseline.sh codex        [target-dir]
  bash scripts/install-dev-baseline.sh claude       [target-dir]
  bash scripts/install-dev-baseline.sh both-personal
  bash scripts/install-dev-baseline.sh codex-project <project-root>
  bash scripts/install-dev-baseline.sh both-project  <project-root>

Examples:
  bash scripts/install-dev-baseline.sh codex
  bash scripts/install-dev-baseline.sh claude
  bash scripts/install-dev-baseline.sh both-personal
  bash scripts/install-dev-baseline.sh codex-project /path/to/project
  bash scripts/install-dev-baseline.sh codex-project C:/path/to/project
  bash scripts/install-dev-baseline.sh both-project  /path/to/project
EOF
}

normalize_target_path() {
  local path="$1"

  if [[ -z "$path" ]]; then
    return 0
  fi

  if [[ "$path" == [A-Za-z]:/* || "$path" == [A-Za-z]:\\* ]]; then
    if command -v wslpath >/dev/null 2>&1; then
      wslpath -u "$path"
      return 0
    fi
  elif [[ "$path" == [A-Za-z]:* ]]; then
    echo "Invalid Windows path after shell parsing: $path" >&2
    echo "Use a POSIX path, /mnt/<drive>/..., or a forward-slash Windows path such as C:/path/to/project." >&2
    exit 1
  fi

  printf '%s\n' "$path"
}

TARGET="$(normalize_target_path "$TARGET")"

default_user_home() {
  if command -v wslpath >/dev/null 2>&1 && command -v cmd.exe >/dev/null 2>&1; then
    local windows_home
    windows_home="$(cmd.exe /c 'echo %USERPROFILE%' < /dev/null 2>/dev/null | tr -d '\r' | tail -n 1)"
    if [[ -n "$windows_home" && "$windows_home" != "%USERPROFILE%" ]]; then
      wslpath -u "$windows_home"
      return 0
    fi
  fi

  printf '%s\n' "$HOME"
}

DEFAULT_HOME="$(default_user_home)"

copy_dir() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"

  while IFS= read -r -d '' rel_dir; do
    mkdir -p "$dst/${rel_dir#./}"
  done < <(cd "$src" && find . -type d -print0)

  while IFS= read -r -d '' rel_file; do
    local rel="${rel_file#./}"
    local src_file="$src/$rel"
    local dst_file="$dst/$rel"

    mkdir -p "$(dirname "$dst_file")"
    if [[ -e "$dst_file" || -L "$dst_file" ]]; then
      if [[ -f "$dst_file" ]] && cmp -s "$src_file" "$dst_file"; then
        continue
      fi
      backup_existing_path "$dst_file"
    fi
    cp "$src_file" "$dst_file"
  done < <(cd "$src" && find . -type f -print0)

  echo "Copied $src -> $dst"
}

backup_existing_path() {
  local path="$1"

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    return 0
  fi

  local backup="${path}.backup-$(timestamp)"
  local suffix=1
  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="${path}.backup-$(timestamp)-$suffix"
    suffix=$((suffix + 1))
  done

  mv "$path" "$backup"
  echo "Backed up existing $path -> $backup"
}

archive_existing_path() {
  local path="$1"
  local archive_root="$2"
  local name="$3"

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    return 0
  fi

  mkdir -p "$archive_root"

  local archive="$archive_root/$name-$(timestamp)"
  local suffix=1
  while [[ -e "$archive" || -L "$archive" ]]; do
    archive="$archive_root/$name-$(timestamp)-$suffix"
    suffix=$((suffix + 1))
  done

  mv "$path" "$archive"
  echo "Archived existing $path -> $archive"
}

replace_dir_with_backup() {
  local src="$1"
  local dst="$2"

  backup_existing_path "$dst"
  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
  echo "Copied $src -> $dst"
}

replace_personal_skill() {
  local src="$1"
  local dst="$2"
  local skills_root="$3"

  archive_existing_path "$dst" "$skills_root/.dev-baseline-backups" "dev-baseline"
  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
  echo "Copied $src -> $dst"
}

copy_file_with_backup() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"
  if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
    echo "Unchanged $dst"
    return 0
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    backup_existing_path "$dst"
  fi

  cp "$src" "$dst"
  echo "Copied $src -> $dst"
}

backup_legacy_entrypoints() {
  local skills_root="$1"

  [[ -d "$skills_root" ]] || return 0

  local backup_root=""
  local name
  for name in dev-baseline-task dev-baseline-report dev-baseline-git-sync; do
    local legacy="$skills_root/$name"
    [[ -d "$legacy" ]] || continue

    if [[ -z "$backup_root" ]]; then
      backup_root="$skills_root/.dev-baseline-legacy-backup-$(timestamp)"
      mkdir -p "$backup_root"
    fi

    mv "$legacy" "$backup_root/$name"
    echo "Backed up legacy standalone entrypoint $legacy -> $backup_root/$name"
  done
}

archive_legacy_backups() {
  local skills_root="$1"

  [[ -d "$skills_root" ]] || return 0

  local archive_root="$skills_root/.dev-baseline-backups"
  local backup
  for backup in "$skills_root"/dev-baseline.backup-*; do
    [[ -e "$backup" || -L "$backup" ]] || continue
    archive_existing_path "$backup" "$archive_root" "$(basename "$backup")"
  done
}

install_personal_skill() {
  local label="$1"
  local default_dst="$2"
  local skills_root="$3"
  local dst="${TARGET:-$default_dst}"

  if [[ -z "${TARGET:-}" ]]; then
    archive_legacy_backups "$skills_root"
    replace_personal_skill "$SOURCE_ROOT/skill" "$dst" "$skills_root"
    backup_legacy_entrypoints "$skills_root"
  else
    replace_dir_with_backup "$SOURCE_ROOT/skill" "$dst"
  fi
  echo "Standard Dev Baseline skill installed for $label at: $dst"
}

install_codex() {
  install_personal_skill "Codex" "$DEFAULT_HOME/.codex/skills/dev-baseline" "$DEFAULT_HOME/.codex/skills"
  echo "If Codex is already running, open a new session or restart Codex to reload personal skills."
}

install_claude() {
  install_personal_skill "Claude Code" "$DEFAULT_HOME/.claude/skills/dev-baseline" "$DEFAULT_HOME/.claude/skills"
}

require_target() {
  local label="$1"
  local usage_text="$2"

  if [[ -z "$TARGET" ]]; then
    echo "$label requires a project root." >&2
    echo "Usage: $usage_text" >&2
    exit 1
  fi
}

install_codex_agents() {
  local dst="$1"
  local tmp
  tmp="$(mktemp -d)"

  cp -R "$SOURCE_ROOT/skill/agents"/. "$tmp"/
  cp -R "$SOURCE_ROOT/skill/codex-agent-overrides"/. "$tmp"/
  replace_dir_with_backup "$tmp" "$dst"
  rm -rf "$tmp"
}

install_codex_project() {
  require_target "Codex project install" "bash scripts/install-dev-baseline.sh codex-project /path/to/project"

  mkdir -p "$TARGET"
  copy_file_with_backup "$SOURCE_ROOT/skill/AGENTS.md" "$TARGET/AGENTS.md"
  replace_dir_with_backup "$SOURCE_ROOT/skill" "$TARGET/.agents/skills/dev-baseline"
  copy_file_with_backup "$SOURCE_ROOT/skill/hooks.json" "$TARGET/.codex/hooks.json"
  install_codex_agents "$TARGET/.codex/agents"
  replace_dir_with_backup "$SOURCE_ROOT/skill/templates" "$TARGET/.codex/dev-baseline/templates"
  copy_dir "$SOURCE_ROOT/skill/shared" "$TARGET/shared"
  echo "Codex project overlay installed from standard skill package into: $TARGET"
}

install_claude_project() {
  require_target "Claude Code project install" "bash scripts/install-dev-baseline.sh both-project /path/to/project"

  replace_dir_with_backup "$SOURCE_ROOT/skill" "$TARGET/.claude/skills/dev-baseline"
  copy_dir "$SOURCE_ROOT/project-overlay/.claude" "$TARGET/.claude"
  install_docs_templates
}

install_both_personal() {
  TARGET=""
  install_codex
  TARGET=""
  install_claude
}

install_docs_templates() {
  if [[ -z "$TARGET" ]]; then
    return 0
  fi
  mkdir -p "$TARGET/.dev-baseline/templates"
  copy_dir "$SOURCE_ROOT/skill/templates" "$TARGET/.dev-baseline/templates"
}

case "$MODE" in
  help|-h|--help)
    ;;
  *)
    check_manifest_assets
    ;;
esac

case "$MODE" in
  claude)
    install_claude
    ;;
  codex)
    install_codex
    ;;
  both-personal)
    install_both_personal
    ;;
  codex-project)
    install_codex_project
    ;;
  both-project|both)
    require_target "Both project install" "bash scripts/install-dev-baseline.sh both-project /path/to/project"
    install_codex_project
    install_claude_project
    echo "Both Claude and Codex packages installed into project: $TARGET"
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    echo "Usage: bash scripts/install-dev-baseline.sh [codex|claude|both-personal|codex-project|both-project] [target]" >&2
    exit 1
    ;;
esac
