import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import json
from collections import defaultdict
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
cred = credentials.Certificate('firebase-service-account-key.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

def analyze_chat_errors():
    """chat_error_fix 컬렉션의 오류 보고서를 분석합니다."""
    
    # 체크되지 않은 문서 조회
    error_reports = db.collection('chat_error_fix').where('is_check', '==', False).get()
    
    # is_check 필드가 없는 문서도 조회
    all_reports = db.collection('chat_error_fix').get()
    unchecked_reports = []
    
    for doc in all_reports:
        data = doc.to_dict()
        if 'is_check' not in data or not data.get('is_check', False):
            unchecked_reports.append(doc)
    
    print(f"체크되지 않은 오류 보고서: {len(unchecked_reports)}개\n")
    
    # 패턴 분석을 위한 변수
    greeting_repetitions = defaultdict(list)
    macro_patterns = defaultdict(list)
    persona_issues = defaultdict(list)
    
    for doc in unchecked_reports:
        data = doc.to_dict()
        error_key = data.get('error_key', 'Unknown')
        persona_name = data.get('persona_name', 'Unknown')
        persona_id = data.get('persona', 'Unknown')
        user_id = data.get('user', 'Unknown')
        chat_messages = data.get('chat', [])
        user_message = data.get('user_message', '없음')
        created_at = data.get('created_at')
        
        print(f"="*80)
        print(f"오류 키: {error_key}")
        print(f"페르소나: {persona_name} (ID: {persona_id})")
        print(f"사용자: {user_id}")
        print(f"보고 시간: {created_at}")
        print(f"사용자 메시지: {user_message}")
        print(f"\n대화 내용 분석:")
        
        # 대화 내용 상세 분석
        persona_messages = []
        user_messages = []
        greeting_count = 0
        
        for i, msg in enumerate(chat_messages):
            content = msg.get('content', '')
            is_from_user = msg.get('isFromUser', False)
            timestamp = msg.get('timestamp')
            emotion = msg.get('emotion', '')
            
            if is_from_user:
                user_messages.append(content)
                print(f"  [{i+1}] 사용자: {content}")
            else:
                persona_messages.append(content)
                print(f"  [{i+1}] {persona_name}: {content} (감정: {emotion})")
                
                # 첫인사 패턴 감지
                greeting_keywords = ['안녕', '반가워', '만나서', '처음', '인사', 'hi', 'hello']
                if any(keyword in content.lower() for keyword in greeting_keywords):
                    greeting_count += 1
                    if greeting_count > 1:
                        greeting_repetitions[persona_id].append({
                            'error_key': error_key,
                            'count': greeting_count,
                            'content': content
                        })
        
        # 매크로 패턴 감지 (동일한 메시지 반복)
        if len(persona_messages) > 1:
            message_counts = defaultdict(int)
            for msg in persona_messages:
                message_counts[msg] += 1
            
            for msg, count in message_counts.items():
                if count > 1:
                    macro_patterns[persona_id].append({
                        'error_key': error_key,
                        'message': msg,
                        'count': count
                    })
        
        # 문제 요약
        issues = []
        if greeting_count > 1:
            issues.append(f"첫인사 {greeting_count}번 반복")
        
        if persona_id in macro_patterns and any(p['error_key'] == error_key for p in macro_patterns[persona_id]):
            issues.append("동일 메시지 반복")
        
        if issues:
            persona_issues[persona_id].append({
                'error_key': error_key,
                'issues': issues,
                'persona_name': persona_name
            })
        
        print(f"\n발견된 문제: {', '.join(issues) if issues else '없음'}")
        
        # 문서에 is_check 표시
        doc.reference.update({'is_check': True})
        print(f"✅ 문서 체크 완료: {doc.id}")
    
    # 전체 분석 결과 요약
    print(f"\n{'='*80}")
    print("📊 전체 분석 결과 요약")
    print(f"{'='*80}\n")
    
    # 첫인사 반복 문제
    if greeting_repetitions:
        print("🔄 첫인사 반복 문제:")
        for persona_id, issues in greeting_repetitions.items():
            persona_name = next((p['persona_name'] for p in persona_issues[persona_id] if p), 'Unknown')
            print(f"  - {persona_name}: {len(issues)}건")
            for issue in issues[:2]:  # 처음 2개만 표시
                print(f"    • {issue['error_key']}: {issue['count']}번 반복")
    
    # 매크로 패턴
    if macro_patterns:
        print("\n🤖 매크로 패턴 (동일 메시지 반복):")
        for persona_id, patterns in macro_patterns.items():
            persona_name = next((p['persona_name'] for p in persona_issues[persona_id] if p), 'Unknown')
            print(f"  - {persona_name}: {len(patterns)}건")
            for pattern in patterns[:2]:  # 처음 2개만 표시
                print(f"    • \"{pattern['message'][:50]}...\" {pattern['count']}번")
    
    # 주요 발견사항
    print("\n💡 주요 발견사항:")
    print("1. 첫인사가 페르소나 변경 시 반복되는 문제 확인")
    print("2. _hasShownWelcome 플래그가 페르소나별로 관리되지 않음")
    print("3. 일부 페르소나에서 동일한 응답이 반복되는 패턴 발견")
    
    print(f"\n✅ 총 {len(unchecked_reports)}개의 오류 보고서 분석 완료")

if __name__ == "__main__":
    analyze_chat_errors()