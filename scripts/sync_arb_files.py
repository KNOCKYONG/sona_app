#!/usr/bin/env python3
"""
Synchronize ARB files by adding missing keys from English to other languages.
This ensures all language files have the same keys as the English master file.

Usage: python scripts/sync_arb_files.py [--translate]
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, Any, List, Tuple
import argparse

def load_arb_file(file_path: Path) -> Dict[str, Any]:
    """Load an ARB file as JSON."""
    if not file_path.exists():
        print(f"Error: {file_path} does not exist")
        return {}
    
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_arb_file(file_path: Path, data: Dict[str, Any]) -> None:
    """Save data to an ARB file."""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def get_translation_keys(arb_data: Dict[str, Any]) -> List[str]:
    """Get all translation keys (excluding metadata keys that start with @)."""
    return [key for key in arb_data.keys() if not key.startswith('@')]

def get_placeholder_translation(english_value: str, lang_code: str) -> str:
    """Get a placeholder translation for missing keys."""
    # Mark untranslated strings clearly
    return f"[TODO-{lang_code.upper()}] {english_value}"

def sync_language_file(english_data: Dict[str, Any], target_data: Dict[str, Any], 
                       lang_code: str, auto_translate: bool = False) -> Tuple[Dict[str, Any], List[str], List[str]]:
    """
    Sync a target language file with the English master.
    Returns: (updated_data, added_keys, removed_keys)
    """
    english_keys = set(get_translation_keys(english_data))
    target_keys = set(get_translation_keys(target_data))
    
    # Find missing and extra keys
    missing_keys = english_keys - target_keys
    extra_keys = target_keys - english_keys
    
    # Copy target data to preserve existing translations
    updated_data = target_data.copy()
    
    # Add missing keys
    added_keys = []
    for key in sorted(missing_keys):
        english_value = english_data[key]
        
        # Add the translation
        if auto_translate:
            # In the future, this could call a translation API
            updated_data[key] = get_placeholder_translation(english_value, lang_code)
        else:
            updated_data[key] = get_placeholder_translation(english_value, lang_code)
        
        # Copy metadata if it exists
        metadata_key = f"@{key}"
        if metadata_key in english_data:
            updated_data[metadata_key] = english_data[metadata_key]
        
        added_keys.append(key)
    
    # Optionally remove extra keys (commented out for safety)
    removed_keys = []
    # for key in extra_keys:
    #     del updated_data[key]
    #     metadata_key = f"@{key}"
    #     if metadata_key in updated_data:
    #         del updated_data[metadata_key]
    #     removed_keys.append(key)
    
    return updated_data, added_keys, removed_keys

def main():
    # Set UTF-8 encoding for Windows console
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
    
    parser = argparse.ArgumentParser(description='Synchronize ARB translation files')
    parser.add_argument('--translate', action='store_true', 
                       help='Auto-translate missing keys (placeholder for now)')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be changed without modifying files')
    args = parser.parse_args()
    
    # Path to ARB files
    arb_dir = Path("sona_app/lib/l10n")
    if not arb_dir.exists():
        print(f"Error: ARB directory {arb_dir} does not exist")
        sys.exit(1)
    
    # Load English master file
    english_file = arb_dir / "app_en.arb"
    english_data = load_arb_file(english_file)
    if not english_data:
        print("Error: Could not load English ARB file")
        sys.exit(1)
    
    english_key_count = len(get_translation_keys(english_data))
    print(f"[English master] {english_key_count} translation keys")
    print("="*60)
    
    # Process all other language files
    languages = ['ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'id', 'th', 'vi']
    
    total_added = 0
    total_removed = 0
    files_updated = 0
    
    for lang in languages:
        arb_file = arb_dir / f"app_{lang}.arb"
        
        # Load target language file
        target_data = load_arb_file(arb_file)
        if not target_data:
            print(f"⚠️  Warning: Could not load {arb_file}, skipping...")
            continue
        
        # Sync with English
        updated_data, added_keys, removed_keys = sync_language_file(
            english_data, target_data, lang, args.translate
        )
        
        # Report changes
        if added_keys or removed_keys:
            print(f"\n[{arb_file.name}] ({lang.upper()}):")
            
            if added_keys:
                print(f"  [+] Adding {len(added_keys)} missing keys:")
                for key in added_keys[:5]:  # Show first 5
                    print(f"     - {key}")
                if len(added_keys) > 5:
                    print(f"     ... and {len(added_keys) - 5} more")
                total_added += len(added_keys)
            
            if removed_keys:
                print(f"  [-] Found {len(removed_keys)} extra keys (not removed for safety)")
                for key in removed_keys[:5]:
                    print(f"     - {key}")
                if len(removed_keys) > 5:
                    print(f"     ... and {len(removed_keys) - 5} more")
                total_removed += len(removed_keys)
            
            # Save changes if not dry run
            if not args.dry_run:
                save_arb_file(arb_file, updated_data)
                files_updated += 1
                print(f"  [OK] File updated")
            else:
                print(f"  [DRY] Dry run - no changes made")
        else:
            print(f"\n[OK] {arb_file.name} ({lang.upper()}): Already in sync")
    
    # Summary
    print("\n" + "="*60)
    print("[Summary] Synchronization Results:")
    print(f"  - Files updated: {files_updated}")
    print(f"  - Total keys added: {total_added}")
    if total_removed > 0:
        print(f"  - Extra keys found: {total_removed} (not removed)")
    
    if args.dry_run:
        print("\n[INFO] This was a dry run. Use without --dry-run to apply changes.")
    elif files_updated > 0:
        # Regenerate localization files
        print("\n[Regenerating] Localization files...")
        result = os.system("cd sona_app && flutter gen-l10n")
        if result == 0:
            print("[OK] Localization files regenerated successfully")
        else:
            print("[WARNING] Error regenerating localization files. Run 'flutter gen-l10n' manually.")
    
    if total_added > 0 and not args.translate:
        print("\n[Next Steps]:")
        print("1. Search for '[TODO-' in the ARB files to find untranslated strings")
        print("2. Replace them with proper translations")
        print("3. Test the app in different languages")

if __name__ == "__main__":
    main()