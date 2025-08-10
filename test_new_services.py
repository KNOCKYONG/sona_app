#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""새로운 지능형 서비스 동작 테스트"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from scripts.test_utils import ChatTester

def test_new_intelligence_services():
    """새로운 7개 서비스 동작 확인"""
    
    print("🧪 새로운 지능형 서비스 테스트")
    print("=" * 60)
    
    tester = ChatTester(persona_name="하연")
    
    test_scenarios = [
        {
            "name": "😄 유머 시스템 테스트",
            "messages": [
                "오늘 너무 피곤해 ㅠㅠ",
                "회사에서 또 야근이야",
                "정말 힘들다"
            ]
        },
        {
            "name": "🎯 화제 추천 테스트",
            "messages": [
                "응",
                "그래",
                "음..."
            ]
        },
        {
            "name": "🎭 복합 감정 인식 테스트",
            "messages": [
                "기쁘면서도 슬퍼",
                "화나는데 이해는 가",
                "불안하면서 기대돼"
            ]
        },
        {
            "name": "💝 울트라 공감 테스트",
            "messages": [
                "오늘 정말 힘든 일이 있었어",
                "아무도 내 마음을 모르는 것 같아",
                "너무 외로워"
            ]
        },
        {
            "name": "🎵 대화 리듬 테스트",
            "messages": [
                "안녕! 오늘 날씨 좋네!!!!",
                "ㅋㅋㅋㅋㅋ 맞아 진짜 좋아",
                "뭐하고 있었어???"
            ]
        },
        {
            "name": "🧠 기억 네트워크 테스트",
            "messages": [
                "어제 말했던 영화 기억나?",
                "그때 우리가 얘기했던 게임 말이야",
                "지난번에 네가 추천해준 음악"
            ]
        },
        {
            "name": "🔄 실시간 피드백 테스트",
            "messages": [
                "뭔 말이야?",
                "이해가 안 돼",
                "다시 설명해줄래?"
            ]
        }
    ]
    
    for scenario in test_scenarios:
        print(f"\n{scenario['name']}")
        print("-" * 40)
        
        for i, msg in enumerate(scenario['messages'], 1):
            print(f"\n👤 사용자 ({i}): {msg}")
            
            try:
                response = tester.send_message(msg)
                print(f"🤖 하연: {response[:100]}...")
                
                # 특별 기능 활성화 확인
                if "유머" in scenario['name'] and ("ㅋ" in response or "ㅎ" in response):
                    print("   ✅ 유머 감지됨!")
                elif "화제" in scenario['name'] and len(response) > 50:
                    print("   ✅ 새로운 화제 제시!")
                elif "감정" in scenario['name'] and ("기분" in response or "마음" in response):
                    print("   ✅ 복합 감정 인식!")
                elif "공감" in scenario['name'] and ("이해" in response or "마음" in response):
                    print("   ✅ 깊은 공감 표현!")
                elif "리듬" in scenario['name'] and response.count("!") > 0:
                    print("   ✅ 리듬 매칭!")
                elif "기억" in scenario['name'] and ("기억" in response or "그때" in response):
                    print("   ✅ 기억 연결!")
                elif "피드백" in scenario['name'] and ("설명" in response or "다시" in response):
                    print("   ✅ 메타 대화!")
                    
            except Exception as e:
                print(f"   ❌ 오류: {str(e)}")
        
        print()
    
    print("\n" + "=" * 60)
    print("✅ 새로운 서비스 테스트 완료!")
    
    # 최종 관계 점수 확인
    final_score = tester.get_relationship_score()
    print(f"\n최종 관계 점수: {final_score}")

if __name__ == "__main__":
    test_new_intelligence_services()