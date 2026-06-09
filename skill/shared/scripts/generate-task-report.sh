#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

resolve_project_path() {
  local path="${1:-}"
  if [[ -z "$path" ]]; then
    printf '\n'
    return 0
  fi
  case "$path" in
    /*|[A-Za-z]:*) printf '%s\n' "$path" ;;
    *) printf '%s/%s\n' "$REPO_ROOT" "$path" ;;
  esac
}

workspace="$(resolve_project_path "${1:-}")"
if [[ -z "$workspace" ]]; then
  echo "Usage: bash shared/scripts/generate-task-report.sh <task-workspace>" >&2
  exit 1
fi

if [[ ! -d "$workspace" ]]; then
  echo "Task workspace not found: $workspace" >&2
  exit 1
fi

timestamp=$(date +"%Y%m%d-%H%M%S")
out="$workspace/stage-report-${timestamp}.html"

html_escape() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

read_file() {
  local file="$1"
  if [[ -f "$workspace/$file" ]]; then
    html_escape < "$workspace/$file"
  else
    echo "Missing: $file" | html_escape
  fi
}

section() {
  local title="$1"
  local file="$2"
  printf '<section><h2>%s</h2><pre>' "$title"
  read_file "$file"
  printf '</pre></section>\n'
}

cat > "$out" <<EOF
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Task Stage Report - ${timestamp}</title>
<style>
body{margin:0;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;background:#0f172a;color:#e5e7eb}
header{padding:32px;background:#111827;border-bottom:1px solid #334155}
main{padding:20px;display:grid;gap:16px}
section{background:#111827;border:1px solid #334155;border-radius:14px;padding:16px}
pre{white-space:pre-wrap;word-break:break-word;background:#020617;border:1px solid #1e293b;border-radius:12px;padding:12px;overflow:auto}
</style>
</head>
<body>
<header><h1>Task Stage Report</h1><p>${workspace} · ${timestamp}</p></header>
<main>
EOF

section "Index" "00-index.md" >> "$out"
section "Task Contract" "01-task-contract.md" >> "$out"
section "Delivery Plan" "02-delivery-plan.md" >> "$out"
section "Work Log" "03-work-log.md" >> "$out"
section "Validation" "04-validation.md" >> "$out"
section "Governance Log" "05-governance-log.md" >> "$out"
section "Readiness and Acceptance" "06-readiness-acceptance.md" >> "$out"
section "Delivery Summary" "07-delivery-summary.md" >> "$out"

cat >> "$out" <<EOF
</main>
</body>
</html>
EOF

echo "Task report generated: $out"
