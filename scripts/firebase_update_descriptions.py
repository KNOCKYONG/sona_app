#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Firebase 페르소나 description 업데이트 스크립트
"""

import json
import time

# 페르소나 이름과 ID 매핑 (Firebase에서 가져온 데이터)
PERSONA_ID_MAP = {
    "예슬": "1aD0ZX6NFq3Ij2FScLCK",
    "예림": "1uvYHUIVEc9jf3yjdLoF",
    "Dr. 박지은": "5Q3POc7ean9ynSEOCV8M",
    "윤미": "5ztpOgh1ncDSR8L9IXOY",
    "채연": "6O8OkOqi1iWV6NPu2L6e",
    "상훈": "7vBP8KtEsKdulKHzAa4x",
    "수진": "8JqUxsfrStSPpjxLAGPA",
    "하연": "8VAZ6GQN3ubrI3CkTJWP",
    "정훈": "ADQdsSbeHQ5ASTAMXy2j",
    "지우": "AY3RsMbb9B3In4tFRZyn",
    "혜진": "Di1rns1v30eYwMRSn4v3",
    "지수": "JEihxQ8m38TKVgGwF2cm",
    "은지": "WAMyc4EL0fgvB8L8CT5c",
    "석진": "l7XWWwDhqNWKP1ATY1w6",
    "동현": "yIWmW3d6rdVKjvflZj9Z",
    "나연": "uZxyTKOBuDM0NHQ15jHW",
    "민준": "GqDNfytwDZCLVFaPczt4",
    "영훈": "GYWpfNnGK0d2rOmZu37j",
    "민수": "mHPXbVvpm3qsoibstfmX",
    "미연": "nFEbQaFlh8W98gix7Wsp",
    "박준영": "xm1nnEvCzxbyr95xFjVX",
    "동호": "ZzTItnobaerduKNaLwXh",
    "성호": "s5mb7z4HRU58FOsZCtUx",
    "세빈": "n2OeC5bVKZf0vZAdLtur",
    "소희": "m75bPHXaTys3htRJomws",
    "효진": "m0OjpI1G2QUyWsCbfBar",
    "재현": "n9heEw7UdkprdSaJo46S",
    "재성": "zrhAI4LNdCRd9qWyBhTM",
    "진욱": "yOlN3CvHeec8699B9Xxh",
    "종호": "zpOJLXVqfRWIoxkHxEQi",
    "준호": "yzQ6zn6egYJfBXf4exYk",
    "준영": "ooaB6VajCv6nFO2YL2rM",
    "주은": "OmpQ91evcAxDnJTgNPAR",
    "은수": "Reuj9HLk5E8PQ66FJxJ3",
    "지윤": "VJdrEsBk2aLmSPhVXe1p",
    "서준": "WXHfoFNQaPQl84e8rHmT",
    "윤성": "i73Xr9knkmkWO2P0GkC6",
    "태윤": "i2pkSXV9AjT4t6P4H7Zn",
    "준석": "jH7p24z8PMer56NFFLsZ",
    "범준": "fAFCIq2g9PDZ6MLBSPO2",
    "수빈": "lAw4LoIE6StxojBv7nHv",
    "혜원": "MVWyUpcOsG058yxXqdjP",
    "태준": "dXBlte1vcAyXGKIwNIgk",
    "유나": "VPFNA8SKaR0QrEIDlwKR",
    "수연": "YAnViyqBUEqVOH7O40L3",
    "현주": "gjNWbPRb9QHxxJMsNeJH",
    "민정": "lASQiz4d9la0HVctfIhp",
    "소영": "ff0gDvhcdm8yMzwBOELD",
    "Dr. 김민서": "FlkZESLYuuUOMrgL40j3",
    "Dr. 이서연": "JyBsnD6fi9g2uu3E1MTt",
    "이준호": "javSezhi97ycKssGF5PE",
    "손유진": "VaeHPoyOH44Ry2poApG4",
    "변호사 김태형": "PUmWIyxv9HrK3H8wEQlR",
    "Dr. 조혜진": "HouahN4jLcy3bkBCnNUX"
}

# 추가로 발견된 페르소나들
ADDITIONAL_PERSONAS = {
    "태호": "MbYfxxIOOH47PqpmXk3v",
    "수아": "RaXtRq57hhyJ8dd0Pe6M",
    "우진": "ZRjSoKKQ76T9yA0HyheR",
    "경호": "JodykCBnc17YY8YKQ4SF",
    "다영": "JnsM74qE44EJSAuE3WMV",
    "성민": "X5mFQ7rccLNNzLhOLCt7",
    "다은": "VOvVoFFLAT1B0nZCvcGA"
}

# 전체 페르소나 맵 병합
PERSONA_ID_MAP.update(ADDITIONAL_PERSONAS)

def load_updates():
    """업데이트 정보 로드"""
    with open('persona_updates.json', 'r', encoding='utf-8') as f:
        return json.load(f)

def print_update_plan():
    """업데이트 계획 출력"""
    updates = load_updates()
    print(f"총 {len(updates)}개 페르소나 업데이트 예정:")
    print("=" * 50)
    
    for i, update in enumerate(updates[:5]):  # 처음 5개만 샘플로 보여줌
        name = update['name']
        persona_id = PERSONA_ID_MAP.get(name, 'ID 없음')
        print(f"{i+1}. {name} ({persona_id})")
        print(f"   새로운 설명: {update['description'][:50]}...")
    
    print("\n... 그 외 나머지 페르소나들")
    print("=" * 50)
    
    # ID가 없는 페르소나 확인
    missing_ids = []
    for update in updates:
        if update['name'] not in PERSONA_ID_MAP:
            missing_ids.append(update['name'])
    
    if missing_ids:
        print(f"\n⚠️  Firebase ID를 찾을 수 없는 페르소나: {', '.join(missing_ids)}")
    
    return updates

def generate_firebase_commands():
    """Firebase MCP 명령어 생성"""
    updates = load_updates()
    commands = []
    
    for update in updates:
        name = update['name']
        if name in PERSONA_ID_MAP:
            persona_id = PERSONA_ID_MAP[name]
            command = {
                'id': persona_id,
                'name': name,
                'description': update['description'],
                'updatedAt': update['updatedAt']
            }
            commands.append(command)
    
    # 업데이트 명령어를 JSON 파일로 저장
    with open('firebase_update_commands.json', 'w', encoding='utf-8') as f:
        json.dump(commands, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ {len(commands)}개의 Firebase 업데이트 명령이 생성되었습니다.")
    print("firebase_update_commands.json 파일을 확인하세요.")
    
    return commands

if __name__ == '__main__':
    print("Firebase 페르소나 Description 업데이트")
    print("=" * 50)
    
    # 업데이트 계획 표시
    updates = print_update_plan()
    
    # Firebase 명령어 생성
    commands = generate_firebase_commands()
    
    print("\n이제 Firebase MCP를 사용하여 업데이트를 진행하세요.")