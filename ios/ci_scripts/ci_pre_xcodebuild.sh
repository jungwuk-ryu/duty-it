#!/bin/sh
set -euxo pipefail

# 0) Move to repo root (works even when this script is in ios/ci_scripts)
REPO_ROOT="$(git rev-parse --show-toplevel)"
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

# 4) Install necessary Ruby gems locally (NO sudo, safe with `set -u`)
export GEM_HOME="${HOME}/.gem"
export PATH="${GEM_HOME}/bin:${PATH}"
export GEM_PATH="${GEM_HOME}:${GEM_PATH:-}"

# Crashlytics/xcodeproj requires modern rexml; install locally
gem install --no-document rexml -v 3.3.6
gem install --no-document xcodeproj -v 1.24.0
# Optional: some environments need ffi present; install if missing
gem install --no-document ffi -v 1.17.0 || true

# 5) CocoaPods from the correct ios directory
cd "$REPO_ROOT/ios"

# (Optional but recommended) unlock stale constraints to avoid version pin mismatches
rm -f Podfile.lock

# (Optional) If you need to pin Firebase iOS SDK for GTMSessionFetcher compatibility,
# set FIREBASE_SDK_VERSION (e.g., 10.2.0) in Xcode Cloud environment variables.
if [ -n "${FIREBASE_SDK_VERSION:-}" ]; then
  ruby -e "
    path = 'Podfile';
    txt = File.read(path);
    if txt =~ /\\$FirebaseSDKVersion/
      txt.gsub!(/\\$FirebaseSDKVersion\\s*=\\s*'.*?'/, \"\\$FirebaseSDKVersion = '${FIREBASE_SDK_VERSION}'\");
    else
      txt = \"\\$FirebaseSDKVersion = '${FIREBASE_SDK_VERSION}'\\n\" + txt
    end
    File.write(path, txt)
  "
fi

# Update specs and install pods
pod repo update
pod install --repo-update
