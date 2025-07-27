#!/usr/bin/env python3
"""
Update Firebase personas with correct imageUrls structure
"""

import json
from pathlib import Path

# Configuration - matching CLAUDE.md structure
personas_data = [
    {
        "korean_name": "채연",
        "english_name": "chaeyeon",
        "additional_images": []
    },
    {
        "korean_name": "Dr. 박지은",
        "english_name": "dr-park-jieun", 
        "additional_images": [1, 2]
    },
    {
        "korean_name": "하연",
        "english_name": "hayeon",
        "additional_images": [1, 2]
    },
    {
        "korean_name": "혜진",
        "english_name": "hyejin",
        "additional_images": []
    },
    {
        "korean_name": "정훈",
        "english_name": "jeonghoon",
        "additional_images": []
    },
    {
        "korean_name": "지우",
        "english_name": "jiwoo",
        "additional_images": []
    },
    {
        "korean_name": "상훈",
        "english_name": "sanghoon",
        "additional_images": []
    },
    {
        "korean_name": "수진",
        "english_name": "sujin",
        "additional_images": []
    },
    {
        "korean_name": "예림",
        "english_name": "yerim",
        "additional_images": [1, 2]
    },
    {
        "korean_name": "예슬",
        "english_name": "yeseul",
        "additional_images": [1, 2]
    },
    {
        "korean_name": "윤미",
        "english_name": "yoonmi",
        "additional_images": []
    }
]

def create_firebase_update_data(english_name):
    """Create Firebase update data matching CLAUDE.md structure"""
    # CLAUDE.md specified structure
    return {
        "imageUrls": {
            "thumb": {"jpg": f"https://teamsona.work/personas/{english_name}/main_thumb.jpg"},
            "small": {"jpg": f"https://teamsona.work/personas/{english_name}/main_small.jpg"},
            "medium": {"jpg": f"https://teamsona.work/personas/{english_name}/main_medium.jpg"},
            "large": {"jpg": f"https://teamsona.work/personas/{english_name}/main_large.jpg"},
            "original": {"jpg": f"https://teamsona.work/personas/{english_name}/main_original.jpg"}
        }
    }

def main():
    print("Firebase ImageUrls Update Script")
    print("=" * 60)
    
    # Create individual update files for each persona
    for persona in personas_data:
        korean_name = persona["korean_name"]
        english_name = persona["english_name"]
        
        print(f"\nProcessing: {korean_name} ({english_name})")
        
        # Create update data
        update_data = create_firebase_update_data(english_name)
        
        # Save to JSON file
        filename = f"firebase_update_{english_name}.json"
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(update_data, f, ensure_ascii=False, indent=2)
        
        print(f"  Created: {filename}")
        print(f"  Example URL: {update_data['imageUrls']['medium']['jpg']}")
    
    print("\n" + "=" * 60)
    print("Update files created successfully!")
    print("\nNext steps:")
    print("1. Use Firebase MCP to update each persona")
    print("2. Update command: mcp__firebase-mcp__firestore_update_document")
    print("3. Collection: personas")
    print("4. Find document by name field and update imageUrls")

if __name__ == "__main__":
    main()