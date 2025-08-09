#!/usr/bin/env python3
"""
제공된 이미지를 사용하여 여러 크기의 아이콘 생성
"""

from PIL import Image
import sys
import os

def resize_icon(input_path, output_path, size):
    """이미지를 리사이즈하여 저장"""
    img = Image.open(input_path)
    
    # RGBA 모드로 변환
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # 고품질 리사이즈
    resized = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    resized.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created: {output_path} ({size}x{size})")

def main():
    # 입력 이미지 경로 (제공된 이미지를 임시로 저장)
    input_image = sys.argv[1] if len(sys.argv) > 1 else None
    
    if not input_image or not os.path.exists(input_image):
        print("Error: Input image not found")
        return
    
    # 출력 경로들
    base_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/'
    
    # 디렉토리가 없으면 생성
    os.makedirs(base_path, exist_ok=True)
    
    # 각 아이콘 생성
    # app_icon_ios_full.png - 1024x1024
    resize_icon(input_image, os.path.join(base_path, 'app_icon_ios_full.png'), 1024)
    
    # app_icon_ios.png - 1024x1024
    resize_icon(input_image, os.path.join(base_path, 'app_icon_ios.png'), 1024)
    
    # app_icon.png - 512x512
    resize_icon(input_image, os.path.join(base_path, 'app_icon.png'), 512)
    
    print("All icons created successfully!")

if __name__ == "__main__":
    main()