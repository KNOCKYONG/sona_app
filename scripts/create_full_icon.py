#!/usr/bin/env python3
"""
여백 없이 완전히 꽉 찬 아이콘 생성
"""

from PIL import Image, ImageDraw
import os

def create_full_icon(size, output_path):
    """여백 없이 꽉 찬 둥근 사각형 아이콘 생성"""
    
    # 핑크색 배경 (#FF6B9D)
    background_color = (255, 107, 157)
    text_color = (255, 255, 255)
    
    # 고해상도로 생성 (안티앨리어싱)
    upscale = 4
    hires_size = size * upscale
    
    # 이미지 생성 - 꽉 찬 사각형
    img = Image.new('RGBA', (hires_size, hires_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 둥근 사각형 그리기 - 전체 캔버스를 꽉 채움
    corner_radius = int(hires_size * 0.18)  # Android 스타일
    draw.rounded_rectangle(
        [(0, 0), (hires_size-1, hires_size-1)],  # 전체 영역 사용
        radius=corner_radius,
        fill=background_color,
        outline=None
    )
    
    # S 텍스트 그리기
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
    
    draw.text((x, y), text, fill=text_color, font=font)
    
    # 다운샘플링 (안티앨리어싱)
    final_img = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    final_img.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created: {output_path} ({size}x{size})")
    
    return final_img

def main():
    base_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/'
    ios_assets_path = '/Users/nohdol/project/sonaapp/sona_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/'
    
    # 디렉토리 생성
    os.makedirs(base_path, exist_ok=True)
    
    # 메인 아이콘들 생성
    print("Creating main icons...")
    create_full_icon(1024, os.path.join(base_path, 'app_icon_ios_full.png'))
    create_full_icon(1024, os.path.join(base_path, 'app_icon_ios.png'))
    create_full_icon(512, os.path.join(base_path, 'app_icon.png'))
    
    # iOS에 필요한 모든 크기 생성
    print("\nCreating all iOS icon sizes...")
    
    # 1024 아이콘을 기준으로 리사이즈
    base_icon = create_full_icon(1024, '/tmp/temp_icon.png')
    
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
            # 각 크기별로 새로 생성 (품질 유지)
            create_full_icon(size, output_path)
    
    print("\n✅ All icons created successfully without any white space!")
    print("Icons are completely filled edge-to-edge with rounded corners.")

if __name__ == "__main__":
    main()