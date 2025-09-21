#!/bin/sh
set -euxo pipefail

# Ensure repo root and Flutter env regardless of where this runs
REPO_ROOT="$(git rev-parse --show-toplevel)"
export FLUTTER_ROOT="$REPO_ROOT/.flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# firebase
PLIST_PATH="$REPO_ROOT/ios/Runner/GoogleService-Info.plist"
echo "$GOOGLESERVICE_INFO_PLIST_B64" | base64 -D > "$PLIST_PATH"
echo "Wrote GoogleService-Info.plist to $PLIST_PATH"

FB_OPTIONS_PATH="$REPO_ROOT/lib/firebase_options.dart"
echo "$FIREBASE_OPTIONS_B64" | base64 -D > "$FB_OPTIONS_PATH"
echo "Wrote firebase_options.dart to $FB_OPTIONS_PATH"

FIREBASE_JSON_PATH="$REPO_ROOT/firebase.json"
echo "$FIREBASE_JSON_B64" | base64 -D > "$FIREBASE_JSON_PATH"
echo "Wrote firebase.json to $FIREBASE_JSON_PATH"

# Pre-build to generate necessary files; no code signing
cd "$REPO_ROOT"
./.flutter/bin/dart pub global activate flutterfire_cli
export PATH="$PATH:/Users/local/.pub-cache/bin"

cat > .env <<EOF
server=${SERVER_ADDRESS}
EOF

flutter build ios --no-codesign --release