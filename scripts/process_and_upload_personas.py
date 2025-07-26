#!/usr/bin/env python3
"""
Persona Image Processor and Uploader
Processes persona images and uploads to Cloudflare R2 Storage
Updates Firebase persona collection with image URLs using MCP
"""

import os
import sys
import json
import subprocess
from PIL import Image
from pathlib import Path
from typing import Dict, List, Optional
import argparse
from datetime import datetime

# Cloudflare R2 configuration
R2_ACCESS_KEY = "YOUR_ACCESS_KEY"
R2_SECRET_KEY = "YOUR_SECRET_KEY"
R2_BUCKET = "sona-personas"
R2_PUBLIC_URL = "https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev/sona-personas"

# Image size configurations
SIZES = {
    'thumb': 150,
    'small': 300,
    'medium': 600,
    'large': 1200
}

class PersonaImageProcessor:
    def __init__(self, source_dir: str):
        self.source_dir = Path(source_dir)
    
    def _call_mcp_firebase(self, operation: str, **kwargs) -> dict:
        """Call MCP Firebase operations through Claude Code subprocess"""
        try:
            # MCP Firebase operations will be called through the main script
            # This is a placeholder for the actual MCP integration
            pass
        except Exception as e:
            print(f"MCP Firebase error: {e}")
            return {}
    
    def process_image(self, image_path: Path, persona_name: str) -> Dict[str, str]:
        """Process a single image and create optimized versions"""
        urls = {}
        
        try:
            with Image.open(image_path) as img:
                # Convert RGBA to RGB if necessary
                if img.mode in ('RGBA', 'LA'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
                
                # Get original dimensions
                orig_width, orig_height = img.size
                aspect_ratio = orig_width / orig_height
                
                # Process each size
                for size_name, target_size in SIZES.items():
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
                    
                    # Save and upload WebP version
                    webp_key = f"personas/{persona_name}/main_{size_name}.webp"
                    webp_path = Path(f"temp_{persona_name}_{size_name}.webp")
                    resized.save(webp_path, 'WEBP', quality=85, method=6)
                    
                    self._upload_to_r2(webp_path, webp_key)
                    urls[f"{size_name}_webp"] = f"{R2_PUBLIC_URL}/{webp_key}"
                    
                    # Save and upload JPEG version
                    jpg_key = f"personas/{persona_name}/main_{size_name}.jpg"
                    jpg_path = Path(f"temp_{persona_name}_{size_name}.jpg")
                    resized.save(jpg_path, 'JPEG', quality=90, optimize=True)
                    
                    self._upload_to_r2(jpg_path, jpg_key)
                    urls[f"{size_name}_jpg"] = f"{R2_PUBLIC_URL}/{jpg_key}"
                    
                    # Clean up temp files
                    webp_path.unlink(missing_ok=True)
                    jpg_path.unlink(missing_ok=True)
                    
                    print(f"  Processed {size_name}: {new_width}x{new_height}")
                
                # Also save original in WebP format
                orig_webp_key = f"personas/{persona_name}/main_original.webp"
                orig_webp_path = Path(f"temp_{persona_name}_original.webp")
                img.save(orig_webp_path, 'WEBP', quality=95, method=6)
                
                self._upload_to_r2(orig_webp_path, orig_webp_key)
                urls['original_webp'] = f"{R2_PUBLIC_URL}/{orig_webp_key}"
                orig_webp_path.unlink(missing_ok=True)
                
                return urls
                
        except Exception as e:
            print(f"  Error processing image {image_path}: {e}")
            return {}
    
    def _upload_to_r2(self, file_path: Path, key: str):
        """Upload file to Cloudflare R2 using MCP"""
        try:
            # Use MCP Cloudflare R2 to upload
            content_type = self._get_content_type(file_path)
            
            # Read file content
            with open(file_path, 'rb') as f:
                file_content = f.read()
            
            # This will be called through the main process using MCP
            print(f"    Prepared for upload: {key}")
            return True
        except Exception as e:
            print(f"    Error preparing upload {key}: {e}")
            return False
    
    def _get_content_type(self, file_path: Path) -> str:
        """Get content type based on file extension"""
        ext = file_path.suffix.lower()
        content_types = {
            '.webp': 'image/webp',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png'
        }
        return content_types.get(ext, 'application/octet-stream')
    
    def scan_persona_folders(self) -> Dict[str, List[Path]]:
        """Scan source directory for persona folders and images"""
        personas = {}
        
        for folder in self.source_dir.iterdir():
            if folder.is_dir():
                persona_name = folder.name
                images = []
                
                # Find all image files
                for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
                    images.extend(folder.glob(ext))
                
                if images:
                    personas[persona_name] = sorted(images)
                    print(f"Found {len(images)} images for persona: {persona_name}")
        
        return personas
    
    def update_firebase_persona(self, persona_name: str, image_urls: Optional[Dict[str, str]] = None):
        """Update Firebase persona document with image URLs using MCP"""
        try:
            if image_urls:
                # Create structured imageUrls object
                image_data = {
                    'thumb': {
                        'webp': image_urls.get('thumb_webp', ''),
                        'jpg': image_urls.get('thumb_jpg', '')
                    },
                    'small': {
                        'webp': image_urls.get('small_webp', ''),
                        'jpg': image_urls.get('small_jpg', '')
                    },
                    'medium': {
                        'webp': image_urls.get('medium_webp', ''),
                        'jpg': image_urls.get('medium_jpg', '')
                    },
                    'large': {
                        'webp': image_urls.get('large_webp', ''),
                        'jpg': image_urls.get('large_jpg', '')
                    },
                    'original': {
                        'webp': image_urls.get('original_webp', '')
                    }
                }
                
                print(f"  Prepared Firebase update for {persona_name}")
                return image_data
            else:
                print(f"  Prepared Firebase clear for {persona_name}")
                return {}
                
        except Exception as e:
            print(f"  Error preparing Firebase update for {persona_name}: {e}")
            return None
    
    def process_all_personas(self):
        """Process all personas in source directory"""
        print(f"Scanning directory: {self.source_dir}")
        print("=" * 60)
        
        # Get all personas from source directory
        persona_folders = self.scan_persona_folders()
        
        # This will return the results for MCP processing
        results = {
            'processed': {},
            'to_clear': []
        }
        
        # Process personas with folders
        for persona_name, images in persona_folders.items():
            print(f"\nProcessing: {persona_name}")
            print("-" * 40)
            
            # Process first image (or you can implement logic to select best image)
            if images:
                urls = self.process_image(images[0], persona_name)
                if urls:
                    image_data = self.update_firebase_persona(persona_name, urls)
                    if image_data is not None:
                        results['processed'][persona_name] = {
                            'urls': urls,
                            'image_data': image_data
                        }
        
        print("\n" + "=" * 60)
        print("Processing complete!")
        print(f"Prepared for processing: {len(results['processed'])} personas")
        
        return results

def main():
    parser = argparse.ArgumentParser(description='Process and upload persona images')
    parser.add_argument('--source', '-s', default='C:\\Users\\yong\\Documents\\personas',
                        help='Source directory containing persona folders')
    parser.add_argument('--r2-config', '-c', help='Path to R2 configuration file')
    
    args = parser.parse_args()
    
    # Load R2 config if provided
    if args.r2_config:
        with open(args.r2_config, 'r') as f:
            config = json.load(f)
            global R2_ACCESS_KEY, R2_SECRET_KEY, R2_BUCKET, R2_PUBLIC_URL
            R2_ACCESS_KEY = config.get('access_key', R2_ACCESS_KEY)
            R2_SECRET_KEY = config.get('secret_key', R2_SECRET_KEY)
            R2_BUCKET = config.get('bucket', R2_BUCKET)
            R2_PUBLIC_URL = config.get('public_url', R2_PUBLIC_URL)
    
    # Check if source directory exists
    if not os.path.exists(args.source):
        print(f"Error: Source directory '{args.source}' not found")
        sys.exit(1)
    
    # Create processor and run
    processor = PersonaImageProcessor(args.source)
    results = processor.process_all_personas()
    
    # Output results as JSON for MCP processing
    print("\n" + "=" * 60)
    print("RESULTS FOR MCP PROCESSING:")
    print(json.dumps(results, indent=2, ensure_ascii=False))

if __name__ == '__main__':
    main()