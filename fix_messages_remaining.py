#!/usr/bin/env python3
"""Fix messagesRemaining to be a simple label string."""

import json
import os

def fix_messages_remaining():
    """Fix messagesRemaining in the English ARB file."""
    arb_path = "sona_app/lib/l10n/app_en.arb"
    
    # Read existing ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Change messagesRemaining to a simple label
    arb_data["messagesRemaining"] = "Messages Remaining"
    arb_data["@messagesRemaining"] = {
        "description": "Label for messages remaining"
    }
    
    # Write back to file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, indent=2, ensure_ascii=False)
    
    print(f"Fixed messagesRemaining in {arb_path}")

if __name__ == "__main__":
    fix_messages_remaining()