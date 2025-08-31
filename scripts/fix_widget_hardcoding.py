#!/usr/bin/env python3
"""
Fix hardcoded Korean text in widget files.
"""

import os
import re

def fix_widget_files():
    """Fix hardcoded Korean text in widget files."""
    
    # File fixes mapping
    fixes = {
        "sona_app/lib/widgets/common/heart_usage_dialog.dart": [
            {
                "search": r"import 'package:flutter/material\.dart';",
                "replace": "import 'package:flutter/material.dart';\nimport '../../l10n/app_localizations.dart';",
                "check": "import '../../l10n/app_localizations.dart';"
            },
            {
                "search": r"'취소'",
                "replace": "AppLocalizations.of(context)!.cancel"
            }
        ],
        "sona_app/lib/widgets/chat/message_bubble.dart": [
            {
                "search": r"import 'package:flutter/material\.dart';",
                "replace": "import 'package:flutter/material.dart';\nimport '../../l10n/app_localizations.dart';",
                "check": "import '../../l10n/app_localizations.dart';"
            },
            {
                "search": r"'한국어'",
                "replace": "AppLocalizations.of(context)!.koreanLanguage"
            },
            {
                "search": r"'재시도'",
                "replace": "AppLocalizations.of(context)!.retryButton"
            }
        ]
    }
    
    for file_path, replacements in fixes.items():
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        for replacement in replacements:
            # Check if import already exists (for import statements)
            if 'check' in replacement and replacement['check'] in content:
                continue
                
            # Apply replacement
            if 'search' in replacement:
                content = re.sub(replacement['search'], replacement['replace'], content)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed: {file_path}")
        else:
            print(f"No changes needed: {file_path}")

if __name__ == "__main__":
    fix_widget_files()