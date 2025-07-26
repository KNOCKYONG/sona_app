#!/usr/bin/env python3
"""
Upload Persona Images to Cloudflare R2
Processes and uploads persona images with optimization
"""

import os
import sys
import json
import boto3
from PIL import Image
import argparse
from pathlib import Path
from typing import Dict, List, Optional

class PersonaImageUploader:
    def __init__(self, config_path: Optional[str] = None):
        """Initialize uploader with R2 credentials"""
        self.config = self.load_config(config_path)
        self.s3_client = self.create_r2_client()
        self.bucket_name = self.config.get('bucket_name', 'sona-personas')
        
    def load_config(self, config_path: Optional[str] = None) -> Dict:
        """Load R2 configuration from file or environment"""
        if config_path and os.path.exists(config_path):
            with open(config_path, 'r') as f:
                return json.load(f)
        
        # Try to load from environment variables
        return {
            'account_id': os.getenv('CLOUDFLARE_ACCOUNT_ID'),
            'access_key_id': os.getenv('CLOUDFLARE_ACCESS_KEY_ID'),
            'secret_access_key': os.getenv('CLOUDFLARE_SECRET_ACCESS_KEY'),
            'bucket_name': os.getenv('R2_BUCKET_NAME', 'sona-personas')
        }
    
    def create_r2_client(self):
        """Create boto3 client for R2"""
        if not all([self.config.get('account_id'), 
                    self.config.get('access_key_id'), 
                    self.config.get('secret_access_key')]):
            raise ValueError("Missing R2 credentials. Please configure credentials.")
        
        return boto3.client(
            's3',
            endpoint_url=f"https://{self.config['account_id']}.r2.cloudflarestorage.com",
            aws_access_key_id=self.config['access_key_id'],
            aws_secret_access_key=self.config['secret_access_key'],
            region_name='auto'
        )
    
    def process_and_upload_image(self, input_path: str, persona_name: str) -> List[Dict]:
        """Process image and upload all versions to R2"""
        sizes = {
            'thumb': 150,
            'small': 300,
            'medium': 600,
            'large': 1200
        }
        
        results = []
        
        try:
            with Image.open(input_path) as img:
                # Convert RGBA to RGB if necessary
                if img.mode in ('RGBA', 'LA'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
                
                orig_width, orig_height = img.size
                aspect_ratio = orig_width / orig_height
                
                # Process each size
                for size_name, target_size in sizes.items():
                    # Calculate dimensions
                    if orig_width > orig_height:
                        new_width = target_size
                        new_height = int(target_size / aspect_ratio)
                    else:
                        new_height = target_size
                        new_width = int(target_size * aspect_ratio)
                    
                    # Don't upscale
                    if new_width > orig_width or new_height > orig_height:
                        new_width, new_height = orig_width, orig_height
                    
                    # Resize image
                    resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                    
                    # Upload as WebP
                    webp_key = f"personas/{persona_name}/main_{size_name}.webp"
                    webp_url = self.upload_image_to_r2(resized, webp_key, 'webp')
                    
                    if webp_url:
                        results.append({
                            'size': size_name,
                            'format': 'webp',
                            'url': webp_url,
                            'key': webp_key,
                            'dimensions': f'{new_width}x{new_height}'
                        })
                        print(f"✅ Uploaded {size_name} ({new_width}x{new_height}): {webp_url}")
                
                # Upload original as well
                orig_key = f"personas/{persona_name}/main_original.webp"
                orig_url = self.upload_image_to_r2(img, orig_key, 'webp', quality=95)
                
                if orig_url:
                    results.append({
                        'size': 'original',
                        'format': 'webp',
                        'url': orig_url,
                        'key': orig_key,
                        'dimensions': f'{orig_width}x{orig_height}'
                    })
                    print(f"✅ Uploaded original ({orig_width}x{orig_height}): {orig_url}")
                
        except Exception as e:
            print(f"❌ Error processing image: {e}")
            return []
        
        return results
    
    def upload_image_to_r2(self, image: Image.Image, key: str, format: str, quality: int = 85) -> Optional[str]:
        """Upload PIL Image to R2"""
        from io import BytesIO
        
        try:
            # Convert image to bytes
            buffer = BytesIO()
            if format == 'webp':
                image.save(buffer, 'WEBP', quality=quality, method=6)
                content_type = 'image/webp'
            else:
                image.save(buffer, 'JPEG', quality=quality, optimize=True)
                content_type = 'image/jpeg'
            
            buffer.seek(0)
            
            # Upload to R2
            self.s3_client.put_object(
                Bucket=self.bucket_name,
                Key=key,
                Body=buffer.getvalue(),
                ContentType=content_type,
                CacheControl='public, max-age=31536000',
                Metadata={
                    'persona': key.split('/')[1],
                    'type': 'profile'
                }
            )
            
            # Return public URL
            return f"https://{self.bucket_name}.{self.config['account_id']}.r2.cloudflarestorage.com/{key}"
            
        except Exception as e:
            print(f"❌ Upload error for {key}: {e}")
            return None
    
    def save_results(self, results: List[Dict], persona_name: str):
        """Save upload results to JSON file"""
        output_file = f"persona_{persona_name}_urls.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump({
                'persona': persona_name,
                'images': results,
                'base_url': f"https://{self.bucket_name}.{self.config['account_id']}.r2.cloudflarestorage.com",
                'timestamp': str(Path(output_file).stat().st_mtime)
            }, f, indent=2, ensure_ascii=False)
        print(f"\n📄 Results saved to: {output_file}")

def main():
    parser = argparse.ArgumentParser(description='Upload persona images to Cloudflare R2')
    parser.add_argument('input', help='Input image path')
    parser.add_argument('--persona', '-p', required=True, help='Persona name')
    parser.add_argument('--config', '-c', help='R2 config file path')
    
    args = parser.parse_args()
    
    # Check if input file exists
    if not os.path.exists(args.input):
        print(f"❌ Error: Input file '{args.input}' not found")
        sys.exit(1)
    
    print(f"🚀 Uploading persona image to Cloudflare R2")
    print(f"👤 Persona: {args.persona}")
    print(f"📁 Input: {args.input}")
    print()
    
    try:
        uploader = PersonaImageUploader(args.config)
        results = uploader.process_and_upload_image(args.input, args.persona)
        
        if results:
            print(f"\n✨ Successfully uploaded {len(results)} images!")
            uploader.save_results(results, args.persona)
        else:
            print("\n❌ Upload failed")
            sys.exit(1)
            
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()