#!/usr/bin/env python3
"""
Add new internationalization key to all ARB files.
Usage: python scripts/add_i18n_key.py <key> <english_value> [description]

Example:
  python scripts/add_i18n_key.py welcomeMessage "Welcome to Sona!" "Welcome message shown on first launch"
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, Any, Optional

# Language mappings for auto-translation suggestions
LANGUAGE_HINTS = {
    'ko': 'Korean',
    'ja': 'Japanese', 
    'zh': 'Chinese',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'id': 'Indonesian',
    'th': 'Thai',
    'vi': 'Vietnamese'
}

def load_arb_file(file_path: Path) -> Dict[str, Any]:
    """Load an ARB file as JSON."""
    if not file_path.exists():
        print(f"Warning: {file_path} does not exist")
        return {}
    
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_arb_file(file_path: Path, data: Dict[str, Any]) -> None:
    """Save data to an ARB file."""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"✅ Updated: {file_path}")

def add_key_to_arb(arb_data: Dict[str, Any], key: str, value: str, description: Optional[str] = None) -> bool:
    """Add a key to ARB data. Returns True if key was added, False if it already exists."""
    if key in arb_data:
        return False
    
    # Add the key and value
    arb_data[key] = value
    
    # Add description if provided
    if description:
        arb_data[f"@{key}"] = {
            "description": description
        }
    
    return True

def get_placeholder_translation(english_value: str, lang_code: str) -> str:
    """Get a placeholder translation for non-English languages."""
    # For now, return a placeholder. In the future, this could use a translation API
    return f"[{lang_code.upper()}] {english_value}"

def main():
    if len(sys.argv) < 3:
        print("Usage: python scripts/add_i18n_key.py <key> <english_value> [description]")
        print("Example: python scripts/add_i18n_key.py welcomeMessage \"Welcome to Sona!\" \"Welcome message shown on first launch\"")
        sys.exit(1)
    
    key = sys.argv[1]
    english_value = sys.argv[2]
    description = sys.argv[3] if len(sys.argv) > 3 else None
    
    # Validate key format (should be camelCase)
    if not key[0].islower() or '_' in key or '-' in key:
        print(f"⚠️  Warning: Key '{key}' should be in camelCase format (e.g., welcomeMessage)")
    
    # Path to ARB files
    arb_dir = Path("sona_app/lib/l10n")
    if not arb_dir.exists():
        print(f"Error: ARB directory {arb_dir} does not exist")
        sys.exit(1)
    
    # Process all ARB files
    languages = ['en', 'ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'id', 'th', 'vi']
    added_count = 0
    skipped_count = 0
    
    for lang in languages:
        arb_file = arb_dir / f"app_{lang}.arb"
        
        # Load existing data
        arb_data = load_arb_file(arb_file)
        
        # Determine the value to use
        if lang == 'en':
            value = english_value
        else:
            # For non-English, add a placeholder that indicates translation is needed
            value = get_placeholder_translation(english_value, lang)
        
        # Add the key
        if add_key_to_arb(arb_data, key, value, description if lang == 'en' else None):
            save_arb_file(arb_file, arb_data)
            added_count += 1
        else:
            print(f"⏭️  Skipped: {arb_file} (key already exists)")
            skipped_count += 1
    
    # Summary
    print("\n" + "="*50)
    print(f"✅ Successfully added '{key}' to {added_count} file(s)")
    if skipped_count > 0:
        print(f"⏭️  Skipped {skipped_count} file(s) (key already exists)")
    
    # Regenerate localization files
    print("\n🔄 Regenerating localization files...")
    os.system("cd sona_app && flutter gen-l10n")
    
    print("\n✨ Done! Next steps:")
    print(f"1. Review the placeholder translations in non-English files")
    print(f"2. Replace '[LANG] {english_value}' with proper translations")
    print(f"3. Test the app in different languages")

if __name__ == "__main__":
    main()