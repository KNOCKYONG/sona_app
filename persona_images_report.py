#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Complete persona images report - check Firebase and R2 status
"""

import sys

# Set encoding for Windows
if sys.platform.startswith('win'):
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

# R2에서 확인된 페르소나 목록 (실제 R2 조회 결과)
R2_PERSONAS_WITH_IMAGES = {
    "beomjun": ["main"],
    "chaeyeon": ["main"],
    "daeun": ["main"], 
    "donghyun": ["main"],
    "yeseul": ["main", "image1", "image2"]  # 추가 이미지 있음
}

# 모든 Firebase 페르소나 (Firebase 조회 결과)
ALL_PERSONAS = [
    ("1aD0ZX6NFq3Ij2FScLCK", "예슬", "yeseul"),
    ("1uvYHUIVEc9jf3yjdLoF", "예림", "yerim"),
    ("5Q3POc7ean9ynSEOCV8M", "Dr. 박지은", "dr-park-jieun"),
    ("5ztpOgh1ncDSR8L9IXOY", "윤미", "yoonmi"),
    ("6O8OkOqi1iWV6NPu2L6e", "채연", "chaeyeon"),
    ("7vBP8KtEsKdulKHzAa4x", "상훈", "sanghoon"),
    ("8JqUxsfrStSPpjxLAGPA", "수진", "sujin"),
    ("8VAZ6GQN3ubrI3CkTJWP", "하연", "hayeon"),
    ("ADQdsSbeHQ5ASTAMXy2j", "정훈", "jeonghoon"),
    ("AY3RsMbb9B3In4tFRZyn", "지우", "jiwoo"),
    ("Di1rns1v30eYwMRSn4v3", "혜진", "hyejin"),
    ("FlkZESLYuuUOMrgL40j3", "Dr. 김민서", "dr-kiminseo"),
    ("GYWpfNnGK0d2rOmZu37j", "영훈", "younghoon"),
    ("GqDNfytwDZCLVFaPczt4", "민준", "minjun"),
    ("HCHkS3ZRKR7FtXny3Mqj", "지유", "jiyoo"),
    ("HouahN4jLcy3bkBCnNUX", "Dr. 조혜진", "johyejin"),
    ("Iy9BQmdxOGZfqipeuY4H", "형준", "hyeongjoon"),
    ("JEihxQ8m38TKVgGwF2cm", "지수", "jisoo"),
    ("JnsM74qE44EJSAuE3WMV", "다영", "dayoung"),
    ("JodykCBnc17YY8YKQ4SF", "경호", "kyeongho"),
    ("JyBsnD6fi9g2uu3E1MTt", "Dr. 이서연", "leesoyeon"),
    ("KinhtKcnmBc0FmdrhgCy", "진호", "jinho"),
    ("MVWyUpcOsG058yxXqdjP", "혜원", "hyewon"),
    ("MbYfxxIOOH47PqpmXk3v", "태호", "taeho"),
    ("NQlqZmBLVGcyaxmSkaTA", "리나", "lina"),
    ("O0GdFmJHSsauN2s1jAwK", "동수", "dongsu"),
    ("OmpQ91evcAxDnJTgNPAR", "주은", "jueun"),
    ("PUmWIyxv9HrK3H8wEQlR", "변호사 김태형", "kimtaehyeong"),
    ("QbjX9EJ0A2Mzzq2YfWRa", "지은", "jieun"),
    ("RaXtRq57hhyJ8dd0Pe6M", "수아", "sua"),
    ("Reuj9HLk5E8PQ66FJxJ3", "은수", "eunsu"),
    ("VJdrEsBk2aLmSPhVXe1p", "지윤", "jiyoon"),
    ("VOvVoFFLAT1B0nZCvcGA", "다은", "daeun"),
    ("VPFNA8SKaR0QrEIDlwKR", "유나", "yoona"),
    ("VaeHPoyOH44Ry2poApG4", "손유진", "sonyoojin"),
    ("WAMyc4EL0fgvB8L8CT5c", "은지", "eunji"),
    ("WEXfPSm7rxczxyHjiqiw", "지율", "jiyul"),
    ("WXHfoFNQaPQl84e8rHmT", "서준", "seojoon"),
    ("X5mFQ7rccLNNzLhOLCt7", "성민", "seongmin"),
    ("XO84j9SW4rIbgTQwbhPy", "대호", "daeho"),
    ("YAnViyqBUEqVOH7O40L3", "수연", "sooyeon"),
    ("ZRjSoKKQ76T9yA0HyheR", "우진", "woojin"),
    ("ZzTItnobaerduKNaLwXh", "동호", "dongho"),
    ("aHkFd6Lh0ZnoZyyNl3Cz", "선호", "seonho"),
    ("agRbuPpiSs6zljRaLfPJ", "성우", "seongwoo"),
    ("c38lgLu28KMRAmbO2dvF", "세리", "seri"),
    ("dFZ9PKsDsuzq2ZGQZegW", "지후", "jihu"),
    ("dXBlte1vcAyXGKIwNIgk", "태준", "taejun"),
    ("e63LQ1CLOL5H7MEfdaUL", "연지", "yeonji"),
    ("fAFCIq2g9PDZ6MLBSPO2", "범준", "beomjun"),
    ("ff0gDvhcdm8yMzwBOELD", "소영", "soyoung"),
    ("gjNWbPRb9QHxxJMsNeJH", "현주", "hyeonju"),
    ("i2pkSXV9AjT4t6P4H7Zn", "태윤", "taeyoon"),
    ("i73Xr9knkmkWO2P0GkC6", "윤성", "yoonsung"),
    ("ip1ooS92pI8A6HvUM061", "한울", "hanul"),
    ("jH7p24z8PMer56NFFLsZ", "준석", "junseok"),
    ("javSezhi97ycKssGF5PE", "이준호", "leejoonho"),
    ("l7XWWwDhqNWKP1ATY1w6", "석진", "seokjin"),
    ("lASQiz4d9la0HVctfIhp", "민정", "minjung"),
    ("lAw4LoIE6StxojBv7nHv", "수빈", "subin"),
    ("lTeLKtF3vSiPrV7au13c", "나나", "nana"),
    ("m0OjpI1G2QUyWsCbfBar", "효진", "hyojin"),
    ("m75bPHXaTys3htRJomws", "소희", "sohee"),
    ("mHPXbVvpm3qsoibstfmX", "민수", "minsu"),
    ("n2OeC5bVKZf0vZAdLtur", "세빈", "sebin"),
    ("n9heEw7UdkprdSaJo46S", "재현", "jaehyun"),
    ("nFEbQaFlh8W98gix7Wsp", "미연", "miyeon"),
    ("ooaB6VajCv6nFO2YL2rM", "준영", "junyoung"),
    ("s5mb7z4HRU58FOsZCtUx", "성호", "seongho"),
    ("uZxyTKOBuDM0NHQ15jHW", "나연", "nayeon"),
    ("xm1nnEvCzxbyr95xFjVX", "박준영", "parkjunyoung"),
    ("yIWmW3d6rdVKjvflZj9Z", "동현", "donghyun"),
    ("yOlN3CvHeec8699B9Xxh", "진욱", "jinwook"),
    ("yzQ6zn6egYJfBXf4exYk", "준호", "junho"),
    ("zpOJLXVqfRWIoxkHxEQi", "종호", "jongho"),
    ("zrhAI4LNdCRd9qWyBhTM", "재성", "jaesung"),
]

print("=" * 80)
print("페르소나 이미지 상태 종합 보고서")
print("=" * 80)

# 카테고리별로 분류
has_images_in_r2 = []
no_images_in_r2 = []

for doc_id, korean_name, english_name in ALL_PERSONAS:
    if english_name in R2_PERSONAS_WITH_IMAGES:
        has_images_in_r2.append((doc_id, korean_name, english_name))
    else:
        no_images_in_r2.append((doc_id, korean_name, english_name))

print(f"\n총 페르소나 수: {len(ALL_PERSONAS)}개")
print(f"R2에 이미지가 있는 페르소나: {len(has_images_in_r2)}개")
print(f"R2에 이미지가 없는 페르소나: {len(no_images_in_r2)}개")

print("\n" + "=" * 40)
print("R2에 이미지가 있는 페르소나 (✅)")
print("=" * 40)
for doc_id, korean_name, english_name in has_images_in_r2:
    images = R2_PERSONAS_WITH_IMAGES[english_name]
    if len(images) > 1:
        print(f"{korean_name} ({english_name}) - 추가 이미지 {len(images)-1}개")
    else:
        print(f"{korean_name} ({english_name})")

print("\n" + "=" * 40)
print("R2에 이미지가 없는 페르소나 (❌)")
print("=" * 40)
for i, (doc_id, korean_name, english_name) in enumerate(no_images_in_r2):
    print(f"{i+1}. {korean_name} ({english_name}) - ID: {doc_id}")

print("\n" + "=" * 40)
print("Firebase imageUrls 업데이트 필요 목록")
print("=" * 40)
print("\n다음 페르소나들은 R2에 이미지가 없어서 Firebase imageUrls를 확인/수정해야 합니다:")
for doc_id, korean_name, english_name in no_images_in_r2[:10]:  # 처음 10개만 표시
    print(f"\n{korean_name} ({english_name}):")
    print(f"  - ID: {doc_id}")
    print(f"  - 필요한 이미지 파일:")
    print(f"    * personas/{english_name}/main_thumb.jpg")
    print(f"    * personas/{english_name}/main_small.jpg")
    print(f"    * personas/{english_name}/main_medium.jpg")
    print(f"    * personas/{english_name}/main_large.jpg")
    print(f"    * personas/{english_name}/main_original.jpg")

if len(no_images_in_r2) > 10:
    print(f"\n... 그 외 {len(no_images_in_r2) - 10}개 페르소나")

print("\n" + "=" * 40)
print("권장 조치사항")
print("=" * 40)
print("1. R2에 이미지가 없는 페르소나들의 이미지를 업로드해야 합니다.")
print("2. 이미지 업로드 후 '이미지 반영' 명령어를 실행하여 Firebase를 업데이트하세요.")
print("3. 매칭된 페르소나의 프로필 사진이 표시되지 않는 이유:")
print("   - 대부분의 페르소나 이미지가 R2에 업로드되지 않았습니다.")
print("   - Firebase의 imageUrls이 존재하더라도 실제 파일이 R2에 없으면 표시되지 않습니다.")