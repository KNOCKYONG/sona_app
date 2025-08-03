#!/usr/bin/env python3
"""
Local Image Optimizer with English folder names - Creates optimized images in assets/personas folder
"""

import os
import sys
from PIL import Image
from pathlib import Path
from persona_name_mapping import get_english_name
import numpy as np

# Set UTF-8 encoding for Windows console
if sys.platform.startswith('win'):
    import locale
    if sys.stdout.encoding != 'utf-8':
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')

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

def remove_black_bars(img):
    """Remove black letterbox bars from top and bottom of image"""
    # Convert to numpy array
    img_array = np.array(img)
    
    # For RGB images
    if len(img_array.shape) == 3:
        # Calculate mean brightness for each row
        row_means = np.mean(img_array, axis=(1, 2))
    else:
        # For grayscale
        row_means = np.mean(img_array, axis=1)
    
    # Find non-black rows (threshold of 10 to account for very dark but not pure black)
    non_black_rows = np.where(row_means > 10)[0]
    
    if len(non_black_rows) == 0:
        return img
    
    # Get the bounds of non-black content
    top = non_black_rows[0]
    bottom = non_black_rows[-1] + 1
    
    # Check if we found black bars (more than 5% of image height)
    height = img_array.shape[0]
    if top > height * 0.05 or (height - bottom) > height * 0.05:
        print(f"    Detected black bars: top={top}px, bottom={height-bottom}px")
        # Crop the image
        if len(img_array.shape) == 3:
            cropped_array = img_array[top:bottom, :, :]
        else:
            cropped_array = img_array[top:bottom, :]
        return Image.fromarray(cropped_array)
    
    return img

def smart_crop_square(img, size):
    """Smart crop to square aspect ratio for persona cards"""
    width, height = img.size
    
    if width == height:
        return img
    
    # For portrait images, crop from top to focus on face area
    if width < height:
        # Take square from top portion (usually where face is)
        crop_height = width
        top = min(int(height * 0.1), height - crop_height)  # Start 10% from top or less
        return img.crop((0, top, width, top + crop_height))
    
    # For landscape images, center crop
    else:
        crop_width = height
        left = (width - crop_width) // 2
        return img.crop((left, 0, left + crop_width, height))

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
    """Optimize all images for a single persona"""
    
    korean_name = persona_info['korean_name']
    english_name = persona_info['english_name']
    persona_dir = persona_info['path']
    
    print(f"\nProcessing: {korean_name} -> {english_name}")
    
    output_persona_dir = Path(OUTPUT_DIR) / english_name
    
    # Create persona output directory with English name
    output_persona_dir.mkdir(parents=True, exist_ok=True)
    
    # Find all image files
    image_files = []
    for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
        image_files.extend(persona_dir.glob(ext))
    
    # Sort image files by name for consistent ordering
    image_files = sorted(image_files, key=lambda x: x.name)
        
    if not image_files:
        print(f"  ERROR: No images found")
        return False
    
    print(f"  Found {len(image_files)} images to process")
    
    processed_count = 0
    
    for idx, source_image in enumerate(image_files):
        # First image is "main", others are "image1", "image2", etc.
        prefix = "main" if idx == 0 else f"image{idx}"
        print(f"\n  Processing image {idx + 1}/{len(image_files)}: {source_image.name} -> {prefix}_*.jpg")
        
        try:
            with Image.open(source_image) as img:
                # Convert to RGB
                if img.mode in ('RGBA', 'LA'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
                elif img.mode != 'RGB':
                    img = img.convert('RGB')
                
                # Remove black bars if present
                img = remove_black_bars(img)
                
                orig_width, orig_height = img.size
                aspect_ratio = orig_width / orig_height
                print(f"    Original: {orig_width}x{orig_height}")
                
                # Process each size
                for size_name, target_size in SIZES.items():
                    # For thumbnail and small sizes, use smart square crop
                    if size_name in ['thumb', 'small']:
                        # First resize to target size maintaining aspect ratio
                        if orig_width > orig_height:
                            new_width = int(target_size * aspect_ratio)
                            new_height = target_size
                        else:
                            new_width = target_size
                            new_height = int(target_size / aspect_ratio)
                        
                        # Don't upscale
                        if new_width > orig_width or new_height > orig_height:
                            resized = img.copy()
                        else:
                            resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                        
                        # Then smart crop to square
                        resized = smart_crop_square(resized, target_size)
                        
                        # Final resize to exact target size if needed
                        if resized.size != (target_size, target_size):
                            resized = resized.resize((target_size, target_size), Image.Resampling.LANCZOS)
                    else:
                        # For medium and large, maintain aspect ratio
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
                    output_file = output_persona_dir / f"{prefix}_{size_name}.jpg"
                    resized.save(output_file, 'JPEG', quality=95, optimize=True, progressive=True)
                    
                    file_size = output_file.stat().st_size
                    print(f"    Created {size_name}: {new_width}x{new_height} ({file_size} bytes)")
                
                # Save original
                output_original = output_persona_dir / f"{prefix}_original.jpg"
                img.save(output_original, 'JPEG', quality=98, optimize=True, progressive=True)
                
                orig_file_size = output_original.stat().st_size
                print(f"    Created original: {orig_width}x{orig_height} ({orig_file_size} bytes)")
                
                processed_count += 1
                
        except Exception as e:
            print(f"    ERROR processing {source_image.name}: {e}")
            continue
    
    if processed_count > 0:
        print(f"\n  SUCCESS: {processed_count}/{len(image_files)} images processed and saved to {output_persona_dir}")
        return True
    else:
        print(f"  ERROR: No images could be processed")
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