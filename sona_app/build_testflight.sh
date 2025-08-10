#!/bin/bash

echo "🚀 TestFlight Build Script for SONA App"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Flutter path
FLUTTER_PATH="/Users/nohdol/project/flutter/bin/flutter"
if [ ! -f "$FLUTTER_PATH" ]; then
    FLUTTER_PATH="/Users/nohdol/flutter/bin/flutter"
fi

# Check if Flutter exists
if [ ! -f "$FLUTTER_PATH" ]; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter first.${NC}"
    echo "You can also use: fvm flutter build ios --release"
    exit 1
fi

# Project directory
PROJECT_DIR="/Users/nohdol/project/app project/sonaapp/sona_app"
cd "$PROJECT_DIR"

echo -e "${YELLOW}📱 Building iOS Release for TestFlight...${NC}"
echo ""

# Step 1: Clean build
echo -e "${GREEN}1️⃣ Cleaning previous builds...${NC}"
$FLUTTER_PATH clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock

# Step 2: Get dependencies
echo -e "${GREEN}2️⃣ Getting Flutter dependencies...${NC}"
$FLUTTER_PATH pub get

# Step 3: Build iOS release
echo -e "${GREEN}3️⃣ Building iOS release...${NC}"
$FLUTTER_PATH build ios --release --no-codesign

# Step 4: Pod install
echo -e "${GREEN}4️⃣ Installing CocoaPods...${NC}"
cd ios
pod install --repo-update
cd ..

echo ""
echo -e "${GREEN}✅ Build preparation completed!${NC}"
echo ""
echo "📋 Next steps for TestFlight upload:"
echo "======================================"
echo ""
echo "1. Open Xcode:"
echo "   open ios/Runner.xcworkspace"
echo ""
echo "2. In Xcode:"
echo "   a. Select 'Runner' in the project navigator"
echo "   b. Select 'Runner' target"
echo "   c. Go to 'Signing & Capabilities'"
echo "   d. Ensure 'Automatically manage signing' is checked"
echo "   e. Select your Team (3VXN83XNN5)"
echo ""
echo "3. Update version and build number:"
echo "   a. In 'General' tab"
echo "   b. Version: Update if needed (current in pubspec.yaml)"
echo "   c. Build: Increment by 1"
echo ""
echo "4. Create Archive:"
echo "   a. Select 'Any iOS Device (arm64)' as destination"
echo "   b. Menu: Product > Archive"
echo "   c. Wait for archive to complete (5-10 minutes)"
echo ""
echo "5. Upload to TestFlight:"
echo "   a. In Organizer window (opens automatically)"
echo "   b. Select your archive"
echo "   c. Click 'Distribute App'"
echo "   d. Select 'App Store Connect'"
echo "   e. Select 'Upload'"
echo "   f. Follow the prompts"
echo ""
echo "6. TestFlight Processing:"
echo "   a. Wait 10-30 minutes for processing"
echo "   b. Check email for completion"
echo "   c. Add testers in App Store Connect"
echo ""
echo "⚠️ Important reminders:"
echo "  - Ensure you have valid Apple Developer account"
echo "  - Bundle ID: com.nohbrother.teamsona.chatapp"
echo "  - Team ID: 3VXN83XNN5"
echo "  - Check that all app icons are present"
echo ""

# Open Xcode automatically
read -p "Do you want to open Xcode now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open ios/Runner.xcworkspace
fi