#!/usr/bin/env bash
set -euo pipefail

echo "postCreate - start"

flutter pub get

export PATH="$PATH:$HOME/.pub-cache/bin:/root/.pub-cache/bin"

which flutterfire || dart pub global activate flutterfire_cli

flutterfire configure \
  --project=${FIREBASE_PROJECT_ID} \
  --platforms=android,ios,web \
  --out=lib/firebase_options.dart \
  --yes

echo "postCreate - done"
