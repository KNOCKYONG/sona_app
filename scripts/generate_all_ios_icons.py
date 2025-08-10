#!/usr/bin/env python3
"""
iOS에 필요한 모든 크기의 아이콘 생성
"""

from PIL import Image
import os

def generate_icon(input_path, output_path, size):
    """아이콘을 특정 크기로 리사이즈"""
    img = Image.open(input_path)
    
    # RGBA 모드로 변환
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # 리사이즈
    resized = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    resized.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created: {output_path} ({size}x{size})")

def main():
    # 소스 이미지 (Android 아이콘 사용)
    source_image = '/Users/nohdol/project/sonaapp/sona_app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'
    
    if not os.path.exists(source_image):
        print("Error: Source icon not found")
        return
    
    # iOS Assets 경로
    ios_assets_path = '/Users/nohdol/project/sonaapp/sona_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/'
    
    # iOS에 필요한 모든 아이콘 크기
    icon_sizes = [
        # iPhone Notification
        ('Icon-App-20x20@2x.png', 40),
        ('Icon-App-20x20@3x.png', 60),
        
        # iPhone Settings
        ('Icon-App-29x29@2x.png', 58),
        ('Icon-App-29x29@3x.png', 87),
        
        # iPhone Spotlight
        ('Icon-App-40x40@2x.png', 80),
        ('Icon-App-40x40@3x.png', 120),
        
        # iPhone App
        ('Icon-App-60x60@2x.png', 120),
        ('Icon-App-60x60@3x.png', 180),
        
        # iPad Notification
        ('Icon-App-20x20@1x.png', 20),
        
        # iPad Settings
        ('Icon-App-29x29@1x.png', 29),
        
        # iPad Spotlight
        ('Icon-App-40x40@1x.png', 40),
        
        # iPad App
        ('Icon-App-76x76@1x.png', 76),
        ('Icon-App-76x76@2x.png', 152),
        
        # iPad Pro App
        ('Icon-App-83.5x83.5@2x.png', 167),
        
        # App Store
        ('Icon-App-1024x1024@1x.png', 1024),
        
        # Additional icons that might exist
        ('Icon-App-50x50@1x.png', 50),
        ('Icon-App-50x50@2x.png', 100),
        ('Icon-App-57x57@1x.png', 57),
        ('Icon-App-57x57@2x.png', 114),
        ('Icon-App-72x72@1x.png', 72),
        ('Icon-App-72x72@2x.png', 144),
    ]
    
    # 각 아이콘 생성
    for filename, size in icon_sizes:
        output_path = os.path.join(ios_assets_path, filename)
        if os.path.exists(output_path):  # 파일이 존재하는 경우만 업데이트
            generate_icon(source_image, output_path, size)
    
    print("\nAll iOS icons generated successfully!")

if __name__ == "__main__":
    main()