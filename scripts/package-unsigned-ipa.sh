#!/bin/bash
set -euo pipefail
xcodegen generate
xcodebuild -project Matchmaker.xcodeproj -scheme Matchmaker -configuration Release \
  -destination 'generic/platform=iOS' -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
APP=$(find build/DerivedData/Build/Products/Release-iphoneos -maxdepth 1 -name '*.app' | head -1)
test -n "$APP"
rm -rf build/Payload build/Matchmaker-unsigned.ipa
mkdir -p build/Payload
cp -R "$APP" build/Payload/
cd build && zip -qr Matchmaker-unsigned.ipa Payload && cd ..
ls -lh build/Matchmaker-unsigned.ipa
unzip -l build/Matchmaker-unsigned.ipa | head -20
