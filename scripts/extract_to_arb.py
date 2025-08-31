#!/usr/bin/env python3
"""
Extract i18n strings from AppLocalizations.dart to ARB files
"""

import re
import json
import os

def extract_strings_from_dart(file_path):
    """Extract all i18n strings from AppLocalizations.dart"""
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Dictionary to store extracted strings
    ko_strings = {}
    en_strings = {}
    
    # Pattern for simple getters: String get key => isKorean ? 'ko' : 'en';
    simple_pattern = r"String get (\w+) => isKorean \? '([^']+)' : '([^']+)';"
    
    for match in re.finditer(simple_pattern, content):
        key = match.group(1)
        ko_value = match.group(2)
        en_value = match.group(3)
        ko_strings[key] = ko_value
        en_strings[key] = en_value
    
    # Pattern for multiline getters
    multiline_pattern = r"String get (\w+) => isKorean\s*\?\s*'([^']+)'\s*:\s*'([^']+)';"
    
    for match in re.finditer(multiline_pattern, content, re.DOTALL):
        key = match.group(1)
        ko_value = match.group(2).replace('\\n', '\n')
        en_value = match.group(3).replace('\\n', '\n')
        if key not in ko_strings:  # Don't override if already found
            ko_strings[key] = ko_value
            en_strings[key] = en_value
    
    # Pattern for methods with parameters (we'll need to handle these differently)
    param_pattern = r"String (\w+)\([^)]+\) => isKorean \? (.+?) : (.+?);"
    param_methods = []
    
    for match in re.finditer(param_pattern, content):
        method_name = match.group(1)
        param_methods.append(method_name)
    
    return ko_strings, en_strings, param_methods

def create_arb_file(strings, locale, output_path):
    """Create ARB file from extracted strings"""
    
    arb_content = {
        "@@locale": locale
    }
    
    # Add all strings with metadata
    for key, value in strings.items():
        arb_content[key] = value
        # Add metadata for each string
        arb_content[f"@{key}"] = {
            "description": f"Localized string for {key}"
        }
    
    # Write ARB file
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(arb_content, f, ensure_ascii=False, indent=2)
    
    print(f"Created {output_path} with {len(strings)} strings")

def main():
    # Paths
    dart_file = "sona_app/lib/l10n/app_localizations.dart"
    ko_arb_file = "sona_app/lib/l10n/app_ko.arb"
    en_arb_file = "sona_app/lib/l10n/app_en.arb"
    
    # Extract strings
    print(f"Extracting strings from {dart_file}...")
    ko_strings, en_strings, param_methods = extract_strings_from_dart(dart_file)
    
    print(f"Found {len(ko_strings)} simple strings")
    print(f"Found {len(param_methods)} parameterized methods (need manual handling)")
    
    # Create ARB files
    create_arb_file(ko_strings, "ko", ko_arb_file)
    create_arb_file(en_strings, "en", en_arb_file)
    
    # Report parameterized methods that need manual handling
    if param_methods:
        print("\nParameterized methods that need manual handling:")
        for method in param_methods:
            print(f"  - {method}")
    
    print("\nExtraction complete!")
    print(f"Korean strings: {len(ko_strings)}")
    print(f"English strings: {len(en_strings)}")

if __name__ == "__main__":
    main()