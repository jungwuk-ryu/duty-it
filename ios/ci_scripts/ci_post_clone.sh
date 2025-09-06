#!/bin/sh
set -euxo pipefail

# 0) Move to repo root
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

# 3) Fetch Dart/Flutter dependencies
flutter pub get

# 4) Install Ruby gems locally (no sudo)
export GEM_HOME="${HOME}/.gem"
export PATH="${GEM_HOME}/bin:${PATH}"
export GEM_PATH="${GEM_HOME}:${GEM_PATH:-}"

gem install --no-document rexml -v 3.3.6
gem install --no-document xcodeproj -v 1.24.0
gem install --no-document ffi -v 1.17.0 || true

# 5) CocoaPods
cd "$REPO_ROOT/ios"
rm -f Podfile.lock
pod repo update

# (선택) Xcode Cloud 환경변수로 Firebase iOS SDK 버전 고정 (예: FIREBASE_SDK_VERSION=10.2.0)
if [ -n "${FIREBASE_SDK_VERSION:-}" ]; then
  /usr/bin/ruby <<'RUBY'
path = 'Podfile'
pin  = ENV['FIREBASE_SDK_VERSION']
txt  = File.read(path)

if txt.match?(/\$FirebaseSDKVersion/)
  # 기존 선언 교체
  txt.gsub!(/\$FirebaseSDKVersion\s*=\s*'.*?'/, "$FirebaseSDKVersion = '#{pin}'")
else
  # 맨 위에 추가
  txt = "$FirebaseSDKVersion = '#{pin}'\n" + txt
end

File.write(path, txt)
RUBY
fi

pod install --repo-update
