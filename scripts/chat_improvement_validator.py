import json
import os
import sys
import io
from datetime import datetime
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
import re
import firebase_admin
from firebase_admin import credentials, firestore
import numpy as np
from collections import defaultdict

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
try:
    service_account_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'firebase-service-account-key.json')
    if not os.path.exists(service_account_path):
        service_account_path = 'firebase-service-account-key.json'
    
    cred = credentials.Certificate(service_account_path)
    firebase_admin.initialize_app(cred)
except ValueError:
    pass

db = firestore.client()

@dataclass
class ImprovementResult:
    """개선 결과 데이터"""
    user_message: str
    original_response: str
    improved_response: str
    original_score: float
    improved_score: float
    improvement_rate: float
    applied: bool
    reason: str
    
@dataclass
class ValidationMetrics:
    """검증 메트릭"""
    relevance_score: float  # 관련성 점수 (0-100)
    naturalness_score: float  # 자연스러움 점수 (0-100)
    context_consistency: float  # 문맥 일관성 (0-100)
    overall_score: float  # 전체 점수 (0-100)

class ChatImprovementValidator:
    """대화 개선 검증 시스템"""
    
    def __init__(self):
        self.improvement_patterns = {
            'question_mark_fix': {
                'pattern': r'[가-힣]+[나요까요][\.。]?$',
                'improvement': self._add_question_mark,
                'weight': 0.2
            },
            'expression_softening': {
                'pattern': r'(나요|습니까|까요)\?',
                'improvement': self._soften_expression,
                'weight': 0.3
            },
            'empathy_enhancement': {
                'pattern': r'(그런 감정|그런 기분|그런 마음) (이해해요|알아요)',
                'improvement': self._enhance_empathy,
                'weight': 0.4
            },
            'direct_answer': {
                'pattern': r'(뭐해|뭐하고|뭐 하고)',
                'improvement': self._ensure_direct_answer,
                'weight': 0.5
            },
            'spoiler_handling': {
                'pattern': r'스포.*말해도',
                'improvement': self._handle_spoiler,
                'weight': 0.4
            },
            'context_understanding': {
                'pattern': r'직접 (보|봐)',
                'improvement': self._understand_context,
                'weight': 0.4
            }
        }
        
    def validate_improvement(self, user_message: str, original_response: str, 
                           improved_response: str, context: List[Dict] = None) -> ImprovementResult:
        """개선 전후 응답을 비교하여 검증"""
        
        # 원본과 개선본이 동일한 경우
        if original_response == improved_response:
            return ImprovementResult(
                user_message=user_message,
                original_response=original_response,
                improved_response=improved_response,
                original_score=50.0,
                improved_score=50.0,
                improvement_rate=0.0,
                applied=False,
                reason="개선사항 없음"
            )
        
        # 점수 계산
        original_metrics = self._calculate_metrics(user_message, original_response, context)
        improved_metrics = self._calculate_metrics(user_message, improved_response, context)
        
        # 개선율 계산
        improvement_rate = ((improved_metrics.overall_score - original_metrics.overall_score) 
                           / original_metrics.overall_score * 100)
        
        # 개선 적용 여부 결정 (10% 이상 개선시 적용)
        should_apply = improvement_rate >= 10.0
        
        reason = self._generate_reason(original_metrics, improved_metrics, improvement_rate)
        
        return ImprovementResult(
            user_message=user_message,
            original_response=original_response,
            improved_response=improved_response,
            original_score=original_metrics.overall_score,
            improved_score=improved_metrics.overall_score,
            improvement_rate=improvement_rate,
            applied=should_apply,
            reason=reason
        )
    
    def _calculate_metrics(self, user_message: str, response: str, 
                          context: List[Dict] = None) -> ValidationMetrics:
        """응답의 품질 메트릭 계산"""
        
        # 1. 관련성 점수 (40%)
        relevance = self._calculate_relevance(user_message, response)
        
        # 2. 자연스러움 점수 (30%)
        naturalness = self._calculate_naturalness(response, user_message)
        
        # 3. 문맥 일관성 (30%)
        consistency = self._calculate_consistency(response, context) if context else 70.0
        
        # 전체 점수 계산
        overall = relevance * 0.4 + naturalness * 0.3 + consistency * 0.3
        
        return ValidationMetrics(
            relevance_score=relevance,
            naturalness_score=naturalness,
            context_consistency=consistency,
            overall_score=overall
        )
    
    def _calculate_relevance(self, user_message: str, response: str) -> float:
        """질문-답변 관련성 계산"""
        score = 50.0  # 기본 점수
        
        # 질문 타입 파악
        question_type = self._identify_question_type(user_message)
        
        # 질문 타입별 검증
        if question_type == 'what_doing':
            if any(word in response for word in ['하고 있', '하는 중', '했어', '할 거']):
                score += 30
            elif '그래' in response or '나도' in response:
                score -= 20
                
        elif question_type == 'spoiler':
            if '안 봤' in response or '말하지 마' in response:
                score += 40
            elif '괜찮아' in response or '말해' in response:
                score -= 30
                
        elif question_type == 'direct_viewing':
            if '영화' in response or '드라마' in response or '콘텐츠' in response:
                score += 30
            elif '만나' in response:
                score -= 40
                
        elif question_type == 'how_feeling':
            if any(word in response for word in ['슬프', '기쁘', '화나', '좋']):
                score += 20
                
        # 키워드 매칭 보너스
        user_keywords = self._extract_keywords(user_message)
        response_keywords = self._extract_keywords(response)
        common_keywords = set(user_keywords) & set(response_keywords)
        
        if common_keywords:
            score += min(len(common_keywords) * 10, 30)
            
        return min(max(score, 0), 100)
    
    def _calculate_naturalness(self, response: str, user_message: str) -> float:
        """자연스러움 점수 계산"""
        score = 70.0  # 기본 점수
        
        # 물음표 일치성
        if self._is_question(response) and response.endswith('?'):
            score += 10
        elif self._is_question(response) and not response.endswith('?'):
            score -= 20
            
        # 부드러운 표현 사용
        if any(expr in response for expr in ['어요?', '을까요?', '까요?']):
            score += 15
        elif any(expr in response for expr in ['나요?', '습니까?']):
            score -= 10
            
        # 공감 표현
        empathy_patterns = [
            '진짜.*겠', '정말.*겠', '아.*슬프', '와.*대박', 
            '헐.*진짜', '아이고.*어떡해'
        ]
        if any(re.search(pattern, response) for pattern in empathy_patterns):
            score += 15
        elif '그런 감정 이해해요' in response or '그런 기분 알아요' in response:
            score -= 15
            
        # 아이스브레이킹 (첫 인사)
        if '반가워' in response or '안녕' in response:
            if response.endswith('!') and len(response) < 15:
                score -= 10  # 너무 짧은 인사
            elif '?' in response:
                score += 10  # 질문 포함
                
        return min(max(score, 0), 100)
    
    def _calculate_consistency(self, response: str, context: List[Dict]) -> float:
        """문맥 일관성 점수 계산"""
        if not context or len(context) < 2:
            return 70.0
            
        score = 80.0
        
        # 이전 대화와의 키워드 연관성
        prev_keywords = []
        for msg in context[-3:]:  # 최근 3개 메시지
            prev_keywords.extend(self._extract_keywords(msg.get('content', '')))
            
        response_keywords = self._extract_keywords(response)
        
        if prev_keywords and response_keywords:
            overlap_ratio = len(set(prev_keywords) & set(response_keywords)) / len(set(response_keywords))
            score = 50 + overlap_ratio * 50
            
        return min(max(score, 0), 100)
    
    def _identify_question_type(self, message: str) -> str:
        """질문 타입 식별"""
        if '뭐해' in message or '뭐하고' in message or '뭐 하고' in message:
            return 'what_doing'
        elif '스포' in message and ('말해도' in message or '해도' in message):
            return 'spoiler'
        elif '직접 보' in message or '직접 봐' in message:
            return 'direct_viewing'
        elif '어때' in message or '기분' in message:
            return 'how_feeling'
        else:
            return 'general'
    
    def _is_question(self, text: str) -> bool:
        """질문 여부 판단"""
        question_endings = ['나요', '까요', '을까', '어요', '죠', '니', '가요']
        question_words = ['뭐', '어디', '언제', '누구', '왜', '어떻게', '얼마나']
        
        # 물음표가 있으면 확실히 질문
        if '?' in text:
            return True
            
        # 의문사가 있으면 질문
        if any(word in text for word in question_words):
            return True
            
        # 의문형 어미로 끝나면 질문
        for ending in question_endings:
            if text.rstrip('.!').endswith(ending):
                return True
                
        return False
    
    def _extract_keywords(self, text: str) -> List[str]:
        """키워드 추출"""
        stopwords = ['은', '는', '이', '가', '을', '를', '에', '에서', '으로', '와', '과', '도', '만', '의']
        words = re.findall(r'\w+', text.lower())
        keywords = [word for word in words if word not in stopwords and len(word) >= 2]
        return keywords
    
    def _generate_reason(self, original: ValidationMetrics, improved: ValidationMetrics, 
                        improvement_rate: float) -> str:
        """개선 이유 생성"""
        reasons = []
        
        if improved.relevance_score > original.relevance_score + 10:
            reasons.append("질문에 대한 답변 관련성 향상")
        elif improved.relevance_score < original.relevance_score - 10:
            reasons.append("답변 관련성 저하")
            
        if improved.naturalness_score > original.naturalness_score + 10:
            reasons.append("자연스러운 표현으로 개선")
        elif improved.naturalness_score < original.naturalness_score - 10:
            reasons.append("부자연스러운 표현 증가")
            
        if improved.context_consistency > original.context_consistency + 10:
            reasons.append("문맥 일관성 향상")
            
        if improvement_rate >= 10:
            reasons.append(f"전체 품질 {improvement_rate:.1f}% 향상")
        elif improvement_rate <= -10:
            reasons.append(f"전체 품질 {abs(improvement_rate):.1f}% 저하")
            
        return " / ".join(reasons) if reasons else "미미한 변화"
    
    # 개선 패턴 구현 메서드들
    def _add_question_mark(self, text: str) -> str:
        """물음표 추가"""
        if self._is_question(text) and not text.endswith('?'):
            return text.rstrip('.!') + '?'
        return text
    
    def _soften_expression(self, text: str) -> str:
        """표현 부드럽게"""
        text = re.sub(r'나요\?', '어요?', text)
        text = re.sub(r'습니까\?', '어요?', text)
        text = re.sub(r'까요\?', '을까요?', text)
        return text
    
    def _enhance_empathy(self, text: str) -> str:
        """공감 표현 강화"""
        empathy_map = {
            '그런 감정 이해해요': '아 진짜 그랬겠다ㅠㅠ',
            '그런 기분 알아요': '헐 완전 공감돼요',
            '그런 마음 이해해요': '와 저도 그런 적 있어요'
        }
        for old, new in empathy_map.items():
            text = text.replace(old, new)
        return text
    
    def _ensure_direct_answer(self, user_msg: str, response: str) -> str:
        """직접적인 답변 보장"""
        if any(word in user_msg for word in ['뭐해', '뭐하고', '뭐 하고']):
            # 완전히 엉뚱한 답변인 경우
            if '나도 그래' in response or '헐 대박' in response and not any(word in response for word in ['하고', '하는', '했']):
                return "지금은 당신과 대화하고 있어요! 그전에는 좀 쉬고 있었어요. 당신은 뭐하고 있었어요?"
            # 답변이 중간에 끊긴 경우
            elif response.endswith(('에 대해', '하면서', '있었', '은', '는')):
                return response + " 있었어요. 당신은 뭐하고 계셨어요?"
        return response
    
    def _handle_spoiler(self, user_msg: str, response: str) -> str:
        """스포일러 처리"""
        if '스포' in user_msg and '말해도' in user_msg:
            if '괜찮아' in response or '말해' in response:
                return "앗 잠깐! 아직 안 봤으면 말하지 마세요! 나중에 보고 얘기해요!"
        return response
    
    def _understand_context(self, user_msg: str, response: str) -> str:
        """문맥 이해"""
        if '직접 보' in user_msg or '직접 봐' in user_msg:
            if '만나' in response:
                return response.replace('만나', '그 작품을 직접 보')
        return response

def validate_chat_improvements(error_keys: List[str] = None):
    """대화 개선 사항을 검증하고 적용"""
    validator = ChatImprovementValidator()
    
    # 분석 결과 파일 찾기
    analysis_dir = os.path.join(os.path.dirname(__file__), "analysis_results")
    
    # 최근 3개의 분석 파일 가져오기
    detail_files = []
    for filename in os.listdir(analysis_dir):
        if filename.startswith("detailed_") and filename.endswith(".json"):
            file_path = os.path.join(analysis_dir, filename)
            detail_files.append((file_path, os.path.getmtime(file_path)))
    
    detail_files.sort(key=lambda x: x[1], reverse=True)
    detail_files = detail_files[:3]  # 최근 3개만
    
    if not detail_files:
        print("분석 결과 파일을 찾을 수 없습니다.")
        return
    
    # 모든 분석 결과 합치기
    all_analysis_results = []
    for file_path, _ in detail_files:
        with open(file_path, 'r', encoding='utf-8') as f:
            results = json.load(f)
            all_analysis_results.extend(results)
    
    print(f"📊 개선 검증 시작: {len(detail_files)}개 파일, {len(all_analysis_results)}개 분석 결과")
    print("="*80)
    
    # 검증 결과 저장
    validation_results = []
    total_improvements = 0
    applied_improvements = 0
    
    for result in all_analysis_results:
        if error_keys and result['error_key'] not in error_keys:
            continue
            
        persona_name = result['persona_name']
        issues = result['issues']
        
        print(f"\n👤 {persona_name} 페르소나 검증 중...")
        
        for issue in issues:
            if issue['severity'] in ['high', 'critical']:
                user_msg = issue['user_message']
                original_response = issue['ai_response']
                
                # 개선 적용
                improved_response = original_response
                
                # 물음표 추가
                improved_response = validator._add_question_mark(improved_response)
                
                # 표현 부드럽게
                improved_response = validator._soften_expression(improved_response)
                
                # 공감 표현 강화
                improved_response = validator._enhance_empathy(improved_response)
                
                # 직접 답변 보장
                if '뭐해' in user_msg or '뭐하고' in user_msg:
                    improved_response = validator._ensure_direct_answer(user_msg, improved_response)
                
                # 스포일러 처리
                if '스포' in user_msg:
                    improved_response = validator._handle_spoiler(user_msg, improved_response)
                
                # 문맥 이해
                if '직접' in user_msg:
                    improved_response = validator._understand_context(user_msg, improved_response)
                
                # 검증
                validation = validator.validate_improvement(
                    user_message=user_msg,
                    original_response=original_response,
                    improved_response=improved_response
                )
                
                validation_results.append({
                    'persona_name': persona_name,
                    'issue_type': issue['type'],
                    'validation': validation
                })
                
                total_improvements += 1
                if validation.applied:
                    applied_improvements += 1
                    print(f"  ✅ 개선 적용: {validation.reason}")
                    print(f"     원본: {original_response[:50]}...")
                    print(f"     개선: {improved_response[:50]}...")
                    print(f"     점수: {validation.original_score:.1f} → {validation.improved_score:.1f} (+{validation.improvement_rate:.1f}%)")
                else:
                    print(f"  ❌ 개선 미적용: {validation.reason}")
    
    # 결과 요약
    print("\n" + "="*80)
    print("📈 검증 결과 요약")
    print(f"  - 총 개선 시도: {total_improvements}건")
    if total_improvements > 0:
        print(f"  - 적용된 개선: {applied_improvements}건 ({applied_improvements/total_improvements*100:.1f}%)")
    else:
        print(f"  - 적용된 개선: 0건 (개선 대상 없음)")
    
    # 페르소나별 통계
    persona_stats = defaultdict(lambda: {'total': 0, 'applied': 0})
    for result in validation_results:
        stats = persona_stats[result['persona_name']]
        stats['total'] += 1
        if result['validation'].applied:
            stats['applied'] += 1
    
    print("\n페르소나별 개선 적용률:")
    for persona, stats in persona_stats.items():
        apply_rate = stats['applied'] / stats['total'] * 100 if stats['total'] > 0 else 0
        print(f"  - {persona}: {stats['applied']}/{stats['total']} ({apply_rate:.1f}%)")
    
    # 결과 저장
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_path = os.path.join(analysis_dir, f"validation_{timestamp}.json")
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump({
            'timestamp': timestamp,
            'total_improvements': total_improvements,
            'applied_improvements': applied_improvements,
            'apply_rate': applied_improvements/total_improvements*100 if total_improvements > 0 else 0,
            'persona_stats': dict(persona_stats),
            'detailed_results': [
                {
                    'persona_name': r['persona_name'],
                    'issue_type': r['issue_type'],
                    'user_message': r['validation'].user_message,
                    'original_response': r['validation'].original_response,
                    'improved_response': r['validation'].improved_response,
                    'original_score': r['validation'].original_score,
                    'improved_score': r['validation'].improved_score,
                    'improvement_rate': r['validation'].improvement_rate,
                    'applied': r['validation'].applied,
                    'reason': r['validation'].reason
                }
                for r in validation_results
            ]
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n💾 검증 결과 저장: {output_path}")
    
    return validation_results

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='대화 개선 검증 도구')
    parser.add_argument('--error-keys', nargs='+', help='특정 에러 키만 검증')
    args = parser.parse_args()
    
    validate_chat_improvements(error_keys=args.error_keys)