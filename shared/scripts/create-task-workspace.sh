#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

usage() {
  echo "Usage: bash shared/scripts/create-task-workspace.sh <version> <task-name> [--update-plan]" >&2
}

version="${1:-}"
task_name="${2:-}"

if [[ -z "$version" || -z "$task_name" ]]; then
  usage
  exit 1
fi

shift 2
update_plan=false
for arg in "$@"; do
  case "$arg" in
    --update-plan)
      update_plan=true
      ;;
    *)
      echo "Unknown option: $arg" >&2
      usage
      exit 1
      ;;
  esac
done

markdown_cell() {
  printf '%s' "$1" | sed 's/|/\\|/g'
}

append_plan_index() {
  local plan_file="${REPO_ROOT}/docs/PLAN.md"
  local row task_cell next_action

  mkdir -p "$(dirname "$plan_file")"

  if [[ ! -f "$plan_file" ]]; then
    cat > "$plan_file" <<'EOF'
# Plan

## Task Index

| Task | Workspace | Status | Owner | Next action |
| --- | --- | --- | --- | --- |
EOF
  elif ! grep -q '^## Task Index' "$plan_file"; then
    cat >> "$plan_file" <<'EOF'

## Task Index

| Task | Workspace | Status | Owner | Next action |
| --- | --- | --- | --- | --- |
EOF
  elif ! grep -q '^| Task | Workspace | Status | Owner | Next action |' "$plan_file"; then
    cat >> "$plan_file" <<'EOF'

| Task | Workspace | Status | Owner | Next action |
| --- | --- | --- | --- | --- |
EOF
  fi

  if grep -Fq "${workspace_rel}" "$plan_file"; then
    echo "PLAN index already contains workspace: ${workspace_rel}"
    return 0
  fi

  task_cell=$(markdown_cell "$task_name")
  next_action="Complete readiness gates"
  row="| ${task_cell} | \`${workspace_rel}\` | drafting | Product Manager | ${next_action} |"

  local tmp
  tmp=$(mktemp)
  awk -v row="$row" '
    BEGIN { inserted = 0; saw_header = 0 }
    {
      print
      if ($0 == "| Task | Workspace | Status | Owner | Next action |") {
        saw_header = 1
        next
      }
      if (saw_header && $0 ~ /^\|[[:space:]-]+\|[[:space:]-]+\|[[:space:]-]+\|[[:space:]-]+\|[[:space:]-]+\|$/ && !inserted) {
        print row
        inserted = 1
        saw_header = 0
      }
    }
    END {
      if (!inserted) {
        print row
      }
    }
  ' "$plan_file" > "$tmp"
  mv "$tmp" "$plan_file"

  echo "PLAN index updated: docs/PLAN.md"
}

copy_compact_templates() {
  local template_dir="$1"
  local target_dir="$2"
  local compact_files=(
    "00-index.md"
    "01-task-contract.md"
    "02-delivery-plan.md"
    "03-work-log.md"
    "04-validation.md"
    "05-governance-log.md"
    "06-readiness-acceptance.md"
    "07-delivery-summary.md"
  )

  for file in "${compact_files[@]}"; do
    if [[ ! -f "$template_dir/$file" ]]; then
      echo "Missing compact task template: $template_dir/$file" >&2
      exit 1
    fi
    cp "$template_dir/$file" "$target_dir/$file"
  done
}

slug=$(printf '%s' "$task_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9一-龥]+/-/g; s/^-+|-+$//g')
date_part=$(date +"%Y%m%d")
workspace_rel="docs/tasks/${date_part}-${version}-${slug}"
workspace="${REPO_ROOT}/${workspace_rel}"
template_dir="${SHARED_ROOT}/templates/tasks"
if [[ ! -d "$template_dir" ]]; then
  template_dir="${REPO_ROOT}/shared/templates/tasks"
fi
[[ -d "$template_dir" ]] || { echo "Task templates not found: $template_dir" >&2; exit 1; }

if [[ -e "$workspace" ]]; then
  echo "Task workspace already exists: $workspace_rel" >&2
  exit 1
fi

mkdir -p "$workspace"
copy_compact_templates "$template_dir" "$workspace"

if [[ -f "$workspace/00-index.md" ]]; then
  sed -i.bak "s/- Task name:/- Task name: ${task_name}/" "$workspace/00-index.md" || true
  sed -i.bak "s/- Version:/- Version: ${version}/" "$workspace/00-index.md" || true
  sed -i.bak "s/- Created at:/- Created at: $(date '+%Y-%m-%d %H:%M:%S')/" "$workspace/00-index.md" || true
  rm -f "$workspace/00-index.md.bak"
fi

if [[ "$update_plan" == "true" ]]; then
  append_plan_index
fi

echo "Task workspace created: $workspace_rel"
