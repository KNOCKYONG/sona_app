#!/usr/bin/env python3
"""
신규 페르소나 이미지를 assets/personas 폴더로 최적화
"""

import os
import sys
from PIL import Image
from pathlib import Path
import json

# UTF-8 인코딩 설정
if sys.platform.startswith('win'):
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

# 신규 페르소나 목록
new_personas = [
    "건우", "도윤", "동혁", "민석", "민호",
    "성민", "세준", "수현", "시우", "우진",
    "원준", "유진", "정우", "지환", "지후",
    "태민", "태현", "하준", "현민", "현우"
]

# 영문 이름 매핑
name_mapping = {
    "건우": "geonwoo",
    "도윤": "doyoon", 
    "동혁": "donghyuk",
    "민석": "minseok",
    "민호": "minho",
    "성민": "seongmin",
    "세준": "sejun",
    "수현": "soohyun",
    "시우": "siwoo",
    "우진": "woojin",
    "원준": "wonjoon",
    "유진": "yoojin",
    "정우": "jungwoo",
    "지환": "jihwan",
    "지후": "jihoo",
    "태민": "taemin",
    "태현": "taehyun",
    "하준": "hajoon",
    "현민": "hyunmin",
    "현우": "hyunwoo"
}

# 이미지 크기 설정
SIZES = {
    'thumb': 150,
    'small': 300, 
    'medium': 600,
    'large': 1200
}

def smart_crop_square(img, size):
    """스마트 정사각형 크롭"""
    width, height = img.size
    
    if width == height:
        return img
    
    # 세로가 더 긴 경우 (인물 사진), 상단 중심으로 크롭
    if width < height:
        crop_height = width
        top = min(int(height * 0.1), height - crop_height)  # 상단 10% 지점에서 시작
        return img.crop((0, top, width, top + crop_height))
    
    # 가로가 더 긴 경우, 중앙 크롭
    else:
        crop_width = height
        left = (width - crop_width) // 2
        return img.crop((left, 0, left + crop_width, height))

def optimize_persona_images(korean_name, english_name):
    """페르소나 이미지 최적화"""
    
    # 소스 디렉토리
    source_dir = Path(r"C:\Users\yong\Documents\personas") / korean_name
    
    # 출력 디렉토리 (assets/personas)
    output_dir = Path(r"C:\Users\yong\sonaapp\assets\personas") / english_name
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"\n처리중: {korean_name} -> {english_name}")
    
    # 이미지 파일 찾기
    image_files = []
    for ext in ['*.png', '*.jpg', '*.jpeg', '*.webp']:
        image_files.extend(source_dir.glob(ext))
    
    if not image_files:
        print(f"  [ERROR] 이미지 파일을 찾을 수 없습니다: {source_dir}")
        return False
    
    # 이미지 파일 정렬 (일관된 순서 보장)
    image_files = sorted(image_files, key=lambda x: x.name)
    print(f"  발견된 이미지: {len(image_files)}개")
    
    processed_count = 0
    
    for idx, source_image in enumerate(image_files):
        # 첫 번째 이미지는 "main", 나머지는 "image1", "image2" 등
        prefix = "main" if idx == 0 else f"image{idx}"
        print(f"  처리중: {source_image.name} -> {prefix}_*.jpg")
        
        try:
            with Image.open(source_image) as img:
                # RGB로 변환
                if img.mode in ('RGBA', 'LA'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    if img.mode == 'RGBA':
                        background.paste(img, mask=img.split()[3])
                    else:
                        background.paste(img)
                    img = background
                elif img.mode != 'RGB':
                    img = img.convert('RGB')
                
                orig_width, orig_height = img.size
                aspect_ratio = orig_width / orig_height
                
                # 각 크기별로 처리
                for size_name, target_size in SIZES.items():
                    # thumb과 small은 정사각형 크롭
                    if size_name in ['thumb', 'small']:
                        # 먼저 적절한 크기로 리사이즈
                        if orig_width > orig_height:
                            new_width = int(target_size * aspect_ratio)
                            new_height = target_size
                        else:
                            new_width = target_size
                            new_height = int(target_size / aspect_ratio)
                        
                        # 업스케일링 방지
                        if new_width > orig_width or new_height > orig_height:
                            resized = img.copy()
                        else:
                            resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                        
                        # 스마트 크롭
                        resized = smart_crop_square(resized, target_size)
                        
                        # 최종 크기로 리사이즈
                        if resized.size != (target_size, target_size):
                            resized = resized.resize((target_size, target_size), Image.Resampling.LANCZOS)
                    else:
                        # medium과 large는 비율 유지
                        if orig_width > orig_height:
                            new_width = target_size
                            new_height = int(target_size / aspect_ratio)
                        else:
                            new_height = target_size
                            new_width = int(target_size * aspect_ratio)
                        
                        # 업스케일링 방지
                        if new_width > orig_width or new_height > orig_height:
                            new_width, new_height = orig_width, orig_height
                        
                        resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                    
                    # 저장
                    output_file = output_dir / f"{prefix}_{size_name}.jpg"
                    resized.save(output_file, 'JPEG', quality=95, optimize=True, progressive=True)
                    print(f"    - {size_name}: {resized.size[0]}x{resized.size[1]}")
                
                # 원본도 저장
                output_original = output_dir / f"{prefix}_original.jpg"
                img.save(output_original, 'JPEG', quality=98, optimize=True, progressive=True)
                print(f"    - original: {orig_width}x{orig_height}")
                
                processed_count += 1
                
        except Exception as e:
            print(f"    [ERROR] {source_image.name} 처리 실패: {e}")
            continue
    
    if processed_count > 0:
        print(f"  [SUCCESS] {processed_count}/{len(image_files)} 이미지 처리 완료")
        return True
    else:
        print(f"  [ERROR] 이미지 처리 실패")
        return False

def main():
    print("=" * 60)
    print("신규 페르소나 이미지 최적화 (assets 폴더)")
    print("=" * 60)
    
    # assets/personas 디렉토리 생성
    assets_dir = Path(r"C:\Users\yong\sonaapp\assets\personas")
    assets_dir.mkdir(parents=True, exist_ok=True)
    
    successful = []
    failed = []
    
    # 각 페르소나 처리
    for korean_name in new_personas:
        english_name = name_mapping.get(korean_name)
        if not english_name:
            print(f"[ERROR] {korean_name}의 영문 매핑을 찾을 수 없습니다")
            failed.append(korean_name)
            continue
        
        if optimize_persona_images(korean_name, english_name):
            successful.append({
                "korean": korean_name,
                "english": english_name
            })
        else:
            failed.append(korean_name)
    
    # 결과 요약
    print("\n" + "=" * 60)
    print("최적화 완료!")
    print(f"  성공: {len(successful)}/{len(new_personas)}")
    print(f"  실패: {len(failed)}")
    
    if successful:
        print("\n성공한 페르소나:")
        for persona in successful:
            print(f"  - {persona['korean']} -> {persona['english']}")
        print(f"\n이미지 저장 위치: {assets_dir}")
    
    if failed:
        print("\n실패한 페르소나:")
        for name in failed:
            print(f"  - {name}")
    
    # 결과를 JSON으로 저장
    result = {
        "successful": successful,
        "failed": failed,
        "total": len(new_personas),
        "success_count": len(successful)
    }
    
    result_file = Path(r"C:\Users\yong\sonaapp\optimization_result_new.json")
    with open(result_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    
    print(f"\n결과 저장: {result_file}")

if __name__ == '__main__':
    main()