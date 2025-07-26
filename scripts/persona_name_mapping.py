#!/usr/bin/env python3
"""
Persona name mapping - Korean to English
"""

# 한글 이름을 영문으로 매핑
PERSONA_NAME_MAPPING = {
    "상훈": "sanghoon",
    "Dr. 박지은": "dr-park-jieun",
    "수진": "sujin",
    "예림": "yerim",
    "예슬": "yeseul",
    "윤미": "yoonmi",
    "정훈": "jeonghoon",
    "지우": "jiwoo",
    "채연": "chaeyeon",
    "하연": "hayeon",
    "혜진": "hyejin"
}

def get_english_name(korean_name: str) -> str:
    """
    한글 이름을 영문으로 변환
    매핑에 없으면 원본 이름 반환
    """
    return PERSONA_NAME_MAPPING.get(korean_name, korean_name)

def get_korean_name(english_name: str) -> str:
    """
    영문 이름을 한글로 변환
    역매핑 생성
    """
    reverse_mapping = {v: k for k, v in PERSONA_NAME_MAPPING.items()}
    return reverse_mapping.get(english_name, english_name)