#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os

# Translation data for each language
translations = {
    "ja": {
        "translationSettingsDescription": "チャットで翻訳が表示される方法を設定します",
        "alwaysShowTranslation": "常に翻訳を表示",
        "alwaysShowTranslationDescription": "すべてのメッセージに対して自動的に翻訳を表示します"
    },
    "zh": {
        "translationSettingsDescription": "配置聊天中翻译的显示方式",
        "alwaysShowTranslation": "始终显示翻译",
        "alwaysShowTranslationDescription": "自动显示所有消息的翻译"
    },
    "th": {
        "translationSettingsDescription": "กำหนดค่าวิธีการแสดงการแปลในแชท",
        "alwaysShowTranslation": "แสดงการแปลเสมอ",
        "alwaysShowTranslationDescription": "แสดงการแปลสำหรับข้อความทั้งหมดโดยอัตโนมัติ"
    },
    "vi": {
        "translationSettingsDescription": "Cấu hình cách hiển thị bản dịch trong trò chuyện",
        "alwaysShowTranslation": "Luôn hiển thị bản dịch",
        "alwaysShowTranslationDescription": "Tự động hiển thị bản dịch cho tất cả tin nhắn"
    },
    "id": {
        "translationSettingsDescription": "Konfigurasi cara terjemahan muncul dalam obrolan",
        "alwaysShowTranslation": "Selalu Tampilkan Terjemahan",
        "alwaysShowTranslationDescription": "Secara otomatis menampilkan terjemahan untuk semua pesan"
    },
    "tl": {
        "translationSettingsDescription": "I-configure kung paano lalabas ang mga pagsasalin sa chat",
        "alwaysShowTranslation": "Palaging Ipakita ang Pagsasalin",
        "alwaysShowTranslationDescription": "Awtomatikong magpakita ng mga pagsasalin para sa lahat ng mensahe"
    },
    "es": {
        "translationSettingsDescription": "Configura cómo aparecen las traducciones en el chat",
        "alwaysShowTranslation": "Mostrar siempre traducción",
        "alwaysShowTranslationDescription": "Mostrar automáticamente traducciones para todos los mensajes"
    },
    "fr": {
        "translationSettingsDescription": "Configurer l'affichage des traductions dans le chat",
        "alwaysShowTranslation": "Toujours afficher la traduction",
        "alwaysShowTranslationDescription": "Afficher automatiquement les traductions pour tous les messages"
    },
    "de": {
        "translationSettingsDescription": "Konfigurieren Sie, wie Übersetzungen im Chat angezeigt werden",
        "alwaysShowTranslation": "Übersetzung immer anzeigen",
        "alwaysShowTranslationDescription": "Übersetzungen für alle Nachrichten automatisch anzeigen"
    },
    "ru": {
        "translationSettingsDescription": "Настройте отображение переводов в чате",
        "alwaysShowTranslation": "Всегда показывать перевод",
        "alwaysShowTranslationDescription": "Автоматически показывать переводы для всех сообщений"
    },
    "pt": {
        "translationSettingsDescription": "Configure como as traduções aparecem no chat",
        "alwaysShowTranslation": "Sempre Mostrar Tradução",
        "alwaysShowTranslationDescription": "Mostrar automaticamente traduções para todas as mensagens"
    },
    "it": {
        "translationSettingsDescription": "Configura come appaiono le traduzioni nella chat",
        "alwaysShowTranslation": "Mostra sempre traduzione",
        "alwaysShowTranslationDescription": "Mostra automaticamente le traduzioni per tutti i messaggi"
    },
    "nl": {
        "translationSettingsDescription": "Configureer hoe vertalingen in de chat verschijnen",
        "alwaysShowTranslation": "Altijd vertaling tonen",
        "alwaysShowTranslationDescription": "Automatisch vertalingen voor alle berichten weergeven"
    },
    "sv": {
        "translationSettingsDescription": "Konfigurera hur översättningar visas i chatten",
        "alwaysShowTranslation": "Visa alltid översättning",
        "alwaysShowTranslationDescription": "Visa automatiskt översättningar för alla meddelanden"
    },
    "pl": {
        "translationSettingsDescription": "Skonfiguruj sposób wyświetlania tłumaczeń w czacie",
        "alwaysShowTranslation": "Zawsze pokazuj tłumaczenie",
        "alwaysShowTranslationDescription": "Automatycznie pokazuj tłumaczenia dla wszystkich wiadomości"
    },
    "tr": {
        "translationSettingsDescription": "Sohbette çevirilerin nasıl görüneceğini yapılandırın",
        "alwaysShowTranslation": "Her Zaman Çeviriyi Göster",
        "alwaysShowTranslationDescription": "Tüm mesajlar için çevirileri otomatik olarak göster"
    },
    "ar": {
        "translationSettingsDescription": "تكوين كيفية ظهور الترجمات في الدردشة",
        "alwaysShowTranslation": "إظهار الترجمة دائماً",
        "alwaysShowTranslationDescription": "عرض الترجمات تلقائيًا لجميع الرسائل"
    },
    "hi": {
        "translationSettingsDescription": "चैट में अनुवाद कैसे दिखाई दें, इसे कॉन्फ़िगर करें",
        "alwaysShowTranslation": "हमेशा अनुवाद दिखाएं",
        "alwaysShowTranslationDescription": "सभी संदेशों के लिए स्वचालित रूप से अनुवाद दिखाएं"
    },
    "ur": {
        "translationSettingsDescription": "چیٹ میں ترجمے کیسے ظاہر ہوں اس کی تشکیل کریں",
        "alwaysShowTranslation": "ہمیشہ ترجمہ دکھائیں",
        "alwaysShowTranslationDescription": "تمام پیغامات کے لیے خودکار طور پر ترجمہ دکھائیں"
    }
}

def add_translation_keys(lang_code):
    """Add missing translation keys to a language file."""
    file_path = f"C:/Users/yong/sonaapp/sona_app/lib/l10n/app_{lang_code}.arb"
    
    if lang_code not in translations:
        print(f"No translations defined for {lang_code}")
        return False
    
    try:
        # Read the file
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            data = json.loads(content)
        
        # Check if keys already exist
        if "translationSettingsDescription" in data:
            print(f"Keys already exist in {lang_code}")
            return True
        
        # Find the position after translationSettings
        new_data = {}
        added = False
        
        for key, value in data.items():
            new_data[key] = value
            
            # Add new keys after translationSettings
            if key == "translationSettings" and not added:
                # Add the metadata key
                if f"@{key}" in data:
                    new_data[f"@{key}"] = data[f"@{key}"]
                
                # Add new keys
                new_data["translationSettingsDescription"] = translations[lang_code]["translationSettingsDescription"]
                new_data["@translationSettingsDescription"] = {
                    "description": "Description for translation settings section"
                }
                new_data["alwaysShowTranslation"] = translations[lang_code]["alwaysShowTranslation"]
                new_data["@alwaysShowTranslation"] = {
                    "description": "Toggle to always show translations"
                }
                new_data["alwaysShowTranslationDescription"] = translations[lang_code]["alwaysShowTranslationDescription"]
                new_data["@alwaysShowTranslationDescription"] = {
                    "description": "Description for always show translation toggle"
                }
                added = True
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=2)
        
        print(f"[SUCCESS] Updated {lang_code}")
        return True
        
    except Exception as e:
        print(f"[ERROR] Error updating {lang_code}: {e}")
        return False

# Update all language files
success_count = 0
for lang_code in translations.keys():
    if add_translation_keys(lang_code):
        success_count += 1

print(f"\n[COMPLETE] Successfully updated {success_count}/{len(translations)} language files")