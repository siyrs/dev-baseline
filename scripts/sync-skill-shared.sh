#!/usr/bin/env bash
set -euo pipefail

# Keep the installable skill/shared mirror aligned with the repository-level
# shared assets. Use `check` in CI/validation and `sync` when intentionally
# refreshing the packaged skill copy.

MODE=${1:-check}
SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$SOURCE_ROOT/shared"
DST="$SOURCE_ROOT/skill/shared"

usage() {
  cat <<'EOF'
Usage: bash scripts/sync-skill-shared.sh [check|sync]

Modes:
  check  Report drift between shared/ and skill/shared/ without changing files.
  sync   Replace skill/shared/ with an exact copy of shared/.
EOF
}

list_files() {
  local root="$1"
  (
    cd "$root"
    find . -type f -print | sed 's#^\./##' | sort
  )
}

require_shared_roots() {
  if [[ ! -d "$SRC" ]]; then
    echo "Missing source shared directory: $SRC" >&2
    exit 1
  fi

  if [[ ! -d "$DST" ]]; then
    echo "Missing packaged shared mirror: $DST" >&2
    exit 1
  fi
}

check_mirror() {
  require_shared_roots

  local src_list
  local dst_list
  src_list="$(mktemp)"
  dst_list="$(mktemp)"
  trap 'rm -f "$src_list" "$dst_list"' RETURN

  list_files "$SRC" > "$src_list"
  list_files "$DST" > "$dst_list"

  local status=0
  local rel

  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    if [[ ! -f "$DST/$rel" ]]; then
      echo "Missing from skill/shared: $rel" >&2
      status=1
    elif ! cmp -s "$SRC/$rel" "$DST/$rel"; then
      echo "Content drift in skill/shared: $rel" >&2
      status=1
    fi
  done < "$src_list"

  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    if [[ ! -f "$SRC/$rel" ]]; then
      echo "Stale file in skill/shared: $rel" >&2
      status=1
    fi
  done < "$dst_list"

  if [[ "$status" -ne 0 ]]; then
    echo "Run: bash scripts/sync-skill-shared.sh sync" >&2
    exit "$status"
  fi

  echo "skill/shared is in sync with shared."
}

sync_mirror() {
  if [[ ! -d "$SRC" ]]; then
    echo "Missing source shared directory: $SRC" >&2
    exit 1
  fi

  if [[ "$DST" != "$SOURCE_ROOT/skill/shared" ]]; then
    echo "Refusing to sync unexpected destination: $DST" >&2
    exit 1
  fi

  rm -rf "$DST"
  mkdir -p "$DST"
  cp -R "$SRC"/. "$DST"/
  echo "Synced shared/ -> skill/shared/"
}

case "$MODE" in
  check)
    check_mirror
    ;;
  sync)
    sync_mirror
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    usage >&2
    exit 1
    ;;
esac
