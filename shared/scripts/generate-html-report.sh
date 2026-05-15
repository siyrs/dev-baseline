#!/usr/bin/env bash
set -euo pipefail

# Generate a self-contained HTML project report.
# Output: docs/report/YYYYMMDD-HHMMSS.html

timestamp=$(date +"%Y%m%d-%H%M%S")
out_dir="docs/report"
out_file="${out_dir}/${timestamp}.html"
mkdir -p "$out_dir"

html_escape() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

read_doc() {
  local path="$1"
  if [[ -f "$path" ]]; then
    html_escape < "$path"
  else
    printf 'Not found: %s\n' "$path" | html_escape
  fi
}

git_status=$(git status --short 2>/dev/null | html_escape || true)
git_branch=$(git branch --show-current 2>/dev/null | html_escape || true)
diff_stat=$(git diff --stat 2>/dev/null | html_escape || true)
file_tree=$(find . -maxdepth 3 -type f ! -path './.git/*' ! -path './node_modules/*' ! -path './target/*' ! -path './dist/*' ! -path './build/*' | sort | html_escape)

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
  <header><h1>Dev Baseline Project Report</h1><p class="subtitle">Generated at ${timestamp}. Self-contained HTML report with tabs for project status, docs, git state, risks and next actions.</p></header>
  <div class="layout">
    <nav aria-label="Report sections">
      <button class="active" data-tab="overview">概览</button><button data-tab="plan">开发计划</button><button data-tab="architecture">架构</button><button data-tab="api">API</button><button data-tab="config">配置</button><button data-tab="deploy">部署</button><button data-tab="testing">测试</button><button data-tab="changelog">变更记录</button><button data-tab="git">Git 状态</button><button data-tab="files">文件结构</button><button data-tab="recommendations">建议</button>
    </nav>
    <main>
      <section id="overview" class="tab active"><h2>项目概览</h2><div class="cards"><div class="card"><strong>当前分支</strong><span>${git_branch:-unknown}</span></div><div class="card"><strong>报告路径</strong><span>${out_file}</span></div><div class="card"><strong>报告格式</strong><span>HTML tabs, self-contained</span></div></div><p class="notice">本报告适合给项目负责人、开发者、评审者快速理解当前项目状态。它不会修改业务代码。</p><h3>README</h3><pre>$(read_doc README.md)</pre></section>
      <section id="plan" class="tab"><h2>开发计划</h2><pre>$(read_doc docs/PLAN.md)</pre></section>
      <section id="architecture" class="tab"><h2>架构说明</h2><pre>$(read_doc docs/ARCHITECTURE.md)</pre></section>
      <section id="api" class="tab"><h2>API 文档</h2><pre>$(read_doc docs/API.md)</pre></section>
      <section id="config" class="tab"><h2>配置文档</h2><pre>$(read_doc docs/CONFIG.md)</pre></section>
      <section id="deploy" class="tab"><h2>部署文档</h2><pre>$(read_doc docs/DEPLOY.md)</pre></section>
      <section id="testing" class="tab"><h2>测试文档</h2><pre>$(read_doc docs/TESTING.md)</pre></section>
      <section id="changelog" class="tab"><h2>变更记录</h2><pre>$(read_doc docs/CHANGELOG.md)</pre></section>
      <section id="git" class="tab"><h2>Git 状态</h2><h3>Branch</h3><pre>${git_branch:-unknown}</pre><h3>Status</h3><pre>${git_status:-Clean working tree or unavailable}</pre><h3>Diff stat</h3><pre>${diff_stat:-No unstaged diff or unavailable}</pre></section>
      <section id="files" class="tab"><h2>文件结构</h2><pre>${file_tree}</pre></section>
      <section id="recommendations" class="tab"><h2>建议与后续动作</h2><div class="cards"><div class="card"><strong>文档同步</strong><span>检查 API、CONFIG、DEPLOY、CHANGELOG 是否与代码变化一致。</span></div><div class="card"><strong>风险检查</strong><span>提交前运行 shared/scripts/check-secrets.sh。</span></div><div class="card"><strong>发布准备</strong><span>发布前确认 CHANGELOG、DEPLOY、TESTING。</span></div><div class="card"><strong>下一步</strong><span>根据 docs/PLAN.md 中的 Todo 和 Blocked 决定下一轮迭代。</span></div></div></section>
    </main>
  </div>
  <script>const buttons=document.querySelectorAll('nav button[data-tab]');const tabs=document.querySelectorAll('section.tab');buttons.forEach(btn=>{btn.addEventListener('click',()=>{const target=btn.dataset.tab;buttons.forEach(b=>b.classList.remove('active'));tabs.forEach(t=>t.classList.remove('active'));btn.classList.add('active');document.getElementById(target).classList.add('active');});});</script>
</body>
</html>
EOF

echo "Report generated: $out_file"
