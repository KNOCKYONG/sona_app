#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Add missing localization keys for hardcoded strings
"""

import json

# New keys to add for hardcoded strings
new_keys = {
    'startChatWithPersona': {
        'en': 'Start a conversation with {personaName}?',
        'ko': '{personaName}과(와) 대화를 시작하시겠습니까?',
        'ja': '{personaName}と会話を始めますか？',
        'zh': '要与{personaName}开始对话吗？',
        'de': 'Gespräch mit {personaName} beginnen?',
        'fr': 'Commencer une conversation avec {personaName}?',
        'it': 'Iniziare una conversazione con {personaName}?',
        'pt': 'Iniciar uma conversa com {personaName}?',
        'ru': 'Начать разговор с {personaName}?',
        'es': '¿Iniciar una conversación con {personaName}?',
        'nl': 'Gesprek beginnen met {personaName}?',
        'sv': 'Starta en konversation med {personaName}?',
        'pl': 'Rozpocząć rozmowę z {personaName}?',
        'tr': '{personaName} ile sohbete başla?',
        'ar': 'بدء محادثة مع {personaName}؟',
        'hi': '{personaName} के साथ बातचीत शुरू करें?',
        'ur': '{personaName} کے ساتھ بات چیت شروع کریں؟',
        'th': 'เริ่มการสนทนากับ {personaName}?',
        'vi': 'Bắt đầu trò chuyện với {personaName}?',
        'id': 'Mulai percakapan dengan {personaName}?',
        'tl': 'Magsimula ng pag-uusap kay {personaName}?'
    },
    'reengagementNotificationSent': {
        'en': 'Re-engagement notification sent to {personaName} (Risk: {riskPercent}%)',
        'ko': '{personaName}님의 재참여 알림을 보냈습니다 (위험도: {riskPercent}%)',
        'ja': '{personaName}への再エンゲージメント通知を送信しました (リスク: {riskPercent}%)',
        'zh': '已向{personaName}发送重新参与通知 (风险: {riskPercent}%)',
        'de': 'Wiederbindungsbenachrichtigung an {personaName} gesendet (Risiko: {riskPercent}%)',
        'fr': 'Notification de réengagement envoyée à {personaName} (Risque: {riskPercent}%)',
        'it': 'Notifica di re-engagement inviata a {personaName} (Rischio: {riskPercent}%)',
        'pt': 'Notificação de reengajamento enviada para {personaName} (Risco: {riskPercent}%)',
        'ru': 'Уведомление о повторном вовлечении отправлено {personaName} (Риск: {riskPercent}%)',
        'es': 'Notificación de reenganche enviada a {personaName} (Riesgo: {riskPercent}%)',
        'nl': 'Herbetrokkenheidsmelding verzonden naar {personaName} (Risico: {riskPercent}%)',
        'sv': 'Återengagemangsmeddelande skickat till {personaName} (Risk: {riskPercent}%)',
        'pl': 'Powiadomienie o ponownym zaangażowaniu wysłane do {personaName} (Ryzyko: {riskPercent}%)',
        'tr': '{personaName} için yeniden katılım bildirimi gönderildi (Risk: {riskPercent}%)',
        'ar': 'تم إرسال إشعار إعادة المشاركة إلى {personaName} (المخاطر: {riskPercent}%)',
        'hi': '{personaName} को पुनः जुड़ाव सूचना भेजी गई (जोखिम: {riskPercent}%)',
        'ur': '{personaName} کو دوبارہ مشغولیت کی اطلاع بھیجی گئی (خطرہ: {riskPercent}%)',
        'th': 'ส่งการแจ้งเตือนการมีส่วนร่วมใหม่ถึง {personaName} (ความเสี่ยง: {riskPercent}%)',
        'vi': 'Đã gửi thông báo tái tương tác cho {personaName} (Rủi ro: {riskPercent}%)',
        'id': 'Notifikasi keterlibatan ulang dikirim ke {personaName} (Risiko: {riskPercent}%)',
        'tl': 'Ipinadala ang abiso ng muling pakikipag-ugnayan kay {personaName} (Panganib: {riskPercent}%)'
    },
    'noActivePersona': {
        'en': 'No active persona',
        'ko': '활성화된 페르소나가 없습니다',
        'ja': 'アクティブなペルソナがありません',
        'zh': '没有活跃的角色',
        'de': 'Keine aktive Persona',
        'fr': 'Aucune persona active',
        'it': 'Nessuna persona attiva',
        'pt': 'Nenhuma persona ativa',
        'ru': 'Нет активной персоны',
        'es': 'Sin persona activa',
        'nl': 'Geen actieve persona',
        'sv': 'Ingen aktiv persona',
        'pl': 'Brak aktywnej persony',
        'tr': 'Aktif persona yok',
        'ar': 'لا توجد شخصية نشطة',
        'hi': 'कोई सक्रिय व्यक्तित्व नहीं',
        'ur': 'کوئی فعال شخصیت نہیں',
        'th': 'ไม่มีเพอร์โซน่าที่ใช้งานอยู่',
        'vi': 'Không có persona hoạt động',
        'id': 'Tidak ada persona aktif',
        'tl': 'Walang aktibong persona'
    }
}

def update_language_file(lang_code, translations):
    """Update a language file with new translations"""
    filepath = f'lib/l10n/app_{lang_code}.arb'
    
    # Read existing file
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new translations
    added = 0
    for key, lang_translations in translations.items():
        if key not in data and lang_code in lang_translations:
            data[key] = lang_translations[lang_code]
            # Add metadata with placeholders if needed
            if '{' in lang_translations[lang_code]:
                placeholders = {}
                if 'personaName' in lang_translations[lang_code]:
                    placeholders['personaName'] = {'type': 'String'}
                if 'riskPercent' in lang_translations[lang_code]:
                    placeholders['riskPercent'] = {'type': 'String'}
                
                data[f'@{key}'] = {
                    'description': f'Localized string for {key}',
                    'placeholders': placeholders
                }
            else:
                data[f'@{key}'] = {
                    'description': f'Localized string for {key}'
                }
            added += 1
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    if added > 0:
        print(f'[OK] Updated {lang_code}: added {added} translations')
    else:
        print(f'[INFO] {lang_code}: keys already exist')

# Apply to all languages
languages = ['en', 'ko', 'ja', 'zh', 'de', 'fr', 'it', 'pt', 'ru', 'es', 'nl', 'sv', 'pl', 'tr', 'ar', 'hi', 'ur', 'th', 'vi', 'id', 'tl']

print('Adding missing localization keys for hardcoded strings...')
for lang in languages:
    update_language_file(lang, new_keys)

print('\n[SUCCESS] All keys added!')
print('Now update the Dart files to use these keys')