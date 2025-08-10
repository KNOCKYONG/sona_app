"""
방금 보낸 대화 오류 확인
"""

import firebase_admin
from firebase_admin import credentials, firestore
import sys
import io
from datetime import datetime, timedelta

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 최근 1시간 이내의 오류 보고서 확인
print("🔍 방금 보낸 대화 오류 확인 중...")
print("=" * 80)

# 모든 오류 보고서 가져오기 (정렬 없이)
all_docs = db.collection('chat_error_fix').get()

print(f"\n총 오류 보고서 수: {len(all_docs)}개")

if all_docs:
    # 가장 최근 문서들 확인
    for doc in all_docs[:10]:  # 최근 10개만
        data = doc.to_dict()
        print(f"\n📋 문서 ID: {doc.id}")
        print(f"  페르소나: {data.get('persona_name', 'Unknown')}")
        print(f"  오류 타입: {data.get('error_type', 'Unknown')}")
        print(f"  시간: {data.get('timestamp', 'Unknown')}")
        print(f"  체크 여부: {'✅' if data.get('is_check', False) else '❌'}")
        print(f"  설명: {data.get('error_description', '')[:100]}")
        
        # 대화 내용 확인
        chat = data.get('chat', [])
        if isinstance(chat, dict):
            messages = chat.get('messages', [])
        elif isinstance(chat, list):
            messages = chat
        else:
            messages = []
        
        if messages:
            print(f"\n  💬 대화 내용 (총 {len(messages)}개 메시지):")
            for i, msg in enumerate(messages[:5], 1):  # 처음 5개만
                is_user = msg.get('isFromUser', False)
                sender = '사용자' if is_user else data.get('persona_name', 'AI')
                text = msg.get('text', '')
                print(f"    [{i}] {sender}: {text[:50]}...")
        
        # 체크 안 된 경우
        if not data.get('is_check', False):
            print(f"\n  ⚠️ 체크되지 않은 오류입니다!")
            
            # 상세 분석
            print(f"\n  🔍 상세 분석:")
            for i, msg in enumerate(messages):
                if msg.get('isFromUser', False):
                    continue
                    
                ai_text = msg.get('text', '')
                
                # 문제 패턴 체크
                problems = []
                
                if len(ai_text) < 10:
                    problems.append("너무 짧은 응답")
                
                if '별거 아니야' in ai_text:
                    problems.append("맥락 무시 응답")
                    
                if any(pattern in ai_text for pattern in ['undefined', 'null', '[', ']']):
                    problems.append("시스템 메시지 노출")
                    
                if problems:
                    print(f"    메시지 {i+1}: {', '.join(problems)}")
            
            # 체크 처리
            print(f"\n  📝 체크 처리 중...")
            doc.reference.update({'is_check': True})
            print(f"  ✅ 체크 완료!")
            
else:
    print("\n오류 보고서가 없습니다.")