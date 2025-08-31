#!/usr/bin/env python3
"""
Fix parameterized messages in ARB files.
Ensures placeholder names match the expected parameter names.
"""

import json
import sys
from pathlib import Path
from typing import Dict, Any

# Map of keys that need fixing with their correct placeholder values
FIXES = {
    "purchaseConfirmMessage": {
        "en": "Confirm purchase of {title} for {price}? {description}",
        "placeholders": ["title", "price", "description", "item"]
    },
    "purchaseConfirmContent": {
        "en": "Purchase {product} for {price}?",
        "placeholders": ["product", "price", "item"]
    },
    "daysAgo": {
        "en": "{count} days ago",
        "placeholders": ["count", "formatted"]
    },
    "hoursAgo": {
        "en": "{count} hours ago",
        "placeholders": ["count", "formatted"]
    },
    "minutesAgo": {
        "en": "{count} minutes ago",
        "placeholders": ["count", "formatted"]
    }
}

def load_arb_file(file_path: Path) -> Dict[str, Any]:
    """Load an ARB file as JSON."""
    if not file_path.exists():
        return {}
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_arb_file(file_path: Path, data: Dict[str, Any]) -> None:
    """Save data to an ARB file."""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def fix_parameterized_messages():
    """Fix parameterized messages in all ARB files."""
    arb_dir = Path("sona_app/lib/l10n")
    
    # Fix each language file
    languages = ['de', 'es', 'fr', 'id', 'it', 'ja', 'ko', 'pt', 'ru', 'th', 'vi', 'zh']
    
    for lang in languages:
        arb_file = arb_dir / f"app_{lang}.arb"
        if not arb_file.exists():
            continue
            
        data = load_arb_file(arb_file)
        modified = False
        
        # Fix purchaseConfirmMessage 
        if "purchaseConfirmMessage" in data:
            # Use placeholder translation for now
            data["purchaseConfirmMessage"] = f"[TODO-{lang.upper()}] Confirm purchase of {{title}} for {{price}}? {{description}}"
            modified = True
            
        # Fix purchaseConfirmContent
        if "purchaseConfirmContent" in data:
            data["purchaseConfirmContent"] = f"[TODO-{lang.upper()}] Purchase {{product}} for {{price}}?"
            modified = True
            
        # Fix daysAgo
        if "daysAgo" in data:
            data["daysAgo"] = f"[TODO-{lang.upper()}] {{count}} days ago"
            modified = True
            
        # Fix hoursAgo  
        if "hoursAgo" in data:
            data["hoursAgo"] = f"[TODO-{lang.upper()}] {{count}} hours ago"
            modified = True
            
        # Fix minutesAgo
        if "minutesAgo" in data:
            data["minutesAgo"] = f"[TODO-{lang.upper()}] {{count}} minutes ago"
            modified = True
            
        if modified:
            save_arb_file(arb_file, data)
            print(f"[OK] Fixed {arb_file.name}")
        else:
            print(f"[SKIP] No changes needed for {arb_file.name}")
    
    print("\n[Regenerating] Localization files...")
    import os
    result = os.system("cd sona_app && flutter gen-l10n")
    if result == 0:
        print("[OK] Localization files regenerated successfully")
    else:
        print("[WARNING] Error regenerating localization files")

if __name__ == "__main__":
    # Set UTF-8 encoding for Windows console
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')
    
    fix_parameterized_messages()