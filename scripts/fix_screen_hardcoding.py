#!/usr/bin/env python3
"""
Fix hardcoded Korean text in screen files.
"""

import os
import re

def fix_screen_files():
    """Fix hardcoded Korean text in screen files."""
    
    # File fixes mapping
    fixes = {
        "sona_app/lib/screens/error_dashboard_screen.dart": [
            {
                "search": r"import 'package:flutter/material\.dart';",
                "replace": "import 'package:flutter/material.dart';\nimport '../l10n/app_localizations.dart';",
                "check": "import '../l10n/app_localizations.dart';"
            },
            {
                "search": r"'필터'",
                "replace": "AppLocalizations.of(context)!.filter"
            },
            {
                "search": r"'현재'",
                "replace": "AppLocalizations.of(context)!.current"
            },
            {
                "search": r"'에러 메시지:'",
                "replace": "AppLocalizations.of(context)!.errorMessage"
            },
            {
                "search": r"'사용자 메시지:'",
                "replace": "AppLocalizations.of(context)!.userMessage"
            },
            {
                "search": r"'최근 대화:'",
                "replace": "AppLocalizations.of(context)!.recentConversation"
            },
            {
                "search": r"'사용자: '",
                "replace": "AppLocalizations.of(context)!.user"
            },
            {
                "search": r"'발생 정보:'",
                "replace": "AppLocalizations.of(context)!.occurrenceInfo"
            },
            {
                "search": r"'첫 발생: '",
                "replace": r"'\${AppLocalizations.of(context)!.firstOccurred}'"
            },
            {
                "search": r"'마지막 발생: '",
                "replace": r"'\${AppLocalizations.of(context)!.lastOccurred}'"
            },
            {
                "search": r"'총 \$\{errorReport\.occurrenceCount\}회 발생'",
                "replace": "AppLocalizations.of(context)!.totalOccurrences(errorReport.occurrenceCount)"
            },
            {
                "search": r"'에러 발생 빈도 \(최근 24시간\)'",
                "replace": "AppLocalizations.of(context)!.errorFrequency24h"
            },
            {
                "search": r"'24시간 전'",
                "replace": "AppLocalizations.of(context)!.hours24Ago"
            },
            {
                "search": r"'API 키 오류'",
                "replace": "AppLocalizations.of(context)!.apiKeyError"
            }
        ],
        "sona_app/lib/screens/login_screen.dart": [
            {
                "search": r"errorMessage\.contains\('비밀번호'\)",
                "replace": "errorMessage.contains(AppLocalizations.of(context)!.passwordText)"
            },
            {
                "search": r"errorMessage\.contains\('등록되지 않은'\)",
                "replace": "errorMessage.contains(AppLocalizations.of(context)!.notRegistered)"
            },
            {
                "search": r"errorMessage\.contains\('올바르지 않습니다'\)",
                "replace": "errorMessage.contains(AppLocalizations.of(context)!.incorrect)"
            }
        ],
        "sona_app/lib/screens/splash_screen.dart": [
            {
                "search": r"message\.contains\('매칭된 페르소나'\)",
                "replace": "message.contains(AppLocalizations.of(context)!.matchedPersonas)"
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
    fix_screen_files()