#!/usr/bin/env bash
set -euo pipefail

tasks_dir="${1:-docs/tasks}"
out="${tasks_dir}/dashboard.html"

if [[ ! -d "$tasks_dir" ]]; then
  echo "Task directory not found: $tasks_dir" >&2
  exit 1
fi

html_escape() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

extract_field() {
  local file="$1"
  local label="$2"
  if [[ -f "$file" ]]; then
    grep -E "^- ${label}:" "$file" | head -n 1 | sed -E "s/^- ${label}:[[:space:]]*//" | html_escape
  fi
}

count_pattern() {
  local file="$1"
  local pattern="$2"
  if [[ -f "$file" ]]; then
    grep -Ec "$pattern" "$file" 2>/dev/null || echo 0
  else
    echo 0
  fi
}

latest_report() {
  local dir="$1"
  local report
  report=$(ls -1 "$dir"/stage-report-*.html 2>/dev/null | sort | tail -n 1 || true)
  if [[ -n "$report" ]]; then
    printf '%s' "$report" | sed "s#^${tasks_dir}/##" | html_escape
  fi
}

rows=""
total=0
ready=0
in_dev=0
qa=0
delivered=0

while IFS= read -r dir; do
  [[ -d "$dir" ]] || continue
  index="$dir/00-index.md"
  [[ -f "$index" ]] || continue

  total=$((total + 1))

  folder=$(basename "$dir" | html_escape)
  task_name=$(extract_field "$index" "Task name")
  version=$(extract_field "$index" "Version")
  status=$(extract_field "$index" "Current status")
  owner=$(extract_field "$index" "Current owner")

  [[ -n "$task_name" ]] || task_name="$folder"
  [[ -n "$version" ]] || version="-"
  [[ -n "$status" ]] || status="unknown"
  [[ -n "$owner" ]] || owner="-"

  case "$status" in
    ready-for-development) ready=$((ready + 1)) ;;
    in-development|self-tested) in_dev=$((in_dev + 1)) ;;
    qa-testing|bugfixing|qa-passed) qa=$((qa + 1)) ;;
    delivered|accepted) delivered=$((delivered + 1)) ;;
  esac

  feature_count=$(count_pattern "$dir/09-feature-status-board.md" '^| FP-')
  bug_count=$(count_pattern "$dir/05-test-report.md" '^| BUG-')
  risk_count=$(count_pattern "$dir/15-risk-register.md" '^| RISK-')
  cr_count=$(count_pattern "$dir/14-change-request-log.md" '^| CR-')
  report=$(latest_report "$dir")

  report_cell="-"
  if [[ -n "$report" ]]; then
    report_cell="<a href=\"${report}\">latest report</a>"
  fi

  rows+=$(cat <<EOF
<tr>
  <td><code>${folder}</code></td>
  <td>${task_name}</td>
  <td>${version}</td>
  <td><span class="badge">${status}</span></td>
  <td>${owner}</td>
  <td>${feature_count}</td>
  <td>${bug_count}</td>
  <td>${risk_count}</td>
  <td>${cr_count}</td>
  <td>${report_cell}</td>
</tr>
EOF
)

done < <(find "$tasks_dir" -mindepth 1 -maxdepth 1 -type d | sort)

cat > "$out" <<EOF
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Dev Baseline Task Dashboard</title>
<style>
:root{--bg:#0f172a;--panel:#111827;--card:#1f2937;--text:#e5e7eb;--muted:#94a3b8;--border:#334155;--accent:#38bdf8}
body{margin:0;background:radial-gradient(circle at top left,#1e3a8a 0,transparent 30rem),var(--bg);color:var(--text);font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
header{padding:32px;background:rgba(17,24,39,.86);border-bottom:1px solid var(--border)}
main{padding:24px;max-width:1500px;margin:0 auto}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px;margin:20px 0}
.card{background:rgba(31,41,55,.9);border:1px solid var(--border);border-radius:16px;padding:16px}
.card strong{display:block;color:var(--accent);font-size:28px}
.card span{color:var(--muted)}
table{width:100%;border-collapse:collapse;background:rgba(17,24,39,.9);border:1px solid var(--border);border-radius:16px;overflow:hidden}
th,td{padding:12px;border-bottom:1px solid var(--border);text-align:left;vertical-align:top}
th{background:#1f2937;color:#dbeafe}
tr:hover{background:#172033}
code{color:#bae6fd}
a{color:#7dd3fc}
.badge{display:inline-block;padding:3px 8px;border:1px solid var(--border);border-radius:999px;background:#0b1220}
.notice{color:var(--muted);margin-top:12px}
</style>
</head>
<body>
<header>
  <h1>Dev Baseline Task Dashboard</h1>
  <p>Generated at $(date '+%Y-%m-%d %H:%M:%S') from <code>${tasks_dir}</code>.</p>
</header>
<main>
  <div class="cards">
    <div class="card"><strong>${total}</strong><span>Total tasks</span></div>
    <div class="card"><strong>${ready}</strong><span>Ready for development</span></div>
    <div class="card"><strong>${in_dev}</strong><span>In development</span></div>
    <div class="card"><strong>${qa}</strong><span>QA / bugfix</span></div>
    <div class="card"><strong>${delivered}</strong><span>Accepted / delivered</span></div>
  </div>

  <table>
    <thead>
      <tr>
        <th>Folder</th>
        <th>Task</th>
        <th>Version</th>
        <th>Status</th>
        <th>Owner</th>
        <th>Features</th>
        <th>Bugs</th>
        <th>Risks</th>
        <th>CRs</th>
        <th>Report</th>
      </tr>
    </thead>
    <tbody>
      ${rows}
    </tbody>
  </table>

  <p class="notice">Tip: use <code>/dev-baseline-task-status &lt;workspace&gt;</code> to inspect a task in detail.</p>
</main>
</body>
</html>
EOF

echo "Task dashboard generated: $out"
