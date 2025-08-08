#!/usr/bin/env python3
"""
Firebase chat_error_fix 컬렉션의 오류를 체크 완료로 표시
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

def mark_errors_as_checked():
    """오류 보고서를 체크 완료로 표시"""
    try:
        # chat_error_fix 컬렉션 참조
        collection_ref = db.collection('chat_error_fix')
        
        # 체크되지 않은 문서들 가져오기
        unchecked_docs = collection_ref.where('is_check', '==', False).stream()
        
        count = 0
        error_keys = []
        for doc in unchecked_docs:
            # is_check를 true로 업데이트
            doc.reference.update({
                'is_check': True,
                'checked_at': datetime.now().isoformat(),
                'checked_reason': '보안 필터 개선 - 사용자 자기 언급 구분 로직 추가'
            })
            count += 1
            error_keys.append(doc.id)
            print(f"[OK] Marked as checked: {doc.id}")
        
        if count == 0:
            print("[INFO] No unchecked errors found")
        else:
            print(f"\n[SUCCESS] Total {count} errors marked as checked")
            print(f"Error keys: {', '.join(error_keys)}")
            
    except Exception as e:
        print(f"[ERROR] {e}")

if __name__ == "__main__":
    mark_errors_as_checked()