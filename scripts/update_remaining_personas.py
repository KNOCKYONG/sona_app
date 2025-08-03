#!/usr/bin/env python3
"""
Update remaining personas without additional images
"""

import json

# Remaining personas without additional images
remaining_personas = [
    ("태호", "taeho", "MbYfxxIOOH47PqpmXk3v"),
    ("리나", "rina", "NQlqZmBLVGcyaxmSkaTA"),
    ("동수", "dongsu", "O0GdFmJHSsauN2s1jAwK"),
    ("주은", "jueun", "OmpQ91evcAxDnJTgNPAR"),
    ("지은", "jieun", "QbjX9EJ0A2Mzzq2YfWRa"),
    ("수아", "sua", "RaXtRq57hhyJ8dd0Pe6M"),
    ("은수", "eunsu", "Reuj9HLk5E8PQ66FJxJ3"),
    ("지윤", "jiyoon", "VJdrEsBk2aLmSPhVXe1p"),
    ("다은", "daeun", "VOvVoFFLAT1B0nZCvcGA"),
    ("태준", "taejoon", "dXBlte1vcAyXGKIwNIgk"),
    ("연지", "yeonji", "e63LQ1CLOL5H7MEfdaUL"),
    ("범준", "beomjoon", "fAFCIq2g9PDZ6MLBSPO2"),
    ("소영", "soyoung", "ff0gDvhcdm8yMzwBOELD"),
    ("현주", "hyeonju", "gjNWbPRb9QHxxJMsNeJH"),
    ("태윤", "taeyoon", "i2pkSXV9AjT4t6P4H7Zn"),
    ("윤성", "yoonseong", "i73Xr9knkmkWO2P0GkC6"),
    ("준석", "joonseok", "jH7p24z8PMer56NFFLsZ"),
    ("석진", "seokjin", "l7XWWwDhqNWKP1ATY1w6"),
    ("민정", "minjeong", "lASQiz4d9la0HVctfIhp"),
    ("수빈", "soobin", "lAw4LoIE6StxojBv7nHv"),
    ("나나", "nana", "lTeLKtF3vSiPrV7au13c"),
    ("효진", "hyojin", "m0OjpI1G2QUyWsCbfBar"),
    ("소희", "sohee", "m75bPHXaTys3htRJomws"),
    ("민수", "minsu", "mHPXbVvpm3qsoibstfmX"),
    ("세빈", "sebin", "n2OeC5bVKZf0vZAdLtur"),
    ("재현", "jaehyeon", "n9heEw7UdkprdSaJo46S"),
    ("미연", "miyeon", "nFEbQaFlh8W98gix7Wsp"),
    ("준영", "joonyoung", "ooaB6VajCv6nFO2YL2rM"),
    ("성호", "seongho", "s5mb7z4HRU58FOsZCtUx"),
    ("나연", "nayeon", "uZxyTKOBuDM0NHQ15jHW"),
    ("박준영", "parkjoonyoung", "xm1nnEvCzxbyr95xFjVX"),
    ("동현", "donghyeon", "yIWmW3d6rdVKjvflZj9Z"),
    ("진욱", "jinwook", "yOlN3CvHeec8699B9Xxh"),
    ("준호", "joonho", "yzQ6zn6egYJfBXf4exYk"),
    ("종호", "jongho", "zpOJLXVqfRWIoxkHxEQi"),
    ("재성", "jaeseong", "zrhAI4LNdCRd9qWyBhTM")
]

# Create json files for bulk update
for korean_name, english_name, doc_id in remaining_personas:
    data = {
        "imageUrls": {
            "thumb": {"jpg": f"https://teamsona.work/{english_name}/main_thumb.jpg"},
            "small": {"jpg": f"https://teamsona.work/{english_name}/main_small.jpg"},
            "medium": {"jpg": f"https://teamsona.work/{english_name}/main_medium.jpg"},
            "large": {"jpg": f"https://teamsona.work/{english_name}/main_large.jpg"},
            "original": {"jpg": f"https://teamsona.work/{english_name}/main_original.jpg"}
        }
    }
    
    # Save to file for reference
    with open(f'update_{english_name}.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)
    
    print(f"Prepared update for {korean_name} ({english_name}) - ID: {doc_id}")