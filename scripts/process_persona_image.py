#!/usr/bin/env python3
"""
Persona Image Processor
Processes persona images for optimal web delivery
"""

import os
import sys
from PIL import Image
import argparse
from pathlib import Path

def create_optimized_versions(input_path, output_dir, persona_name):
    """
    Create optimized versions of the persona image in different sizes
    """
    # Define size configurations
    sizes = {
        'thumb': 150,
        'small': 300,
        'medium': 600,
        'large': 1200
    }
    
    # Create output directory if it doesn't exist
    persona_dir = Path(output_dir) / 'personas' / persona_name
    persona_dir.mkdir(parents=True, exist_ok=True)
    
    # Open the original image
    try:
        with Image.open(input_path) as img:
            # Convert RGBA to RGB if necessary (for JPEG/WebP)
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            
            # Get original dimensions
            orig_width, orig_height = img.size
            aspect_ratio = orig_width / orig_height
            
            results = []
            
            for size_name, target_size in sizes.items():
                # Calculate new dimensions maintaining aspect ratio
                if orig_width > orig_height:
                    new_width = target_size
                    new_height = int(target_size / aspect_ratio)
                else:
                    new_height = target_size
                    new_width = int(target_size * aspect_ratio)
                
                # Don't upscale images
                if new_width > orig_width or new_height > orig_height:
                    new_width, new_height = orig_width, orig_height
                
                # Create resized image
                resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                
                # Save as WebP
                webp_path = persona_dir / f'main_{size_name}.webp'
                resized.save(webp_path, 'WEBP', quality=85, method=6)
                
                # Also save as JPEG for compatibility
                jpg_path = persona_dir / f'main_{size_name}.jpg'
                resized.save(jpg_path, 'JPEG', quality=90, optimize=True)
                
                results.append({
                    'size': size_name,
                    'webp': str(webp_path),
                    'jpg': str(jpg_path),
                    'dimensions': f'{new_width}x{new_height}'
                })
                
                print(f"✅ Created {size_name}: {new_width}x{new_height}")
            
            # Also save the original in WebP format
            orig_webp = persona_dir / 'main_original.webp'
            img.save(orig_webp, 'WEBP', quality=95, method=6)
            results.append({
                'size': 'original',
                'webp': str(orig_webp),
                'dimensions': f'{orig_width}x{orig_height}'
            })
            
            return results
            
    except Exception as e:
        print(f"❌ Error processing image: {e}")
        return None

def main():
    parser = argparse.ArgumentParser(description='Process persona images for web delivery')
    parser.add_argument('input', help='Input image path')
    parser.add_argument('--persona', '-p', required=True, help='Persona name')
    parser.add_argument('--output', '-o', default='.', help='Output directory (default: current directory)')
    
    args = parser.parse_args()
    
    # Check if input file exists
    if not os.path.exists(args.input):
        print(f"❌ Error: Input file '{args.input}' not found")
        sys.exit(1)
    
    print(f"🖼️  Processing image for persona: {args.persona}")
    print(f"📁 Input: {args.input}")
    print(f"📂 Output directory: {args.output}")
    print()
    
    results = create_optimized_versions(args.input, args.output, args.persona)
    
    if results:
        print("\n✨ Processing complete!")
        print("\n📋 Generated files:")
        for result in results:
            print(f"  - {result['size']}: {result['dimensions']}")
            print(f"    WebP: {result['webp']}")
            if 'jpg' in result:
                print(f"    JPEG: {result['jpg']}")
    else:
        sys.exit(1)

if __name__ == '__main__':
    main()