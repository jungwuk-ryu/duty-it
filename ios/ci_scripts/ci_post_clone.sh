#!/bin/sh
set -euxo pipefail

# 0) Move to repo root (works even when this script is in ios/ci_scripts)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || cd ../.. && pwd)"
cd "$REPO_ROOT"

# 1) Install Flutter
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
if [ ! -d "$REPO_ROOT/.flutter" ]; then
  git clone -b "$FLUTTER_VERSION" https://github.com/flutter/flutter.git --depth 1 "$REPO_ROOT/.flutter"
fi

export FLUTTER_ROOT="$REPO_ROOT/.flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# 2) Prepare Flutter
flutter --version
flutter config --no-analytics
# Precache iOS artifacts to avoid first-build failures
flutter precache --ios

# 3) Fetch Dart/Flutter dependencies
flutter pub get

# 4) CocoaPods install from the correct ios directory
cd "$REPO_ROOT/ios"
pod install --repo-update