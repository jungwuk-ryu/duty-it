#!/bin/sh
set -euxo pipefail
export PATH="$PWD/flutter/bin:$PATH"

# 코드서명 없이 빌드(생성 파일 보장)
flutter build ios --no-codesign --release