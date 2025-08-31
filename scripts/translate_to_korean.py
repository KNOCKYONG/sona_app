#!/usr/bin/env python3
"""
Translate TODO items to Korean in app_ko.arb file.
"""

import json
import sys
from pathlib import Path

# 한국어 번역 매핑
TRANSLATIONS = {
    "purchaseConfirmMessage": "{title}을(를) {price}에 구매하시겠습니까? {description}",
    "purchaseConfirmContent": "{product}을(를) {price}에 구매하시겠습니까?",
    "daysAgo": "{count}일 전",
    "hoursAgo": "{count}시간 전",
    "minutesAgo": "{count}분 전",
    "accountDeletedSuccess": "계정이 성공적으로 삭제되었습니다",
    "accountDeletionInfo": "계정 삭제 안내",
    "accountDeletionWarning1": "경고: 이 작업은 되돌릴 수 없습니다",
    "accountDeletionWarning2": "모든 데이터가 영구적으로 삭제됩니다",
    "accountDeletionWarning3": "모든 대화 기록에 접근할 수 없게 됩니다",
    "accountDeletionWarning4": "구매한 모든 콘텐츠가 포함됩니다",
    "agreeToTerms": "약관에 동의합니다",
    "appTagline": "당신의 AI 친구들",
    "changeProfilePhoto": "프로필 사진 변경",
    "checkInternetConnection": "인터넷 연결을 확인해주세요",
    "copyrightInfringement": "저작권 침해",
    "currentLanguage": "현재 언어",
    "dailyLimitDescription": "일일 메시지 한도에 도달했습니다",
    "dailyLimitTitle": "일일 한도 도달",
    "deleteAccountWarning": "정말로 계정을 삭제하시겠습니까?",
    "deletingAccount": "계정 삭제 중...",
    "effectSoundDescription": "효과음 재생",
    "emotionBasedEncounters": "감정 기반 만남",
    "enterNickname": "닉네임을 입력해주세요",
    "enterPassword": "비밀번호를 입력해주세요",
    "errorDescription": "오류 설명",
    "guestLoginPromptMessage": "대화를 계속하려면 로그인하세요",
    "heartDescription": "더 많은 메시지를 위한 하트",
    "inappropriateContent": "부적절한 콘텐츠",
    "incorrectPassword": "잘못된 비밀번호",
    "invalidEmailFormat": "잘못된 이메일 형식",
    "invalidEmailFormatError": "올바른 이메일 주소를 입력해주세요",
    "lastUpdated": "마지막 업데이트",
    "loadingProducts": "상품 불러오는 중...",
    "loginComplete": "로그인 완료",
    "loginFailed": "로그인 실패",
    "loginFailedTryAgain": "로그인 실패. 다시 시도해주세요.",
    "loginRequiredService": "이 서비스를 이용하려면 로그인이 필요합니다",
    "loginWithApple": "Apple로 로그인",
    "loginWithGoogle": "Google로 로그인",
    "logoutConfirm": "정말로 로그아웃하시겠습니까?",
    "meetNewPersonas": "새로운 페르소나 만나기",
    "messageLimitReset": "메시지 한도는 자정에 초기화됩니다",
    "newMessageNotification": "새 메시지 알림",
    "nicknameAlreadyUsed": "이미 사용 중인 닉네임입니다",
    "nicknameHelperText": "3-10자",
    "nicknameInUse": "이미 사용 중인 닉네임입니다",
    "nicknameLabel": "닉네임",
    "nicknameLengthError": "닉네임은 3-10자여야 합니다",
    "nicknamePlaceholder": "닉네임을 입력하세요",
    "noConversationYet": "아직 대화가 없습니다",
    "noMatchedPersonas": "아직 매칭된 페르소나가 없습니다",
    "noTranslatedMessages": "번역할 메시지가 없습니다",
    "notificationPermissionRequired": "알림 권한이 필요합니다",
    "notificationSettings": "알림 설정",
    "passwordConfirmation": "확인을 위해 비밀번호를 입력하세요",
    "personalInfoExposure": "개인정보 노출",
    "privacyPolicyAgreement": "개인정보 처리방침에 동의해주세요",
    "weekdays": "일,월,화,수,목,금,토"
}

# 추가 번역 (Privacy & Terms)
PRIVACY_TERMS = {
    "privacySection1Content": "저희는 귀하의 개인정보를 보호하기 위해 최선을 다하고 있습니다. 본 개인정보 처리방침은 귀하가 서비스를 이용할 때 저희가 정보를 수집, 사용, 보호하는 방법을 설명합니다.",
    "privacySection2Content": "저희는 귀하가 계정을 생성하거나, 프로필을 업데이트하거나, 서비스를 이용할 때 직접 제공하는 정보를 수집합니다.",
    "privacySection2Title": "수집하는 정보",
    "privacySection3Content": "저희는 서비스를 제공, 유지, 개선하고 귀하와 소통하기 위해 수집한 정보를 사용합니다.",
    "privacySection4Content": "저희는 귀하의 동의 없이 개인정보를 제3자에게 판매, 거래 또는 전송하지 않습니다.",
    "privacySection5Content": "저희는 무단 액세스, 변경, 공개 또는 파괴로부터 귀하의 개인정보를 보호하기 위해 적절한 보안 조치를 구현합니다.",
    "privacySection6Content": "저희는 서비스 제공 및 법적 의무 준수에 필요한 기간 동안 개인정보를 보관합니다.",
    "privacySection7Content": "귀하는 언제든지 계정 설정을 통해 개인정보에 접근, 업데이트 또는 삭제할 권리가 있습니다.",
    "privacySection7Title": "귀하의 권리",
    "privacySection8Content": "본 개인정보 처리방침에 대한 질문이 있으시면 support@sona.com으로 문의해주세요.",
    "privacySection8Title": "문의하기"
}

# 추가 번역 (Purchase & Store)
PURCHASE_STORE = {
    "problemMessage": "문제",
    "profilePhotoUpdateFailed": "프로필 사진 업데이트 실패",
    "profilePhotoUpdated": "프로필 사진이 업데이트되었습니다",
    "profileUpdateFailed": "프로필 업데이트 실패",
    "profileUpdated": "프로필이 성공적으로 업데이트되었습니다",
    "purchaseAndRefundPolicy": "구매 및 환불 정책",
    "purchaseFailed": "구매 실패",
    "purchasePending": "구매 처리 중...",
    "purchasePolicy": "구매 정책",
    "purchaseSection1Content": "신용카드 및 디지털 지갑을 포함한 다양한 결제 수단을 지원합니다.",
    "purchaseSection1Title": "결제 수단",
    "purchaseSection2Content": "구매한 아이템을 사용하지 않은 경우 구매일로부터 14일 이내에 환불이 가능합니다.",
    "purchaseSection2Title": "환불 정책",
    "purchaseSection3Content": "계정 설정을 통해 언제든지 구독을 취소할 수 있습니다.",
    "purchaseSection3Title": "취소",
    "purchaseSection4Content": "구매 시 이용약관 및 서비스 계약에 동의하는 것으로 간주됩니다.",
    "purchaseSection4Title": "이용약관",
    "purchaseSection5Content": "구매 관련 문제는 고객 지원팀에 문의해주세요.",
    "purchaseSection5Title": "고객 지원",
    "purchaseSection6Content": "모든 구매는 표준 약관이 적용됩니다."
}

def main():
    # Set UTF-8 encoding for Windows console
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
    
    # Path to Korean ARB file
    arb_file = Path("sona_app/lib/l10n/app_ko.arb")
    
    if not arb_file.exists():
        print(f"Error: {arb_file} not found")
        sys.exit(1)
    
    # Load the ARB file
    with open(arb_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Combine all translations
    all_translations = {**TRANSLATIONS, **PRIVACY_TERMS, **PURCHASE_STORE}
    
    # Update TODO items with Korean translations
    updated_count = 0
    for key, korean_value in all_translations.items():
        if key in data:
            if "[TODO-KO]" in data[key]:
                data[key] = korean_value
                updated_count += 1
                print(f"[OK] Translated: {key}")
    
    # Save the updated file
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"\n[Summary] Updated {updated_count} translations")
    
    # Regenerate localization files
    import os
    print("\n[Regenerating] Localization files...")
    result = os.system("cd sona_app && flutter gen-l10n")
    if result == 0:
        print("[OK] Localization files regenerated successfully")
    else:
        print("[WARNING] Error regenerating localization files")

if __name__ == "__main__":
    main()