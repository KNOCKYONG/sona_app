#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Upload processed images to Cloudflare R2
"""

import os
import sys
import boto3
from botocore.exceptions import NoCredentialsError
import json
from datetime import datetime

# R2 configuration
R2_ENDPOINT = "https://4648f6e7b18891c0a10bb5704caabb31.r2.cloudflarestorage.com"
R2_ACCESS_KEY_ID = "24qPI_Zai5V-pVZPji1qY9Y8lrhTY1ZDpcyKQmbw"
R2_SECRET_ACCESS_KEY = "YOUR_SECRET_KEY"  # You need to provide this
R2_BUCKET_NAME = "sona-personas"
R2_PUBLIC_URL = "https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev"

def upload_to_r2(local_path, r2_key):
    """Upload a file to R2 and return the public URL"""
    
    try:
        # Create S3 client for R2
        s3_client = boto3.client(
            's3',
            endpoint_url=R2_ENDPOINT,
            aws_access_key_id=R2_ACCESS_KEY_ID,
            aws_secret_access_key=R2_SECRET_ACCESS_KEY,
            region_name='auto'
        )
        
        # Upload file
        with open(local_path, 'rb') as file:
            s3_client.put_object(
                Bucket=R2_BUCKET_NAME,
                Key=r2_key,
                Body=file,
                ContentType='image/webp'
            )
        
        # Generate public URL
        public_url = f"{R2_PUBLIC_URL}/{r2_key}"
        return public_url
        
    except FileNotFoundError:
        print(f"Error: File not found: {local_path}")
        return None
    except NoCredentialsError:
        print("Error: R2 credentials not configured properly")
        return None
    except Exception as e:
        print(f"Error uploading {local_path}: {str(e)}")
        return None

def upload_persona_images(persona_name, image_dir):
    """Upload all persona images to R2"""
    
    print(f"Uploading images for persona: {persona_name}")
    
    # Image files to upload
    image_files = [
        'main_thumb.webp',
        'main_small.webp',
        'main_medium.webp',
        'main_large.webp',
        'main_original.webp'
    ]
    
    results = {}
    
    for filename in image_files:
        local_path = os.path.join(image_dir, filename)
        
        if not os.path.exists(local_path):
            print(f"  - Skipping {filename} (file not found)")
            continue
        
        # R2 key path
        r2_key = f"personas/{persona_name}/{filename}"
        
        print(f"  - Uploading {filename}...", end='', flush=True)
        
        # Upload to R2
        public_url = upload_to_r2(local_path, r2_key)
        
        if public_url:
            file_size = os.path.getsize(local_path)
            results[filename] = {
                'url': public_url,
                'size_kb': round(file_size / 1024, 2)
            }
            print(f" ✓ ({results[filename]['size_kb']} KB)")
        else:
            print(" ✗ Failed")
    
    # Save upload results
    if results:
        results_file = os.path.join(image_dir, 'upload_results.json')
        with open(results_file, 'w', encoding='utf-8') as f:
            json.dump({
                'persona_name': persona_name,
                'uploaded_at': datetime.now().isoformat(),
                'images': results
            }, f, indent=2, ensure_ascii=False)
        
        print(f"\n✅ Successfully uploaded {len(results)} images")
        print(f"📁 Results saved to: {os.path.abspath(results_file)}")
        
        # Print URLs
        print("\n🌐 Public URLs:")
        for filename, data in results.items():
            print(f"  - {filename}: {data['url']}")
    
    return results

def main():
    if len(sys.argv) < 3:
        print("Usage: python upload_to_r2.py <persona_name> <image_directory>")
        print("Example: python upload_to_r2.py 윤미 윤미")
        sys.exit(1)
    
    persona_name = sys.argv[1]
    image_dir = sys.argv[2]
    
    if not os.path.exists(image_dir):
        print(f"Error: Directory not found: {image_dir}")
        sys.exit(1)
    
    # Note about secret key
    if R2_SECRET_ACCESS_KEY == "YOUR_SECRET_KEY":
        print("⚠️  Warning: R2 Secret Access Key not configured!")
        print("Please edit this script and add your R2 Secret Access Key")
        print("\nTo get your Secret Access Key:")
        print("1. Go to Cloudflare Dashboard")
        print("2. R2 → Manage R2 API Tokens")
        print("3. Create or view your token to get the Secret Access Key")
        sys.exit(1)
    
    # Upload images
    results = upload_to_r2_persona_images(persona_name, image_dir)
    
    if not results:
        print("\n❌ Upload failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()