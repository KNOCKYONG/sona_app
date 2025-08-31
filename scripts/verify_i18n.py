#!/usr/bin/env python3
"""
Verify i18n implementation is working correctly
"""
import json
import os
import sys
from pathlib import Path

def load_arb_file(file_path):
    """Load and parse an ARB file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def verify_arb_consistency():
    """Verify all ARB files have the same keys"""
    print("🔍 Verifying ARB file consistency...")
    
    arb_dir = Path("sona_app/lib/l10n")
    arb_files = list(arb_dir.glob("app_*.arb"))
    
    if not arb_files:
        print("❌ No ARB files found!")
        return False
    
    print(f"✅ Found {len(arb_files)} ARB files")
    
    # Load English as the template
    template_file = arb_dir / "app_en.arb"
    if not template_file.exists():
        print("❌ Template file app_en.arb not found!")
        return False
    
    template_data = load_arb_file(template_file)
    template_keys = set(k for k in template_data.keys() if not k.startswith('@'))
    print(f"📋 Template has {len(template_keys)} translation keys")
    
    # Check each language file
    all_consistent = True
    for arb_file in arb_files:
        if arb_file == template_file:
            continue
            
        lang_code = arb_file.stem.replace('app_', '')
        data = load_arb_file(arb_file)
        keys = set(k for k in data.keys() if not k.startswith('@'))
        
        missing = template_keys - keys
        extra = keys - template_keys
        
        if missing or extra:
            all_consistent = False
            print(f"\n❌ {lang_code.upper()} has issues:")
            if missing:
                print(f"   Missing keys: {list(missing)[:5]}...")
            if extra:
                print(f"   Extra keys: {list(extra)[:5]}...")
        else:
            print(f"✅ {lang_code.upper()}: {len(keys)} keys - OK")
    
    return all_consistent

def verify_placeholder_consistency():
    """Verify placeholders are consistent across languages"""
    print("\n🔍 Verifying placeholder consistency...")
    
    arb_dir = Path("sona_app/lib/l10n")
    template_file = arb_dir / "app_en.arb"
    template_data = load_arb_file(template_file)
    
    # Find all keys with placeholders
    placeholder_keys = {}
    for key, value in template_data.items():
        if key.startswith('@') and 'placeholders' in value:
            message_key = key[1:]  # Remove @ prefix
            placeholder_keys[message_key] = value['placeholders']
    
    print(f"📋 Found {len(placeholder_keys)} messages with placeholders")
    
    # Check each language
    all_consistent = True
    for arb_file in arb_dir.glob("app_*.arb"):
        if arb_file == template_file:
            continue
            
        lang_code = arb_file.stem.replace('app_', '')
        data = load_arb_file(arb_file)
        
        for msg_key, expected_placeholders in placeholder_keys.items():
            meta_key = f"@{msg_key}"
            if meta_key in data and 'placeholders' in data[meta_key]:
                actual_placeholders = data[meta_key]['placeholders']
                
                # Check each placeholder type
                for ph_name, ph_info in expected_placeholders.items():
                    if ph_name in actual_placeholders:
                        expected_type = ph_info.get('type', 'String')
                        actual_type = actual_placeholders[ph_name].get('type', 'String')
                        
                        if expected_type != actual_type:
                            all_consistent = False
                            print(f"❌ {lang_code}: {msg_key}.{ph_name} type mismatch: {actual_type} vs {expected_type}")
    
    if all_consistent:
        print("✅ All placeholders are consistent!")
    
    return all_consistent

def verify_generated_files():
    """Verify localization files were generated"""
    print("\n🔍 Verifying generated localization files...")
    
    l10n_dir = Path("sona_app/lib/l10n")
    
    expected_files = [
        "app_localizations.dart",
        "app_localizations_en.dart",
        "app_localizations_ko.dart",
        "app_localizations_ja.dart",
        "app_localizations_zh.dart",
        "app_localizations_th.dart",
        "app_localizations_vi.dart",
        "app_localizations_id.dart",
        "app_localizations_es.dart",
        "app_localizations_fr.dart",
        "app_localizations_de.dart",
        "app_localizations_ru.dart",
        "app_localizations_pt.dart",
        "app_localizations_it.dart",
    ]
    
    all_exist = True
    for file_name in expected_files:
        file_path = l10n_dir / file_name
        if file_path.exists():
            print(f"✅ {file_name} exists")
        else:
            print(f"❌ {file_name} missing!")
            all_exist = False
    
    return all_exist

def check_sample_translations():
    """Check some sample translations to verify they're working"""
    print("\n🔍 Checking sample translations...")
    
    arb_dir = Path("sona_app/lib/l10n")
    
    # Sample keys to check
    sample_keys = ['appName', 'loading', 'settings', 'language', 'chat']
    
    languages = {
        'en': 'English',
        'ko': 'Korean',
        'ja': 'Japanese',
        'zh': 'Chinese',
        'th': 'Thai',
    }
    
    for lang_code, lang_name in languages.items():
        arb_file = arb_dir / f"app_{lang_code}.arb"
        if arb_file.exists():
            data = load_arb_file(arb_file)
            print(f"\n{lang_name} samples:")
            for key in sample_keys:
                if key in data:
                    print(f"  {key}: {data[key]}")
    
    return True

def main():
    """Main verification function"""
    print("=" * 60)
    print("🌍 i18n Implementation Verification")
    print("=" * 60)
    
    results = []
    
    # Run all checks
    results.append(("ARB Consistency", verify_arb_consistency()))
    results.append(("Placeholder Consistency", verify_placeholder_consistency()))
    results.append(("Generated Files", verify_generated_files()))
    results.append(("Sample Translations", check_sample_translations()))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)
    
    all_passed = True
    for check_name, passed in results:
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{check_name}: {status}")
        if not passed:
            all_passed = False
    
    print("=" * 60)
    
    if all_passed:
        print("🎉 All i18n checks passed!")
        return 0
    else:
        print("⚠️ Some i18n checks failed. Please review the issues above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())