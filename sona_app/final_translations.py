#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Add final missing translations
"""

import json

# Final 4 keys that are missing in many languages
final_keys = {
    'ar': {  # Arabic
        'mbtiTest': 'اختبار MBTI',
        'personaAge': 'العمر',
        'personaDescription': 'الوصف',
        'personaName': 'الاسم'
    },
    'es': {  # Spanish
        'mbtiTest': 'Test MBTI',
        'personaAge': 'Edad',
        'personaDescription': 'Descripción',
        'personaName': 'Nombre',
        'shareDescription': 'Tu persona puede ser compartida con otros usuarios después de la aprobación'
    },
    'hi': {  # Hindi
        'mbtiTest': 'MBTI परीक्षण',
        'personaAge': 'आयु',
        'personaDescription': 'विवरण',
        'personaName': 'नाम'
    },
    'id': {  # Indonesian
        'mbtiTest': 'Tes MBTI',
        'personaAge': 'Usia',
        'personaDescription': 'Deskripsi',
        'personaName': 'Nama'
    },
    'ko': {  # Korean - still missing 2
        'mbtiTest': 'MBTI 테스트',
        'shareDescription': '승인 후 다른 사용자와 페르소나를 공유할 수 있습니다'
    },
    'nl': {  # Dutch
        'mbtiTest': 'MBTI Test',
        'personaAge': 'Leeftijd',
        'personaDescription': 'Beschrijving',
        'personaName': 'Naam'
    },
    'pl': {  # Polish
        'mbtiTest': 'Test MBTI',
        'personaAge': 'Wiek',
        'personaDescription': 'Opis',
        'personaName': 'Imię'
    },
    'sv': {  # Swedish
        'mbtiTest': 'MBTI-test',
        'personaAge': 'Ålder',
        'personaDescription': 'Beskrivning',
        'personaName': 'Namn'
    },
    'th': {  # Thai
        'mbtiTest': 'แบบทดสอบ MBTI',
        'personaAge': 'อายุ',
        'personaDescription': 'คำอธิบาย',
        'personaName': 'ชื่อ'
    },
    'tl': {  # Tagalog
        'mbtiTest': 'MBTI Test',
        'personaAge': 'Edad',
        'personaDescription': 'Paglalarawan',
        'personaName': 'Pangalan'
    },
    'tr': {  # Turkish
        'mbtiTest': 'MBTI Testi',
        'personaAge': 'Yaş',
        'personaDescription': 'Açıklama',
        'personaName': 'İsim'
    },
    'ur': {  # Urdu
        'mbtiTest': 'MBTI ٹیسٹ',
        'personaAge': 'عمر',
        'personaDescription': 'تفصیل',
        'personaName': 'نام'
    },
    'vi': {  # Vietnamese
        'mbtiTest': 'Kiểm tra MBTI',
        'personaAge': 'Tuổi',
        'personaDescription': 'Mô tả',
        'personaName': 'Tên'
    }
}

def update_language_file(lang_code, translations_dict):
    """Update a language file with new translations"""
    filepath = f'lib/l10n/app_{lang_code}.arb'
    
    # Read existing file
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new translations
    added = 0
    for key, value in translations_dict.items():
        if key not in data:
            data[key] = value
            # Add metadata
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
        print(f'[INFO] {lang_code}: already complete')

# Apply final translations
print('Adding final missing translations...')
for lang_code, trans_dict in final_keys.items():
    update_language_file(lang_code, trans_dict)

print('\n[SUCCESS] Final translations completed!')
print('Run "flutter gen-l10n" for final verification')