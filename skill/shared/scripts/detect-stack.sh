#!/usr/bin/env bash
set -euo pipefail

# Detect common project stack clues.

echo "# Stack Detection"

[[ -f package.json ]] && echo "- Node.js project: package.json"
[[ -f pnpm-lock.yaml ]] && echo "- Package manager: pnpm"
[[ -f yarn.lock ]] && echo "- Package manager: yarn"
[[ -f package-lock.json ]] && echo "- Package manager: npm"
[[ -f pom.xml ]] && echo "- Java Maven project: pom.xml"
[[ -f build.gradle || -f build.gradle.kts ]] && echo "- Java/Gradle project"
[[ -f requirements.txt ]] && echo "- Python requirements.txt"
[[ -f pyproject.toml ]] && echo "- Python pyproject.toml"
[[ -f go.mod ]] && echo "- Go module: go.mod"
[[ -f Cargo.toml ]] && echo "- Rust project: Cargo.toml"
[[ -f Dockerfile ]] && echo "- Dockerfile present"
ls docker-compose*.yml docker-compose*.yaml >/dev/null 2>&1 && echo "- Docker Compose present"
[[ -d src/main/java ]] && echo "- Spring/Java source layout detected"
[[ -d src ]] && echo "- src directory present"
[[ -d tests || -d test ]] && echo "- test directory present"
[[ -d frontend ]] && echo "- frontend directory present"
[[ -d backend ]] && echo "- backend directory present"
[[ -d docs ]] && echo "- docs directory present"
