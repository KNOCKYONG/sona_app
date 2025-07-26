#!/usr/bin/env python3
"""
Automated Persona Image Processor
Automatically processes all persona images and uploads to Cloudflare R2
Updates Firebase persona collection with optimized image URLs
"""

import os
import sys
import json
import subprocess
import time
from PIL import Image
from pathlib import Path
from typing import Dict, List, Optional, Set
import argparse
from datetime import datetime

# Configuration
PERSONAS_SOURCE_DIR = r"C:\Users\yong\Documents\personas"
R2_BUCKET = "sona-personas"
R2_PUBLIC_URL = "https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev/sona-personas"

# Image size configurations
SIZES = {
    'thumb': 150,
    'small': 300,
    'medium': 600,
    'large': 1200
}

class AutoPersonaImageProcessor:
    def __init__(self, source_dir: str = PERSONAS_SOURCE_DIR):
        self.source_dir = Path(source_dir)
        self.processed_count = 0
        self.skipped_count = 0
        self.error_count = 0
        
    def scan_persona_folders(self) -> Dict[str, List[Path]]:
        """Scan source directory for persona folders and images"""
        personas = {}
        
        if not self.source_dir.exists():
            print(f"❌ Source directory not found: {self.source_dir}")
            return personas
            
        print(f"📁 Scanning: {self.source_dir}")
        
        for folder in self.source_dir.iterdir():
            if folder.is_dir():
                persona_name = folder.name
                images = []
                
                # Find all image files
                for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
                    images.extend(folder.glob(ext))
                
                if images:
                    personas[persona_name] = sorted(images)
                    print(f"✅ Found {len(images)} images for: {persona_name}")
                else:
                    print(f"⚠️  No images found in: {persona_name}")
        
        return personas
    
    def get_firebase_personas(self) -> Set[str]:
        """Get all persona names from Firebase collection"""
        try:
            # This will be called through MCP
            result = subprocess.run([
                'claude', '--mcp', 'firebase', 'list_documents', 
                '--collection', 'personas', '--limit', '100'
            ], capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                data = json.loads(result.stdout)
                return {doc['data']['name'] for doc in data.get('documents', []) if 'name' in doc['data']}
            else:
                print(f"⚠️  Failed to get Firebase personas: {result.stderr}")
                return set()
                
        except Exception as e:
            print(f"⚠️  Error getting Firebase personas: {e}")
            return set()
    
    def process_persona_image(self, image_path: Path, persona_name: str) -> Optional[Dict[str, str]]:
        """Process a single persona image to multiple sizes"""
        try:
            with Image.open(image_path) as img:
                # Convert RGBA to RGB if necessary
                if img.mode in ('RGBA', 'LA'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
                
                orig_width, orig_height = img.size
                aspect_ratio = orig_width / orig_height
                
                urls = {}
                temp_files = []
                
                # Process each size
                for size_name, target_size in SIZES.items():
                    if orig_width > orig_height:
                        new_width = target_size
                        new_height = int(target_size / aspect_ratio)
                    else:
                        new_height = target_size
                        new_width = int(target_size * aspect_ratio)
                    
                    # Don't upscale images
                    if new_width > orig_width or new_height > orig_height:
                        new_width, new_height = orig_width, orig_height
                    
                    resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                    
                    # Save WebP and JPEG
                    webp_file = f"temp_{persona_name}_{size_name}.webp"
                    jpg_file = f"temp_{persona_name}_{size_name}.jpg"
                    
                    resized.save(webp_file, 'WEBP', quality=85, method=6)
                    resized.save(jpg_file, 'JPEG', quality=90, optimize=True)
                    
                    temp_files.extend([webp_file, jpg_file])
                    
                    # Generate URLs
                    urls[f"{size_name}_webp"] = f"{R2_PUBLIC_URL}/personas/{persona_name}/main_{size_name}.webp"
                    urls[f"{size_name}_jpg"] = f"{R2_PUBLIC_URL}/personas/{persona_name}/main_{size_name}.jpg"
                    
                    print(f"    ✅ {size_name}: {new_width}x{new_height}")
                
                # Save original as WebP
                orig_webp_file = f"temp_{persona_name}_original.webp"
                img.save(orig_webp_file, 'WEBP', quality=95, method=6)
                temp_files.append(orig_webp_file)
                
                urls['original_webp'] = f"{R2_PUBLIC_URL}/personas/{persona_name}/main_original.webp"
                
                # Upload to R2
                upload_success = self.upload_images_to_r2(persona_name, temp_files)
                
                # Clean up temp files
                for temp_file in temp_files:
                    Path(temp_file).unlink(missing_ok=True)
                
                return urls if upload_success else None
                
        except Exception as e:
            print(f"    ❌ Error processing image: {e}")
            return None
    
    def upload_images_to_r2(self, persona_name: str, temp_files: List[str]) -> bool:
        """Upload all image files to Cloudflare R2"""
        try:
            success_count = 0
            
            for temp_file in temp_files:
                if not Path(temp_file).exists():
                    continue
                    
                # Extract size and format from filename
                parts = temp_file.replace(f"temp_{persona_name}_", "").split(".")
                size_name = parts[0]
                file_format = parts[1]
                
                # Generate R2 key
                r2_key = f"personas/{persona_name}/main_{size_name}.{file_format}"
                
                # Upload using MCP
                result = subprocess.run([
                    'claude', '--mcp', 'cloudflare-r2', 'put_object',
                    '--bucket', R2_BUCKET,
                    '--key', r2_key,
                    '--content', temp_file,
                    '--content-type', f"image/{file_format}"
                ], capture_output=True, text=True, timeout=60)
                
                if result.returncode == 0:
                    success_count += 1
                    print(f"    📤 Uploaded: {r2_key}")
                else:
                    print(f"    ❌ Upload failed: {r2_key} - {result.stderr}")
            
            return success_count == len(temp_files)
            
        except Exception as e:
            print(f"    ❌ Upload error: {e}")
            return False
    
    def update_firebase_persona(self, persona_name: str, image_urls: Dict[str, str]) -> bool:
        """Update Firebase persona document with image URLs"""
        try:
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
            
            # Update Firebase using MCP
            update_data = {
                'imageUrls': image_data,
                'updatedAt': datetime.now().isoformat()
            }
            
            result = subprocess.run([
                'claude', '--mcp', 'firebase', 'update_document_by_name',
                '--collection', 'personas',
                '--name-field', 'name',
                '--name-value', persona_name,
                '--data', json.dumps(update_data)
            ], capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                print(f"    🔄 Updated Firebase for: {persona_name}")
                return True
            else:
                print(f"    ❌ Firebase update failed: {persona_name} - {result.stderr}")
                return False
                
        except Exception as e:
            print(f"    ❌ Firebase error: {e}")
            return False
    
    def clear_firebase_persona_images(self, persona_name: str) -> bool:
        """Clear Firebase persona imageUrls field"""
        try:
            update_data = {
                'imageUrls': {},
                'updatedAt': datetime.now().isoformat()
            }
            
            result = subprocess.run([
                'claude', '--mcp', 'firebase', 'update_document_by_name',
                '--collection', 'personas',
                '--name-field', 'name',
                '--name-value', persona_name,
                '--data', json.dumps(update_data)
            ], capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                print(f"    🗑️  Cleared images for: {persona_name}")
                return True
            else:
                print(f"    ❌ Clear failed: {persona_name} - {result.stderr}")
                return False
                
        except Exception as e:
            print(f"    ❌ Clear error: {e}")
            return False
    
    def process_all_personas(self, force_update: bool = False) -> Dict[str, any]:
        """Process all personas automatically"""
        print(">> Starting automated persona image processing...")
        print("=" * 60)
        
        start_time = time.time()
        
        # Get personas from folders and Firebase
        folder_personas = self.scan_persona_folders()
        firebase_personas = self.get_firebase_personas()
        
        print(f"\n📊 Summary:")
        print(f"   Folder personas: {len(folder_personas)}")
        print(f"   Firebase personas: {len(firebase_personas)}")
        
        results = {
            'processed': {},
            'cleared': [],
            'errors': [],
            'skipped': []
        }
        
        # Process personas with folders
        print(f"\n🖼️  Processing personas with images:")
        print("-" * 40)
        
        for persona_name, images in folder_personas.items():
            print(f"\n📁 Processing: {persona_name}")
            
            if not images:
                print(f"    ⚠️  No images found, skipping")
                self.skipped_count += 1
                results['skipped'].append(persona_name)
                continue
            
            # Use first image
            image_path = images[0]
            print(f"    🖼️  Using: {image_path.name}")
            
            # Process image
            urls = self.process_persona_image(image_path, persona_name)
            
            if urls:
                # Update Firebase
                if self.update_firebase_persona(persona_name, urls):
                    self.processed_count += 1
                    results['processed'][persona_name] = urls
                    print(f"    ✅ Completed: {persona_name}")
                else:
                    self.error_count += 1
                    results['errors'].append(f"{persona_name}: Firebase update failed")
            else:
                self.error_count += 1
                results['errors'].append(f"{persona_name}: Image processing failed")
        
        # Clear personas without folders
        personas_without_folders = firebase_personas - set(folder_personas.keys())
        
        if personas_without_folders:
            print(f"\n🗑️  Clearing personas without folders:")
            print("-" * 40)
            
            for persona_name in personas_without_folders:
                print(f"🗑️  Clearing: {persona_name}")
                if self.clear_firebase_persona_images(persona_name):
                    results['cleared'].append(persona_name)
                else:
                    results['errors'].append(f"{persona_name}: Clear failed")
        
        # Summary
        elapsed_time = time.time() - start_time
        
        print(f"\n" + "=" * 60)
        print(f"✅ Processing complete!")
        print(f"   ⏱️  Time: {elapsed_time:.1f}s")
        print(f"   ✅ Processed: {self.processed_count}")
        print(f"   🗑️  Cleared: {len(results['cleared'])}")
        print(f"   ⚠️  Skipped: {self.skipped_count}")
        print(f"   ❌ Errors: {self.error_count}")
        
        if results['errors']:
            print(f"\n❌ Errors:")
            for error in results['errors']:
                print(f"   - {error}")
        
        return results

def main():
    parser = argparse.ArgumentParser(description='Automated persona image processing')
    parser.add_argument('--source', '-s', default=PERSONAS_SOURCE_DIR,
                        help='Source directory containing persona folders')
    parser.add_argument('--force', '-f', action='store_true',
                        help='Force update all personas')
    parser.add_argument('--dry-run', '-d', action='store_true',
                        help='Dry run - show what would be processed')
    
    args = parser.parse_args()
    
    # Check if source directory exists
    if not os.path.exists(args.source):
        print(f"❌ Error: Source directory '{args.source}' not found")
        sys.exit(1)
    
    processor = AutoPersonaImageProcessor(args.source)
    
    if args.dry_run:
        print(">> Dry run mode - scanning only...")
        personas = processor.scan_persona_folders()
        firebase_personas = processor.get_firebase_personas()
        
        print(f"\nWould process {len(personas)} personas:")
        for name in personas.keys():
            print(f"  - {name}")
        
        personas_to_clear = firebase_personas - set(personas.keys())
        if personas_to_clear:
            print(f"\nWould clear {len(personas_to_clear)} personas:")
            for name in personas_to_clear:
                print(f"  - {name}")
    else:
        results = processor.process_all_personas(args.force)
        
        # Output results as JSON for potential automation
        with open('persona_processing_results.json', 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    main()