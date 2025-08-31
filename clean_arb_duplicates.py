#!/usr/bin/env python3
"""Clean up duplicate entries and fix message placeholders in ARB file."""

import json
import os

def clean_arb_file():
    """Clean up the English ARB file."""
    arb_path = "sona_app/lib/l10n/app_en.arb"
    
    # Read existing ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Keep track of what we've seen
    cleaned_data = {}
    
    # Process entries in order, keeping only the first occurrence
    for key, value in arb_data.items():
        if key not in cleaned_data:
            cleaned_data[key] = value
    
    # Make sure messagesRemaining is just a simple string (no placeholders)
    if "messagesRemaining" in cleaned_data:
        cleaned_data["messagesRemaining"] = "Messages Remaining"
        cleaned_data["@messagesRemaining"] = {
            "description": "Label for messages remaining"
        }
    
    # Write back to file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(cleaned_data, f, indent=2, ensure_ascii=False)
    
    print(f"Cleaned up {arb_path}")
    print(f"Total entries: {len(cleaned_data)}")

if __name__ == "__main__":
    clean_arb_file()