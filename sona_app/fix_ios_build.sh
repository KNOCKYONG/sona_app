#!/bin/bash

echo "🔧 iOS Build Fix Script"
echo "======================="

# Flutter 경로 설정 (상위 project 폴더에 있다고 가정)
FLUTTER_PATH="/Users/nohdol/project/flutter/bin/flutter"
if [ ! -f "$FLUTTER_PATH" ]; then
    FLUTTER_PATH="/Users/nohdol/flutter/bin/flutter"
fi

# Flutter가 없으면 fvm 시도
if [ ! -f "$FLUTTER_PATH" ]; then
    echo "⚠️ Flutter not found at expected locations"
    echo "Trying fvm..."
    FLUTTER_PATH="fvm flutter"
fi

echo "📍 Using Flutter at: $FLUTTER_PATH"

# 프로젝트 루트로 이동
cd /Users/nohdol/project/app\ project/sonaapp/sona_app

echo "🧹 Step 1: Cleaning Flutter project..."
$FLUTTER_PATH clean 2>/dev/null || echo "Flutter clean failed, continuing..."

echo "📦 Step 2: Getting Flutter dependencies..."
$FLUTTER_PATH pub get 2>/dev/null || echo "Flutter pub get failed, continuing..."

echo "🍎 Step 3: Cleaning iOS build..."
cd ios

# Pods 관련 파일 모두 삭제
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm -rf Flutter/Generated.xcconfig

echo "🔄 Step 4: Regenerating iOS files..."
cd ..
$FLUTTER_PATH build ios --config-only 2>/dev/null || echo "Flutter build config failed, continuing..."

echo "📝 Step 5: Installing CocoaPods..."
cd ios

# pod가 설치되어 있는지 확인
if command -v pod &> /dev/null; then
    echo "✅ CocoaPods found"
    pod deintegrate
    pod cache clean --all
    pod install --repo-update
else
    echo "❌ CocoaPods not found. Please install it with: sudo gem install cocoapods"
fi

echo "✅ iOS build fix completed!"
echo ""
echo "📋 Next steps:"
echo "1. Open Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Try building again"
echo ""
echo "If Flutter is not in PATH, add this to your ~/.zshrc or ~/.bash_profile:"
echo "export PATH=\"\$PATH:/Users/nohdol/flutter/bin\""