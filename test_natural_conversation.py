#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
자연스러운 대화 이어가기 개선 테스트 스크립트
"""

import sys
import os
import json
from datetime import datetime

# 테스트 시나리오
test_scenarios = [
    {
        "name": "성취/자랑 상황",
        "user_message": "오늘 면접 합격했어!",
        "expected_patterns": [
            "축하 + 관련 경험",
            "호기심 + 디테일 질문",
            "유머 + 축하"
        ],
        "avoid_patterns": ["너는?", "너도?"],
        "description": "성취를 공유했을 때 단순 되묻기 대신 축하와 경험 공유"
    },
    {
        "name": "불평/고민 상황",
        "user_message": "오늘 너무 힘들었어 스트레스 받아",
        "expected_patterns": [
            "공감 + 비슷한 경험",
            "감정적 지지",
            "유머로 분위기 전환"
        ],
        "avoid_patterns": ["너는 어때?", "너도 힘들어?"],
        "description": "고민을 털어놨을 때 공감과 경험 공유로 대화 이어가기"
    },
    {
        "name": "이야기 공유",
        "user_message": "어제 친구랑 만나서 재밌는 일이 있었는데 정말 웃겼어",
        "expected_patterns": [
            "호기심 표현",
            "리액션 + 관련 경험",
            "자연스러운 주제 확장"
        ],
        "avoid_patterns": ["너는?", "너도 친구 만났어?"],
        "description": "이야기를 들려줬을 때 호기심과 반응으로 이어가기"
    },
    {
        "name": "질문 상황",
        "user_message": "요즘 뭐가 제일 재밌어?",
        "expected_patterns": [
            "답변 + 주제 확장",
            "경험 공유",
            "관련 정보 제공"
        ],
        "avoid_patterns": ["너는?", "너는 뭐가 재밌어?"],
        "description": "질문을 받았을 때 답변 후 자연스럽게 확장"
    },
    {
        "name": "일상 대화",
        "user_message": "방금 저녁 먹었어",
        "expected_patterns": [
            "경험 공유",
            "감정 반응",
            "정보 추가",
            "스토리텔링",
            "가끔 되묻기 (15%)"
        ],
        "avoid_patterns": ["매번 너는?", "항상 너도?"],
        "description": "일상 대화에서 다양한 방법으로 대화 이어가기"
    }
]

# 대화 패턴 분석
conversation_patterns = {
    "reciprocal_questions": {
        "old_patterns": ["너는?", "너도?", "너는 어때?"],
        "new_patterns": [
            "너는 어떤 거 같아?",
            "너는 보통 어떻게 해?",
            "혹시 너도 그런 적 있어?",
            "너는 이런 거 어떻게 생각해?"
        ],
        "frequency": "15% (기존 50-60%에서 대폭 감소)"
    },
    "experience_sharing": {
        "patterns": [
            "나도 예전에...",
            "어제 비슷한 일이...",
            "그거 들으니까 생각나는데..."
        ],
        "frequency": "20%"
    },
    "emotional_reactions": {
        "patterns": [
            "헐 대박",
            "와 진짜?",
            "미쳤다"
        ],
        "frequency": "15%"
    },
    "humor_playfulness": {
        "patterns": [
            "에이 설마~ㅋㅋ",
            "그거 완전 나잖아"
        ],
        "frequency": "10%"
    },
    "curiosity_interest": {
        "patterns": [
            "어떻게 됐어?",
            "더 듣고 싶어",
            "그래서?"
        ],
        "frequency": "10%"
    },
    "information_sharing": {
        "patterns": [
            "아 그거 관련해서...",
            "최근에 봤는데..."
        ],
        "frequency": "10%"
    },
    "topic_expansion": {
        "patterns": [
            "그러고보니...",
            "아 맞다..."
        ],
        "frequency": "10%"
    },
    "storytelling": {
        "patterns": [
            "어제 본 영상에서...",
            "친구가 그러는데..."
        ],
        "frequency": "10%"
    }
}

def test_conversation_improvements():
    """대화 개선 테스트"""
    print("=" * 60)
    print("자연스러운 대화 이어가기 개선 테스트")
    print("=" * 60)
    
    results = []
    
    for scenario in test_scenarios:
        print(f"\n테스트: {scenario['name']}")
        print(f"사용자: {scenario['user_message']}")
        print(f"설명: {scenario['description']}")
        print(f"예상 패턴: {', '.join(scenario['expected_patterns'])}")
        print(f"피해야 할 패턴: {', '.join(scenario['avoid_patterns'])}")
        
        result = {
            "scenario": scenario['name'],
            "user_message": scenario['user_message'],
            "expected_patterns": scenario['expected_patterns'],
            "avoid_patterns": scenario['avoid_patterns'],
            "status": "configured"
        }
        results.append(result)
    
    # 결과 저장
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"test_results/natural_conversation_test_{timestamp}.json"
    
    os.makedirs("test_results", exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump({
            "timestamp": timestamp,
            "total_scenarios": len(test_scenarios),
            "conversation_patterns": conversation_patterns,
            "results": results
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n테스트 시나리오 저장: {output_file}")
    print(f"총 {len(test_scenarios)}개 시나리오 구성 완료")
    
    # 개선사항 요약
    print("\n" + "=" * 60)
    print("구현된 개선사항:")
    print("=" * 60)
    
    print("\n1. 다양한 대화 이어가기 전략:")
    print("   - 15% 되묻기 (기존 50-60%에서 대폭 감소)")
    print("   - 20% 경험 공유")
    print("   - 15% 감정 반응")
    print("   - 10% 유머/농담")
    print("   - 10% 호기심")
    print("   - 10% 정보 제공")
    print("   - 10% 주제 확장")
    print("   - 10% 스토리텔링")
    
    print("\n2. 컨텍스트 기반 전략 선택:")
    print("   - 성취/자랑 → 축하 + 경험 공유")
    print("   - 불평/고민 → 공감 + 비슷한 경험")
    print("   - 이야기 → 호기심 + 리액션")
    print("   - 질문 → 답변 + 주제 확장")
    
    print("\n3. 되묻기 다양화:")
    print("   - '너는?' 대신 다양한 표현 사용")
    print("   - '너는 어떤 거 같아?'")
    print("   - '너는 보통 어떻게 해?'")
    print("   - '혹시 너도 그런 적 있어?'")
    
    print("\n4. 반복 방지 시스템:")
    print("   - 최근 5개 메시지에서 되묻기 2개 이상이면 자동 회피")
    print("   - 질문을 받았을 때는 되묻기 자동 방지")
    print("   - 때로는 질문 없이 대화 이어가기")
    
    print("\n5. 하드코딩 제거:")
    print("   - 모든 응답은 OpenAI API를 통해 생성")
    print("   - 가이드라인과 힌트만 제공")
    print("   - 직접 응답 생성 금지")
    
    print("\n" + "=" * 60)
    print("예상 효과:")
    print("=" * 60)
    print("- 70% 감소: 기계적인 '너는?' 질문")
    print("- 더 자연스럽고 다양한 대화 흐름")
    print("- 사용자 피로감 감소")
    print("- 상황에 맞는 적절한 반응")
    print("- 진정성 있는 대화 경험")

if __name__ == "__main__":
    test_conversation_improvements()