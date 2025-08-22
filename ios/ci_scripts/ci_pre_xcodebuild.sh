#!/bin/sh
set -euxo pipefail

# Ensure repo root and Flutter env regardless of where this runs
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || cd ../.. && pwd)"
export FLUTTER_ROOT="$REPO_ROOT/.flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Pre-build to generate necessary files; no code signing
cd "$REPO_ROOT"
flutter build ios --no-codesign --release