#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
from googletrans import Translator

translator = Translator()

# Define translations for showAllGenderPersonas
translations_to_fix = {
    "showAllGenderPersonas": {
        "en": "Show All Gender Personas",
        "ko": "모든 성별 페르소나 보기",
        "ja": "すべての性別のペルソナを表示",
        "zh": "显示所有性别角色",
        "th": "แสดงเพอร์โซน่าทุกเพศ",
        "vi": "Hiển thị tất cả giới tính",
        "id": "Tampilkan Semua Gender Persona",
        "es": "Mostrar todas las personas",
        "fr": "Afficher tous les genres",
        "de": "Alle Geschlechter anzeigen",
        "ru": "Показать все гендеры",
        "pt": "Mostrar todos os gêneros",
        "it": "Mostra tutti i generi"
    }
}

# Language codes
languages = ["en", "ko", "ja", "zh", "th", "vi", "id", "es", "fr", "de", "ru", "pt", "it"]

def fix_translations():
    """Fix specific untranslated keys"""
    for lang in languages:
        file_path = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
        
        # Read existing file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Fix specific translations
        for key, translations in translations_to_fix.items():
            if key in data:
                old_value = data[key]
                new_value = translations[lang]
                if old_value != new_value:
                    data[key] = new_value
                    print(f"Fixed {key} in {file_path}: '{old_value}' -> '{new_value}'")
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

def find_korean_in_non_korean_files():
    """Find Korean text in non-Korean ARB files"""
    korean_keys = {}
    
    for lang in languages:
        if lang == "ko":
            continue
            
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
            korean_keys[lang] = korean_found
            print(f"\nFound {len(korean_found)} Korean texts in {file_path}:")
            for key, value in korean_found[:5]:  # Show first 5
                print(f"  {key}: {value[:50]}...")
            if len(korean_found) > 5:
                print(f"  ... and {len(korean_found) - 5} more")
    
    return korean_keys

def translate_missing_keys(korean_keys):
    """Translate Korean text to appropriate languages"""
    # Get English translations as reference
    with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    
    for lang, keys_to_translate in korean_keys.items():
        file_path = f"lib/l10n/app_{lang}.arb"
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        print(f"\nTranslating {len(keys_to_translate)} keys for {lang}...")
        
        for key, korean_value in keys_to_translate:
            # First check if we have English translation
            if key in en_data and not en_data[key].startswith("@"):
                # Use English as source for translation
                english_text = en_data[key]
                
                try:
                    # Translate from English to target language
                    if lang == "vi":
                        translated = translator.translate(english_text, src='en', dest='vi').text
                    elif lang == "id":
                        translated = translator.translate(english_text, src='en', dest='id').text
                    elif lang == "es":
                        translated = translator.translate(english_text, src='en', dest='es').text
                    elif lang == "fr":
                        translated = translator.translate(english_text, src='en', dest='fr').text
                    elif lang == "de":
                        translated = translator.translate(english_text, src='en', dest='de').text
                    elif lang == "ru":
                        translated = translator.translate(english_text, src='en', dest='ru').text
                    elif lang == "pt":
                        translated = translator.translate(english_text, src='en', dest='pt').text
                    elif lang == "it":
                        translated = translator.translate(english_text, src='en', dest='it').text
                    else:
                        translated = english_text  # Fallback to English
                    
                    data[key] = translated
                    print(f"  Translated {key}: {korean_value[:30]}... -> {translated[:30]}...")
                    
                except Exception as e:
                    print(f"  Error translating {key}: {e}")
                    # Keep English as fallback
                    if key in en_data:
                        data[key] = en_data[key]
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"Updated {file_path}")

if __name__ == "__main__":
    print("Step 1: Fixing known untranslated keys...")
    fix_translations()
    
    print("\nStep 2: Finding Korean text in non-Korean files...")
    korean_keys = find_korean_in_non_korean_files()
    
    if korean_keys:
        print("\nStep 3: Translating Korean texts to appropriate languages...")
        print("Note: This will use Google Translate API. Make sure you have internet connection.")
        response = input("Do you want to proceed with automatic translation? (y/n): ")
        if response.lower() == 'y':
            translate_missing_keys(korean_keys)
    else:
        print("\nNo Korean text found in non-Korean files!")
    
    print("\nDone! Remember to run 'flutter gen-l10n' to regenerate the Dart files.")