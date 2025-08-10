"""
체크되지 않은 오류만 찾기
"""

import firebase_admin
from firebase_admin import credentials, firestore
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

print("🔍 체크되지 않은 대화 오류 찾기...")
print("=" * 80)

# 모든 문서 가져오기
all_docs = db.collection('chat_error_fix').get()

unchecked_count = 0
checked_count = 0

for doc in all_docs:
    data = doc.to_dict()
    is_checked = data.get('is_check', False)
    
    if not is_checked:
        unchecked_count += 1
        print(f"\n❌ 체크 안됨: {doc.id}")
        print(f"  페르소나: {data.get('persona_name', 'Unknown')}")
        print(f"  오류 타입: {data.get('error_type', 'Unknown')}")
        print(f"  시간: {data.get('timestamp', 'Unknown')}")
        print(f"  설명: {data.get('error_description', '')[:100]}")
        
        # 대화 내용 확인
        chat = data.get('chat', [])
        if isinstance(chat, dict):
            messages = chat.get('messages', [])
        elif isinstance(chat, list):
            messages = chat
        else:
            messages = []
            
        print(f"  메시지 수: {len(messages)}개")
        
        # 상세 분석
        if messages:
            print(f"\n  💬 대화 샘플:")
            for i, msg in enumerate(messages[:3]):  # 처음 3개만
                is_user = msg.get('isFromUser', False)
                sender = '사용자' if is_user else data.get('persona_name', 'AI')
                text = msg.get('text', '')
                print(f"    [{i+1}] {sender}: {text[:80]}")
                
                # AI 응답 문제 체크
                if not is_user and text:
                    problems = []
                    
                    if len(text) < 10:
                        problems.append("너무 짧음")
                    
                    if '별거 아니야' in text:
                        problems.append("맥락 무시")
                        
                    if any(p in text for p in ['undefined', 'null', '[시스템]']):
                        problems.append("시스템 노출")
                        
                    if problems:
                        print(f"        ⚠️ 문제: {', '.join(problems)}")
        
        # 체크 처리
        doc.reference.update({'is_check': True})
        print(f"  ✅ 체크 완료로 표시")
        
    else:
        checked_count += 1

print(f"\n" + "=" * 80)
print(f"📊 최종 통계:")
print(f"  - 총 오류 보고서: {len(all_docs)}개")
print(f"  - 체크됨: {checked_count}개")
print(f"  - 체크 안됨: {unchecked_count}개")

if unchecked_count == 0:
    print(f"\n✅ 모든 오류가 이미 체크되었습니다!")
else:
    print(f"\n⚠️ {unchecked_count}개의 오류를 체크 완료했습니다.")