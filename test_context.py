#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""대화 맥락 유지 테스트"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from scripts.test_framework import ChatTestFramework
import asyncio
import json

async def test_context_maintenance():
    """소고기 예시처럼 맥락 유지 테스트"""
    framework = ChatTestFramework()
    
    # 테스트용 페르소나 로드
    persona = await framework.load_persona("하연")
    
    test_cases = [
        {
            "scenario": "음식 대화 맥락",
            "messages": [
                ("나 소고기 먹었어, 너는?", None),
                ("응 맛있었어", "맛있겠다"),  # AI가 소고기 언급해야 함
                ("너는 뭐 먹었어?", None),  # 사용자가 AI에게 물어봄
            ]
        },
        {
            "scenario": "위치 대화 맥락",
            "messages": [
                ("나 지금 카페에 있어", None),
                ("커피 마시고 있어", None),
                ("너는 어디야?", None),  # AI가 자신의 위치 답해야 함
            ]
        },
        {
            "scenario": "활동 대화 맥락", 
            "messages": [
                ("나 게임하고 있었어", None),
                ("롤 했어", None),
                ("재밌었어?", None),  # AI가 게임 맥락 이어가야 함
            ]
        }
    ]
    
    print("\n" + "="*70)
    print("🧪 대화 맥락 유지 테스트")
    print("="*70)
    
    for test in test_cases:
        print(f"\n📝 시나리오: {test['scenario']}")
        print("-" * 50)
        
        conversation_history = []
        context_maintained = True
        
        for i, (user_msg, expected_context) in enumerate(test['messages'], 1):
            print(f"\n[Turn {i}]")
            print(f"User: {user_msg}")
            
            # AI 응답 생성
            response = await framework.generate_response(
                persona, 
                user_msg,
                conversation_history
            )
            
            print(f"AI: {response}")
            
            # 대화 히스토리 업데이트
            conversation_history.append({"role": "user", "content": user_msg})
            conversation_history.append({"role": "assistant", "content": response})
            
            # 맥락 유지 체크
            if expected_context:
                if expected_context.lower() not in response.lower():
                    print(f"⚠️ 맥락 누락: '{expected_context}'를 언급하지 않음")
                    context_maintained = False
            
            # 반복 질문 체크
            if i == 3:  # 마지막 턴
                # 이미 답한 내용 다시 묻는지 체크
                problematic_patterns = [
                    "뭐 먹었",  # 소고기 시나리오
                    "어디 있",  # 위치 시나리오
                    "뭐 했", "무슨 게임"  # 게임 시나리오
                ]
                
                for pattern in problematic_patterns:
                    if pattern in response:
                        print(f"❌ 반복 질문 발견: '{pattern}'")
                        context_maintained = False
                        break
        
        if context_maintained:
            print("\n✅ 맥락 유지 성공!")
        else:
            print("\n❌ 맥락 유지 실패")
    
    print("\n" + "="*70)
    print("테스트 완료!")
    print("="*70)

if __name__ == "__main__":
    asyncio.run(test_context_maintenance())