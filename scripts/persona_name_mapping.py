#!/usr/bin/env python3
"""
Persona name mapping - Korean to English
"""

# 한글 이름을 영문으로 매핑
PERSONA_NAME_MAPPING = {
    "상훈": "sanghoon",
    "Dr. 박지은": "dr-park-jieun",
    "Dr. 김민서": "dr-kim-minseo",
    "수진": "sujin",
    "예림": "yerim",
    "예슬": "yeseul",
    "윤미": "yoonmi",
    "정훈": "jeonghoon",
    "지우": "jiwoo",
    "채연": "chaeyeon",
    "하연": "hayeon",
    "혜진": "hyejin",
    "나연": "nayeon",
    "동현": "donghyun",
    "미연": "miyeon",
    "민수": "minsu",
    "민준": "minjun",
    "박준영": "park-junyoung",
    "성호": "seongho",
    "세빈": "sebin",
    "소희": "sohee",
    "영훈": "younghoon",
    "재성": "jaesung",
    "재현": "jaehyun",
    "종호": "jongho",
    "준영": "junyoung",
    "준호": "junho",
    "진욱": "jinwook",
    "효진": "hyojin",
    "나나": "nana",
    "다은": "daeun",
    "동수": "dongsu",
    "리나": "rina",
    "민정": "minjung",
    "범준": "beomjun",
    "석진": "seokjin",
    "소영": "soyoung",
    "수빈": "subin",
    "수아": "sua",
    "연지": "yeonji",
    "윤성": "yoonsung",
    "은수": "eunsu",
    "주은": "jueun",
    "준석": "junseok",
    "지윤": "jiyoon",
    "지은": "jieun",
    "진호": "jinho",
    "태윤": "taeyoon",
    "태준": "taejun",
    "태호": "taeho",
    "현주": "hyeonju",
    "혜원": "hyewon"
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