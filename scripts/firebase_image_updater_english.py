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
                # Check if main images exist
                main_files = [
                    "main_thumb.jpg",
                    "main_small.jpg", 
                    "main_medium.jpg",
                    "main_large.jpg",
                    "main_original.jpg"
                ]
                
                if all((item / f).exists() for f in main_files):
                    english_name = item.name
                    korean_name = get_korean_name(english_name)
                    
                    # Count additional images
                    additional_images = []
                    idx = 1
                    while True:
                        image_files = [
                            f"image{idx}_thumb.jpg",
                            f"image{idx}_small.jpg",
                            f"image{idx}_medium.jpg",
                            f"image{idx}_large.jpg",
                            f"image{idx}_original.jpg"
                        ]
                        if all((item / f).exists() for f in image_files):
                            additional_images.append(idx)
                            idx += 1
                        else:
                            break
                    
                    personas.append({
                        'english_name': english_name,
                        'korean_name': korean_name,
                        'additional_images': additional_images
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
        additional_count = len(persona['additional_images'])
        print(f"  - {persona['korean_name']} (folder: {persona['english_name']}, "
              f"main + {additional_count} additional images)")
    
    print("\n" + "=" * 60)
    print("Firebase update preparation...")
    
    # We'll process one persona at a time using MCP
    for persona_info in personas:
        korean_name = persona_info['korean_name']
        english_name = persona_info['english_name']
        additional_images = persona_info['additional_images']
        
        print(f"\nProcessing: {korean_name}")
        print(f"  English folder: {english_name}")
        print(f"  Total images: 1 main + {len(additional_images)} additional")
        
        # Create imageUrls structure with main and additional images
        image_urls_data = {
            "imageUrls": {
                "mainImageUrls": {
                    "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg",
                    "small": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg",
                    "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg",
                    "large": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg",
                    "original": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"
                }
            },
            "updatedAt": datetime.now().isoformat() + "Z"
        }
        
        # Add additional images if any
        if additional_images:
            image_urls_data["imageUrls"]["additionalImageUrls"] = {}
            for idx in additional_images:
                image_urls_data["imageUrls"]["additionalImageUrls"][f"image{idx}"] = {
                    "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_thumb.jpg",
                    "small": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_small.jpg",
                    "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_medium.jpg",
                    "large": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_large.jpg",
                    "original": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_original.jpg"
                }
        
        print(f"  Image URLs prepared with main and additional images")
        print(f"  Main URL example: {image_urls_data['imageUrls']['mainImageUrls']['medium']}")
        if additional_images:
            print(f"  Additional URLs created for: {', '.join([f'image{idx}' for idx in additional_images])}")
        print(f"  Ready for Firebase update")
    
    print(f"\n" + "=" * 60)
    print("Ready to update Firebase documents!")
    print("Use Firebase MCP to update each persona with the generated URLs")
    print("\nNote: The URLs now use English folder names to avoid encoding issues")
    
    # Create update commands for Firebase MCP
    print(f"\n" + "=" * 60)
    print("Firebase Update Commands (for manual execution):")
    
    for persona_info in personas:
        korean_name = persona_info['korean_name']
        english_name = persona_info['english_name']
        additional_images = persona_info['additional_images']
        
        # Create the JSON structure for the update
        update_data = {
            "photoUrls": [],
            "imageUrls": {
                "mainImageUrls": {
                    "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg",
                    "small": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg",
                    "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg",
                    "large": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg",
                    "original": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"
                }
            }
        }
        
        # Add additional images if any
        if additional_images:
            update_data["imageUrls"]["additionalImageUrls"] = {}
            for idx in additional_images:
                update_data["imageUrls"]["additionalImageUrls"][f"image{idx}"] = {
                    "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_thumb.jpg",
                    "small": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_small.jpg",
                    "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_medium.jpg",
                    "large": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_large.jpg",
                    "original": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_original.jpg"
                }
        
        # Save the update data to a JSON file for easy MCP command execution
        import json
        json_filename = f"update_{english_name}.json"
        with open(json_filename, 'w', encoding='utf-8') as f:
            json.dump(update_data, f, ensure_ascii=False, indent=2)
        
        print(f"\n# Update {korean_name} ({english_name}):")
        print(f"# Saved update data to: {json_filename}")
        print(f"# Use with Firebase MCP to update the document")
    
    # After Firebase update is complete, clean up local assets
    print(f"\n" + "=" * 60)
    print("Cleaning up local optimized images and JSON files...")
    
    import shutil
    assets_dir = Path(r"C:\Users\yong\sonaapp\assets\personas")
    
    # Clean up assets directory
    if assets_dir.exists():
        try:
            # Remove the entire personas directory and its contents
            shutil.rmtree(assets_dir)
            print(f"✅ Successfully removed: {assets_dir}")
            print("All optimized images have been cleaned up.")
        except Exception as e:
            print(f"❌ Error removing assets directory: {e}")
    else:
        print("⚠️ Assets directory not found, nothing to clean up.")
    
    # Clean up JSON update files
    json_files_removed = 0
    for persona_info in personas:
        json_filename = f"update_{persona_info['english_name']}.json"
        if os.path.exists(json_filename):
            try:
                os.remove(json_filename)
                json_files_removed += 1
            except Exception as e:
                print(f"❌ Error removing {json_filename}: {e}")
    
    if json_files_removed > 0:
        print(f"✅ Successfully removed {json_files_removed} JSON update files.")

if __name__ == '__main__':
    main()