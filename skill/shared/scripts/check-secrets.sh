#!/usr/bin/env bash
set -euo pipefail

# Detect obvious secret or local-only files before staging/committing.
# Usage:
#   bash shared/scripts/check-secrets.sh [file ...]
# If no files are provided, changed files from git status are checked.

if [[ $# -gt 0 ]]; then
  mapfile -t files < <(printf '%s\n' "$@" | sed '/^$/d' | sort -u)
elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  mapfile -t files < <(git status --porcelain | awk '{print $2}' | sed '/^$/d' | sort -u)
else
  mapfile -t files < <(find . -type f | sed 's#^./##' | sort -u)
fi

suspicious=()

is_suspicious_path() {
  local path="$1"
  case "$path" in
    .env|.env.*|*/.env|*/.env.*|*.pem|*.key|*.p12|*.pfx|*.jks|*id_rsa*|*id_ed25519*|*.npmrc|*.pypirc|*.netrc|*.pgpass|*.kube/config)
      return 0 ;;
    .ssh/*|*/.ssh/*|secrets/*|*/secrets/*|credentials/*|*/credentials/*|private/*|*/private/*)
      return 0 ;;
  esac
  return 1
}

has_token_like_content() {
  local path="$1"
  [[ -f "$path" && -r "$path" ]] || return 1
  local size
  size=$(wc -c < "$path" 2>/dev/null || echo 0)
  [[ "$size" -le 1048576 ]] || return 1
  grep -Iq . "$path" 2>/dev/null || return 1
  grep -Eiq '(api[_-]?key|secret|token|password|passwd|private[_-]?key|access[_-]?key|client[_-]?secret)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8,}' "$path" 2>/dev/null
}

for file in "${files[@]}"; do
  [[ -n "$file" ]] || continue
  if is_suspicious_path "$file" || has_token_like_content "$file"; then
    suspicious+=("$file")
  fi
done

if [[ ${#suspicious[@]} -gt 0 ]]; then
  echo "Suspicious secret or local-only files detected:" >&2
  printf ' - %s\n' "${suspicious[@]}" >&2
  echo "Do not stage, commit, or push these files until reviewed." >&2
  exit 1
fi

echo "No suspicious secret files detected."
