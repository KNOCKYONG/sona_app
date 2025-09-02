#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Add missing settings and theme keys to all language files"""

import json
from pathlib import Path

# Translations for each language
translations = {
    'ko': {
        'editProfileSubtitle': '성별, 생년월일, 자기소개 수정',
        'systemThemeName': '시스템 설정',
        'lightThemeName': '라이트 모드',
        'darkThemeName': '다크 모드'
    },
    'vi': {
        'editProfileSubtitle': 'Chỉnh sửa giới tính, ngày sinh và giới thiệu',
        'systemThemeName': 'Hệ thống',
        'lightThemeName': 'Sáng',
        'darkThemeName': 'Tối'
    },
    'ja': {
        'editProfileSubtitle': '性別、生年月日、自己紹介を編集',
        'systemThemeName': 'システム',
        'lightThemeName': 'ライト',
        'darkThemeName': 'ダーク'
    },
    'zh': {
        'editProfileSubtitle': '编辑性别、生日和自我介绍',
        'systemThemeName': '系统',
        'lightThemeName': '浅色',
        'darkThemeName': '深色'
    },
    'es': {
        'editProfileSubtitle': 'Editar género, fecha de nacimiento e introducción',
        'systemThemeName': 'Sistema',
        'lightThemeName': 'Claro',
        'darkThemeName': 'Oscuro'
    },
    'fr': {
        'editProfileSubtitle': 'Modifier le genre, la date de naissance et la présentation',
        'systemThemeName': 'Système',
        'lightThemeName': 'Clair',
        'darkThemeName': 'Sombre'
    },
    'de': {
        'editProfileSubtitle': 'Geschlecht, Geburtsdatum und Vorstellung bearbeiten',
        'systemThemeName': 'System',
        'lightThemeName': 'Hell',
        'darkThemeName': 'Dunkel'
    },
    'id': {
        'editProfileSubtitle': 'Edit jenis kelamin, tanggal lahir, dan perkenalan',
        'systemThemeName': 'Sistem',
        'lightThemeName': 'Terang',
        'darkThemeName': 'Gelap'
    },
    'th': {
        'editProfileSubtitle': 'แก้ไขเพศ วันเกิด และการแนะนำตัว',
        'systemThemeName': 'ระบบ',
        'lightThemeName': 'สว่าง',
        'darkThemeName': 'มืด'
    },
    'pt': {
        'editProfileSubtitle': 'Editar gênero, data de nascimento e introdução',
        'systemThemeName': 'Sistema',
        'lightThemeName': 'Claro',
        'darkThemeName': 'Escuro'
    },
    'ru': {
        'editProfileSubtitle': 'Изменить пол, дату рождения и описание',
        'systemThemeName': 'Система',
        'lightThemeName': 'Светлая',
        'darkThemeName': 'Темная'
    },
    'it': {
        'editProfileSubtitle': 'Modifica genere, data di nascita e presentazione',
        'systemThemeName': 'Sistema',
        'lightThemeName': 'Chiaro',
        'darkThemeName': 'Scuro'
    },
    'ar': {
        'editProfileSubtitle': 'تعديل الجنس وتاريخ الميلاد والمقدمة',
        'systemThemeName': 'النظام',
        'lightThemeName': 'فاتح',
        'darkThemeName': 'داكن'
    },
    'hi': {
        'editProfileSubtitle': 'लिंग, जन्मतिथि और परिचय संपादित करें',
        'systemThemeName': 'सिस्टम',
        'lightThemeName': 'लाइट',
        'darkThemeName': 'डार्क'
    },
    'tr': {
        'editProfileSubtitle': 'Cinsiyet, doğum tarihi ve tanıtımı düzenle',
        'systemThemeName': 'Sistem',
        'lightThemeName': 'Açık',
        'darkThemeName': 'Koyu'
    },
    'ur': {
        'editProfileSubtitle': 'جنس، تاریخ پیدائش اور تعارف میں ترمیم کریں',
        'systemThemeName': 'سسٹم',
        'lightThemeName': 'لائٹ',
        'darkThemeName': 'ڈارک'
    },
    'nl': {
        'editProfileSubtitle': 'Bewerk geslacht, geboortedatum en introductie',
        'systemThemeName': 'Systeem',
        'lightThemeName': 'Licht',
        'darkThemeName': 'Donker'
    },
    'sv': {
        'editProfileSubtitle': 'Redigera kön, födelsedatum och introduktion',
        'systemThemeName': 'System',
        'lightThemeName': 'Ljus',
        'darkThemeName': 'Mörk'
    },
    'pl': {
        'editProfileSubtitle': 'Edytuj płeć, datę urodzenia i opis',
        'systemThemeName': 'System',
        'lightThemeName': 'Jasny',
        'darkThemeName': 'Ciemny'
    },
    'tl': {
        'editProfileSubtitle': 'I-edit ang kasarian, petsa ng kapanganakan at pagpapakilala',
        'systemThemeName': 'Sistema',
        'lightThemeName': 'Maliwanag',
        'darkThemeName': 'Madilim'
    }
}

# Add to all language files
arb_dir = Path('sona_app/lib/l10n')

for lang_code, trans in translations.items():
    arb_file = arb_dir / f'app_{lang_code}.arb'
    
    with open(arb_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new keys
    for key, value in trans.items():
        if key not in data:
            data[key] = value
            data[f'@{key}'] = {
                'description': f'Localized string for {key}'
            }
    
    # Save file
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Updated {lang_code}")

print("Done!")