#!/bin/bash

# 수동으로 dSYM 파일을 Firebase Crashlytics에 업로드하는 스크립트

echo "Manual dSYM upload to Firebase Crashlytics"
echo "==========================================="

# Firebase Crashlytics CLI 경로
UPLOAD_SYMBOLS="${PODS_ROOT:-Pods}/FirebaseCrashlytics/upload-symbols"

# 대체 경로들
if [ ! -f "$UPLOAD_SYMBOLS" ]; then
    UPLOAD_SYMBOLS="./Pods/FirebaseCrashlytics/upload-symbols"
fi

if [ ! -f "$UPLOAD_SYMBOLS" ]; then
    echo "Error: upload-symbols not found. Please run 'pod install' first."
    exit 1
fi

# GoogleService-Info.plist 경로
GOOGLE_SERVICE_INFO_PLIST="./Runner/GoogleService-Info.plist"

if [ ! -f "$GOOGLE_SERVICE_INFO_PLIST" ]; then
    echo "Error: GoogleService-Info.plist not found at $GOOGLE_SERVICE_INFO_PLIST"
    exit 1
fi

# dSYM 파일 찾기
echo "Looking for dSYM files..."

# Build 디렉토리에서 dSYM 파일 찾기
DSYM_FILES=$(find ~/Library/Developer/Xcode/DerivedData -name "Runner.app.dSYM" -type d 2>/dev/null | head -1)

if [ -z "$DSYM_FILES" ]; then
    echo "No dSYM files found in DerivedData"
    echo ""
    echo "To generate dSYM files:"
    echo "1. Open Xcode"
    echo "2. Select Runner target"
    echo "3. Build Settings > Debug Information Format"
    echo "4. Set to 'DWARF with dSYM File' for Release configuration"
    echo "5. Archive the app (Product > Archive)"
    exit 1
fi

echo "Found dSYM: $DSYM_FILES"
echo ""
echo "Uploading to Firebase Crashlytics..."

# dSYM 업로드
"$UPLOAD_SYMBOLS" -gsp "$GOOGLE_SERVICE_INFO_PLIST" -p ios "$DSYM_FILES"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ dSYM upload completed successfully!"
    echo ""
    echo "dSYM UUID: 83027C12-70AE-3AF4-91F2-B1F2011A2158"
else
    echo ""
    echo "❌ dSYM upload failed. Please check the error messages above."
fi