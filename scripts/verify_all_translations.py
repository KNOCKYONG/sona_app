#!/usr/bin/env python3
"""
Verify all translations are complete and no TODO tags remain.
"""

import json
import os
import sys

LANGUAGES = ['ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'id', 'th', 'vi']

def check_language(lang_code):
    """Check a single language file for completeness."""
    arb_path = f"sona_app/lib/l10n/app_{lang_code}.arb"
    
    if not os.path.exists(arb_path):
        return f"File not found: {arb_path}"
    
    with open(arb_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Check for TODO tags
    todo_count = 0
    english_count = 0
    total_keys = 0
    
    for key, value in data.items():
        if key.startswith('@'):
            continue
            
        total_keys += 1
        
        if isinstance(value, str):
            # Check for TODO tags
            if 'TODO' in value.upper():
                todo_count += 1
            
            # Check for English text (for non-English languages)
            if lang_code != 'en':
                # Simple check: if the value is mostly ASCII, it might be English
                ascii_ratio = len(value.encode('ascii', 'ignore')) / len(value.encode('utf-8'))
                if ascii_ratio > 0.95 and len(value) > 10:
                    # Exclude some common keys that might be in English
                    if key not in ['appName', 'email', 'SONA', 'API', 'URL', 'ID']:
                        english_count += 1
    
    return {
        'total': total_keys,
        'todos': todo_count,
        'english': english_count
    }

def main():
    print("Verifying all translations...")
    print("=" * 60)
    
    all_good = True
    
    for lang in LANGUAGES:
        result = check_language(lang)
        
        if isinstance(result, str):
            print(f"  [{lang.upper()}] Error: {result}")
            all_good = False
        else:
            status = "OK" if (result['todos'] == 0 and result['english'] < 5) else "NEEDS FIX"
            print(f"  [{lang.upper()}] {status} Total: {result['total']}, TODOs: {result['todos']}, English: {result['english']}")
            
            if result['todos'] > 0 or result['english'] > 10:
                all_good = False
    
    print("=" * 60)
    
    if all_good:
        print("SUCCESS: All translations verified successfully!")
        return 0
    else:
        print("WARNING: Some languages need attention")
        return 1

if __name__ == "__main__":
    sys.exit(main())