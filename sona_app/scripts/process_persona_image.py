#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Persona Image Processor
Processes persona images for optimal web/app usage
"""

import os
import sys
import argparse
from PIL import Image
import json
from datetime import datetime

# Image size configurations
IMAGE_SIZES = {
    'thumb': 150,
    'small': 300,
    'medium': 600,
    'large': 1200,
    'original': None
}

def process_image(input_path, persona_name, output_dir='personas'):
    """Process a single persona image into multiple sizes"""
    
    # Check if input file exists
    if not os.path.exists(input_path):
        print(f"Error: Image file not found: {input_path}")
        return None
    
    # Create output directory structure
    persona_dir = os.path.join(output_dir, persona_name)
    os.makedirs(persona_dir, exist_ok=True)
    
    print(f"Processing image for persona: {persona_name}")
    
    try:
        # Open the original image
        with Image.open(input_path) as img:
            # Convert RGBA to RGB if necessary
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode not in ('RGB',):
                img = img.convert('RGB')
            
            # Get original dimensions
            original_width, original_height = img.size
            print(f"Original size: {original_width}x{original_height}")
            
            results = {}
            
            # Process each size
            for size_name, target_width in IMAGE_SIZES.items():
                if size_name == 'original':
                    # Save original with WebP compression
                    output_path = os.path.join(persona_dir, f'main_{size_name}.webp')
                    img.save(output_path, 'WEBP', quality=85, method=6)
                    file_size = os.path.getsize(output_path)
                    results[size_name] = {
                        'path': output_path,
                        'width': original_width,
                        'height': original_height,
                        'size_kb': round(file_size / 1024, 2)
                    }
                    print(f"  - {size_name}: {original_width}x{original_height} ({results[size_name]['size_kb']} KB)")
                else:
                    # Skip if original is smaller than target
                    if original_width <= target_width:
                        # Use original size
                        output_path = os.path.join(persona_dir, f'main_{size_name}.webp')
                        img.save(output_path, 'WEBP', quality=80, method=6)
                        file_size = os.path.getsize(output_path)
                        results[size_name] = {
                            'path': output_path,
                            'width': original_width,
                            'height': original_height,
                            'size_kb': round(file_size / 1024, 2)
                        }
                        print(f"  - {size_name}: {original_width}x{original_height} (original size kept) ({results[size_name]['size_kb']} KB)")
                    else:
                        # Calculate new dimensions maintaining aspect ratio
                        aspect_ratio = original_height / original_width
                        new_width = target_width
                        new_height = int(new_width * aspect_ratio)
                        
                        # Resize image
                        resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                        
                        # Save as WebP
                        output_path = os.path.join(persona_dir, f'main_{size_name}.webp')
                        resized.save(output_path, 'WEBP', quality=80, method=6)
                        file_size = os.path.getsize(output_path)
                        
                        results[size_name] = {
                            'path': output_path,
                            'width': new_width,
                            'height': new_height,
                            'size_kb': round(file_size / 1024, 2)
                        }
                        print(f"  - {size_name}: {new_width}x{new_height} ({results[size_name]['size_kb']} KB)")
            
            # Save processing results
            results_file = os.path.join(persona_dir, 'processing_results.json')
            with open(results_file, 'w', encoding='utf-8') as f:
                json.dump({
                    'persona_name': persona_name,
                    'original_file': input_path,
                    'processed_at': datetime.now().isoformat(),
                    'images': results
                }, f, indent=2, ensure_ascii=False)
            
            print(f"\n✅ Successfully processed {len(results)} image sizes")
            print(f"📁 Output directory: {os.path.abspath(persona_dir)}")
            
            # Calculate total size
            total_size = sum(r['size_kb'] for r in results.values())
            print(f"💾 Total size: {round(total_size, 2)} KB")
            
            return results
            
    except Exception as e:
        print(f"Error processing image: {str(e)}")
        return None

def main():
    parser = argparse.ArgumentParser(description='Process persona images for web/app usage')
    parser.add_argument('input', help='Input image file path')
    parser.add_argument('--persona', required=True, help='Persona name')
    parser.add_argument('--output', default='personas', help='Output directory (default: personas)')
    
    args = parser.parse_args()
    
    # Process the image
    results = process_image(args.input, args.persona, args.output)
    
    if results:
        print("\n🎉 Image processing complete!")
    else:
        print("\n❌ Image processing failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()