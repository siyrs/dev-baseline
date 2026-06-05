SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

resolve_project_path() {
  local path="cd "$REPO_ROOT"
"
  case "$path" in
    /*|[A-Za-z]:*) printf '%s\n' "$path" ;;
    *) printf '%s/%s\n' "$REPO_ROOT" "$path" ;;
  esac
}

#!/usr/bin/env bash
set -euo pipefail

workspace="${1:-}"
workspace=$(resolve_project_path "$workspace")

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
main{display:grid;grid-template-columns:240px 1fr;gap:20px;padding:20px}
nav{position:sticky;top:20px;align-self:start;background:#111827;border:1px solid #334155;border-radius:14px;padding:12px}
button{display:block;width:100%;margin:4px 0;padding:10px;border:0;border-radius:10px;background:transparent;color:#e5e7eb;text-align:left;cursor:pointer}
button.active,button:hover{background:#1e293b}
section{display:none;background:#111827;border:1px solid #334155;border-radius:14px;padding:16px}
section.active{display:block}
pre{white-space:pre-wrap;word-break:break-word;background:#020617;border:1px solid #1e293b;border-radius:12px;padding:12px;overflow:auto}
</style>
</head>
<body>
<header><h1>Task Stage Report</h1><p>${workspace} · ${timestamp}</p></header>
<main>
<nav>
<button class="active" data-tab="index">Index</button>
<button data-tab="ready">Readiness</button>
<button data-tab="features">Features</button>
<button data-tab="test">Test</button>
<button data-tab="bugs">Bugfix</button>
<button data-tab="accept">Acceptance</button>
<button data-tab="summary">Summary</button>
</nav>
<div>
<section id="index" class="active"><h2>Index</h2><pre>$(read_file 00-index.md)</pre></section>
<section id="ready"><h2>Readiness</h2><pre>$(read_file 11-readiness-gates.md)</pre></section>
<section id="features"><h2>Feature Status</h2><pre>$(read_file 09-feature-status-board.md)</pre></section>
<section id="test"><h2>Test Plan</h2><pre>$(read_file 04-test-plan.md)</pre><h2>Test Report</h2><pre>$(read_file 05-test-report.md)</pre></section>
<section id="bugs"><h2>Bugfix Log</h2><pre>$(read_file 06-bugfix-log.md)</pre></section>
<section id="accept"><h2>Acceptance</h2><pre>$(read_file 07-acceptance-report.md)</pre></section>
<section id="summary"><h2>Delivery Summary</h2><pre>$(read_file 08-delivery-summary.md)</pre><h2>Stage User Report</h2><pre>$(read_file 12-stage-user-report.md)</pre></section>
</div>
</main>
<script>
const buttons=document.querySelectorAll('button[data-tab]');
const sections=document.querySelectorAll('section');
buttons.forEach(btn=>btn.onclick=()=>{buttons.forEach(b=>b.classList.remove('active'));sections.forEach(s=>s.classList.remove('active'));btn.classList.add('active');document.getElementById(btn.dataset.tab).classList.add('active');});
</script>
</body>
</html>
EOF

echo "Task report generated: $out"

