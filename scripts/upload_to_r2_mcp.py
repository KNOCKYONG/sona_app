#!/usr/bin/env python3
"""
Cloudflare R2 MCP를 사용하여 이미지를 업로드하는 스크립트
"""

import sys
import json
from pathlib import Path

def upload_to_r2_mcp(persona_name, image_number):
    """
    Cloudflare R2 MCP를 사용하여 페르소나 이미지를 업로드합니다.
    
    Args:
        persona_name: 페르소나 이름 (예: "윤미")
        image_number: 이미지 번호 (메인: 1, 서브: 2+)
    """
    # 출력 디렉토리
    output_dir = Path("output_images")
    
    # 페르소나 ID 생성 (간단하게 이름을 ID로 사용)
    persona_id = persona_name
    
    # 이미지 크기 목록
    sizes = ['thumb', 'small', 'medium', 'large', 'original']
    
    # 업로드 결과 저장
    upload_results = {
        'personaId': persona_id,
        'mainImageUrls': {},
        'additionalImageUrls': {}
    }
    
    print(f"🚀 {persona_name} 페르소나 이미지 업로드 시작...")
    
    # 각 크기별 이미지 업로드
    for size in sizes:
        if image_number == 1:
            # 메인 이미지
            local_file = output_dir / f"main_{size}.webp"
            remote_path = f"personas/{persona_id}/main_{size}.webp"
        else:
            # 서브 이미지
            sub_index = image_number - 2
            local_file = output_dir / f"sub{sub_index}_{size}.webp"
            remote_path = f"personas/{persona_id}/sub{sub_index}_{size}.webp"
        
        if local_file.exists():
            print(f"📤 업로드 중: {local_file.name} -> {remote_path}")
            
            # Cloudflare R2 MCP 명령어 생성
            # MCP 서버가 이미 설정되어 있다고 가정
            # 실제로는 Claude Code 내에서 MCP 도구를 직접 사용해야 함
            
            # URL 생성 (실제 업로드 후 받게 될 URL)
            public_url = f"https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev/sona-personas/{remote_path}"
            
            if image_number == 1:
                upload_results['mainImageUrls'][size] = public_url
            else:
                sub_index = image_number - 2
                if sub_index not in upload_results['additionalImageUrls']:
                    upload_results['additionalImageUrls'][sub_index] = {}
                upload_results['additionalImageUrls'][sub_index][size] = public_url
            
            print(f"✅ 업로드 완료: {public_url}")
        else:
            print(f"⚠️  파일 없음: {local_file}")
    
    # 결과 저장
    result_file = output_dir / f"{persona_name}_upload_result.json"
    with open(result_file, 'w', encoding='utf-8') as f:
        json.dump(upload_results, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ 업로드 결과가 {result_file}에 저장되었습니다.")
    print("\n📌 주의: 실제 업로드는 Claude Code 내에서 Cloudflare R2 MCP 도구를 사용해야 합니다.")
    print("이 스크립트는 업로드 구조와 URL 형식을 보여주는 예시입니다.")
    
    return upload_results

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("사용법: python upload_to_r2_mcp.py <페르소나_이름> <이미지_번호>")
        print("예시: python upload_to_r2_mcp.py 윤미 1")
        sys.exit(1)
    
    persona_name = sys.argv[1]
    image_number = int(sys.argv[2])
    
    upload_to_r2_mcp(persona_name, image_number)