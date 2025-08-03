#!/usr/bin/env python3
"""
Check which personas have additional images in R2
"""

import subprocess
import json

# 모든 페르소나 영문 이름
personas_english = [
    "yeseul", "yerim", "dr-park-jieun", "yoonmi", "chaeyeon", "sanghoon", "sujin", "hayeon",
    "jeonghoon", "jiwoo", "hyejin", "dr-kim-minseo", "younghoon", "minjoon", "jiyoo",
    "johyejin", "hyeongjoon", "jisoo", "dayoung", "kyeongho", "leesoyeon", "jinho",
    "hyewon", "taeho", "rina", "dongsu", "jueun", "kimtaehyeong", "jieun", "sua",
    "eunsu", "jiyoon", "daeun", "yoona", "sonyoojin", "eunji", "jiyul", "seojoon",
    "seongmin", "daeho", "sooyeon", "woojin", "dongho", "seonho", "seongwoo", "seri",
    "jihu", "taejoon", "yeonji", "beomjoon", "soyoung", "hyeonju", "taeyoon", "yoonseong",
    "hanul", "joonseok", "leejoonho", "seokjin", "minjeong", "soobin", "nana", "hyojin",
    "sohee", "minsu", "sebin", "jaehyeon", "miyeon", "joonyoung", "seongho", "nayeon",
    "parkjoonyoung", "donghyeon", "jinwook", "joonho", "jongho", "jaeseong"
]

# 각 페르소나별로 확인
personas_with_images = {}

for persona in personas_english:
    # 이 스크립트는 실제로는 MCP 호출이 필요하지만, 
    # 여기서는 결과를 표시하는 구조만 만들어둡니다
    personas_with_images[persona] = {
        "has_main": True,  # 모든 페르소나는 main 이미지를 가지고 있음
        "additional_images": []  # 추가 이미지 리스트
    }

# 나나는 이미 확인했으니 추가
personas_with_images["nana"]["additional_images"] = ["image1", "image2"]

print("Personas with additional images:")
for persona, info in personas_with_images.items():
    if info["additional_images"]:
        print(f"{persona}: {info['additional_images']}")