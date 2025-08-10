"""
체크되지 않은 오류 보고서 목록 확인
"""

import firebase_admin
from firebase_admin import credentials, firestore
import sys
import io
from datetime import datetime

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 체크되지 않은 오류 보고서 가져오기
docs = db.collection('chat_error_fix').where('is_check', '==', False).limit(5).get()

print("📋 체크되지 않은 오류 보고서 목록:")
print("=" * 60)

if not docs:
    print("체크되지 않은 오류 보고서가 없습니다.")
else:
    for doc in docs:
        data = doc.to_dict()
        print(f"\n문서 ID: {doc.id}")
        print(f"  - 페르소나: {data.get('persona_name', 'Unknown')}")
        print(f"  - 오류 타입: {data.get('error_type', 'Unknown')}")
        print(f"  - 시간: {data.get('timestamp', 'Unknown')}")
        print(f"  - 설명: {data.get('error_description', 'No description')[:50]}...")
        
        # 대화 메시지 수 확인
        chat = data.get('chat', {})
        messages = chat.get('messages', [])
        print(f"  - 대화 메시지 수: {len(messages)}개")