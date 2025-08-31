#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os

def copy_english_to_korean_values():
    """Replace Korean text with English translations in non-Korean files"""
    
    # Read English translations as reference
    with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    
    # Languages to fix (excluding Korean, English, Japanese, Chinese, Thai which are OK)
    languages_to_fix = ["vi", "id", "es", "fr", "de", "ru", "pt", "it"]
    
    for lang in languages_to_fix:
        file_path = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        changes_made = 0
        
        for key, value in data.items():
            # Skip metadata keys
            if key.startswith("@"):
                continue
            
            # Check if value contains Korean characters
            if isinstance(value, str) and any('\uAC00' <= char <= '\uD7AF' for char in value):
                # Replace with English translation if available
                if key in en_data and not en_data[key].startswith("@"):
                    data[key] = en_data[key]
                    changes_made += 1
        
        if changes_made > 0:
            # Write back to file
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Updated {file_path}: Replaced {changes_made} Korean texts with English")
        else:
            print(f"No Korean text found in {file_path}")

def verify_translations():
    """Verify that no Korean text remains in non-Korean files"""
    languages = ["vi", "id", "es", "fr", "de", "ru", "pt", "it"]
    
    print("\n=== Verification: Checking for remaining Korean text ===")
    all_clear = True
    
    for lang in languages:
        file_path = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(file_path):
            continue
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        korean_count = 0
        for key, value in data.items():
            if not key.startswith("@") and isinstance(value, str):
                if any('\uAC00' <= char <= '\uD7AF' for char in value):
                    korean_count += 1
        
        if korean_count > 0:
            print(f"{lang.upper()}: Still has {korean_count} Korean texts!")
            all_clear = False
        else:
            print(f"{lang.upper()}: Clean - no Korean text found")
    
    if all_clear:
        print("\nAll files are clean! No Korean text in non-Korean files.")
    else:
        print("\nSome files still have Korean text. Manual translation may be needed.")

if __name__ == "__main__":
    print("Replacing Korean text with English translations...")
    copy_english_to_korean_values()
    
    verify_translations()
    
    print("\nDone! Remember to:")
    print("1. Run 'flutter gen-l10n' to regenerate the Dart files")
    print("2. Consider using a proper translation service for better localization")
    print("3. The texts are now in English - proper translations to each language would be better")