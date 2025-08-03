#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
모든 사용자의 actionedPersonaIds를 동기화하는 스크립트
- user_persona_relationships에서 isMatched=true인 페르소나만 actionedPersonaIds에 포함
- 패스한 페르소나는 제외
"""

import json
import os
import sys
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# UTF-8 인코딩 설정
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer)
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer)

# Firebase Admin SDK 초기화
if not firebase_admin._apps:
    # 서비스 계정 키 경로
    cred_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'firebase-service-account-key.json')
    
    if not os.path.exists(cred_path):
        print(f"❌ Firebase 서비스 계정 키를 찾을 수 없습니다: {cred_path}")
        print("   firebase-service-account-key.json 파일을 프로젝트 루트에 추가해주세요.")
        exit(1)
    
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)

db = firestore.client()

def sync_user_actioned_personas():
    """모든 사용자의 actionedPersonaIds를 동기화"""
    print("🔄 모든 사용자의 actionedPersonaIds 동기화 시작...")
    
    try:
        # 모든 사용자 가져오기
        users_ref = db.collection('users')
        users = users_ref.stream()
        
        total_users = 0
        updated_users = 0
        
        for user_doc in users:
            total_users += 1
            user_id = user_doc.id
            user_data = user_doc.to_dict()
            
            email = user_data.get('email', 'Unknown')
            current_actioned_ids = user_data.get('actionedPersonaIds', [])
            
            print(f"\n📊 사용자: {email} ({user_id})")
            print(f"   현재 actionedPersonaIds: {len(current_actioned_ids)}개")
            
            # user_persona_relationships에서 매칭된 페르소나만 가져오기
            relationships_ref = db.collection('user_persona_relationships')
            matched_query = relationships_ref.where('userId', '==', user_id)\
                                          .where('isMatched', '==', True)\
                                          .where('isActive', '==', True)
            
            matched_personas = []
            for rel_doc in matched_query.stream():
                rel_data = rel_doc.to_dict()
                persona_id = rel_data.get('personaId')
                swipe_action = rel_data.get('swipeAction', '')
                
                if persona_id and swipe_action in ['like', 'super_like']:
                    matched_personas.append(persona_id)
                    print(f"   ✅ 매칭된 페르소나: {rel_data.get('personaName', 'Unknown')} ({swipe_action})")
            
            # 패스한 페르소나 수 확인 (참고용)
            passed_query = relationships_ref.where('userId', '==', user_id)\
                                          .where('isMatched', '==', False)
            passed_count = len(list(passed_query.stream()))
            print(f"   ❌ 패스한 페르소나: {passed_count}개")
            
            # actionedPersonaIds 업데이트 필요한지 확인
            if set(current_actioned_ids) != set(matched_personas):
                print(f"   🔧 업데이트 필요: {len(current_actioned_ids)}개 → {len(matched_personas)}개")
                
                # Firebase 업데이트
                user_ref = db.collection('users').document(user_id)
                user_ref.update({
                    'actionedPersonaIds': matched_personas,
                    'updatedAt': firestore.SERVER_TIMESTAMP
                })
                
                updated_users += 1
                print(f"   ✅ 업데이트 완료!")
            else:
                print(f"   ✨ 이미 동기화됨")
        
        print(f"\n📊 동기화 완료:")
        print(f"   - 전체 사용자: {total_users}명")
        print(f"   - 업데이트된 사용자: {updated_users}명")
        
    except Exception as e:
        print(f"❌ 오류 발생: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    sync_user_actioned_personas()