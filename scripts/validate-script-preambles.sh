#!/usr/bin/env bash
set -euo pipefail

files=(shared/scripts/*.sh skill/shared/scripts/*.sh scripts/*.sh)

for file in "${files[@]}"; do
  [[ -f "$file" ]] || continue
  first_line="$(head -n 1 "$file")"
  first_line="${first_line%$'\r'}"
  if [[ "$first_line" != '#!/usr/bin/env bash' ]]; then
    echo "Invalid shebang position: $file" >&2
    exit 1
  fi
done

for file in "${files[@]}"; do
  [[ -f "$file" ]] || continue
  bash -n "$file"
done

if grep -R -n --exclude=validate-script-preambles.sh 'local path="cd ' shared/scripts skill/shared/scripts scripts; then
  echo "Broken resolve_project_path implementation found." >&2
  exit 1
fi

if grep -R -n -E --exclude=validate-script-preambles.sh 'SCRIPT_DIR=\\"|SHARED_ROOT=\\"|REPO_ROOT=\\"|cd \\"[$]REPO_ROOT' shared/scripts skill/shared/scripts scripts; then
  echo "Escaped quote path resolver found." >&2
  exit 1
fi

printf 'Script preambles OK.\n'
