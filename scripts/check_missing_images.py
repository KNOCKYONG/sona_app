#!/usr/bin/env python3
"""
Firebase MCP를 활용하여 이미지가 업로드되지 않은 페르소나 확인
"""

import json
import subprocess
from datetime import datetime

def run_claude_command(command):
    """Claude MCP 명령 실행"""
    try:
        # Windows 환경에서 명령 실행
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='ignore'
        )
        if result.returncode == 0:
            try:
                return json.loads(result.stdout)
            except json.JSONDecodeError:
                print(f"JSON parsing error: {result.stdout}")
                return None
        else:
            print(f"Error running command: {result.stderr}")
            return None
    except Exception as e:
        print(f"Exception running command: {e}")
        return None

def check_persona_images():
    """모든 페르소나의 이미지 상태 확인"""
    
    print("=" * 50)
    print("페르소나 이미지 상태 확인")
    print("=" * 50)
    
    # 1. 모든 페르소나 가져오기
    print("\n1. Firebase에서 페르소나 목록 가져오기...")
    command = 'claude mcp firebase-mcp firestore_list_documents --collection personas --limit 100'
    result = run_claude_command(command)
    
    if not result or 'documents' not in result:
        print("Error: 페르소나 목록을 가져올 수 없습니다.")
        return
    
    personas = result['documents']
    print(f"   총 {len(personas)}개 페르소나 발견")
    
    # 2. 이미지 상태 분석
    print("\n2. 이미지 상태 분석 중...")
    
    personas_without_images = []
    personas_with_empty_urls = []
    personas_with_images = []
    
    for persona in personas:
        data = persona['data']
        persona_id = persona['id']
        name = data.get('name', 'Unknown')
        
        # imageUrls 필드 확인
        image_urls = data.get('imageUrls')
        has_valid_r2 = data.get('hasValidR2Image', False)
        
        # 개별 페르소나 상세 정보 가져오기
        detail_command = f'claude mcp firebase-mcp firestore_get_document --collection personas --id {persona_id}'
        detail_result = run_claude_command(detail_command)
        
        if detail_result and 'data' in detail_result:
            detail_data = detail_result['data']
            actual_image_urls = detail_data.get('imageUrls')
            
            # imageUrls가 비어있거나 없는 경우
            if not actual_image_urls or actual_image_urls == '[]' or actual_image_urls == '{}':
                personas_without_images.append({
                    'id': persona_id,
                    'name': name,
                    'hasValidR2Image': has_valid_r2,
                    'imageUrls': actual_image_urls
                })
            elif isinstance(actual_image_urls, str) and actual_image_urls.startswith('[Object'):
                # [Object]로 표시되는 경우 - 실제 내용 확인 필요
                personas_with_empty_urls.append({
                    'id': persona_id,
                    'name': name,
                    'hasValidR2Image': has_valid_r2
                })
            else:
                personas_with_images.append({
                    'id': persona_id,
                    'name': name
                })
        
        print(f"   - {name}: 확인 완료")
    
    # 3. 결과 출력
    print("\n" + "=" * 50)
    print("분석 결과")
    print("=" * 50)
    
    if personas_without_images:
        print(f"\n🔴 이미지가 없는 페르소나: {len(personas_without_images)}개")
        for p in personas_without_images:
            print(f"   - {p['name']} (ID: {p['id']})")
            print(f"     hasValidR2Image: {p['hasValidR2Image']}")
            print(f"     imageUrls: {p['imageUrls']}")
    
    if personas_with_empty_urls:
        print(f"\n🟡 이미지 URL 확인 필요: {len(personas_with_empty_urls)}개")
        for p in personas_with_empty_urls:
            print(f"   - {p['name']} (ID: {p['id']})")
    
    print(f"\n🟢 이미지가 있는 페르소나: {len(personas_with_images)}개")
    
    # 4. 결과 저장
    result_data = {
        'timestamp': datetime.now().isoformat(),
        'total_personas': len(personas),
        'without_images': personas_without_images,
        'need_check': personas_with_empty_urls,
        'with_images': len(personas_with_images)
    }
    
    with open('missing_images_report.json', 'w', encoding='utf-8') as f:
        json.dump(result_data, f, ensure_ascii=False, indent=2)
    
    print(f"\n📄 상세 보고서가 'missing_images_report.json'에 저장되었습니다.")
    
    return personas_without_images, personas_with_empty_urls

if __name__ == "__main__":
    check_persona_images()