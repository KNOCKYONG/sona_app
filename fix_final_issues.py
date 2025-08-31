#!/usr/bin/env python3
"""Fix final localization issues."""

import json
import os

def fix_final_issues():
    """Fix final issues in the English ARB file."""
    arb_path = "sona_app/lib/l10n/app_en.arb"
    
    # Read existing ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Remove locale as it shouldn't be in ARB - locale is available through context
    if "locale" in arb_data:
        del arb_data["locale"]
    if "@locale" in arb_data:
        del arb_data["@locale"]
    
    # Fix purchaseConfirmMessage to have 4 parameters (seems to need another one)
    # Check existing parameters
    if "purchaseConfirmMessage" in arb_data:
        # Update to have all needed parameters
        arb_data["purchaseConfirmMessage"] = "Confirm purchase of {title} for {price}? {description}"
        arb_data["@purchaseConfirmMessage"] = {
            "description": "Purchase confirmation message",
            "placeholders": {
                "title": {
                    "type": "String",
                    "example": "Premium Package"
                },
                "price": {
                    "type": "String",
                    "example": "$9.99"
                },
                "description": {
                    "type": "String",
                    "example": "This includes..."
                }
            }
        }
    
    # Write back to file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, indent=2, ensure_ascii=False)
    
    print(f"Fixed final issues in {arb_path}")

if __name__ == "__main__":
    fix_final_issues()