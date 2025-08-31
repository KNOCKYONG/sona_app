#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os

# Define the new keys to add
new_keys = {
    "tutorialWelcomeTitle": {
        "en": "Welcome to SONA!",
        "ko": "SONA에 오신 것을 환영합니다!",
        "ja": "SONAへようこそ！",
        "zh": "欢迎来到SONA！",
        "th": "ยินดีต้อนรับสู่ SONA!",
        "vi": "Chào mừng đến với SONA!",
        "id": "Selamat datang di SONA!",
        "es": "¡Bienvenido a SONA!",
        "fr": "Bienvenue sur SONA!",
        "de": "Willkommen bei SONA!",
        "ru": "Добро пожаловать в SONA!",
        "pt": "Bem-vindo ao SONA!",
        "it": "Benvenuto su SONA!"
    },
    "tutorialWelcomeDescription": {
        "en": "Create special relationships with AI personas.",
        "ko": "AI 페르소나와 특별한 관계를 만들어보세요.",
        "ja": "AIペルソナと特別な関係を築きましょう。",
        "zh": "与AI角色建立特殊关系。",
        "th": "สร้างความสัมพันธ์พิเศษกับ AI personas",
        "vi": "Tạo mối quan hệ đặc biệt với AI personas.",
        "id": "Ciptakan hubungan istimewa dengan persona AI.",
        "es": "Crea relaciones especiales con personajes de IA.",
        "fr": "Créez des relations spéciales avec des personnages IA.",
        "de": "Schaffen Sie besondere Beziehungen mit KI-Personas.",
        "ru": "Создавайте особые отношения с ИИ-персонажами.",
        "pt": "Crie relacionamentos especiais com personas de IA.",
        "it": "Crea relazioni speciali con i personaggi IA."
    }
}

# Language codes
languages = ["en", "ko", "ja", "zh", "th", "vi", "id", "es", "fr", "de", "ru", "pt", "it"]

# Process each language file
for lang in languages:
    file_path = f"lib/l10n/app_{lang}.arb"
    
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    
    # Read existing file
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new keys
    for key, translations in new_keys.items():
        if key not in data:
            data[key] = translations[lang]
            # Add metadata key
            metadata_key = f"@{key}"
            if metadata_key not in data:
                data[metadata_key] = {
                    "description": f"Tutorial: {key.replace('tutorial', '').replace('Title', ' title').replace('Description', ' description').strip()}"
                }
            print(f"Added {key} to {file_path}")
        else:
            print(f"Key {key} already exists in {file_path}")
    
    # Write back to file
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Tutorial localization keys added successfully!")