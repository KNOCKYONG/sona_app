#!/usr/bin/env python3
"""
Clean up isCasual conditionals from chat_orchestrator.dart
"""

import re

def clean_iscasual_conditionals(content):
    """Remove isCasual conditionals and keep only casual responses"""
    
    # Pattern to match isCasual conditional blocks
    # This matches: 'key': isCasual ? [...] : [...]
    pattern = r"('[\w]+'):\s+isCasual\s*\?\s*\[(.*?)\]\s*:\s*\[(.*?)\](?=,\s*'|\s*},)"
    
    def replace_conditional(match):
        key = match.group(1)
        casual_content = match.group(2)
        # Return the key with just the casual array
        return f"{key}: [{casual_content}]"
    
    # Apply replacement
    cleaned_content = re.sub(pattern, replace_conditional, content, flags=re.DOTALL)
    
    return cleaned_content

def main():
    # Read the file
    file_path = r"C:\Users\yong\sonaapp\sona_app\lib\services\chat\chat_orchestrator.dart"
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Clean up isCasual conditionals
    cleaned_content = clean_iscasual_conditionals(content)
    
    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(cleaned_content)
    
    print("Successfully cleaned up isCasual conditionals")
    
    # Count remaining isCasual references
    remaining = cleaned_content.count('isCasual')
    print(f"Remaining isCasual references: {remaining}")

if __name__ == "__main__":
    main()