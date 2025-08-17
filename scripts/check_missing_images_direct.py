#!/usr/bin/env python3
"""
직접 Firebase 접근으로 이미지가 없는 페르소나 확인
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import json

# Firebase 초기화
if not firebase_admin._apps:
    import os
    service_account_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'firebase-service-account-key.json')
    cred = credentials.Certificate(service_account_path)
    firebase_admin.initialize_app(cred)

db = firestore.client()

def check_persona_images():
    """모든 페르소나의 이미지 상태 확인"""
    
    print("=" * 50)
    print("Persona Image Status Check")
    print("=" * 50)
    
    # 1. 모든 페르소나 가져오기
    print("\n1. Getting persona list from Firebase...")
    personas_ref = db.collection('personas')
    personas = personas_ref.get()
    
    print(f"   Total {len(personas)} personas found")
    
    # 2. 이미지 상태 분석
    print("\n2. Analyzing image status...")
    
    personas_without_images = []
    personas_with_invalid_urls = []
    personas_with_images = []
    personas_need_check = []
    
    for doc in personas:
        data = doc.to_dict()
        persona_id = doc.id
        name = data.get('name', 'Unknown')
        
        # imageUrls 필드 확인
        image_urls = data.get('imageUrls')
        has_valid_r2 = data.get('hasValidR2Image', False)
        
        # imageUrls 상태 확인
        if image_urls is None:
            # imageUrls 필드가 없음
            personas_without_images.append({
                'id': persona_id,
                'name': name,
                'hasValidR2Image': has_valid_r2,
                'imageUrls': None
            })
        elif isinstance(image_urls, list):
            if len(image_urls) == 0:
                # 빈 배열
                personas_without_images.append({
                    'id': persona_id,
                    'name': name,
                    'hasValidR2Image': has_valid_r2,
                    'imageUrls': []
                })
            else:
                # 이미지가 있음
                personas_with_images.append({
                    'id': persona_id,
                    'name': name,
                    'imageCount': len(image_urls),
                    'imageUrls': image_urls
                })
        elif isinstance(image_urls, dict):
            # dict 형태인 경우 (예: mainImages, secondaryImages)
            main_images = image_urls.get('mainImages', [])
            secondary_images = image_urls.get('secondaryImages', [])
            
            if not main_images and not secondary_images:
                personas_with_invalid_urls.append({
                    'id': persona_id,
                    'name': name,
                    'hasValidR2Image': has_valid_r2,
                    'imageUrls': image_urls
                })
            else:
                personas_with_images.append({
                    'id': persona_id,
                    'name': name,
                    'mainImageCount': len(main_images) if isinstance(main_images, list) else 0,
                    'secondaryImageCount': len(secondary_images) if isinstance(secondary_images, list) else 0
                })
        else:
            # 예상치 못한 형태
            personas_need_check.append({
                'id': persona_id,
                'name': name,
                'hasValidR2Image': has_valid_r2,
                'imageUrlsType': type(image_urls).__name__,
                'imageUrls': str(image_urls)[:100]  # 처음 100자만
            })
        
        print(f"   - {name}: checked")
    
    # 3. 결과 출력
    print("\n" + "=" * 50)
    print("Analysis Results")
    print("=" * 50)
    
    if personas_without_images:
        print(f"\n[ERROR] Personas without images: {len(personas_without_images)}")
        for p in personas_without_images:
            print(f"   - {p['name']} (ID: {p['id']})")
            print(f"     hasValidR2Image: {p['hasValidR2Image']}")
            print(f"     imageUrls: {p['imageUrls']}")
    else:
        print("\n[OK] No personas without images!")
    
    if personas_with_invalid_urls:
        print(f"\n[WARNING] Invalid image URL structure: {len(personas_with_invalid_urls)}")
        for p in personas_with_invalid_urls:
            print(f"   - {p['name']} (ID: {p['id']})")
    
    if personas_need_check:
        print(f"\n[CHECK] Need verification: {len(personas_need_check)}")
        for p in personas_need_check:
            print(f"   - {p['name']} (ID: {p['id']})")
            print(f"     Type: {p['imageUrlsType']}")
    
    print(f"\n[OK] Personas with images: {len(personas_with_images)}")
    
    # 이미지가 있는 페르소나 중 일부 상세 정보 출력
    if personas_with_images:
        print("\n[INFO] Sample personas with images (first 5):")
        for p in personas_with_images[:5]:
            print(f"   - {p['name']}: ", end="")
            if 'imageCount' in p:
                print(f"{p['imageCount']} images")
            else:
                print(f"main {p.get('mainImageCount', 0)}, secondary {p.get('secondaryImageCount', 0)}")
    
    # 4. 결과 저장
    result_data = {
        'timestamp': datetime.now().isoformat(),
        'total_personas': len(personas),
        'without_images': personas_without_images,
        'with_invalid_urls': personas_with_invalid_urls,
        'need_check': personas_need_check,
        'with_images_count': len(personas_with_images),
        'with_images_sample': personas_with_images[:10] if personas_with_images else []
    }
    
    with open('missing_images_report.json', 'w', encoding='utf-8') as f:
        json.dump(result_data, f, ensure_ascii=False, indent=2)
    
    print(f"\n[SAVED] Detailed report saved to 'missing_images_report.json'")
    
    # 5. 영문 이름 매핑 확인 (personas_with_images에서 샘플)
    if personas_with_images:
        print("\n[MAPPING] Korean to English name mapping:")
        # persona_name_mapping.py에서 매핑 정보 가져오기
        name_mapping = {
            "예슬": "yeseul", "예림": "yerim", "박지은": "dr-park-jieun",
            "윤미": "yoonmi", "채연": "chaeyeon", "상훈": "sanghoon",
            "수진": "sujin", "하연": "hayeon", "정훈": "jeonghoon",
            "지우": "jiwoo", "혜진": "hyejin", "김민서": "dr-kim-minseo",
            "영훈": "younghoon", "민준": "minjoon", "지유": "jiyoo",
            "조혜진": "johyejin", "형준": "hyeongjoon", "지수": "jisoo",
            "다영": "dayoung", "경호": "kyeongho", "이서연": "leesoyeon",
            "진호": "jinho", "혜원": "hyewon", "태호": "taeho",
            "리나": "rina", "동수": "dongsu", "주은": "jueun",
            "김태형": "kimtaehyeong", "지은": "jieun", "수아": "sua",
            "은수": "eunsu", "지윤": "jiyoon", "다은": "daeun",
            "유나": "yoona", "손유진": "sonyoojin", "은지": "eunji",
            "지율": "jiyul", "서준": "seojoon", "성민": "seongmin",
            "대호": "daeho", "수연": "sooyeon", "우진": "woojin",
            "동호": "dongho", "선호": "seonho", "성우": "seongwoo",
            "세리": "seri", "지후": "jihu", "태준": "taejoon",
            "연지": "yeonji", "범준": "beomjoon", "소영": "soyoung",
            "현주": "hyeonju", "태윤": "taeyoon", "윤성": "yoonseong",
            "한울": "hanul", "준석": "joonseok", "이준호": "leejoonho",
            "석진": "seokjin", "민정": "minjeong", "수빈": "soobin",
            "나나": "nana", "효진": "hyojin", "소희": "sohee",
            "민수": "minsu", "세빈": "sebin", "재현": "jaehyeon",
            "미연": "miyeon", "준영": "joonyoung", "성호": "seongho",
            "나연": "nayeon", "박준영": "parkjoonyoung", "동현": "donghyeon",
            "진욱": "jinwook", "준호": "joonho", "종호": "jongho",
            "재성": "jaeseong"
        }
        
        for p in personas_with_images[:5]:
            korean_name = p['name']
            english_name = name_mapping.get(korean_name, "unknown")
            print(f"   - {korean_name} → {english_name}")
    
    return personas_without_images, personas_with_invalid_urls

if __name__ == "__main__":
    check_persona_images()