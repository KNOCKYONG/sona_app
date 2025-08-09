#!/usr/bin/env python3
"""
Android 아이콘을 여백 없이 꽉 차게 리사이즈
"""

from PIL import Image
import os

def crop_and_resize_icon(input_path, output_path, size):
    """이미지의 투명 영역을 제거하고 리사이즈하여 저장"""
    img = Image.open(input_path)
    
    # RGBA 모드로 변환
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # 이미지의 실제 콘텐츠 영역 찾기 (투명하지 않은 부분)
    bbox = img.getbbox()
    
    if bbox:
        # 투명 영역 제거 (크롭)
        cropped = img.crop(bbox)
    else:
        cropped = img
    
    # 정사각형으로 만들기 위해 가장 긴 변 기준으로 캔버스 생성
    width, height = cropped.size
    max_dim = max(width, height)
    
    # 새로운 정사각형 캔버스 생성 (투명 배경)
    square_img = Image.new('RGBA', (max_dim, max_dim), (0, 0, 0, 0))
    
    # 중앙에 이미지 배치
    paste_x = (max_dim - width) // 2
    paste_y = (max_dim - height) // 2
    square_img.paste(cropped, (paste_x, paste_y))
    
    # 고품질 리사이즈
    resized = square_img.resize((size, size), Image.Resampling.LANCZOS)
    
    # 저장
    resized.save(output_path, 'PNG', quality=100, optimize=False)
    print(f"Created: {output_path} ({size}x{size})")

def main():
    # Android 아이콘 경로
    input_image = '/Users/nohdol/project/sonaapp/sona_app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'
    
    if not os.path.exists(input_image):
        print("Error: Android icon not found")
        return
    
    # 출력 경로들
    base_path = '/Users/nohdol/project/sonaapp/sona_app/assets/icons/'
    
    # 디렉토리가 없으면 생성
    os.makedirs(base_path, exist_ok=True)
    
    # 각 아이콘 생성 (여백 없이)
    # app_icon_ios_full.png - 1024x1024
    crop_and_resize_icon(input_image, os.path.join(base_path, 'app_icon_ios_full.png'), 1024)
    
    # app_icon_ios.png - 1024x1024
    crop_and_resize_icon(input_image, os.path.join(base_path, 'app_icon_ios.png'), 1024)
    
    # app_icon.png - 512x512
    crop_and_resize_icon(input_image, os.path.join(base_path, 'app_icon.png'), 512)
    
    # Xcode Assets에도 복사
    xcode_path = '/Users/nohdol/project/sonaapp/sona_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png'
    crop_and_resize_icon(input_image, xcode_path, 1024)
    print(f"Updated Xcode icon: {xcode_path}")
    
    print("\nAll icons created successfully without padding!")

if __name__ == "__main__":
    main()