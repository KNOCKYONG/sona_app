#!/usr/bin/env python3
"""
Local Image Optimizer with English folder names - Creates optimized images in assets/personas folder
"""

import os
from PIL import Image
from pathlib import Path
from persona_name_mapping import get_english_name

# Configuration
PERSONAS_SOURCE_DIR = r"C:\Users\yong\Documents\personas"
OUTPUT_DIR = r"C:\Users\yong\sonaapp\assets\personas"

# Image sizes
SIZES = {
    'thumb': 150,
    'small': 300, 
    'medium': 600,
    'large': 1200
}

def create_output_directories():
    """Create output directory structure"""
    output_path = Path(OUTPUT_DIR)
    output_path.mkdir(parents=True, exist_ok=True)
    return output_path

def scan_personas():
    """Scan and return personas with images"""
    source_dir = Path(PERSONAS_SOURCE_DIR)
    personas = []
    
    print("Scanning persona folders...")
    print("-" * 40)
    
    for item in source_dir.iterdir():
        if item.is_dir():
            image_files = []
            for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
                image_files.extend(item.glob(ext))
            
            if image_files:
                korean_name = item.name
                english_name = get_english_name(korean_name)
                personas.append({
                    'korean_name': korean_name,
                    'english_name': english_name,
                    'path': item
                })
                print(f"Found: {korean_name} -> {english_name} ({len(image_files)} images)")
    
    return personas

def optimize_persona_images(persona_info: dict):
    """Optimize images for a single persona"""
    
    korean_name = persona_info['korean_name']
    english_name = persona_info['english_name']
    persona_dir = persona_info['path']
    
    print(f"\nProcessing: {korean_name} -> {english_name}")
    
    output_persona_dir = Path(OUTPUT_DIR) / english_name
    
    # Create persona output directory with English name
    output_persona_dir.mkdir(parents=True, exist_ok=True)
    
    # Find first image
    image_files = []
    for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
        image_files.extend(persona_dir.glob(ext))
        
    if not image_files:
        print(f"  ERROR: No images found")
        return False
        
    source_image = image_files[0]
    print(f"  Source: {source_image.name}")
    
    try:
        with Image.open(source_image) as img:
            # Convert to RGB
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            orig_width, orig_height = img.size
            aspect_ratio = orig_width / orig_height
            print(f"  Original: {orig_width}x{orig_height}")
            
            # Process each size
            for size_name, target_size in SIZES.items():
                # Calculate dimensions
                if orig_width > orig_height:
                    new_width = target_size
                    new_height = int(target_size / aspect_ratio)
                else:
                    new_height = target_size
                    new_width = int(target_size * aspect_ratio)
                
                if new_width > orig_width or new_height > orig_height:
                    new_width, new_height = orig_width, orig_height
                
                # Create resized image
                resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                
                # Save to output directory
                output_file = output_persona_dir / f"main_{size_name}.jpg"
                resized.save(output_file, 'JPEG', quality=95, optimize=True, progressive=True)
                
                file_size = output_file.stat().st_size
                print(f"  Created {size_name}: {new_width}x{new_height} ({file_size} bytes)")
            
            # Save original
            output_original = output_persona_dir / "main_original.jpg"
            img.save(output_original, 'JPEG', quality=98, optimize=True, progressive=True)
            
            orig_file_size = output_original.stat().st_size
            print(f"  Created original: {orig_width}x{orig_height} ({orig_file_size} bytes)")
            
        print(f"  SUCCESS: All images saved to {output_persona_dir}")
        return True
            
    except Exception as e:
        print(f"  ERROR: {e}")
        return False

def create_mapping_file(personas):
    """Create a mapping file for Korean to English names"""
    mapping_file = Path(OUTPUT_DIR) / "name_mapping.txt"
    
    with open(mapping_file, 'w', encoding='utf-8') as f:
        f.write("Korean Name -> English Name Mapping\n")
        f.write("=" * 40 + "\n")
        for persona in personas:
            f.write(f"{persona['korean_name']} -> {persona['english_name']}\n")
    
    print(f"\nMapping file created: {mapping_file}")

def main():
    print("Local Image Optimizer with English Folder Names")
    print("=" * 60)
    
    # Create output directory
    create_output_directories()
    
    # Scan personas
    personas = scan_personas()
    
    if not personas:
        print("\nNo personas with images found!")
        return
    
    print(f"\nFound {len(personas)} personas with images")
    print("=" * 60)
    
    # Process all personas
    successful = []
    failed = []
    
    for persona_info in personas:
        if optimize_persona_images(persona_info):
            successful.append(persona_info)
        else:
            failed.append(persona_info)
    
    # Create mapping file
    create_mapping_file(personas)
    
    # Summary
    print(f"\n" + "=" * 60)
    print(f"OPTIMIZATION COMPLETE!")
    print(f"  Total personas: {len(personas)}")
    print(f"  Successful: {len(successful)}")
    print(f"  Failed: {len(failed)}")
    
    if successful:
        print(f"\nSuccessfully optimized:")
        for persona in successful:
            print(f"  - {persona['korean_name']} -> {persona['english_name']}")
        print(f"\nImages saved to: {OUTPUT_DIR}")
    
    if failed:
        print(f"\nFailed personas:")
        for persona in failed:
            print(f"  - {persona['korean_name']}")

if __name__ == '__main__':
    main()