#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os

# Manual translations for common untranslated keys
manual_translations = {
    "showAllGenderPersonas": {
        "en": "Show All Gender Personas",
        "ko": "모든 성별 페르소나 보기",
        "ja": "すべての性別のペルソナを表示",
        "zh": "显示所有性别角色",
        "th": "แสดงเพอร์โซน่าทุกเพศ",
        "vi": "Hiển thị tất cả giới tính personas",
        "id": "Tampilkan Semua Gender Persona",
        "es": "Mostrar personas de todos los géneros",
        "fr": "Afficher toutes les personas",
        "de": "Alle Geschlechter-Personas anzeigen",
        "ru": "Показать персонажей всех полов",
        "pt": "Mostrar personas de todos os gêneros",
        "it": "Mostra tutte le personas"
    }
}

# Get Vietnamese translations from English as reference
vietnamese_translations = {
    "totalLikes": "Tổng số lượt thích",
    "ownedHearts": "Trái tim sở hữu",
    "matchedPersonas": "Personas đã ghép đôi",
    "retryButton": "Thử lại",
    "matchingFailed": "Ghép đôi thất bại",
    "errorOccurred": "Đã xảy ra lỗi",
    "signupComplete": "Đăng ký hoàn tất",
    "accountDeletionTitle": "Xóa tài khoản",
    "continueButton": "Tiếp tục",
    "loadingData": "Đang tải dữ liệu...",
    "report": "Báo cáo",
    "reportAI": "Báo cáo AI",
    "reportAITitle": "Báo cáo cuộc trò chuyện AI",
    "later": "Sau này",
    "notEnoughHearts": "Không đủ trái tim",
    "spamAdvertising": "Spam/Quảng cáo",
    "hateSpeech": "Ngôn từ thù ghét",
    "sexualContent": "Nội dung khiêu dâm",
    "violentContent": "Nội dung bạo lực",
    "harassmentBullying": "Quấy rối/Bắt nạt",
    "detailedReason": "Lý do chi tiết",
    "permissionRequired": "Yêu cầu quyền truy cập",
    "galleryPermission": "Quyền truy cập thư viện",
    "permissionDenied": "Quyền truy cập bị từ chối",
    "openSettings": "Mở cài đặt",
    "unlimitedMessages": "Không giới hạn",
    "profileInfo": "Thông tin hồ sơ",
    "generalPersona": "Persona chung",
    "expertPersona": "Persona chuyên gia",
    "termsAgreement": "Đồng ý điều khoản",
    "preferenceSettings": "Cài đặt ưu tiên",
    "leaveChatRoom": "Rời khỏi phòng chat",
    "backButton": "Quay lại",
    "moreButton": "Xem thêm",
    "chatListTab": "Danh sách chat",
    "loginTab": "Đăng nhập",
    "signupTab": "Đăng ký",
    "emailLabel": "Email",
    "passwordLabel": "Mật khẩu",
    "sendingEmail": "Đang gửi email...",
    "endTutorial": "Kết thúc hướng dẫn",
    "profileEdit": "Chỉnh sửa hồ sơ",
    "complete": "Hoàn thành",
    "me": "Tôi",
    "storyEvent": "Sự kiện câu chuyện",
    "chooseOption": "Chọn một tùy chọn:",
    "allowPermission": "Cho phép",
    "privacySection6Title": "6. Quyền của người dùng",
    "selectTheme": "Chọn giao diện",
    "systemTheme": "Theo hệ thống"
}

def fix_specific_translations():
    """Fix specific untranslated keys in all language files"""
    languages = ["en", "ko", "ja", "zh", "th", "vi", "id", "es", "fr", "de", "ru", "pt", "it"]
    
    for lang in languages:
        file_path = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
        
        # Read existing file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        changes_made = False
        
        # Fix manual translations
        for key, translations in manual_translations.items():
            if key in data and data[key] != translations[lang]:
                old_value = data[key]
                data[key] = translations[lang]
                print(f"Fixed {key} in {lang}")
                changes_made = True
        
        # Fix Vietnamese translations specifically
        if lang == "vi":
            for key, translation in vietnamese_translations.items():
                if key in data:
                    old_value = data[key]
                    # Check if old value contains Korean
                    if any('\uAC00' <= char <= '\uD7AF' for char in str(old_value)):
                        data[key] = translation
                        print(f"Fixed Vietnamese {key}")
                        changes_made = True
        
        if changes_made:
            # Write back to file
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Updated {file_path}")

def list_remaining_korean():
    """List remaining Korean text in non-Korean files"""
    languages = ["vi", "id", "es", "fr", "de", "ru", "pt", "it"]
    
    print("\n=== Remaining Korean text in non-Korean files ===")
    
    for lang in languages:
        file_path = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(file_path):
            continue
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        korean_found = []
        for key, value in data.items():
            if not key.startswith("@") and isinstance(value, str):
                # Check if value contains Korean characters
                if any('\uAC00' <= char <= '\uD7AF' for char in value):
                    korean_found.append((key, value))
        
        if korean_found:
            print(f"\n{lang.upper()}: Found {len(korean_found)} Korean texts")
            # Show first 10 keys
            for key, value in korean_found[:10]:
                try:
                    print(f"  {key}: {value[:50]}...")
                except:
                    print(f"  {key}: [encoding error]")
            if len(korean_found) > 10:
                print(f"  ... and {len(korean_found) - 10} more")

if __name__ == "__main__":
    print("Fixing untranslated keys...")
    fix_specific_translations()
    
    print("\nChecking for remaining Korean text...")
    list_remaining_korean()
    
    print("\nDone! Run 'flutter gen-l10n' to regenerate the Dart files.")