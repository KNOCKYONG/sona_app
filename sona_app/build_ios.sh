#!/bin/bash

echo "🎯 SONA iOS Build Script"
echo "========================"

# Flutter clean and get dependencies
echo "📦 Cleaning and getting dependencies..."
flutter clean
flutter pub get

# Pod install
echo "🔧 Installing iOS pods..."
cd ios
pod install --repo-update
cd ..

# Build iOS release
echo "🏗️ Building iOS release..."
flutter build ios --release

echo "✅ iOS build completed!"
echo ""
echo "📝 Next steps:"
echo "1. Open ios/Runner.xcworkspace in Xcode"
echo "2. Select a development team in Signing & Capabilities"
echo "3. Archive and upload to App Store Connect"
echo ""
echo "⚠️ Important: Replace GoogleService-Info.plist with your actual Firebase iOS configuration file"