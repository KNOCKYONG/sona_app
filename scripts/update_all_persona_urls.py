#!/usr/bin/env python3
"""
Update all personas with correct URL format
"""

# 페르소나 이름과 영문 매핑
personas_mapping = {
    # 기본 페르소나들
    "예슬": "yeseul",
    "예림": "yerim",
    "Dr. 박지은": "dr-park-jieun",
    "윤미": "yoonmi",
    "채연": "chaeyeon",
    "상훈": "sanghoon",
    "수진": "sujin",
    "하연": "hayeon",
    "정훈": "jeonghoon",
    "지우": "jiwoo",
    "혜진": "hyejin",
    "Dr. 김민서": "dr-kim-minseo",
    "영훈": "younghoon",
    "민준": "minjoon",
    "지유": "jiyoo",
    "Dr. 조혜진": "johyejin",
    "형준": "hyeongjoon",
    "지수": "jisoo",
    "다영": "dayoung",
    "경호": "kyeongho",
    "Dr. 이서연": "leesoyeon",
    "진호": "jinho",
    "혜원": "hyewon",
    "태호": "taeho",
    "리나": "rina",
    "동수": "dongsu",
    "주은": "jueun",
    "변호사 김태형": "kimtaehyeong",
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
    "태준": "taejoon",
    "연지": "yeonji",
    "범준": "beomjoon",
    "소영": "soyoung",
    "현주": "hyeonju",
    "태윤": "taeyoon",
    "윤성": "yoonseong",
    "한울": "hanul",
    "준석": "joonseok",
    "이준호": "leejoonho",
    "석진": "seokjin",
    "민정": "minjeong",
    "수빈": "soobin",
    "나나": "nana",
    "효진": "hyojin",
    "소희": "sohee",
    "민수": "minsu",
    "세빈": "sebin",
    "재현": "jaehyeon",
    "미연": "miyeon",
    "준영": "joonyoung",
    "성호": "seongho",
    "나연": "nayeon",
    "박준영": "parkjoonyoung",
    "동현": "donghyeon",
    "진욱": "jinwook",
    "준호": "joonho",
    "종호": "jongho",
    "재성": "jaeseong"
}

# 여러 이미지를 가진 페르소나들
multiple_images = [
    "Dr. 박지은", "하연", "지유", "Dr. 조혜진", "형준", "지수", 
    "다영", "경호", "Dr. 이서연", "변호사 김태형", "손유진", "유나",
    "은지", "지율", "서준", "성민", "대호", "수연", "우진", "동호",
    "선호", "성우", "세리", "지후", "한울", "이준호"
]

# Firebase 업데이트 명령어 생성
for korean_name, english_name in personas_mapping.items():
    # 기본 이미지 URL 구조
    base_urls = {
        "thumb": {"jpg": f"https://teamsona.work/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"https://teamsona.work/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"https://teamsona.work/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"https://teamsona.work/{english_name}/main_large.jpg"},
        "original": {"jpg": f"https://teamsona.work/{english_name}/main_original.jpg"}
    }
    
    # 여러 이미지가 있는 경우 추가
    if korean_name in multiple_images:
        base_urls["additional"] = [
            {"jpg": f"https://teamsona.work/{english_name}/image1_medium.jpg"}
        ]
        # Dr. 박지은과 하연은 3개의 이미지를 가짐
        if korean_name in ["Dr. 박지은", "하연"]:
            base_urls["additional"].append(
                {"jpg": f"https://teamsona.work/{english_name}/image2_medium.jpg"}
            )
    
    print(f'"{korean_name}": {base_urls},')