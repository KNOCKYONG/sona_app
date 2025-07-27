"""
Firebase Personas 컬렉션에 topics와 keywords 필드를 추가하는 마이그레이션 스크립트
"""

import firebase_admin
from firebase_admin import credentials, firestore
import json

# Firebase 초기화
cred = credentials.Certificate("../sona_app/firebase-admin-sdk.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# 페르소나별 주제와 키워드 매핑
persona_topics_keywords = {
    "상훈": {
        "topics": ["일상 대화", "운동/건강", "취미 공유", "연애 상담"],
        "keywords": ["스포츠", "운동", "건강", "활발", "긍정적", "친구같은"]
    },
    "Dr. 박지은": {
        "topics": ["심리 상담", "연애 상담", "인간관계", "자기계발"],
        "keywords": ["전문가", "심리", "상담", "치유", "조언", "심리학"]
    },
    "수진": {
        "topics": ["일상 대화", "요리/맛집", "문화/예술", "취미 공유"],
        "keywords": ["요리", "맛집", "문화", "예술", "감성적", "따뜻한"]
    },
    "예림": {
        "topics": ["게임 이야기", "취미 공유", "일상 대화", "문화/예술"],
        "keywords": ["게임", "애니메이션", "만화", "오타쿠", "귀여운", "발랄"]
    },
    "예슬": {
        "topics": ["패션/뷰티", "일상 대화", "문화/예술", "연애 상담"],
        "keywords": ["패션", "뷰티", "스타일", "트렌디", "세련된", "도시적"]
    },
    "윤미": {
        "topics": ["공부/학습", "진로 상담", "일상 대화", "자기계발"],
        "keywords": ["공부", "학습", "진로", "대학생", "열정적", "성실"]
    },
    "정훈": {
        "topics": ["운동/건강", "일상 대화", "취미 공유", "직장 생활"],
        "keywords": ["운동", "헬스", "건강", "남성적", "듬직한", "신뢰"]
    },
    "지우": {
        "topics": ["일상 대화", "여행 계획", "문화/예술", "취미 공유"],
        "keywords": ["여행", "자유로운", "모험", "활발", "밝은", "긍정적"]
    },
    "채연": {
        "topics": ["문화/예술", "일상 대화", "감성 대화", "연애 상담"],
        "keywords": ["예술", "감성", "문학", "차분한", "지적인", "우아한"]
    },
    "하연": {
        "topics": ["일상 대화", "취미 공유", "연애 상담", "친구 대화"],
        "keywords": ["친근한", "다정한", "편안한", "상냥한", "이해심", "공감"]
    },
    "혜진": {
        "topics": ["직장 생활", "자기계발", "진로 상담", "일상 대화"],
        "keywords": ["커리어", "직장", "전문성", "리더십", "성공", "야망"]
    }
}

def migrate_personas():
    """페르소나에 topics와 keywords 필드 추가"""
    personas_ref = db.collection('personas')
    personas = personas_ref.get()
    
    updated_count = 0
    
    for persona_doc in personas:
        persona_data = persona_doc.to_dict()
        persona_name = persona_data.get('name', '')
        
        # 이미 topics나 keywords가 있으면 스킵
        if 'topics' in persona_data and 'keywords' in persona_data:
            print(f"✓ {persona_name} - 이미 업데이트됨")
            continue
        
        # 매핑된 데이터 찾기
        if persona_name in persona_topics_keywords:
            update_data = persona_topics_keywords[persona_name]
            
            # 전문가 페르소나 특별 처리
            if persona_data.get('isExpert', False):
                # 전문가는 전문 분야에 맞는 주제 강화
                if persona_name == "Dr. 박지은":
                    update_data['topics'] = ["심리 상담", "연애 상담", "인간관계", "자기계발", "진로 상담"]
                    update_data['keywords'] = ["전문가", "심리학박사", "상담", "치유", "전문상담", "심리치료"]
            
            # Firebase 업데이트
            personas_ref.document(persona_doc.id).update(update_data)
            print(f"✅ {persona_name} - topics: {update_data['topics']}, keywords: {update_data['keywords']}")
            updated_count += 1
        else:
            print(f"⚠️ {persona_name} - 매핑 데이터 없음")
    
    print(f"\n총 {updated_count}개의 페르소나 업데이트 완료")

if __name__ == "__main__":
    print("페르소나 topics/keywords 마이그레이션 시작...")
    migrate_personas()
    print("마이그레이션 완료!")