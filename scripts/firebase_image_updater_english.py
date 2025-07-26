#!/usr/bin/env python3
"""
Firebase Image Updater with English folder names - Updates Firebase with R2 image URLs
"""

import os
from pathlib import Path
from datetime import datetime
from persona_name_mapping import get_english_name, get_korean_name

# Configuration
R2_BUCKET = "sona-personas"
# Using custom domain instead of R2 dev subdomain
R2_PUBLIC_URL = "https://teamsona.work"

def scan_r2_folders():
    """Scan R2 folders (based on local assets structure)"""
    assets_dir = Path(r"C:\Users\yong\sonaapp\assets\personas")
    
    personas = []
    if assets_dir.exists():
        for item in assets_dir.iterdir():
            if item.is_dir():
                # Check if all required images exist
                required_files = [
                    "main_thumb.jpg",
                    "main_small.jpg", 
                    "main_medium.jpg",
                    "main_large.jpg",
                    "main_original.jpg"
                ]
                
                if all((item / f).exists() for f in required_files):
                    english_name = item.name
                    korean_name = get_korean_name(english_name)
                    personas.append({
                        'english_name': english_name,
                        'korean_name': korean_name
                    })
    
    return personas

def main():
    print("Firebase Image Updater - English Folder Names Version")
    print("=" * 60)
    print("Checking for personas with optimized images...")
    
    # Scan for personas
    personas = scan_r2_folders()
    
    if not personas:
        print("\nNo personas found with complete image sets!")
        print("Please ensure:")
        print("1. You've run 'python scripts/local_image_optimizer_english.py'")
        print("2. You've uploaded assets/personas folder to Cloudflare R2")
        return
    
    print(f"\nFound {len(personas)} personas ready for update:")
    for persona in personas:
        print(f"  - {persona['korean_name']} (folder: {persona['english_name']})")
    
    print("\n" + "=" * 60)
    print("Firebase update preparation...")
    
    # We'll process one persona at a time using MCP
    for persona_info in personas:
        korean_name = persona_info['korean_name']
        english_name = persona_info['english_name']
        
        print(f"\nProcessing: {korean_name}")
        print(f"  English folder: {english_name}")
        
        # Create imageUrls structure with English folder names
        image_urls_data = {
            "imageUrls": {
                "thumb": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg"},
                "small": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg"},
                "medium": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg"},
                "large": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg"},
                "original": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"}
            },
            "updatedAt": datetime.now().isoformat() + "Z"
        }
        
        print(f"  Image URLs prepared with English paths")
        print(f"  Example URL: {image_urls_data['imageUrls']['medium']['jpg']}")
        print(f"  Ready for Firebase update")
    
    print(f"\n" + "=" * 60)
    print("Ready to update Firebase documents!")
    print("Use Firebase MCP to update each persona with the generated URLs")
    print("\nNote: The URLs now use English folder names to avoid encoding issues")

if __name__ == '__main__':
    main()