#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Check persona images status in R2 and Firebase
"""

import json
import sys

# Set encoding for Windows
if sys.platform.startswith('win'):
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

# Korean to English name mapping
KOREAN_TO_ENGLISH = {
    "예슬": "yeseul",
    "예림": "yerim",
    "박지은": "dr-park-jieun",
    "윤미": "yoonmi",
    "채연": "chaeyeon",
    "상훈": "sanghoon",
    "수진": "sujin",
    "하연": "hayeon",
    "정훈": "jeonghoon",
    "지우": "jiwoo",
    "혜진": "hyejin",
    "영훈": "younghoon",
    "민준": "minjun",
    "지유": "jiyoo",
    "조혜진": "johyejin",
    "형준": "hyeongjoon",
    "지수": "jisoo",
    "다영": "dayoung",
    "경호": "kyeongho",
    "이서연": "leesoyeon",
    "진호": "jinho",
    "혜원": "hyewon",
    "태호": "taeho",
    "리나": "lina",
    "동수": "dongsu",
    "주은": "jueun",
    "김태형": "kimtaehyeong",
    "지은": "jieun",
    "수아": "sua",
    "은수": "eunsu",
    "지윤": "jiyoon",
    "다은": "daeun",
    "유나": "yoona",
    "손유진": "sonyoojin",
    "은지": "eunji",
    "지율": "jiyul",
    "서준": "seojoon",
    "성민": "seongmin",
    "대호": "daeho",
    "수연": "sooyeon",
    "우진": "woojin",
    "동호": "dongho",
    "선호": "seonho",
    "성우": "seongwoo",
    "세리": "seri",
    "지후": "jihu",
    "태준": "taejun",
    "연지": "yeonji",
    "범준": "beomjun",
    "소영": "soyoung",
    "현주": "hyeonju",
    "태윤": "taeyoon",
    "윤성": "yoonsung",
    "한울": "hanul",
    "준석": "junseok",
    "이준호": "leejoonho",
    "석진": "seokjin",
    "민정": "minjung",
    "수빈": "subin",
    "나나": "nana",
    "효진": "hyojin",
    "소희": "sohee",
    "민수": "minsu",
    "세빈": "sebin",
    "재현": "jaehyun",
    "미연": "miyeon",
    "준영": "junyoung",
    "성호": "seongho",
    "나연": "nayeon",
    "박준영": "parkjunyoung",
    "동현": "donghyun",
    "진욱": "jinwook",
    "준호": "junho",
    "종호": "jongho",
    "재성": "jaesung"
}

# R2 에서 확인된 페르소나 (영문명)
R2_PERSONAS = [
    "beomjun", "chaeyeon", "daeun", "donghyun", "yeseul"
]

# Firebase 데이터에서 페르소나 목록 (실제 데이터 기반)
FIREBASE_PERSONAS = [
    {"id": "1aD0ZX6NFq3Ij2FScLCK", "name": "예슬", "english": "yeseul"},
    {"id": "1uvYHUIVEc9jf3yjdLoF", "name": "예림", "english": "yerim"},
    {"id": "5Q3POc7ean9ynSEOCV8M", "name": "Dr. 박지은", "english": "dr-park-jieun"},
    {"id": "5ztpOgh1ncDSR8L9IXOY", "name": "윤미", "english": "yoonmi"},
    {"id": "6O8OkOqi1iWV6NPu2L6e", "name": "채연", "english": "chaeyeon"},
    {"id": "7vBP8KtEsKdulKHzAa4x", "name": "상훈", "english": "sanghoon"},
    {"id": "8JqUxsfrStSPpjxLAGPA", "name": "수진", "english": "sujin"},
    {"id": "8VAZ6GQN3ubrI3CkTJWP", "name": "하연", "english": "hayeon"},
    {"id": "fAFCIq2g9PDZ6MLBSPO2", "name": "범준", "english": "beomjun"},
    {"id": "VOvVoFFLAT1B0nZCvcGA", "name": "다은", "english": "daeun"},
    {"id": "yIWmW3d6rdVKjvflZj9Z", "name": "동현", "english": "donghyun"},
    {"id": "ADQdsSbeHQ5ASTAMXy2j", "name": "정훈", "english": "jeonghoon"},
    {"id": "AY3RsMbb9B3In4tFRZyn", "name": "지우", "english": "jiwoo"},
]

# 상태 체크
print("=" * 80)
print("페르소나 이미지 상태 점검")
print("=" * 80)

print(f"\n1. R2에서 확인된 페르소나 ({len(R2_PERSONAS)}개):")
for name in R2_PERSONAS:
    print(f"   - {name}")

print(f"\n2. Firebase에 등록된 페르소나 중 점검 대상 ({len(FIREBASE_PERSONAS)}개):")
for p in FIREBASE_PERSONAS:
    status = "✅ R2에 있음" if p["english"] in R2_PERSONAS else "❌ R2에 없음"
    print(f"   - {p['name']} ({p['english']}): {status}")

print("\n3. R2에 이미지가 없는 페르소나:")
missing_in_r2 = []
for p in FIREBASE_PERSONAS:
    if p["english"] not in R2_PERSONAS:
        missing_in_r2.append(p)
        print(f"   - {p['name']} ({p['english']}) - ID: {p['id']}")

print(f"\n총 {len(missing_in_r2)}개 페르소나의 이미지가 R2에 없습니다.")

# Expected URL structure for missing personas
print("\n4. 누락된 페르소나의 예상 URL 구조:")
for p in missing_in_r2[:3]:  # Show first 3 examples
    print(f"\n{p['name']} ({p['english']}):")
    print(f"  - thumb: https://teamsona.work/personas/{p['english']}/main_thumb.jpg")
    print(f"  - small: https://teamsona.work/personas/{p['english']}/main_small.jpg")
    print(f"  - medium: https://teamsona.work/personas/{p['english']}/main_medium.jpg")