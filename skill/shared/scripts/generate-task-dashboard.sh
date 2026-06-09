#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

tasks_dir="${1:-${REPO_ROOT}/docs/tasks}"
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
validation=0
delivered=0

while IFS= read -r dir; do
  [[ -d "$dir" ]] || continue
  index="$dir/00-index.md"
  contract="$dir/01-task-contract.md"
  [[ -f "$index" && -f "$contract" ]] || continue

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
    readiness|ready-for-development) ready=$((ready + 1)) ;;
    in-development|self-tested) in_dev=$((in_dev + 1)) ;;
    validation|qa-testing|bugfixing|qa-passed) validation=$((validation + 1)) ;;
    delivered|accepted) delivered=$((delivered + 1)) ;;
  esac

  feature_count=$(count_pattern "$dir/01-task-contract.md" '^| FP-')
  bug_count=$(count_pattern "$dir/03-work-log.md" '^| BUG-')
  risk_count=$(count_pattern "$dir/05-governance-log.md" '^| RISK-')
  delta_count=$(count_pattern "$dir/05-governance-log.md" '^| CR-')

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
  <td>${delta_count}</td>
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
body{margin:0;background:#0f172a;color:#e5e7eb;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
header{padding:32px;background:#111827;border-bottom:1px solid #334155}
main{padding:24px;max-width:1500px;margin:0 auto}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px;margin:20px 0}
.card{background:#1f2937;border:1px solid #334155;border-radius:16px;padding:16px}
.card strong{display:block;color:#38bdf8;font-size:28px}
.card span{color:#94a3b8}
table{width:100%;border-collapse:collapse;background:#111827;border:1px solid #334155;border-radius:16px;overflow:hidden}
th,td{padding:12px;border-bottom:1px solid #334155;text-align:left;vertical-align:top}
th{background:#1f2937;color:#dbeafe}
code{color:#bae6fd} a{color:#7dd3fc}.badge{display:inline-block;padding:3px 8px;border:1px solid #334155;border-radius:999px;background:#0b1220}
.notice{color:#94a3b8;margin-top:12px}
</style>
</head>
<body>
<header>
  <h1>Dev Baseline Task Dashboard</h1>
  <p>Generated at $(date '+%Y-%m-%d %H:%M:%S') from <code>${tasks_dir}</code>.</p>
</header>
<main>
  <div class="cards">
    <div class="card"><strong>${total}</strong><span>Total compact tasks</span></div>
    <div class="card"><strong>${ready}</strong><span>Ready</span></div>
    <div class="card"><strong>${in_dev}</strong><span>In development</span></div>
    <div class="card"><strong>${validation}</strong><span>Validation / bugfix</span></div>
    <div class="card"><strong>${delivered}</strong><span>Accepted / delivered</span></div>
  </div>

  <table>
    <thead>
      <tr>
        <th>Folder</th><th>Task</th><th>Version</th><th>Status</th><th>Owner</th>
        <th>FPs</th><th>Bugs</th><th>Risks</th><th>Deltas</th><th>Report</th>
      </tr>
    </thead>
    <tbody>${rows}</tbody>
  </table>
  <p class="notice">Compact task workspaces use 00-index plus 01-07 task records.</p>
</main>
</body>
</html>
EOF

echo "Task dashboard generated: $out"
