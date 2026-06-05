SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

#!/usr/bin/env bash
set -euo pipefail

# Generate a self-contained HTML project report.
# Output: docs/report/YYYYMMDD-HHMMSS.html

timestamp=$(date +"%Y%m%d-%H%M%S")
out_dir="${REPO_ROOT}/docs/report"
out_file="${out_dir}/${timestamp}.html"
mkdir -p "$out_dir"

html_escape() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

escape_text() {
  printf '%s' "$1" | html_escape
}

read_doc() {
  html_escape < "$1"
}

first_heading() {
  local path="$1"
  if [[ -f "$path" ]]; then
    sed -n 's/^#\{1,2\}[[:space:]]\+//p' "$path" | head -n 1
  fi
}

detect_stack() {
  local items=()
  [[ -f package.json ]] && items+=("Node.js / JavaScript")
  [[ -f pnpm-lock.yaml ]] && items+=("pnpm")
  [[ -f yarn.lock ]] && items+=("Yarn")
  [[ -f package-lock.json ]] && items+=("npm")
  [[ -f pom.xml ]] && items+=("Java / Maven")
  [[ -f build.gradle || -f build.gradle.kts ]] && items+=("Java/Kotlin / Gradle")
  [[ -f pyproject.toml || -f setup.py || -f requirements.txt ]] && items+=("Python")
  [[ -f go.mod ]] && items+=("Go")
  [[ -f Cargo.toml ]] && items+=("Rust")
  [[ -f Dockerfile || -f docker-compose.yml || -f compose.yml ]] && items+=("Docker")
  [[ -f Makefile ]] && items+=("Make")
  if [[ ${#items[@]} -eq 0 ]]; then
    printf 'Not detected from root files'
  else
    local IFS=', '
    printf '%s' "${items[*]}"
  fi
}

list_top_dirs() {
  find . -maxdepth 1 -mindepth 1 -type d \
    ! -name '.git' ! -name 'node_modules' ! -name 'target' ! -name 'dist' ! -name 'build' \
    -printf '%f\n' 2>/dev/null | sort | html_escape || true
}

list_entry_files() {
  find . -maxdepth 1 -type f \
    \( -name 'package.json' -o -name 'pom.xml' -o -name 'build.gradle' -o -name 'build.gradle.kts' -o -name 'pyproject.toml' -o -name 'requirements.txt' -o -name 'go.mod' -o -name 'Cargo.toml' -o -name 'Dockerfile' -o -name 'README.md' \) \
    -printf '%f\n' 2>/dev/null | sort | html_escape || true
}

available_docs() {
  {
    for path in README.md docs/PLAN.md docs/ARCHITECTURE.md docs/API.md docs/CONFIG.md docs/DEPLOY.md docs/TESTING.md docs/CHANGELOG.md; do
      if [[ -f "$path" ]]; then
        printf '%s\n' "$path"
      fi
    done
    true
  } | html_escape
}

architecture_summary() {
  if [[ -f docs/ARCHITECTURE.md ]]; then
    sed -n '1,80p' docs/ARCHITECTURE.md | html_escape
  else
    printf 'No dedicated architecture document found. The snapshot below is inferred from repository structure and root-level project files.\n' | html_escape
  fi
}

git_status=$(git status --short 2>/dev/null | html_escape || true)
git_branch=$(git branch --show-current 2>/dev/null | html_escape || true)
git_head=$(git rev-parse --short HEAD 2>/dev/null | html_escape || true)
diff_stat=$(git diff --stat 2>/dev/null | html_escape || true)
file_tree=$(find . -maxdepth 3 -type f ! -path './.git/*' ! -path './node_modules/*' ! -path './target/*' ! -path './dist/*' ! -path './build/*' | sort | html_escape)
project_name=$(basename "$(pwd)")
project_title=$(first_heading README.md)
project_title=${project_title:-$project_name}
stack_summary=$(detect_stack | html_escape)
top_dirs=$(list_top_dirs)
entry_files=$(list_entry_files)
doc_inventory=$(available_docs)
arch_summary=$(architecture_summary)
file_count=$(find . -type f ! -path './.git/*' ! -path './node_modules/*' ! -path './target/*' ! -path './dist/*' ! -path './build/*' 2>/dev/null | wc -l | tr -d ' ')
nav_file=$(mktemp)
sections_file=$(mktemp)
trap 'rm -f "$nav_file" "$sections_file"' EXIT

add_doc_tab() {
  local id="$1"
  local label="$2"
  local title="$3"
  local path="$4"
  if [[ ! -f "$path" ]]; then
    return 0
  fi
  printf '<button data-tab="%s">%s</button>\n' "$id" "$label" >> "$nav_file"
  {
    printf '<section id="%s" class="tab"><h2>%s</h2><pre>' "$id" "$title"
    read_doc "$path"
    printf '</pre></section>\n'
  } >> "$sections_file"
}

add_doc_tab readme "README" "README" README.md
add_doc_tab plan "开发计划" "开发计划" docs/PLAN.md
add_doc_tab architecture "架构" "架构说明" docs/ARCHITECTURE.md
add_doc_tab api "API" "API 文档" docs/API.md
add_doc_tab config "配置" "配置文档" docs/CONFIG.md
add_doc_tab deploy "部署" "部署文档" docs/DEPLOY.md
add_doc_tab testing "测试" "测试文档" docs/TESTING.md
add_doc_tab changelog "变更记录" "变更记录" docs/CHANGELOG.md

cat > "$out_file" <<EOF
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dev Baseline Project Report - ${timestamp}</title>
  <style>
    :root { --bg:#0f172a; --panel:#111827; --card:#1f2937; --muted:#94a3b8; --text:#e5e7eb; --accent:#38bdf8; --accent2:#a78bfa; --border:#334155; }
    *{box-sizing:border-box} body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;color:var(--text);background:radial-gradient(circle at top left,#1e3a8a 0,transparent 32rem),radial-gradient(circle at top right,#581c87 0,transparent 30rem),var(--bg);line-height:1.6}
    header{padding:3rem 2rem 2rem;border-bottom:1px solid var(--border);background:rgba(15,23,42,.76);backdrop-filter:blur(12px);position:sticky;top:0;z-index:20} h1{margin:0 0 .5rem;font-size:clamp(2rem,4vw,3rem)} .subtitle{color:var(--muted);margin:0}
    .layout{display:grid;grid-template-columns:280px 1fr;gap:1.5rem;padding:1.5rem;max-width:1500px;margin:0 auto} nav{position:sticky;top:8.5rem;align-self:start;background:rgba(17,24,39,.82);border:1px solid var(--border);border-radius:16px;padding:1rem}
    nav button{width:100%;display:block;text-align:left;border:0;border-radius:12px;color:var(--text);background:transparent;padding:.75rem .9rem;cursor:pointer;font-size:.95rem;margin-bottom:.25rem} nav button:hover,nav button.active{background:linear-gradient(90deg,rgba(56,189,248,.22),rgba(167,139,250,.18));color:white}
    main{min-width:0} section.tab{display:none;background:rgba(17,24,39,.82);border:1px solid var(--border);border-radius:18px;padding:1.25rem;box-shadow:0 18px 70px rgba(0,0,0,.25)} section.tab.active{display:block}
    .cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;margin:1rem 0}.card{background:rgba(31,41,55,.86);border:1px solid var(--border);border-radius:16px;padding:1rem}.card strong{display:block;color:var(--accent);margin-bottom:.35rem}
    pre{white-space:pre-wrap;word-break:break-word;background:#020617;border:1px solid #1e293b;border-radius:14px;padding:1rem;overflow:auto;max-height:72vh}.notice{border-left:4px solid var(--accent);padding:.75rem 1rem;background:rgba(56,189,248,.08);border-radius:12px;color:#dbeafe}
    @media(max-width:900px){header{position:static}.layout{grid-template-columns:1fr}nav{position:static}}
  </style>
</head>
<body>
  <header><h1>$(escape_text "$project_title")</h1><p class="subtitle">Dev Baseline Project Report · ${timestamp}</p></header>
  <div class="layout">
    <nav aria-label="Report sections">
      <button class="active" data-tab="overview">概览</button>
      $(cat "$nav_file")
      <button data-tab="git">Git 状态</button><button data-tab="files">文件结构</button><button data-tab="recommendations">建议</button>
    </nav>
    <main>
      <section id="overview" class="tab active"><h2>项目概览</h2><div class="cards"><div class="card"><strong>项目</strong><span>$(escape_text "$project_name")</span></div><div class="card"><strong>技术栈信号</strong><span>${stack_summary}</span></div><div class="card"><strong>当前分支</strong><span>${git_branch:-unknown}</span></div><div class="card"><strong>HEAD</strong><span>${git_head:-unknown}</span></div><div class="card"><strong>文件数</strong><span>${file_count}</span></div><div class="card"><strong>报告路径</strong><span>${out_file}</span></div></div><p class="notice">首页展示项目基本信息和基础架构快照；只有实际存在的 Markdown 文档才会作为独立章节输出。</p><h3>基础架构快照</h3><pre>${arch_summary}</pre><h3>顶层目录</h3><pre>${top_dirs:-No top-level directories detected}</pre><h3>入口/配置文件</h3><pre>${entry_files:-No common entry files detected}</pre><h3>已纳入报告的文档</h3><pre>${doc_inventory:-No standard Markdown docs detected}</pre></section>
      $(cat "$sections_file")
      <section id="git" class="tab"><h2>Git 状态</h2><h3>Branch</h3><pre>${git_branch:-unknown}</pre><h3>Status</h3><pre>${git_status:-Clean working tree or unavailable}</pre><h3>Diff stat</h3><pre>${diff_stat:-No unstaged diff or unavailable}</pre></section>
      <section id="files" class="tab"><h2>文件结构</h2><pre>${file_tree}</pre></section>
      <section id="recommendations" class="tab"><h2>建议与后续动作</h2><div class="cards"><div class="card"><strong>文档同步</strong><span>只维护当前项目真实存在的文档，避免报告输出空章节。</span></div><div class="card"><strong>风险检查</strong><span>提交前运行 secret scan 或仓库提供的安全检查。</span></div><div class="card"><strong>发布准备</strong><span>发布前确认 README、CHANGELOG、DEPLOY、TESTING 等实际存在文档。</span></div><div class="card"><strong>下一步</strong><span>根据已存在的计划或任务文档决定下一轮动作。</span></div></div></section>
    </main>
  </div>
  <script>const buttons=document.querySelectorAll('nav button[data-tab]');const tabs=document.querySelectorAll('section.tab');buttons.forEach(btn=>{btn.addEventListener('click',()=>{const target=btn.dataset.tab;buttons.forEach(b=>b.classList.remove('active'));tabs.forEach(t=>t.classList.remove('active'));btn.classList.add('active');document.getElementById(target).classList.add('active');});});</script>
</body>
</html>
EOF

echo "Report generated: $out_file"
