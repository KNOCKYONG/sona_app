#!/usr/bin/env python3
"""
iOS 앱 아이콘 생성 스크립트
Android 아이콘과 동일한 스타일로 고품질 아이콘 생성
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_ios_icon():
    # 아이콘 크기 설정 (1024x1024)
    size = 1024
    
    # 핑크색 배경 (#FF6B9D를 RGB로 변환)
    background_color = (255, 107, 157)
    
    # 흰색 텍스트
    text_color = (255, 255, 255)
    
    # 안티앨리어싱을 위한 고해상도 이미지 생성 (4배 크기)
    upscale = 4
    hires_size = size * upscale
    
    # 고해상도 이미지 생성 - 투명 배경
    hires_img = Image.new('RGBA', (hires_size, hires_size), (0, 0, 0, 0))
    hires_draw = ImageDraw.Draw(hires_img)
    
    # Android와 동일한 둥근 사각형 그리기
    corner_radius = int(hires_size * 0.18)  # Android 스타일 corner radius
    hires_draw.rounded_rectangle(
        [(0, 0), (hires_size, hires_size)],
        radius=corner_radius,
        fill=background_color
    )
    
    # S 텍스트 그리기
    # 폰트 크기를 크게 설정 (아이콘 크기의 약 45% - Android와 동일하게)
    font_size = int(hires_size * 0.45)
    
    # 시스템 폰트 사용 (macOS) - 더 두꺼운 폰트 사용
    try:
        # SF Pro Display Heavy 또는 Helvetica Neue Bold 사용
        font_paths = [
            '/System/Library/Fonts/SFNS.ttf',
            '/System/Library/Fonts/Supplemental/SF-Pro-Display-Heavy.otf',
            '/System/Library/Fonts/Helvetica.ttc',
            '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
            '/Library/Fonts/Arial Bold.ttf'
        ]
        
        font = None
        for font_path in font_paths:
            if os.path.exists(font_path):
                try:
                    font = ImageFont.truetype(font_path, font_size, index=0)
                    break
                except:
                    continue
        
        if not font:
            # 대체 폰트 시도
            try:
                font = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', font_size, index=1)  # Bold index
            except:
                font = ImageFont.load_default()
                print("Warning: Using default font. Text may appear small.")
            
    except Exception as e:
        print(f"Font loading error: {e}")
        font = ImageFont.load_default()
    
    # S 텍스트 위치 계산 (중앙 정렬)
    text = "S"
    
    # 텍스트 바운딩 박스 가져오기
    bbox = hires_draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # 중앙 위치 계산 (살짝 위로 조정)
    x = (hires_size - text_width) // 2
    y = (hires_size - text_height) // 2 - int(hires_size * 0.03)
    
    # S 텍스트 그리기 (더 부드럽게)
    hires_draw.text((x, y), text, fill=text_color, font=font)
    
    # 다운샘플링 (안티앨리어싱 효과)
    final_img = hires_img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장 경로
    output_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/app_icon_ios.png'
    
    # 디렉토리가 없으면 생성
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # 이미지 저장 (고품질)
    final_img.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"iOS icon created: {output_path}")
    
    # 검증용 - 전체 꽉 찬 버전도 생성 (둥근 사각형)
    full_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    full_draw = ImageDraw.Draw(full_img)
    
    # Android와 동일한 둥근 사각형 그리기
    corner_radius_full = int(size * 0.18)
    full_draw.rounded_rectangle(
        [(0, 0), (size, size)],
        radius=corner_radius_full,
        fill=background_color
    )
    
    # 정사각형 버전을 위한 폰트 크기 조정
    square_font_size = int(size * 0.45)
    try:
        square_font = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', square_font_size, index=1)
    except:
        square_font = font
    
    # 텍스트 바운딩 박스 재계산
    bbox = full_draw.textbbox((0, 0), text, font=square_font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # 중앙 위치 계산
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - int(size * 0.03)
    
    full_draw.text((x, y), text, fill=text_color, font=square_font)
    
    full_output_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/app_icon_ios_full.png'
    full_img.save(full_output_path, 'PNG', quality=100, optimize=False)
    print(f"iOS full icon created (for testing): {full_output_path}")

if __name__ == "__main__":
    create_ios_icon()