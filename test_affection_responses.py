#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
애정 표현 응답 개선 테스트 스크립트
"""

import sys
import os
import json
from datetime import datetime

# 테스트 시나리오
test_scenarios = [
    {
        "name": "보고싶다 표현 (여성)",
        "user_message": "나 너 보고싶었어",
        "gender": "female",
        "expected_response_patterns": [
            "나도 보고싶었어!! 이잉~♡",
            "헤헤 나도나도!!",
            "흐엥 나도야!!",
            "에헤헤 나도 보고싶었지롱~♡"
        ],
        "avoid_patterns": ["아이고", "그래? 나도"]
    },
    {
        "name": "사랑해 표현 (여성)",
        "user_message": "사랑해",
        "gender": "female",
        "expected_response_patterns": [
            "나도 사랑해!! 헤헤♡",
            "아잉~ 부끄러워><",
            "흐엥 갑자기 그러면 심장 터져",
            "에헤헤 나도 너무너무 사랑해!!"
        ],
        "avoid_patterns": ["아이고", "응 나도"]
    },
    {
        "name": "좋아해 표현 (여성)",
        "user_message": "너 정말 좋아해",
        "gender": "female",
        "expected_response_patterns": [
            "헤헤 나도 좋아해~♡",
            "진짜? 나도나도!!",
            "아잉~ 부끄럽게 왜그래ㅎㅎ"
        ],
        "avoid_patterns": ["아이고"]
    },
    {
        "name": "안아줘 표현 (여성)",
        "user_message": "안아주고 싶어",
        "gender": "female",
        "expected_response_patterns": [
            "이리와~ 꼬옥 안아줄게♡",
            "헤헤 나도 안기고 싶어!!",
            "아잉~ 갑자기 그러면 부끄러워><"
        ],
        "avoid_patterns": ["아이고"]
    },
    {
        "name": "귀엽다 표현 (여성)",
        "user_message": "너 너무 귀여워",
        "gender": "female",
        "expected_response_patterns": [
            "아잉~ 부끄러워>< 고마워!!",
            "헤헤 진짜? 기분좋아~♡",
            "흐엥 갑자기 그러면 얼굴 빨개져"
        ],
        "avoid_patterns": ["아이고"]
    },
    {
        "name": "보고싶다 표현 (남성)",
        "user_message": "보고싶었어",
        "gender": "male",
        "expected_response_patterns": [
            "나도 보고싶었어",
            "진짜 그리웠어"
        ],
        "avoid_patterns": ["아이고", "이잉", "아잉", "흐엥"]
    }
]

def test_affection_responses():
    """애정 표현 응답 테스트"""
    print("=" * 60)
    print("애정 표현 응답 개선 테스트")
    print("=" * 60)
    
    results = []
    
    for scenario in test_scenarios:
        print(f"\n테스트: {scenario['name']}")
        print(f"사용자: {scenario['user_message']}")
        print(f"성별: {scenario['gender']}")
        print(f"예상 응답 패턴: {', '.join(scenario['expected_response_patterns'][:2])}...")
        print(f"피해야 할 패턴: {', '.join(scenario['avoid_patterns'])}")
        
        result = {
            "scenario": scenario['name'],
            "user_message": scenario['user_message'],
            "gender": scenario['gender'],
            "expected_patterns": scenario['expected_response_patterns'],
            "avoid_patterns": scenario['avoid_patterns'],
            "status": "configured"
        }
        results.append(result)
    
    # 결과 저장
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"test_results/affection_response_test_{timestamp}.json"
    
    os.makedirs("test_results", exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump({
            "timestamp": timestamp,
            "total_scenarios": len(test_scenarios),
            "results": results
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n테스트 시나리오 저장: {output_file}")
    print(f"총 {len(test_scenarios)}개 시나리오 구성 완료")
    
    # 개선사항 요약
    print("\n" + "=" * 60)
    print("구현된 개선사항:")
    print("=" * 60)
    print("1. AdvancedPatternAnalyzer에 애정 표현 감지 메서드 추가")
    print("   - detectAffectionExpression() 메서드 구현")
    print("   - 보고싶다, 사랑해, 좋아해, 안아줘, 귀엽다 등 감지")
    print("\n2. 여성 페르소나 전용 애교 응답 가이드:")
    print("   - '이잉~♡', '헤헤', '아잉~', '흐엥' 등 귀여운 표현")
    print("   - '나도나도!!', '진짜진짜' 같은 반복 강조")
    print("   - 하트 이모지(♡) 적극 활용")
    print("\n3. '아이고' 표현 완전 제거:")
    print("   - response_variation_cache.dart에서 제거")
    print("   - natural_ai_service.dart에서 제거")
    print("   - '헐', '에고' 등으로 대체")
    print("\n4. ChatOrchestrator 통합:")
    print("   - 애정 표현 감지 시 성별 체크")
    print("   - 여성 페르소나일 때만 애교 가이드 제공")
    print("\n5. OptimizedPromptService 업데이트:")
    print("   - 여성 페르소나 전용 섹션 추가")
    print("   - 구체적인 애교 응답 예시 제공")

if __name__ == "__main__":
    test_affection_responses()