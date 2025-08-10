#!/usr/bin/env python3
"""
그라데이션 효과가 있는 아이콘 생성
"""

from PIL import Image, ImageDraw, ImageFont
import os
import numpy as np

def create_gradient(width, height):
    """대각선 그라데이션 생성"""
    # 그라데이션 색상 (밝은 핑크 -> 진한 핑크)
    color1 = (255, 139, 189)  # 밝은 핑크 #FF8BBD
    color2 = (255, 91, 137)   # 진한 핑크 #FF5B89
    
    # 그라데이션 배열 생성
    gradient = np.zeros((height, width, 4), dtype=np.uint8)
    
    for y in range(height):
        for x in range(width):
            # 대각선 그라데이션 (좌상단에서 우하단으로)
            t = (x + y) / (width + height)
            
            # 색상 보간
            r = int(color1[0] * (1 - t) + color2[0] * t)
            g = int(color1[1] * (1 - t) + color2[1] * t)
            b = int(color1[2] * (1 - t) + color2[2] * t)
            
            gradient[y, x] = [r, g, b, 255]
    
    return Image.fromarray(gradient, 'RGBA')

def create_gradient_icon(size, output_path):
    """그라데이션 배경의 둥근 사각형 아이콘 생성"""
    
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
    corner_radius = int(hires_size * 0.18)  # Android 스타일
    mask_draw.rounded_rectangle(
        [(0, 0), (hires_size-1, hires_size-1)],
        radius=corner_radius,
        fill=255
    )
    
    # 그라데이션에 마스크 적용
    img.paste(gradient, (0, 0))
    img.putalpha(mask)
    
    # 약간의 그림자 효과 추가 (깊이감)
    shadow = Image.new('RGBA', (hires_size, hires_size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    
    # 상단에 밝은 효과
    for i in range(int(hires_size * 0.02)):
        alpha = int(20 * (1 - i / (hires_size * 0.02)))
        shadow_draw.rounded_rectangle(
            [(i, i), (hires_size-1-i, hires_size-1-i)],
            radius=corner_radius-i,
            outline=(255, 255, 255, alpha),
            width=1
        )
    
    # 하단에 어두운 효과
    for i in range(int(hires_size * 0.01)):
        alpha = int(15 * (1 - i / (hires_size * 0.01)))
        shadow_draw.rounded_rectangle(
            [(i, i), (hires_size-1-i, hires_size-1-i)],
            radius=corner_radius-i,
            outline=(0, 0, 0, alpha),
            width=1
        )
    
    # 그림자 효과 합성
    img = Image.alpha_composite(img, shadow)
    
    # S 텍스트 그리기
    draw = ImageDraw.Draw(img)
    
    # 폰트 로드
    font_size = int(hires_size * 0.45)
    
    try:
        from PIL import ImageFont
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
        from PIL import ImageFont
        font = ImageFont.load_default()
    
    # S 텍스트 중앙에 배치
    text = "S"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (hires_size - text_width) // 2
    y = (hires_size - text_height) // 2 - int(hires_size * 0.03)
    
    # 텍스트에 약간의 그림자 효과
    shadow_offset = int(hires_size * 0.005)
    draw.text((x + shadow_offset, y + shadow_offset), text, 
              fill=(0, 0, 0, 80), font=font)  # 그림자
    draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)  # 메인 텍스트
    
    # 다운샘플링 (안티앨리어싱)
    final_img = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    final_img.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created gradient icon: {output_path} ({size}x{size})")
    
    return final_img

def main():
    base_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/'
    ios_assets_path = '/Users/nohdol/project/sonaapp/sona_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/'
    
    # 디렉토리 생성
    os.makedirs(base_path, exist_ok=True)
    
    # 메인 아이콘들 생성
    print("Creating main gradient icons...")
    create_gradient_icon(1024, os.path.join(base_path, 'app_icon_ios_full.png'))
    create_gradient_icon(1024, os.path.join(base_path, 'app_icon_ios.png'))
    create_gradient_icon(512, os.path.join(base_path, 'app_icon.png'))
    
    # iOS에 필요한 모든 크기 생성
    print("\nCreating all iOS gradient icon sizes...")
    
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
            create_gradient_icon(size, output_path)
    
    print("\n✅ All gradient icons created successfully!")
    print("Icons have beautiful gradient effect from light pink to dark pink.")

if __name__ == "__main__":
    main()