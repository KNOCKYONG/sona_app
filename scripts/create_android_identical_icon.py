#!/usr/bin/env python3
"""
Android 아이콘과 완전히 동일한 iOS 아이콘 생성
그라데이션 핑크 배경에 흰색 S 텍스트
"""

from PIL import Image, ImageDraw, ImageFont
import os
import numpy as np

def create_gradient(width, height):
    """대각선 그라데이션 생성 (Android app_icon_foreground와 동일)"""
    # 그라데이션 색상 (밝은 핑크 -> 진한 핑크)
    color1 = (255, 139, 189)  # 밝은 핑크 #FF8BBD
    color2 = (255, 91, 137)   # 진한 핑크 #FF5B89
    
    # 효율적인 그라데이션 생성
    gradient = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(gradient)
    
    # 대각선 그라데이션을 위한 선 그리기 방식
    for i in range(width + height):
        progress = i / (width + height - 1)
        r = int(color1[0] + (color2[0] - color1[0]) * progress)
        g = int(color1[1] + (color2[1] - color1[1]) * progress)
        b = int(color1[2] + (color2[2] - color1[2]) * progress)
        
        # 대각선 그리기
        if i < width:
            draw.line([(i, 0), (0, i)], fill=(r, g, b), width=2)
        else:
            draw.line([(width-1, i-width+1), (i-width+1, height-1)], fill=(r, g, b), width=2)
    
    return gradient

def create_android_identical_icon(size, output_path):
    """Android와 완전히 동일한 아이콘 생성 (그라데이션 포함)"""
    
    # 고해상도로 생성 (안티앨리어싱)
    upscale = 4
    hires_size = size * upscale
    
    # 투명 배경 이미지 생성
    img = Image.new('RGBA', (hires_size, hires_size), (0, 0, 0, 0))
    
    # 그라데이션 생성
    gradient = create_gradient(hires_size, hires_size)
    
    # 둥근 사각형 마스크 생성
    mask = Image.new('L', (hires_size, hires_size), 0)
    mask_draw = ImageDraw.Draw(mask)
    corner_radius = int(hires_size * 0.2237)  # iOS 표준 비율
    mask_draw.rounded_rectangle(
        [(0, 0), (hires_size-1, hires_size-1)],
        radius=corner_radius,
        fill=255
    )
    
    # 그라데이션에 마스크 적용
    img.paste(gradient, (0, 0))
    img.putalpha(mask)
    
    # Draw 객체 생성
    draw = ImageDraw.Draw(img)
    
    # S 텍스트 그리기
    font_size = int(hires_size * 0.45)
    
    try:
        # macOS 시스템 폰트 사용
        font_paths = [
            '/System/Library/Fonts/Helvetica.ttc',
            '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
            '/Library/Fonts/Arial Bold.ttf'
        ]
        
        font = None
        for font_path in font_paths:
            if os.path.exists(font_path):
                try:
                    font = ImageFont.truetype(font_path, font_size, index=1)  # Bold
                    break
                except:
                    continue
        
        if not font:
            font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
    
    # S 텍스트 중앙에 배치
    text = "S"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (hires_size - text_width) // 2
    y = (hires_size - text_height) // 2 - int(hires_size * 0.03)
    
    # 흰색 텍스트 (Android와 동일)
    draw.text((x, y), text, fill=(255, 255, 255), font=font)
    
    # 다운샘플링 (안티앨리어싱)
    final_img = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    final_img.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created Android-identical icon: {output_path} ({size}x{size})")
    
    return final_img

def main():
    base_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/'
    ios_assets_path = '/Users/nohdol/project/sonaapp/sona_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/'
    
    # 디렉토리 생성
    os.makedirs(base_path, exist_ok=True)
    
    # 메인 아이콘들 생성
    print("Creating Android-identical icons...")
    create_android_identical_icon(1024, os.path.join(base_path, 'app_icon_ios_full.png'))
    create_android_identical_icon(1024, os.path.join(base_path, 'app_icon_ios.png'))
    create_android_identical_icon(512, os.path.join(base_path, 'app_icon.png'))
    
    # iOS에 필요한 모든 크기 생성
    print("\nCreating all iOS icon sizes (Android-identical)...")
    
    icon_sizes = [
        ('Icon-App-20x20@1x.png', 20),
        ('Icon-App-20x20@2x.png', 40),
        ('Icon-App-20x20@3x.png', 60),
        ('Icon-App-29x29@1x.png', 29),
        ('Icon-App-29x29@2x.png', 58),
        ('Icon-App-29x29@3x.png', 87),
        ('Icon-App-40x40@1x.png', 40),
        ('Icon-App-40x40@2x.png', 80),
        ('Icon-App-40x40@3x.png', 120),
        ('Icon-App-60x60@2x.png', 120),
        ('Icon-App-60x60@3x.png', 180),
        ('Icon-App-76x76@1x.png', 76),
        ('Icon-App-76x76@2x.png', 152),
        ('Icon-App-83.5x83.5@2x.png', 167),
        ('Icon-App-1024x1024@1x.png', 1024),
        # Additional sizes
        ('Icon-App-50x50@1x.png', 50),
        ('Icon-App-50x50@2x.png', 100),
        ('Icon-App-57x57@1x.png', 57),
        ('Icon-App-57x57@2x.png', 114),
        ('Icon-App-72x72@1x.png', 72),
        ('Icon-App-72x72@2x.png', 144),
    ]
    
    for filename, size in icon_sizes:
        output_path = os.path.join(ios_assets_path, filename)
        if os.path.exists(output_path) or '1024' in filename:
            create_android_identical_icon(size, output_path)
    
    print("\n✅ All icons created successfully!")
    print("iOS icons are now IDENTICAL to Android icon:")
    print("- Gradient pink background (light to dark pink)")
    print("- White 'S' text")
    print("- No black outline")

if __name__ == "__main__":
    main()