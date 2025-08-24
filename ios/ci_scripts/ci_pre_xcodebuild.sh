#!/bin/sh
set -euxo pipefail

# Ensure repo root and Flutter env regardless of where this runs
REPO_ROOT="$(git rev-parse --show-toplevel)"
export FLUTTER_ROOT="$REPO_ROOT/.flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Pre-build to generate necessary files; no code signing
cd "$REPO_ROOT"
./.flutter/bin/dart pub global activate flutterfire_cli
export PATH="$PATH:/Users/local/.pub-cache/bin"

cat > .env <<'EOF'
server=${SERVER_ADDRESS}
EOF

flutter build ios --no-codesign --release