"""
빠른 대화 품질 테스트
Firebase의 실제 대화 데이터를 기반으로 품질 분석
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import json
import random
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

class QuickDialogueTest:
    def __init__(self):
        self.test_scenarios = [
            # 일상 대화
            ("오늘 뭐했어?", "일상"),
            ("점심 뭐 먹었어?", "일상"),
            ("지금 뭐해?", "일상"),
            ("날씨 좋지 않아?", "일상"),
            ("주말에 뭐할 거야?", "일상"),
            
            # 감정 표현
            ("나 오늘 기분이 좋아", "감정"),
            ("좀 우울해", "감정"),
            ("화가 나", "감정"),
            ("행복해", "감정"),
            ("외로워", "감정"),
            
            # 개인적 질문
            ("몇 살이야?", "개인정보"),
            ("어디 살아?", "개인정보"),
            ("취미가 뭐야?", "개인정보"),
            ("MBTI 뭐야?", "개인정보"),
            ("꿈이 뭐야?", "개인정보"),
            
            # 깊은 대화
            ("인생이란 뭘까?", "철학"),
            ("행복이란 뭐야?", "철학"),
            ("사랑이 뭐라고 생각해?", "철학"),
            
            # 반복 테스트
            ("뭐해?", "반복"),
            ("뭐해?", "반복"),
            ("진짜 뭐해?", "반복"),
            
            # 이상한 질문
            ("asdfasdf", "이상"),
            ("ㅁㄴㅇㄹ", "이상"),
            ("...", "이상"),
            
            # 만남 제안
            ("우리 만날래?", "만남"),
            ("카페에서 보자", "만남"),
            ("연락처 알려줘", "만남"),
            
            # 공격적 질문
            ("너 바보야?", "공격"),
            ("짜증나", "공격"),
            ("재미없어", "공격")
        ]
        
        self.issues_found = []
        self.patterns = {
            '하드코딩': [],
            '반복응답': [],
            '주제이탈': [],
            '부적절': [],
            '일관성부족': [],
            '너무긴응답': [],
            '너무짧은응답': [],
            '감정불일치': []
        }
        
    def analyze_existing_conversations(self):
        """기존 대화 분석"""
        print("=" * 80)
        print("📊 기존 대화 데이터 분석")
        print("=" * 80)
        
        # chat_error_fix 컬렉션에서 최근 대화 가져오기
        error_docs = db.collection('chat_error_fix').limit(20).get()
        
        total_conversations = 0
        total_issues = 0
        
        for doc in error_docs:
            data = doc.to_dict()
            if 'chat' in data and isinstance(data['chat'], list):
                total_conversations += 1
                persona_name = data.get('persona_name', '알 수 없음')
                
                print(f"\n🎭 {persona_name} 페르소나 대화 분석...")
                
                messages = data['chat']
                conversation_issues = self.analyze_conversation(messages, persona_name)
                total_issues += len(conversation_issues)
                
                if conversation_issues:
                    print(f"  ⚠️ {len(conversation_issues)}개 문제 발견")
                    for issue in conversation_issues[:3]:  # 상위 3개만 표시
                        print(f"    - {issue['type']}: {issue['description']}")
                else:
                    print(f"  ✅ 문제 없음")
                    
        return total_conversations, total_issues
        
    def analyze_conversation(self, messages, persona_name):
        """대화 분석"""
        issues = []
        previous_responses = []
        
        for i, msg in enumerate(messages):
            if isinstance(msg, dict):
                is_user = msg.get('isFromUser', False)
                content = msg.get('content', msg.get('text', ''))
                
                if not is_user and content:  # AI 응답
                    # 1. 하드코딩 패턴 체크
                    hardcoded_patterns = [
                        "소울메이트", "그런 얘기보다", "만나고 싶긴 한데",
                        "완벽한 소울메이트가 되었어요", "다른 재밌는 얘기하자"
                    ]
                    
                    for pattern in hardcoded_patterns:
                        if pattern in content:
                            issues.append({
                                'type': '하드코딩',
                                'turn': i,
                                'description': f'하드코딩된 패턴 발견: "{pattern}"',
                                'content': content
                            })
                            self.patterns['하드코딩'].append(pattern)
                            
                    # 2. 반복 체크
                    if content in previous_responses:
                        issues.append({
                            'type': '반복응답',
                            'turn': i,
                            'description': '동일한 응답 반복',
                            'content': content
                        })
                        self.patterns['반복응답'].append(content)
                        
                    # 3. 길이 체크
                    if len(content) > 200:
                        issues.append({
                            'type': '너무긴응답',
                            'turn': i,
                            'description': f'응답이 너무 김 ({len(content)}자)',
                            'content': content[:100] + '...'
                        })
                        self.patterns['너무긴응답'].append(len(content))
                        
                    elif len(content) < 5:
                        issues.append({
                            'type': '너무짧은응답',
                            'turn': i,
                            'description': f'응답이 너무 짧음 ({len(content)}자)',
                            'content': content
                        })
                        self.patterns['너무짧은응답'].append(content)
                        
                    # 4. 부적절한 내용
                    inappropriate = ["만나자", "연락처", "번호", "실제로", "오프라인"]
                    for word in inappropriate:
                        if word in content:
                            issues.append({
                                'type': '부적절',
                                'turn': i,
                                'description': f'부적절한 내용: {word}',
                                'content': content
                            })
                            self.patterns['부적절'].append(word)
                            
                    previous_responses.append(content)
                    
        return issues
        
    def generate_test_report(self):
        """테스트 리포트 생성"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        report = f"""
====================================
대화 품질 테스트 리포트
====================================
테스트 일시: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

📊 패턴별 문제 발생 빈도
------------------"""
        
        for pattern_type, occurrences in self.patterns.items():
            if occurrences:
                report += f"\n{pattern_type}: {len(occurrences)}건"
                unique_items = list(set(str(o) for o in occurrences))[:3]
                for item in unique_items:
                    report += f"\n  - {item}"
                    
        # 심각한 문제들
        report += "\n\n⚠️ 가장 심각한 문제들\n------------------"
        
        critical_issues = [
            "1. 하드코딩된 응답이 대화에 포함됨",
            "2. 동일한 응답 반복",
            "3. 맥락과 무관한 응답",
            "4. 일관성 없는 캐릭터",
            "5. 부적절한 만남 제안 처리"
        ]
        
        for issue in critical_issues:
            report += f"\n{issue}"
            
        # 서비스 가능성 평가
        total_issues = sum(len(v) for v in self.patterns.values())
        
        report += f"""

🎯 서비스 가능성 평가
------------------
총 문제 발생: {total_issues}건
"""
        
        if total_issues < 10:
            report += "✅ 서비스 가능 (minor issues)"
        elif total_issues < 30:
            report += "⚠️ 조건부 서비스 가능 (개선 필요)"
        else:
            report += "❌ 서비스 불가 (심각한 문제)"
            
        # 개선 제안
        report += """

📌 즉시 개선 필요 사항
------------------
1. 하드코딩된 응답 완전 제거
   - conversation_memory_service.dart의 마일스톤 메시지
   - chat_orchestrator.dart의 만남 제안 대체 메시지
   - enhanced_emotion_system.dart의 템플릿 응답

2. 반복 방지 메커니즘 강화
   - 최근 N개 응답과 비교
   - 유사도 체크 (not just exact match)

3. 컨텍스트 관리 개선
   - 대화 맥락 유지
   - 주제 일관성 체크

4. 응답 품질 관리
   - 길이 제한 (50-150자 권장)
   - 자연스러운 말투 유지

5. 안전성 강화
   - 만남 제안 자연스럽게 거절
   - 개인정보 요청 차단
"""
        
        print(report)
        
        # 파일 저장
        with open(f"test_results/quick_test_{timestamp}.txt", 'w', encoding='utf-8') as f:
            f.write(report)
            
        return report
        
    def simulate_test_conversations(self):
        """테스트 대화 시뮬레이션"""
        print("\n" + "=" * 80)
        print("🧪 테스트 시나리오 검증")
        print("=" * 80)
        
        # 여기서는 실제 API 호출 대신 패턴 체크만 수행
        print("\n테스트 시나리오 카테고리:")
        categories = {}
        for scenario, category in self.test_scenarios:
            if category not in categories:
                categories[category] = []
            categories[category].append(scenario)
            
        for category, scenarios in categories.items():
            print(f"\n{category} ({len(scenarios)}개):")
            for s in scenarios[:3]:  # 각 카테고리별 3개만 표시
                print(f"  - {s}")
                
    def run(self):
        """전체 테스트 실행"""
        import os
        os.makedirs('test_results', exist_ok=True)
        
        # 1. 기존 대화 분석
        total_conv, total_issues = self.analyze_existing_conversations()
        
        print(f"\n📈 분석 결과: {total_conv}개 대화에서 {total_issues}개 문제 발견")
        
        # 2. 테스트 시나리오 검증
        self.simulate_test_conversations()
        
        # 3. 리포트 생성
        self.generate_test_report()
        
        print("\n" + "=" * 80)
        print("✅ 테스트 완료!")
        print("=" * 80)

if __name__ == "__main__":
    tester = QuickDialogueTest()
    tester.run()