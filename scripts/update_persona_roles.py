"""
Firebase Personas의 role 필드를 업데이트하는 스크립트
normal 페르소나와 expert 페르소나를 구분
"""

import firebase_admin
from firebase_admin import credentials, firestore

# Firebase 초기화
cred = credentials.Certificate("../sona_app/firebase-admin-sdk.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# 페르소나별 역할 매핑
persona_roles = {
    "상훈": "normal",
    "Dr. 박지은": "expert",  # 전문가
    "수진": "normal",
    "예림": "normal",
    "예슬": "normal",
    "윤미": "normal",
    "정훈": "normal",
    "지우": "normal",
    "채연": "normal",
    "하연": "normal",
    "혜진": "normal"
}

def update_persona_roles():
    """페르소나 role 필드 업데이트"""
    personas_ref = db.collection('personas')
    personas = personas_ref.get()
    
    updated_count = 0
    
    for persona_doc in personas:
        persona_data = persona_doc.to_dict()
        persona_name = persona_data.get('name', '')
        
        # role 매핑
        if persona_name in persona_roles:
            role = persona_roles[persona_name]
            
            # isExpert와 role이 일치하는지 확인
            is_expert = persona_data.get('isExpert', False)
            expected_expert = (role == 'expert')
            
            update_data = {'role': role}
            
            # isExpert 필드도 함께 업데이트 필요한 경우
            if is_expert != expected_expert:
                update_data['isExpert'] = expected_expert
                print(f"⚠️ {persona_name} - isExpert 필드 수정: {is_expert} → {expected_expert}")
            
            # Firebase 업데이트
            personas_ref.document(persona_doc.id).update(update_data)
            print(f"✅ {persona_name} - role: {role}")
            updated_count += 1
        else:
            print(f"⚠️ {persona_name} - 역할 매핑 없음")
    
    print(f"\n총 {updated_count}개의 페르소나 role 업데이트 완료")

if __name__ == "__main__":
    print("페르소나 role 업데이트 시작...")
    update_persona_roles()
    print("업데이트 완료!")