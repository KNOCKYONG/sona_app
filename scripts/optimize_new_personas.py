#!/usr/bin/env python3
"""
신규 20대 남성 페르소나 이미지 최적화 및 R2 업로드
"""

import os
from PIL import Image
import subprocess
import json
from pathlib import Path

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

def optimize_image(input_path, output_path, size):
    """이미지 최적화 및 리사이즈"""
    try:
        with Image.open(input_path) as img:
            # RGBA를 RGB로 변환 (투명 배경 제거)
            if img.mode == 'RGBA':
                # 흰색 배경 생성
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[3] if len(img.split()) > 3 else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # 리사이즈
            img.thumbnail(size, Image.Resampling.LANCZOS)
            
            # 저장 (품질 설정)
            if size[0] <= 200:  # thumb
                quality = 85
            elif size[0] <= 400:  # small
                quality = 88
            elif size[0] <= 800:  # medium
                quality = 90
            else:  # large, original
                quality = 92
                
            img.save(output_path, 'JPEG', quality=quality, optimize=True)
            return True
    except Exception as e:
        print(f"Error optimizing {input_path}: {e}")
        return False

def process_persona(korean_name, english_name):
    """페르소나 이미지 처리"""
    source_dir = Path(f"C:/Users/yong/Documents/personas/{korean_name}")
    output_dir = Path(f"optimized_images/{english_name}")
    
    # 출력 디렉토리 생성
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # 원본 이미지 찾기
    image_file = source_dir / f"{korean_name}.png"
    if not image_file.exists():
        print(f"[ERROR] Image not found for {korean_name}")
        return False
    
    print(f"Processing {korean_name} ({english_name})...")
    
    # 각 크기별로 최적화
    sizes = {
        "thumb": (200, 200),
        "small": (400, 400),
        "medium": (800, 800),
        "large": (1200, 1200),
        "original": (2000, 2000)
    }
    
    results = {}
    for size_name, dimensions in sizes.items():
        output_file = output_dir / f"main_{size_name}.jpg"
        if optimize_image(image_file, output_file, dimensions):
            results[size_name] = str(output_file)
            print(f"  [OK] {size_name}: {dimensions[0]}x{dimensions[1]}")
        else:
            print(f"  [FAIL] Failed to create {size_name}")
    
    return results

def main():
    print("=" * 50)
    print("New Persona Image Optimization")
    print("=" * 50)
    
    # 모든 페르소나 처리
    processed = []
    failed = []
    
    for korean_name in new_personas:
        english_name = name_mapping.get(korean_name)
        if not english_name:
            print(f"[ERROR] No English mapping for {korean_name}")
            failed.append(korean_name)
            continue
        
        result = process_persona(korean_name, english_name)
        if result:
            processed.append({
                "korean": korean_name,
                "english": english_name,
                "files": result
            })
        else:
            failed.append(korean_name)
        
        print()
    
    # 결과 저장
    results = {
        "processed": processed,
        "failed": failed,
        "total": len(new_personas),
        "success": len(processed)
    }
    
    with open("optimization_results.json", "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    
    print("=" * 50)
    print(f"[SUCCESS] Processed: {len(processed)}/{len(new_personas)}")
    if failed:
        print(f"[FAILED] Failed: {', '.join(failed)}")
    print("\n[SAVED] Results saved to optimization_results.json")

if __name__ == "__main__":
    main()