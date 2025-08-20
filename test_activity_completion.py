#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
활동 완료 맥락 감지 테스트 스크립트
"""

import sys
import os
import json
from datetime import datetime

# 테스트 시나리오
test_scenarios = [
    {
        "name": "퇴근 완료",
        "user_message": "아 퇴근했다...",
        "expected_not_to_ask": ["그동안 뭐 했어?", "뭐 하고 있었어?"],
        "expected_response_type": "empathy_and_rest"
    },
    {
        "name": "학교 끝",
        "user_message": "학교 끝났어",
        "expected_not_to_ask": ["뭐 했어?", "그동안 뭐 했어?"],
        "expected_response_type": "acknowledge_effort"
    },
    {
        "name": "야자 완료",
        "user_message": "야자 끝나고 왔어",
        "expected_not_to_ask": ["그동안 뭐 했어?", "뭐 하고 있었어?"],
        "expected_response_type": "study_empathy"
    },
    {
        "name": "면접 완료",
        "user_message": "면접 봤어",
        "expected_not_to_ask": ["뭐 했어?", "그동안 뭐 했어?"],
        "expected_response_type": "interview_result_curiosity"
    },
    {
        "name": "인강 완료",
        "user_message": "인강 다 들었어",
        "expected_not_to_ask": ["그동안 뭐 했어?", "뭐 하고 있었어?"],
        "expected_response_type": "learning_curiosity"
    },
    {
        "name": "운동 완료",
        "user_message": "운동하고 왔어",
        "expected_not_to_ask": ["그동안 뭐 했어?", "뭐 했어?"],
        "expected_response_type": "exercise_acknowledgment"
    },
    {
        "name": "스터디 완료",
        "user_message": "스터디 끝났어",
        "expected_not_to_ask": ["뭐 했어?", "그동안 뭐 했어?"],
        "expected_response_type": "study_acknowledgment"
    },
    {
        "name": "교육 완료",
        "user_message": "교육 받고 왔어",
        "expected_not_to_ask": ["그동안 뭐 했어?", "뭐 하고 있었어?"],
        "expected_response_type": "education_curiosity"
    }
]

def test_activity_completion():
    """활동 완료 맥락 처리 테스트"""
    print("=" * 60)
    print("활동 완료 맥락 처리 테스트")
    print("=" * 60)
    
    results = []
    
    for scenario in test_scenarios:
        print(f"\n테스트: {scenario['name']}")
        print(f"사용자: {scenario['user_message']}")
        print(f"금지된 질문: {', '.join(scenario['expected_not_to_ask'])}")
        print(f"예상 응답 타입: {scenario['expected_response_type']}")
        
        # 실제로는 여기서 ChatOrchestrator를 호출하여 테스트하지만
        # 이 스크립트는 테스트 시나리오 검증용
        result = {
            "scenario": scenario['name'],
            "user_message": scenario['user_message'],
            "inappropriate_questions": scenario['expected_not_to_ask'],
            "expected_type": scenario['expected_response_type'],
            "status": "configured"  # 실제 테스트 시 "passed" 또는 "failed"로 업데이트
        }
        results.append(result)
    
    # 결과 저장
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"test_results/activity_completion_test_{timestamp}.json"
    
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
    print("1. AdvancedPatternAnalyzer에 활동 완료 감지 메서드 추가")
    print("2. ChatOrchestrator에 활동 완료 힌트 통합")
    print("3. OptimizedPromptService에 활동 완료 가이드라인 추가")
    print("4. 다양한 활동 타입 지원:")
    print("   - 업무 (퇴근, 회사, 야근)")
    print("   - 교육 (학교, 야자, 학원, 과외)")
    print("   - 온라인 학습 (인강, 온라인 강의)")
    print("   - 비즈니스 (면접, 발표, 프레젠테이션)")
    print("   - 건강 (운동, 병원)")
    print("   - 여가 (영화, 쇼핑, 놀이)")
    print("   - 창작 (그림, 음악, 글쓰기)")
    print("\n5. 부적절한 질문 방지:")
    print("   - '그동안 뭐 했어?' (이미 활동을 말했는데)")
    print("   - '뭐 하고 있었어?' (완료된 활동인데 현재형)")
    print("   - '지금까지 뭐 했어?' (구체적 활동 언급했는데)")

if __name__ == "__main__":
    test_activity_completion()