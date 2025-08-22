#!/bin/sh
set -euxo pipefail

# 1) Flutter 설치
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
git clone -b "$FLUTTER_VERSION" https://github.com/flutter/flutter.git --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# 2) Flutter 준비
flutter --version
flutter config --no-analytics
# iOS용 아티팩트 미리 받기(첫 빌드 실패 줄이기)
flutter precache --ios

# 3) 의존성 설치
flutter pub get

# 4) CocoaPods 설치/업데이트
cd ios
# 저장소 메타 갱신(네트워크 느릴 경우 생략 가능)
pod repo update
# Pod 설치(지원 파일 및 xcfilelist 생성)
pod install