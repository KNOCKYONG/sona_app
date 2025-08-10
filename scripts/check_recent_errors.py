"""
최근 오류 보고서 확인
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

# 최근 오류 보고서 가져오기 (체크 여부 관계없이)
docs = db.collection('chat_error_fix').order_by('timestamp', direction=firestore.Query.DESCENDING).limit(5).get()

print("📋 최근 오류 보고서 목록:")
print("=" * 80)

if not docs:
    print("오류 보고서가 없습니다.")
else:
    for doc in docs:
        data = doc.to_dict()
        print(f"\n문서 ID: {doc.id}")
        print(f"  - 페르소나: {data.get('persona_name', 'Unknown')}")
        print(f"  - 오류 타입: {data.get('error_type', 'Unknown')}")
        print(f"  - 시간: {data.get('timestamp', 'Unknown')}")
        print(f"  - 체크 여부: {'✅ 체크됨' if data.get('is_check', False) else '⚠️ 체크 안됨'}")
        print(f"  - 설명: {data.get('error_description', 'No description')[:80]}...")
        
        # 대화 메시지 수 확인
        chat = data.get('chat', {})
        messages = chat.get('messages', [])
        print(f"  - 대화 메시지 수: {len(messages)}개")
        
    # 첫 번째 문서 상세 확인
    print("\n" + "=" * 80)
    print("📌 가장 최근 오류 상세 내용:")
    print("=" * 80)
    
    first_doc = list(docs)[0]
    data = first_doc.to_dict()
    chat = data.get('chat', {})
    messages = chat.get('messages', [])
    
    print(f"\n문서 ID: {first_doc.id}")
    print(f"페르소나: {data.get('persona_name', 'Unknown')}")
    print(f"\n💬 대화 내용:")
    print("-" * 40)
    
    for i, msg in enumerate(messages, 1):
        is_from_user = msg.get('isFromUser', False)
        sender = '사용자' if is_from_user else data.get('persona_name', 'AI')
        content = msg.get('text', '')
        
        print(f"\n[{i}] {sender}:")
        print(f"    {content}")
        
        # 문제 패턴 감지
        if not is_from_user:
            if '별거 아니야' in content:
                print(f"    ⚠️ 문제: 대화 맥락과 맞지 않는 짧은 응답")
            if len(content) < 10:
                print(f"    ⚠️ 문제: 너무 짧은 응답")
    
    # 체크 안 된 경우 체크 처리
    if not data.get('is_check', False):
        print(f"\n📝 체크 처리 중...")
        first_doc.reference.update({'is_check': True})
        print(f"✅ 체크 완료로 표시되었습니다.")