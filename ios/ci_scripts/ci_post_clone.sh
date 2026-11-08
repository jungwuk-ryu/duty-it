#!/bin/bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

flutter_version=$(cat .flutter-version)
export FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/flutter-$flutter_version}"
export PATH="$FLUTTER_ROOT/bin:$PATH"
if [[ ! -d "$FLUTTER_ROOT/.git" ]]; then
  git clone --depth 1 --branch "$flutter_version" https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
fi
if [[ "$(git -C "$FLUTTER_ROOT" describe --tags --exact-match HEAD)" != "$flutter_version" ]]; then
  echo "Expected Flutter $flutter_version at $FLUTTER_ROOT" >&2
  exit 1
fi

# Restore generated configuration before analyzing the app or running tests.
printf '%s' "${GOOGLESERVICE_INFO_PLIST_B64:?}" | base64 -D > ios/Runner/GoogleService-Info.plist
printf '%s' "${FIREBASE_OPTIONS_B64:?}" | base64 -D > lib/firebase_options.dart
printf '%s' "${FIREBASE_JSON_B64:?}" | base64 -D > firebase.json
printf 'server=%s\n' "${SERVER_ADDRESS:?}" > .env

flutter precache --ios
flutter pub get --enforce-lockfile
flutter analyze --no-pub
flutter test --no-pub

# Match the CocoaPods version that wrote the committed lockfile. Some Xcode
# Cloud images have only system Ruby, so use Homebrew Ruby if installation is needed.
pods_version=$(awk '$1 == "COCOAPODS:" { print $2 }' ios/Podfile.lock)
if [[ "$(pod --version 2>/dev/null || true)" != "$pods_version" ]]; then
  brew install ruby@3.3
  export GEM_HOME="$HOME/.ci-cocoapods"
  ruby_bin=$(brew --prefix ruby@3.3)/bin
  export PATH="$GEM_HOME/bin:$ruby_bin:$PATH"
  gem install --no-document cocoapods --version "$pods_version"
fi
pod install --project-directory=ios --deployment

dart pub global activate flutterfire_cli 1.3.1
flutter build ios --release --no-pub --config-only --no-codesign
git diff --exit-code -- ios/Podfile.lock pubspec.lock
