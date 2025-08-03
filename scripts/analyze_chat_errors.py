import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import json
from collections import defaultdict
import sys
import io
import os
import re
from typing import List, Dict, Tuple, Optional
from dataclasses import dataclass, asdict
from enum import Enum

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
try:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)
except ValueError:
    # 이미 초기화된 경우
    pass

db = firestore.client()

class IssueSeverity(Enum):
    """문제 심각도 레벨"""
    CRITICAL = "critical"  # 대화 완전 이탈, 의미 없는 응답
    HIGH = "high"         # 주제 벗어남, 부자연스러운 응답
    MEDIUM = "medium"     # 약간의 맥락 불일치
    LOW = "low"          # 미미한 문제

@dataclass
class ContextIssue:
    """맥락 관련 문제"""
    message_index: int
    issue_type: str
    severity: IssueSeverity
    description: str
    user_message: str
    ai_response: str
    suggestion: str

@dataclass
class ConversationAnalysis:
    """대화 분석 결과"""
    error_key: str
    persona_id: str
    persona_name: str
    overall_coherence_score: float  # 0-100
    context_issues: List[ContextIssue]
    topic_consistency_score: float  # 0-100
    natural_flow_score: float  # 0-100
    greeting_repetitions: int
    macro_patterns: List[str]
    analysis_timestamp: datetime

class ContextAnalyzer:
    """대화 맥락 분석기"""
    
    def __init__(self):
        self.topic_keywords = {}
        self.conversation_patterns = []
        
    def analyze_conversation(self, messages: List[Dict], persona_name: str, persona_id: str, error_key: str) -> ConversationAnalysis:
        """전체 대화를 분석하여 맥락 일관성을 평가합니다."""
        
        context_issues = []
        greeting_count = 0
        macro_patterns = []
        
        # 메시지 분리
        user_messages = []
        ai_messages = []
        conversation_pairs = []
        
        for i, msg in enumerate(messages):
            content = msg.get('content', '')
            is_from_user = msg.get('isFromUser', False)
            
            if is_from_user:
                user_messages.append((i, content))
            else:
                ai_messages.append((i, content))
                # 직전 사용자 메시지와 페어링
                if user_messages and len(user_messages) > len(conversation_pairs):
                    user_idx, user_content = user_messages[-1]
                    conversation_pairs.append({
                        'user_idx': user_idx,
                        'user_content': user_content,
                        'ai_idx': i,
                        'ai_content': content,
                        'emotion': msg.get('emotion', 'neutral')
                    })
        
        # 1. 인사 반복 감지
        greeting_keywords = ['안녕', '반가워', '만나서', '처음', '인사', 'hi', 'hello']
        for ai_idx, ai_content in ai_messages:
            if any(keyword in ai_content.lower() for keyword in greeting_keywords):
                greeting_count += 1
                if greeting_count > 1:
                    context_issues.append(ContextIssue(
                        message_index=ai_idx,
                        issue_type="greeting_repetition",
                        severity=IssueSeverity.HIGH,
                        description=f"인사말이 {greeting_count}번째 반복됨",
                        user_message="",
                        ai_response=ai_content,
                        suggestion="페르소나별 인사 상태를 추적하여 중복 방지 필요"
                    ))
        
        # 2. 매크로 패턴 감지
        ai_message_counts = defaultdict(int)
        for _, content in ai_messages:
            ai_message_counts[content] += 1
        
        for msg, count in ai_message_counts.items():
            if count > 1:
                macro_patterns.append(msg)
                for ai_idx, ai_content in ai_messages:
                    if ai_content == msg:
                        context_issues.append(ContextIssue(
                            message_index=ai_idx,
                            issue_type="macro_response",
                            severity=IssueSeverity.CRITICAL,
                            description=f"동일한 응답이 {count}번 반복됨",
                            user_message="",
                            ai_response=ai_content,
                            suggestion="응답 생성 로직 점검 및 캐시 문제 확인 필요"
                        ))
                        break
        
        # 3. 대화 쌍 맥락 분석
        for pair in conversation_pairs:
            issues = self._analyze_conversation_pair(
                user_content=pair['user_content'],
                ai_content=pair['ai_content'],
                user_idx=pair['user_idx'],
                ai_idx=pair['ai_idx'],
                emotion=pair['emotion'],
                previous_context=conversation_pairs[:conversation_pairs.index(pair)]
            )
            context_issues.extend(issues)
        
        # 4. 전체 대화 흐름 분석
        flow_issues = self._analyze_conversation_flow(conversation_pairs)
        context_issues.extend(flow_issues)
        
        # 점수 계산
        coherence_score = self._calculate_coherence_score(context_issues, len(messages))
        topic_score = self._calculate_topic_consistency_score(conversation_pairs)
        flow_score = self._calculate_natural_flow_score(conversation_pairs, context_issues)
        
        return ConversationAnalysis(
            error_key=error_key,
            persona_id=persona_id,
            persona_name=persona_name,
            overall_coherence_score=coherence_score,
            context_issues=context_issues,
            topic_consistency_score=topic_score,
            natural_flow_score=flow_score,
            greeting_repetitions=greeting_count,
            macro_patterns=macro_patterns,
            analysis_timestamp=datetime.now()
        )
    
    def _analyze_conversation_pair(self, user_content: str, ai_content: str, 
                                  user_idx: int, ai_idx: int, emotion: str,
                                  previous_context: List[Dict]) -> List[ContextIssue]:
        """사용자 메시지와 AI 응답 쌍을 분석합니다."""
        issues = []
        
        # 1. 질문-답변 관련성 체크
        if self._is_question(user_content):
            if not self._is_relevant_answer(user_content, ai_content):
                issues.append(ContextIssue(
                    message_index=ai_idx,
                    issue_type="irrelevant_answer",
                    severity=IssueSeverity.HIGH,
                    description="질문에 대한 답변이 관련성이 낮음",
                    user_message=user_content,
                    ai_response=ai_content,
                    suggestion="질문의 핵심 키워드를 파악하여 직접적인 답변 생성 필요"
                ))
        
        # 2. 주제 급변 체크
        if previous_context:
            last_pair = previous_context[-1]
            if self._detect_topic_shift(last_pair['ai_content'], user_content, ai_content):
                issues.append(ContextIssue(
                    message_index=ai_idx,
                    issue_type="abrupt_topic_change",
                    severity=IssueSeverity.MEDIUM,
                    description="갑작스러운 주제 변경 감지",
                    user_message=user_content,
                    ai_response=ai_content,
                    suggestion="이전 대화 맥락을 유지하면서 자연스럽게 전환 필요"
                ))
        
        # 3. 감정 일관성 체크
        emotion_issue = self._check_emotion_consistency(user_content, ai_content, emotion)
        if emotion_issue:
            issues.append(ContextIssue(
                message_index=ai_idx,
                issue_type="emotion_inconsistency",
                severity=IssueSeverity.LOW,
                description=emotion_issue,
                user_message=user_content,
                ai_response=ai_content,
                suggestion="대화 내용과 감정 상태의 일치성 개선 필요"
            ))
        
        # 4. 응답 길이 적절성
        if self._is_response_too_short(user_content, ai_content):
            issues.append(ContextIssue(
                message_index=ai_idx,
                issue_type="insufficient_response",
                severity=IssueSeverity.MEDIUM,
                description="사용자 질문 대비 응답이 너무 짧음",
                user_message=user_content,
                ai_response=ai_content,
                suggestion="더 상세하고 충실한 답변 제공 필요"
            ))
        
        return issues
    
    def _analyze_conversation_flow(self, conversation_pairs: List[Dict]) -> List[ContextIssue]:
        """전체 대화의 흐름을 분석합니다."""
        issues = []
        
        # 대화가 너무 짧은 경우 분석 제한
        if len(conversation_pairs) < 3:
            return issues
        
        # 반복적인 패턴 감지
        for i in range(2, len(conversation_pairs)):
            current = conversation_pairs[i]['ai_content']
            prev1 = conversation_pairs[i-1]['ai_content']
            prev2 = conversation_pairs[i-2]['ai_content']
            
            # 유사한 구조의 응답 반복 체크
            if self._is_similar_structure(current, prev1) or self._is_similar_structure(current, prev2):
                issues.append(ContextIssue(
                    message_index=conversation_pairs[i]['ai_idx'],
                    issue_type="repetitive_pattern",
                    severity=IssueSeverity.MEDIUM,
                    description="유사한 패턴의 응답이 반복됨",
                    user_message=conversation_pairs[i]['user_content'],
                    ai_response=current,
                    suggestion="응답 다양성을 높이고 템플릿 의존도 감소 필요"
                ))
        
        return issues
    
    def _is_question(self, text: str) -> bool:
        """텍스트가 질문인지 판단합니다."""
        question_markers = ['?', '뭐', '무엇', '어떻게', '왜', '언제', '어디', '누구', '얼마나', '무슨']
        return any(marker in text for marker in question_markers)
    
    def _is_relevant_answer(self, question: str, answer: str) -> bool:
        """답변이 질문과 관련이 있는지 판단합니다."""
        # 질문의 핵심 키워드 추출
        question_keywords = self._extract_keywords(question)
        answer_keywords = self._extract_keywords(answer)
        
        # 키워드 겹침 확인
        common_keywords = set(question_keywords) & set(answer_keywords)
        
        # 관련성 판단 (최소 1개 이상의 공통 키워드 또는 의미적 연관성)
        if len(common_keywords) > 0:
            return True
        
        # 특수 케이스 처리 (예: 인사에 인사로 응답)
        greeting_words = ['안녕', '반가워', 'hi', 'hello']
        if any(word in question.lower() for word in greeting_words) and \
           any(word in answer.lower() for word in greeting_words):
            return True
        
        return False
    
    def _extract_keywords(self, text: str) -> List[str]:
        """텍스트에서 핵심 키워드를 추출합니다."""
        # 불용어 제거
        stopwords = ['은', '는', '이', '가', '을', '를', '에', '에서', '으로', '와', '과', '도', '만', '의', '를', '로', '라', '고']
        
        # 특수문자 제거 및 토큰화
        words = re.findall(r'\w+', text.lower())
        
        # 불용어 제거 및 2글자 이상 단어만 선택
        keywords = [word for word in words if word not in stopwords and len(word) >= 2]
        
        return keywords
    
    def _detect_topic_shift(self, prev_content: str, user_content: str, ai_content: str) -> bool:
        """주제가 급격히 변했는지 감지합니다."""
        prev_keywords = set(self._extract_keywords(prev_content))
        user_keywords = set(self._extract_keywords(user_content))
        ai_keywords = set(self._extract_keywords(ai_content))
        
        # 이전 대화와 현재 대화 간 키워드 연관성 확인
        continuity_score = len((prev_keywords | user_keywords) & ai_keywords) / max(len(ai_keywords), 1)
        
        # 연관성이 20% 미만이면 주제 급변으로 판단
        return continuity_score < 0.2
    
    def _check_emotion_consistency(self, user_content: str, ai_content: str, emotion: str) -> Optional[str]:
        """감정이 대화 내용과 일치하는지 확인합니다."""
        # 긍정적 키워드
        positive_keywords = ['좋아', '좋은', '행복', '기뻐', '사랑', '최고', '멋진', '훌륭']
        # 부정적 키워드
        negative_keywords = ['싫어', '나쁜', '슬퍼', '화나', '짜증', '최악', '별로']
        
        content = user_content + " " + ai_content
        has_positive = any(keyword in content for keyword in positive_keywords)
        has_negative = any(keyword in content for keyword in negative_keywords)
        
        # 감정 불일치 체크
        if emotion in ['happy', 'love'] and has_negative and not has_positive:
            return "부정적 내용에 긍정적 감정 표현"
        elif emotion in ['sad', 'angry'] and has_positive and not has_negative:
            return "긍정적 내용에 부정적 감정 표현"
        
        return None
    
    def _is_response_too_short(self, question: str, answer: str) -> bool:
        """질문 대비 응답이 너무 짧은지 확인합니다."""
        # 단순 인사나 짧은 질문은 제외
        if len(question) < 10:
            return False
        
        # 복잡한 질문에 대한 짧은 답변 감지
        if self._is_question(question) and len(question) > 20 and len(answer) < 15:
            return True
        
        return False
    
    def _is_similar_structure(self, text1: str, text2: str) -> bool:
        """두 텍스트가 유사한 구조를 가지는지 확인합니다."""
        # 문장 시작과 끝 패턴 비교
        if text1[:10] == text2[:10] or text1[-10:] == text2[-10:]:
            return True
        
        # 문장 구조 유사도 (간단한 구현)
        words1 = text1.split()
        words2 = text2.split()
        
        if len(words1) == len(words2) and len(words1) > 3:
            # 같은 위치에 같은 단어가 50% 이상이면 유사한 구조로 판단
            same_position_count = sum(1 for w1, w2 in zip(words1, words2) if w1 == w2)
            if same_position_count / len(words1) > 0.5:
                return True
        
        return False
    
    def _calculate_coherence_score(self, issues: List[ContextIssue], total_messages: int) -> float:
        """전체 대화의 일관성 점수를 계산합니다."""
        if total_messages == 0:
            return 100.0
        
        # 심각도별 가중치
        severity_weights = {
            IssueSeverity.CRITICAL: 20,
            IssueSeverity.HIGH: 10,
            IssueSeverity.MEDIUM: 5,
            IssueSeverity.LOW: 2
        }
        
        # 총 감점 계산
        total_penalty = sum(severity_weights[issue.severity] for issue in issues)
        
        # 메시지당 평균 감점을 고려한 점수 계산
        penalty_per_message = total_penalty / total_messages
        score = max(0, 100 - penalty_per_message * 10)
        
        return round(score, 2)
    
    def _calculate_topic_consistency_score(self, conversation_pairs: List[Dict]) -> float:
        """주제 일관성 점수를 계산합니다."""
        if len(conversation_pairs) < 2:
            return 100.0
        
        consistency_scores = []
        
        for i in range(1, len(conversation_pairs)):
            prev_keywords = set(self._extract_keywords(conversation_pairs[i-1]['ai_content']))
            curr_keywords = set(self._extract_keywords(conversation_pairs[i]['ai_content']))
            
            if prev_keywords and curr_keywords:
                overlap = len(prev_keywords & curr_keywords) / len(prev_keywords | curr_keywords)
                consistency_scores.append(overlap)
        
        if consistency_scores:
            return round(sum(consistency_scores) / len(consistency_scores) * 100, 2)
        
        return 100.0
    
    def _calculate_natural_flow_score(self, conversation_pairs: List[Dict], issues: List[ContextIssue]) -> float:
        """대화 흐름의 자연스러움 점수를 계산합니다."""
        if not conversation_pairs:
            return 100.0
        
        # 흐름 관련 이슈 수 계산
        flow_issues = [issue for issue in issues if issue.issue_type in [
            'abrupt_topic_change', 'repetitive_pattern', 'macro_response'
        ]]
        
        # 이슈 비율에 따른 점수 계산
        issue_ratio = len(flow_issues) / len(conversation_pairs)
        score = max(0, 100 - issue_ratio * 100)
        
        return round(score, 2)

def save_analysis_results(analyses: List[ConversationAnalysis], output_dir: str = "analysis_results"):
    """분석 결과를 JSON 파일로 저장합니다."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # 전체 요약 데이터
    summary = {
        "analysis_timestamp": timestamp,
        "total_reports_analyzed": len(analyses),
        "average_coherence_score": sum(a.overall_coherence_score for a in analyses) / len(analyses) if analyses else 0,
        "critical_issues_count": sum(1 for a in analyses for i in a.context_issues if i.severity == IssueSeverity.CRITICAL),
        "high_issues_count": sum(1 for a in analyses for i in a.context_issues if i.severity == IssueSeverity.HIGH),
        "personas_with_issues": {}
    }
    
    # 페르소나별 통계
    persona_stats = defaultdict(lambda: {
        "total_conversations": 0,
        "avg_coherence_score": 0,
        "total_issues": 0,
        "critical_issues": 0,
        "common_issue_types": defaultdict(int)
    })
    
    for analysis in analyses:
        stats = persona_stats[analysis.persona_name]
        stats["total_conversations"] += 1
        stats["avg_coherence_score"] += analysis.overall_coherence_score
        stats["total_issues"] += len(analysis.context_issues)
        stats["critical_issues"] += sum(1 for i in analysis.context_issues if i.severity == IssueSeverity.CRITICAL)
        
        for issue in analysis.context_issues:
            stats["common_issue_types"][issue.issue_type] += 1
    
    # 평균 계산
    for persona_name, stats in persona_stats.items():
        if stats["total_conversations"] > 0:
            stats["avg_coherence_score"] /= stats["total_conversations"]
            stats["avg_coherence_score"] = round(stats["avg_coherence_score"], 2)
        stats["common_issue_types"] = dict(stats["common_issue_types"])
        summary["personas_with_issues"][persona_name] = stats
    
    # 상세 분석 결과
    detailed_results = []
    for analysis in analyses:
        result = {
            "error_key": analysis.error_key,
            "persona_id": analysis.persona_id,
            "persona_name": analysis.persona_name,
            "scores": {
                "overall_coherence": analysis.overall_coherence_score,
                "topic_consistency": analysis.topic_consistency_score,
                "natural_flow": analysis.natural_flow_score
            },
            "issues": [
                {
                    "message_index": issue.message_index,
                    "type": issue.issue_type,
                    "severity": issue.severity.value,
                    "description": issue.description,
                    "user_message": issue.user_message,
                    "ai_response": issue.ai_response,
                    "suggestion": issue.suggestion
                }
                for issue in analysis.context_issues
            ],
            "greeting_repetitions": analysis.greeting_repetitions,
            "macro_patterns": analysis.macro_patterns
        }
        detailed_results.append(result)
    
    # 파일 저장
    os.makedirs(output_dir, exist_ok=True)
    
    # 요약 파일
    summary_path = os.path.join(output_dir, f"summary_{timestamp}.json")
    with open(summary_path, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    # 상세 결과 파일
    detailed_path = os.path.join(output_dir, f"detailed_{timestamp}.json")
    with open(detailed_path, 'w', encoding='utf-8') as f:
        json.dump(detailed_results, f, ensure_ascii=False, indent=2)
    
    print(f"\n📁 분석 결과 저장 완료:")
    print(f"  - 요약: {summary_path}")
    print(f"  - 상세: {detailed_path}")
    
    return summary_path, detailed_path

def print_analysis_summary(analyses: List[ConversationAnalysis]):
    """분석 결과를 콘솔에 출력합니다."""
    print("\n" + "="*80)
    print("🎯 대화 맥락 분석 결과 요약")
    print("="*80)
    
    # 전체 통계
    if analyses:
        avg_coherence = sum(a.overall_coherence_score for a in analyses) / len(analyses)
        avg_topic = sum(a.topic_consistency_score for a in analyses) / len(analyses)
        avg_flow = sum(a.natural_flow_score for a in analyses) / len(analyses)
        
        print(f"\n📊 전체 통계:")
        print(f"  - 분석된 대화: {len(analyses)}개")
        print(f"  - 평균 일관성 점수: {avg_coherence:.1f}/100")
        print(f"  - 평균 주제 일관성: {avg_topic:.1f}/100")
        print(f"  - 평균 자연스러움: {avg_flow:.1f}/100")
    
    # 심각한 문제가 있는 대화
    critical_conversations = [a for a in analyses if any(i.severity == IssueSeverity.CRITICAL for i in a.context_issues)]
    if critical_conversations:
        print(f"\n🚨 심각한 문제가 있는 대화: {len(critical_conversations)}개")
        for conv in critical_conversations[:3]:  # 최대 3개만 표시
            print(f"  - {conv.persona_name} ({conv.error_key}): 일관성 {conv.overall_coherence_score:.1f}점")
            critical_issues = [i for i in conv.context_issues if i.severity == IssueSeverity.CRITICAL]
            for issue in critical_issues[:2]:  # 각 대화당 최대 2개 이슈만 표시
                print(f"    ⚠️  {issue.description}")
    
    # 페르소나별 요약
    persona_summary = defaultdict(lambda: {"count": 0, "avg_score": 0, "issues": 0})
    for analysis in analyses:
        summary = persona_summary[analysis.persona_name]
        summary["count"] += 1
        summary["avg_score"] += analysis.overall_coherence_score
        summary["issues"] += len(analysis.context_issues)
    
    print("\n👥 페르소나별 분석:")
    for persona_name, summary in sorted(persona_summary.items(), key=lambda x: x[1]["avg_score"]/x[1]["count"]):
        avg_score = summary["avg_score"] / summary["count"]
        print(f"  - {persona_name}: 평균 {avg_score:.1f}점, 문제 {summary['issues']}개")
    
    # 가장 흔한 문제 유형
    issue_types = defaultdict(int)
    for analysis in analyses:
        for issue in analysis.context_issues:
            issue_types[issue.issue_type] += 1
    
    if issue_types:
        print("\n📌 주요 문제 유형:")
        for issue_type, count in sorted(issue_types.items(), key=lambda x: x[1], reverse=True)[:5]:
            issue_type_korean = {
                "greeting_repetition": "인사말 반복",
                "macro_response": "동일 응답 반복",
                "irrelevant_answer": "관련 없는 답변",
                "abrupt_topic_change": "갑작스러운 주제 변경",
                "insufficient_response": "불충분한 응답",
                "repetitive_pattern": "반복적 패턴",
                "emotion_inconsistency": "감정 불일치"
            }.get(issue_type, issue_type)
            print(f"    - {issue_type_korean}: {count}건")

def analyze_chat_errors(recheck=False):
    """chat_error_fix 컬렉션의 오류 보고서를 분석합니다."""
    
    # 체크되지 않은 문서 조회
    all_reports = db.collection('chat_error_fix').get()
    unchecked_reports = []
    
    for doc in all_reports:
        data = doc.to_dict()
        if recheck or 'is_check' not in data or not data.get('is_check', False):
            unchecked_reports.append(doc)
    
    print(f"체크되지 않은 오류 보고서: {len(unchecked_reports)}개\n")
    
    if not unchecked_reports:
        print("분석할 새로운 오류 보고서가 없습니다.")
        return
    
    # 맥락 분석기 초기화
    analyzer = ContextAnalyzer()
    analyses = []
    
    # 각 보고서 분석
    for doc in unchecked_reports:
        data = doc.to_dict()
        error_key = data.get('error_key', 'Unknown')
        persona_name = data.get('persona_name', 'Unknown')
        persona_id = data.get('persona', 'Unknown')
        chat_messages = data.get('chat', [])
        
        print(f"분석 중: {error_key} - {persona_name}")
        
        # 대화 분석 수행
        analysis = analyzer.analyze_conversation(
            messages=chat_messages,
            persona_name=persona_name,
            persona_id=persona_id,
            error_key=error_key
        )
        analyses.append(analysis)
        
        # 문서에 is_check 표시
        doc.reference.update({'is_check': True})
    
    # 분석 결과 출력
    print_analysis_summary(analyses)
    
    # 결과 저장
    if analyses:
        summary_path, detailed_path = save_analysis_results(analyses)
        print(f"\n✅ 총 {len(unchecked_reports)}개의 오류 보고서 분석 완료")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='채팅 오류 분석 도구')
    parser.add_argument('--recheck', action='store_true', help='이미 체크된 문서도 다시 분석')
    args = parser.parse_args()
    
    analyze_chat_errors(recheck=args.recheck)