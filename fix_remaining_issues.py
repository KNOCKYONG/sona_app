#!/usr/bin/env python3
"""Fix remaining localization issues in the ARB file."""

import json
import os

def fix_remaining_issues():
    """Fix remaining issues in the English ARB file."""
    arb_path = "sona_app/lib/l10n/app_en.arb"
    
    # Read existing ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Fix weekdays - it should be handled as a string and split in the code
    # The current implementation is correct, weekdays as comma-separated string
    
    # Add locale if missing
    if "locale" not in arb_data:
        arb_data["locale"] = "en"
        arb_data["@locale"] = {
            "description": "Current locale"
        }
    
    # Check for parameterized methods that might need placeholders
    # These methods have parameters and need to be defined with placeholders
    
    # monthDay expects month (String) and day (int)
    if "monthDay" not in arb_data or "{month}" not in arb_data.get("monthDay", ""):
        arb_data["monthDay"] = "{month} {day}"
        arb_data["@monthDay"] = {
            "description": "Month and day format",
            "placeholders": {
                "month": {
                    "type": "String",
                    "example": "January"
                },
                "day": {
                    "type": "int",
                    "example": "1"
                }
            }
        }
    
    # purchaseConfirmMessage expects 3 parameters
    if "purchaseConfirmMessage" not in arb_data or "{title}" not in arb_data.get("purchaseConfirmMessage", ""):
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
    
    # daysAgo expects count and formatted string
    if "daysAgo" not in arb_data or "{count}" not in arb_data.get("daysAgo", ""):
        arb_data["daysAgo"] = "{count} {formatted}"
        arb_data["@daysAgo"] = {
            "description": "Days ago format",
            "placeholders": {
                "count": {
                    "type": "int",
                    "example": "3"
                },
                "formatted": {
                    "type": "String",
                    "example": "days ago"
                }
            }
        }
    
    # hoursAgo expects count and formatted string
    if "hoursAgo" not in arb_data or "{count}" not in arb_data.get("hoursAgo", ""):
        arb_data["hoursAgo"] = "{count} {formatted}"
        arb_data["@hoursAgo"] = {
            "description": "Hours ago format",
            "placeholders": {
                "count": {
                    "type": "int",
                    "example": "3"
                },
                "formatted": {
                    "type": "String",
                    "example": "hours ago"
                }
            }
        }
    
    # minutesAgo expects count and formatted string
    if "minutesAgo" not in arb_data or "{count}" not in arb_data.get("minutesAgo", ""):
        arb_data["minutesAgo"] = "{count} {formatted}"
        arb_data["@minutesAgo"] = {
            "description": "Minutes ago format",
            "placeholders": {
                "count": {
                    "type": "int",
                    "example": "3"
                },
                "formatted": {
                    "type": "String",
                    "example": "minutes ago"
                }
            }
        }
    
    # errorWithMessage expects error type and message
    if "errorWithMessage" not in arb_data or "{error}" not in arb_data.get("errorWithMessage", ""):
        arb_data["errorWithMessage"] = "{error}: {message}"
        arb_data["@errorWithMessage"] = {
            "description": "Error with message format",
            "placeholders": {
                "error": {
                    "type": "String",
                    "example": "Error"
                },
                "message": {
                    "type": "String",
                    "example": "Something went wrong"
                }
            }
        }
    
    # messagesRemaining should return a function, not a string
    # This needs to be handled differently - it should be a method that takes a parameter
    if "messagesRemaining" not in arb_data or "{count}" not in arb_data.get("messagesRemaining", ""):
        arb_data["messagesRemaining"] = "{count} messages remaining"
        arb_data["@messagesRemaining"] = {
            "description": "Messages remaining format",
            "placeholders": {
                "count": {
                    "type": "String",
                    "example": "10"
                }
            }
        }
    
    # Write back to file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, indent=2, ensure_ascii=False)
    
    print(f"Fixed remaining issues in {arb_path}")

if __name__ == "__main__":
    fix_remaining_issues()