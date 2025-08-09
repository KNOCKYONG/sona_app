#!/bin/bash

# Firebase Crashlytics dSYM 업로드 스크립트
# Xcode의 Build Phases에서 실행됩니다

echo "Starting dSYM upload to Firebase Crashlytics..."

# GoogleService-Info.plist 경로
GOOGLE_SERVICE_INFO_PLIST="${PROJECT_DIR}/Runner/GoogleService-Info.plist"

# dSYM 파일 경로
DSYM_PATH="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"

# Crashlytics 업로드 스크립트 경로 (Pods를 통해 설치됨)
UPLOAD_SCRIPT="${PODS_ROOT}/FirebaseCrashlytics/upload-symbols"

# GoogleService-Info.plist 파일이 있는지 확인
if [ ! -f "$GOOGLE_SERVICE_INFO_PLIST" ]; then
    echo "Warning: GoogleService-Info.plist not found at $GOOGLE_SERVICE_INFO_PLIST"
    exit 0
fi

# dSYM 파일이 있는지 확인
if [ ! -d "$DSYM_PATH" ]; then
    echo "Warning: dSYM not found at $DSYM_PATH"
    exit 0
fi

# 업로드 스크립트가 있는지 확인
if [ ! -f "$UPLOAD_SCRIPT" ]; then
    echo "Warning: Firebase Crashlytics upload script not found at $UPLOAD_SCRIPT"
    exit 0
fi

# dSYM 업로드 실행
echo "Uploading dSYM from: $DSYM_PATH"
"$UPLOAD_SCRIPT" -gsp "$GOOGLE_SERVICE_INFO_PLIST" -p ios "$DSYM_PATH"

echo "dSYM upload completed"