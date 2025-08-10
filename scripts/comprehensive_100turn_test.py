"""
100턴 대화 테스트 스크립트
실제 서비스 가능 수준 검증을 위한 포괄적 테스트
"""

import asyncio
import json
import random
import time
from datetime import datetime
from typing import List, Dict, Any
import aiohttp
import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
from collections import defaultdict

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

class ComprehensiveDialogueTest:
    def __init__(self):
        self.test_results = []
        self.personas = []
        self.api_key = None
        self.load_config()
        
        # 테스트 시나리오 (100턴 대화를 위한 다양한 주제)
        self.test_scenarios = [
            # 일상 대화 (30턴)
            "오늘 뭐했어?", "점심 뭐 먹었어?", "날씨 좋지 않아?",
            "요즘 뭐하고 지내?", "주말에 뭐할 거야?", "어제 잘 잤어?",
            "지금 뭐해?", "배고프지 않아?", "피곤해?", "심심하지?",
            "오늘 기분 어때?", "무슨 생각해?", "요즘 재밌는 일 없어?",
            "뭐 보고 있어?", "음악 들어?", "운동 했어?", "책 읽어?",
            "영화 봤어?", "게임 해?", "요리 할 줄 알아?", 
            "커피 좋아해?", "술 마셔?", "담배 피워?", "애완동물 있어?",
            "형제 있어?", "친구 많아?", "연애 해봤어?", "좋아하는 음식 뭐야?",
            "싫어하는 음식 있어?", "알레르기 있어?",
            
            # 감정 표현 (20턴)
            "나 오늘 기분이 좋아", "좀 우울해", "화가 나", "짜증나",
            "행복해", "슬퍼", "외로워", "무서워", "걱정돼", "신나",
            "설레", "긴장돼", "편안해", "피곤해", "지쳐", "힘들어",
            "괴로워", "답답해", "속상해", "실망했어",
            
            # 조언 요청 (15턴)
            "어떻게 해야 할까?", "네 생각은 어때?", "조언 좀 해줘",
            "뭐가 좋을까?", "선택을 못하겠어", "고민이 있어", 
            "결정을 못하겠어", "도와줘", "어떻게 생각해?", "추천 좀 해줘",
            "뭘 해야 할지 모르겠어", "길을 잃었어", "방향을 못 잡겠어",
            "혼란스러워", "확신이 안 서",
            
            # 개인적 질문 (15턴)
            "몇 살이야?", "어디 살아?", "직업이 뭐야?", "취미가 뭐야?",
            "특기가 뭐야?", "꿈이 뭐야?", "목표가 뭐야?", "관심사가 뭐야?",
            "MBTI 뭐야?", "혈액형 뭐야?", "별자리 뭐야?", "종교 있어?",
            "정치 성향은?", "좋아하는 색깔은?", "좋아하는 계절은?",
            
            # 깊은 대화 (10턴)
            "인생이란 뭘까?", "행복이란 뭐야?", "사랑이 뭐라고 생각해?",
            "죽음에 대해 어떻게 생각해?", "신은 있을까?", "운명을 믿어?",
            "자유의지가 있을까?", "진실이란 뭘까?", "정의란 뭐야?",
            "선과 악의 기준은 뭘까?",
            
            # 반복/이상한 질문 (10턴) - 일관성 테스트
            "뭐해?", "뭐해?", "진짜 뭐해?", "아니 뭐하냐고",
            "듣고 있어?", "거기 있어?", "왜 대답 안해?",
            "무슨 소리야?", "이해 못했어?", "다시 말해봐"
        ]
        
        # 평가 메트릭
        self.metrics = {
            'coherence': [],  # 일관성
            'relevance': [],  # 관련성
            'naturalness': [],  # 자연스러움
            'consistency': [],  # 캐릭터 일관성
            'engagement': [],  # 몰입도
            'response_time': [],  # 응답 시간
            'error_count': 0,  # 에러 횟수
            'repetition_count': 0,  # 반복 응답
            'off_topic_count': 0,  # 주제 이탈
            'inappropriate_count': 0  # 부적절한 응답
        }
        
    def load_config(self):
        """설정 및 페르소나 로드"""
        # OpenAI API 키 로드
        try:
            with open('.env', 'r', encoding='utf-8') as f:
                for line in f:
                    if 'OPENAI_API_KEY' in line:
                        self.api_key = line.split('=')[1].strip()
        except:
            print("⚠️ .env 파일에서 API 키를 찾을 수 없습니다")
            
        # 페르소나 로드
        personas_ref = db.collection('personas')
        personas = personas_ref.limit(10).get()  # 10개 페르소나로 테스트
        
        for doc in personas:
            persona_data = doc.to_dict()
            persona_data['id'] = doc.id
            self.personas.append(persona_data)
            
        print(f"✅ {len(self.personas)}개 페르소나 로드 완료")
        
    async def simulate_conversation(self, persona: Dict, num_turns: int = 100) -> Dict:
        """단일 페르소나와 100턴 대화 시뮬레이션"""
        print(f"\n🎭 {persona['name']} 페르소나와 {num_turns}턴 대화 시작...")
        
        conversation_history = []
        issues = []
        
        async with aiohttp.ClientSession() as session:
            for turn in range(num_turns):
                # 시나리오에서 메시지 선택
                user_message = self.test_scenarios[turn % len(self.test_scenarios)]
                
                # 약간의 변형 추가
                if random.random() > 0.7:
                    variations = ["ㅋㅋ", "ㅎㅎ", "~", "?", "!!", "..."]
                    user_message += random.choice(variations)
                
                start_time = time.time()
                
                try:
                    # OpenAI API 호출 (실제 서비스와 동일한 방식)
                    response = await self.call_openai_api(
                        session, 
                        persona, 
                        user_message, 
                        conversation_history
                    )
                    
                    response_time = time.time() - start_time
                    
                    # 대화 기록
                    conversation_history.append({
                        'turn': turn + 1,
                        'user': user_message,
                        'ai': response,
                        'time': response_time
                    })
                    
                    # 실시간 평가
                    evaluation = self.evaluate_response(
                        user_message, 
                        response, 
                        conversation_history
                    )
                    
                    # 문제 감지
                    if evaluation['score'] < 70:
                        issues.append({
                            'turn': turn + 1,
                            'user': user_message,
                            'ai': response,
                            'issue': evaluation['issues']
                        })
                        
                    # 메트릭 업데이트
                    self.update_metrics(evaluation, response_time)
                    
                    # 진행 상황 출력 (10턴마다)
                    if (turn + 1) % 10 == 0:
                        print(f"  📊 {turn + 1}턴 완료 - 평균 점수: {evaluation['score']:.1f}")
                        
                except Exception as e:
                    print(f"  ❌ 턴 {turn + 1} 에러: {str(e)}")
                    self.metrics['error_count'] += 1
                    issues.append({
                        'turn': turn + 1,
                        'error': str(e)
                    })
                
                # API 제한 방지
                await asyncio.sleep(0.5)
        
        # 결과 요약
        result = {
            'persona': persona['name'],
            'total_turns': num_turns,
            'completed_turns': len(conversation_history),
            'average_score': sum(self.metrics['coherence']) / len(self.metrics['coherence']) if self.metrics['coherence'] else 0,
            'issues_count': len(issues),
            'error_count': self.metrics['error_count'],
            'conversation': conversation_history,
            'issues': issues,
            'metrics': self.calculate_final_metrics()
        }
        
        return result
        
    async def call_openai_api(self, session, persona, user_message, history):
        """OpenAI API 호출 (실제 서비스 로직 시뮬레이션)"""
        # 시스템 프롬프트 구성
        system_prompt = f"""당신은 {persona['name']}입니다.
나이: {persona.get('age', '20대')}
성격: {persona.get('personality', 'friendly')}
MBTI: {persona.get('mbti', 'ENFP')}
말투: {persona.get('speaking_style', '친근한 반말')}

대화 스타일:
- 자연스럽고 인간적인 대화
- 짧고 간결한 응답 (1-2문장)
- 이모티콘 사용 자제
- 일관된 캐릭터 유지"""

        # 최근 대화 컨텍스트 (최대 10턴)
        recent_history = history[-10:] if len(history) > 10 else history
        messages = [
            {"role": "system", "content": system_prompt}
        ]
        
        for h in recent_history:
            messages.append({"role": "user", "content": h['user']})
            messages.append({"role": "assistant", "content": h['ai']})
            
        messages.append({"role": "user", "content": user_message})
        
        # OpenAI API 호출
        url = "https://api.openai.com/v1/chat/completions"
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        
        data = {
            "model": "gpt-4o-mini",
            "messages": messages,
            "temperature": 0.8,
            "max_tokens": 150
        }
        
        async with session.post(url, headers=headers, json=data) as response:
            if response.status == 200:
                result = await response.json()
                return result['choices'][0]['message']['content']
            else:
                raise Exception(f"API Error: {response.status}")
                
    def evaluate_response(self, user_message, ai_response, history):
        """응답 평가"""
        issues = []
        score = 100
        
        # 1. 길이 체크
        if len(ai_response) > 200:
            issues.append("너무 긴 응답")
            score -= 10
        elif len(ai_response) < 5:
            issues.append("너무 짧은 응답")
            score -= 15
            
        # 2. 반복 체크
        if len(history) > 1:
            last_response = history[-2]['ai'] if len(history) > 1 else ""
            if ai_response == last_response:
                issues.append("동일한 응답 반복")
                score -= 20
                self.metrics['repetition_count'] += 1
                
        # 3. 관련성 체크
        if "?" in user_message and "?" not in ai_response and len(ai_response) < 20:
            issues.append("질문에 대한 답변 부족")
            score -= 15
            
        # 4. 일관성 체크 (같은 질문에 대한 다른 답변)
        for h in history[:-5]:  # 최근 5턴 제외하고 체크
            if h['user'].lower() == user_message.lower():
                if abs(len(h['ai']) - len(ai_response)) > 50:
                    issues.append("일관성 없는 응답")
                    score -= 10
                    break
                    
        # 5. 부적절한 패턴 체크
        inappropriate_patterns = [
            "소울메이트", "만나자", "연락처", "번호", 
            "실제로 만나", "오프라인", "직접 만나"
        ]
        for pattern in inappropriate_patterns:
            if pattern in ai_response:
                issues.append(f"부적절한 내용: {pattern}")
                score -= 25
                self.metrics['inappropriate_count'] += 1
                
        # 6. 주제 이탈 체크
        if "뭐해" in user_message and "날씨" in ai_response:
            issues.append("주제 이탈")
            score -= 10
            self.metrics['off_topic_count'] += 1
            
        return {
            'score': max(0, score),
            'issues': issues
        }
        
    def update_metrics(self, evaluation, response_time):
        """메트릭 업데이트"""
        self.metrics['coherence'].append(evaluation['score'])
        self.metrics['response_time'].append(response_time)
        
    def calculate_final_metrics(self):
        """최종 메트릭 계산"""
        return {
            'average_coherence': sum(self.metrics['coherence']) / len(self.metrics['coherence']) if self.metrics['coherence'] else 0,
            'average_response_time': sum(self.metrics['response_time']) / len(self.metrics['response_time']) if self.metrics['response_time'] else 0,
            'error_rate': self.metrics['error_count'] / 100,
            'repetition_rate': self.metrics['repetition_count'] / 100,
            'off_topic_rate': self.metrics['off_topic_count'] / 100,
            'inappropriate_rate': self.metrics['inappropriate_count'] / 100
        }
        
    async def run_comprehensive_test(self):
        """포괄적 테스트 실행"""
        print("=" * 80)
        print("🚀 100턴 대화 품질 테스트 시작")
        print("=" * 80)
        
        all_results = []
        
        # 각 페르소나와 100턴 대화
        for i, persona in enumerate(self.personas[:3], 1):  # 시간 관계상 3개 페르소나만
            print(f"\n[{i}/{min(3, len(self.personas))}] 테스트 중...")
            
            # 메트릭 초기화
            self.metrics = {
                'coherence': [],
                'relevance': [],
                'naturalness': [],
                'consistency': [],
                'engagement': [],
                'response_time': [],
                'error_count': 0,
                'repetition_count': 0,
                'off_topic_count': 0,
                'inappropriate_count': 0
            }
            
            result = await self.simulate_conversation(persona, 100)
            all_results.append(result)
            
            # 중간 결과 출력
            print(f"\n📈 {persona['name']} 결과:")
            print(f"  - 평균 점수: {result['average_score']:.1f}/100")
            print(f"  - 문제 발생: {result['issues_count']}회")
            print(f"  - 에러 발생: {result['error_count']}회")
            
        # 최종 보고서 생성
        self.generate_final_report(all_results)
        
        return all_results
        
    def generate_final_report(self, results):
        """최종 보고서 생성"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # 전체 통계
        total_turns = sum(r['completed_turns'] for r in results)
        total_issues = sum(r['issues_count'] for r in results)
        total_errors = sum(r['error_count'] for r in results)
        avg_score = sum(r['average_score'] for r in results) / len(results)
        
        # 주요 문제 패턴 분석
        all_issues = []
        for r in results:
            all_issues.extend(r['issues'])
            
        issue_types = defaultdict(int)
        for issue in all_issues:
            if 'issue' in issue:
                for i in issue['issue']:
                    issue_types[i] += 1
                    
        # 보고서 작성
        report = f"""
====================================
100턴 대화 테스트 최종 보고서
====================================
테스트 일시: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
테스트 페르소나: {len(results)}개
총 대화 턴: {total_turns}턴

📊 전체 통계
------------------
평균 품질 점수: {avg_score:.1f}/100
총 문제 발생: {total_issues}회 ({total_issues/total_turns*100:.1f}%)
총 에러 발생: {total_errors}회 ({total_errors/total_turns*100:.1f}%)

🔍 주요 문제 패턴
------------------"""
        
        for issue_type, count in sorted(issue_types.items(), key=lambda x: x[1], reverse=True)[:10]:
            report += f"\n- {issue_type}: {count}회"
            
        report += "\n\n📈 페르소나별 성능\n------------------"
        
        for r in results:
            metrics = r['metrics']
            report += f"""
{r['persona']}:
  - 평균 점수: {r['average_score']:.1f}
  - 응답 시간: {metrics['average_response_time']:.2f}초
  - 반복률: {metrics['repetition_rate']*100:.1f}%
  - 주제이탈률: {metrics['off_topic_rate']*100:.1f}%
  - 부적절응답률: {metrics['inappropriate_rate']*100:.1f}%"""
            
        # 심각한 문제 사례
        report += "\n\n⚠️ 심각한 문제 사례\n------------------"
        
        critical_issues = [i for i in all_issues if 'issue' in i and len(i['issue']) >= 2][:5]
        for idx, issue in enumerate(critical_issues, 1):
            report += f"""
사례 {idx}:
  사용자: {issue['user']}
  AI: {issue['ai']}
  문제: {', '.join(issue['issue'])}"""
            
        # 서비스 가능 여부 판단
        report += f"""

🎯 서비스 가능성 평가
------------------
"""
        
        if avg_score >= 80 and total_errors < 5:
            report += "✅ 서비스 가능 수준"
        elif avg_score >= 70:
            report += "⚠️ 개선 필요 (조건부 서비스 가능)"
        else:
            report += "❌ 서비스 불가 (대폭 개선 필요)"
            
        report += f"""

권장 개선 사항:
1. 반복 응답 문제 해결 (현재 {sum(r['metrics']['repetition_rate'] for r in results)/len(results)*100:.1f}%)
2. 주제 일관성 개선 (현재 이탈률 {sum(r['metrics']['off_topic_rate'] for r in results)/len(results)*100:.1f}%)
3. 응답 시간 최적화 (현재 평균 {sum(r['metrics']['average_response_time'] for r in results)/len(results):.2f}초)
4. 에러 처리 강화 (현재 에러율 {total_errors/total_turns*100:.1f}%)
"""
        
        # 파일로 저장
        report_file = f"test_results/comprehensive_test_{timestamp}.txt"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)
            
        # 상세 데이터 JSON 저장
        detailed_file = f"test_results/detailed_test_{timestamp}.json"
        with open(detailed_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2, default=str)
            
        print(report)
        print(f"\n📁 보고서 저장: {report_file}")
        print(f"📁 상세 데이터 저장: {detailed_file}")
        
        return report

async def main():
    """메인 실행"""
    tester = ComprehensiveDialogueTest()
    
    # .env 파일이 없으면 생성
    import os
    if not os.path.exists('.env'):
        print("⚠️ .env 파일을 생성하고 OpenAI API 키를 입력해주세요")
        with open('.env', 'w') as f:
            f.write("OPENAI_API_KEY=your-api-key-here\n")
        return
        
    # test_results 디렉토리 생성
    os.makedirs('test_results', exist_ok=True)
    
    # 테스트 실행
    results = await tester.run_comprehensive_test()
    
    print("\n" + "=" * 80)
    print("✅ 100턴 대화 테스트 완료!")
    print("=" * 80)

if __name__ == "__main__":
    asyncio.run(main())