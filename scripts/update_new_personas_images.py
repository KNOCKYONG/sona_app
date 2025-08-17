#!/usr/bin/env python3
"""
신규 페르소나 이미지 URL을 Firebase에 업데이트
"""

import firebase_admin
from firebase_admin import credentials, firestore
import json
from pathlib import Path
import sys

# UTF-8 인코딩 설정
if sys.platform.startswith('win'):
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred_path = Path(__file__).parent.parent / 'firebase-service-account-key.json'
    cred = credentials.Certificate(str(cred_path))
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 신규 페르소나 목록과 영문 매핑
new_personas = {
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

# R2 베이스 URL
R2_BASE_URL = "https://pub-ad4e2b5b2765401f808d655de4f2ad43.r2.dev/personas"

def generate_image_urls(english_name):
    """페르소나의 이미지 URL 생성"""
    base_url = f"{R2_BASE_URL}/{english_name}"
    
    return {
        "main": {
            "thumb": f"{base_url}/main_thumb.jpg",
            "small": f"{base_url}/main_small.jpg",
            "medium": f"{base_url}/main_medium.jpg",
            "large": f"{base_url}/main_large.jpg",
            "original": f"{base_url}/main_original.jpg"
        }
    }

def update_persona_images():
    """Firebase에서 신규 페르소나들의 이미지 URL 업데이트"""
    
    print("=" * 60)
    print("신규 페르소나 이미지 URL 업데이트")
    print("=" * 60)
    
    successful = []
    failed = []
    not_found = []
    
    for korean_name, english_name in new_personas.items():
        try:
            # 페르소나 문서 찾기
            query = db.collection('personas').where('name', '==', korean_name).limit(1)
            docs = query.get()
            
            if not docs:
                print(f"[NOT FOUND] {korean_name} - Firebase에 페르소나가 없습니다")
                not_found.append(korean_name)
                continue
            
            persona_doc = docs[0]
            persona_id = persona_doc.id
            
            # 이미지 URL 생성
            image_urls = generate_image_urls(english_name)
            
            # Firebase 업데이트
            update_data = {
                'images': image_urls,
                'hasValidR2Image': True,
                'imageUrl': image_urls['main']['medium'],  # 기본 이미지 URL
                'thumbnailUrl': image_urls['main']['thumb']  # 썸네일 URL
            }
            
            db.collection('personas').document(persona_id).update(update_data)
            
            print(f"[SUCCESS] {korean_name} ({english_name}) - ID: {persona_id}")
            print(f"  - 썸네일: {image_urls['main']['thumb']}")
            print(f"  - 기본 이미지: {image_urls['main']['medium']}")
            
            successful.append({
                'korean': korean_name,
                'english': english_name,
                'id': persona_id
            })
            
        except Exception as e:
            print(f"[ERROR] {korean_name}: {str(e)}")
            failed.append(korean_name)
    
    # 결과 요약
    print("\n" + "=" * 60)
    print("업데이트 완료!")
    print(f"  성공: {len(successful)}/{len(new_personas)}")
    print(f"  실패: {len(failed)}")
    print(f"  미발견: {len(not_found)}")
    
    if successful:
        print("\n성공한 페르소나:")
        for persona in successful:
            print(f"  - {persona['korean']} ({persona['english']}) - ID: {persona['id']}")
    
    if failed:
        print("\n실패한 페르소나:")
        for name in failed:
            print(f"  - {name}")
    
    if not_found:
        print("\nFirebase에 없는 페르소나:")
        for name in not_found:
            print(f"  - {name}")
    
    # 결과 저장
    result = {
        'successful': successful,
        'failed': failed,
        'not_found': not_found,
        'total': len(new_personas),
        'success_count': len(successful)
    }
    
    result_file = Path(__file__).parent.parent / 'image_update_result.json'
    with open(result_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    
    print(f"\n결과 저장: {result_file}")

if __name__ == '__main__':
    update_persona_images()