#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"


tasks_dir="${1:-${REPO_ROOT}/docs/tasks}"
out_dir="${REPO_ROOT}/docs/report"
timestamp=$(date +"%Y%m%d-%H%M%S")
out="${out_dir}/metrics-${timestamp}.html"
mkdir -p "$out_dir"

total=0
bugs=0
risks=0
crs=0
reports=0

if [[ -d "$tasks_dir" ]]; then
  while IFS= read -r dir; do
    [[ -d "$dir" ]] || continue
    [[ -f "$dir/00-index.md" ]] || continue
    total=$((total + 1))
    bugs=$((bugs + $(grep -c '^| BUG-' "$dir/05-test-report.md" 2>/dev/null || echo 0)))
    risks=$((risks + $(grep -c '^| RISK-' "$dir/15-risk-register.md" 2>/dev/null || echo 0)))
    crs=$((crs + $(grep -c '^| CR-' "$dir/14-change-request-log.md" 2>/dev/null || echo 0)))
    reports=$((reports + $(ls "$dir"/stage-report-*.html 2>/dev/null | wc -l | tr -d ' ')))
  done < <(find "$tasks_dir" -mindepth 1 -maxdepth 1 -type d | sort)
fi

cat > "$out" <<EOF
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Dev Baseline Metrics</title>
<style>
body{margin:0;background:#0f172a;color:#e5e7eb;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
header{padding:32px;background:#111827;border-bottom:1px solid #334155}
main{padding:24px;max-width:1200px;margin:0 auto}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px}
.card{background:#1f2937;border:1px solid #334155;border-radius:16px;padding:18px}
.card strong{display:block;color:#38bdf8;font-size:32px}
</style>
</head>
<body>
<header><h1>Dev Baseline Metrics</h1><p>Generated at $(date '+%Y-%m-%d %H:%M:%S')</p></header>
<main>
<div class="cards">
<div class="card"><strong>${total}</strong><span>Total tasks</span></div>
<div class="card"><strong>${bugs}</strong><span>Bug rows</span></div>
<div class="card"><strong>${risks}</strong><span>Risk rows</span></div>
<div class="card"><strong>${crs}</strong><span>Change requests</span></div>
<div class="card"><strong>${reports}</strong><span>Task reports</span></div>
</div>
</main>
</body>
</html>
EOF

echo "Metrics report generated: $out"
