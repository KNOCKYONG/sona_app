"""
특정 오류 보고서의 대화 내용 상세 확인
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

def check_error_detail(error_key: str):
    """특정 오류 보고서의 상세 내용 확인"""
    
    # 오류 보고서 가져오기
    error_doc = db.collection('chat_error_fix').document(error_key).get()
    
    if not error_doc.exists:
        print(f"❌ 오류 보고서를 찾을 수 없습니다: {error_key}")
        return
    
    data = error_doc.to_dict()
    
    print("=" * 80)
    print(f"📋 오류 보고서: {error_key}")
    print("=" * 80)
    
    # 기본 정보
    print(f"\n📌 기본 정보:")
    print(f"  - 페르소나: {data.get('persona_name', 'Unknown')}")
    print(f"  - 보고 시간: {data.get('timestamp', 'Unknown')}")
    print(f"  - 오류 타입: {data.get('error_type', 'Unknown')}")
    print(f"  - 설명: {data.get('error_description', 'No description')}")
    
    # 대화 내용
    print(f"\n💬 대화 내용:")
    print("-" * 40)
    
    chat = data.get('chat', {})
    messages = chat.get('messages', [])
    
    if not messages:
        print("대화 내용이 없습니다.")
        return
    
    for i, msg in enumerate(messages, 1):
        is_from_user = msg.get('isFromUser', False)
        sender = '사용자' if is_from_user else data.get('persona_name', 'AI')
        content = msg.get('text', '')
        timestamp = msg.get('timestamp', '')
        
        print(f"\n[{i}] {sender}:")
        print(f"    {content}")
        if timestamp:
            print(f"    (시간: {timestamp})")
    
    # 문제 분석
    print(f"\n\n🔍 문제 분석:")
    print("-" * 40)
    
    # 대화 흐름 분석
    print("\n📊 대화 흐름:")
    for i in range(len(messages) - 1):
        if messages[i].get('isFromUser') and not messages[i+1].get('isFromUser'):
            user_msg = messages[i].get('text', '')
            ai_msg = messages[i+1].get('text', '')
            
            print(f"\n  Q: {user_msg[:50]}...")
            print(f"  A: {ai_msg[:50]}...")
            
            # 문제 감지
            if '별거 아니야' in ai_msg and len(user_msg) > 20:
                print(f"  ⚠️ 문제: 사용자의 긴 메시지에 짧은 응답")
            
            if '뭐' in user_msg and '유튜브' in ai_msg:
                print(f"  ✅ 적절: 근황 질문에 구체적 답변")
    
    # 체크 상태 업데이트
    if not data.get('is_check', False):
        print(f"\n\n📝 체크 상태 업데이트 중...")
        error_doc.reference.update({'is_check': True})
        print(f"✅ 체크 완료로 표시되었습니다.")

# 실행
if __name__ == "__main__":
    # 최근 오류 보고서 확인
    check_error_detail("ERR1754802141190_1190")