#!/usr/bin/env python3
"""
특정 Firebase chat_error_fix 오류를 체크 완료로 표시
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# Firebase Admin SDK 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def mark_specific_error_checked(error_key):
    """특정 오류를 체크 완료로 표시"""
    try:
        # chat_error_fix 컬렉션 참조
        collection_ref = db.collection('chat_error_fix')
        
        # 특정 error_key를 가진 문서 찾기
        docs = collection_ref.where('error_key', '==', error_key).stream()
        
        count = 0
        for doc in docs:
            # is_check를 true로 업데이트
            doc.reference.update({
                'is_check': True,
                'checked_at': datetime.now().isoformat(),
                'checked_reason': '대화 맥락 개선 필요 - 질문 직접 답변 로직 강화 예정'
            })
            count += 1
            print(f"[OK] Marked as checked: {doc.id} (Error key: {error_key})")
        
        if count == 0:
            print(f"[INFO] No document found with error_key: {error_key}")
        else:
            print(f"\n[SUCCESS] Marked {count} error(s) as checked")
            
    except Exception as e:
        print(f"[ERROR] {e}")

if __name__ == "__main__":
    # 체크할 에러 키
    error_key = "ERR1754577944527_4527"
    mark_specific_error_checked(error_key)