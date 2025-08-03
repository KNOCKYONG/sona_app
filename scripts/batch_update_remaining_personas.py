#!/usr/bin/env python3
"""
Batch update remaining personas with correct imageUrls
"""

# All remaining personas to update (from the Firebase list)
remaining_personas = [
    # Personas with additional images
    ("다영", "dayoung", "JnsM74qE44EJSAuE3WMV", True),
    ("경호", "kyeongho", "JodykCBnc17YY8YKQ4SF", True),
    ("Dr. 이서연", "leesoyeon", "JyBsnD6fi9g2uu3E1MTt", True),
    ("변호사 김태형", "kimtaehyeong", "PUmWIyxv9HrK3H8wEQlR", True),
    ("유나", "yoona", "VPFNA8SKaR0QrEIDlwKR", True),
    ("손유진", "sonyoojin", "VaeHPoyOH44Ry2poApG4", True),
    ("은지", "eunji", "WAMyc4EL0fgvB8L8CT5c", True),
    ("지율", "jiyul", "WEXfPSm7rxczxyHjiqiw", True),
    ("서준", "seojoon", "WXHfoFNQaPQl84e8rHmT", True),
    ("성민", "seongmin", "X5mFQ7rccLNNzLhOLCt7", True),
    ("대호", "daeho", "XO84j9SW4rIbgTQwbhPy", True),
    ("수연", "sooyeon", "YAnViyqBUEqVOH7O40L3", True),
    ("우진", "woojin", "ZRjSoKKQ76T9yA0HyheR", True),
    ("동호", "dongho", "ZzTItnobaerduKNaLwXh", True),
    ("선호", "seonho", "aHkFd6Lh0ZnoZyyNl3Cz", True),
    ("성우", "seongwoo", "agRbuPpiSs6zljRaLfPJ", True),
    ("세리", "seri", "c38lgLu28KMRAmbO2dvF", True),
    ("지후", "jihu", "dFZ9PKsDsuzq2ZGQZegW", True),
    ("한울", "hanul", "ip1ooS92pI8A6HvUM061", True),
    ("이준호", "leejoonho", "javSezhi97ycKssGF5PE", True),
    
    # Personas without additional images
    ("진호", "jinho", "KinhtKcnmBc0FmdrhgCy", False),
    ("혜원", "hyewon", "MVWyUpcOsG058yxXqdjP", False),
    ("태호", "taeho", "MbYfxxIOOH47PqpmXk3v", False),
    ("리나", "rina", "NQlqZmBLVGcyaxmSkaTA", False),
    ("동수", "dongsu", "O0GdFmJHSsauN2s1jAwK", False),
    ("주은", "jueun", "OmpQ91evcAxDnJTgNPAR", False),
    ("지은", "jieun", "QbjX9EJ0A2Mzzq2YfWRa", False),
    ("수아", "sua", "RaXtRq57hhyJ8dd0Pe6M", False),
    ("은수", "eunsu", "Reuj9HLk5E8PQ66FJxJ3", False),
    ("지윤", "jiyoon", "VJdrEsBk2aLmSPhVXe1p", False),
    ("다은", "daeun", "VOvVoFFLAT1B0nZCvcGA", False),
    ("태준", "taejoon", "dXBlte1vcAyXGKIwNIgk", False),
    ("연지", "yeonji", "e63LQ1CLOL5H7MEfdaUL", False),
    ("범준", "beomjoon", "fAFCIq2g9PDZ6MLBSPO2", False),
    ("소영", "soyoung", "ff0gDvhcdm8yMzwBOELD", False),
    ("현주", "hyeonju", "gjNWbPRb9QHxxJMsNeJH", False),
    ("태윤", "taeyoon", "i2pkSXV9AjT4t6P4H7Zn", False),
    ("윤성", "yoonseong", "i73Xr9knkmkWO2P0GkC6", False),
    ("준석", "joonseok", "jH7p24z8PMer56NFFLsZ", False),
    ("석진", "seokjin", "l7XWWwDhqNWKP1ATY1w6", False),
    ("민정", "minjeong", "lASQiz4d9la0HVctfIhp", False),
    ("수빈", "soobin", "lAw4LoIE6StxojBv7nHv", False),
    ("나나", "nana", "lTeLKtF3vSiPrV7au13c", False),
    ("효진", "hyojin", "m0OjpI1G2QUyWsCbfBar", False),
    ("소희", "sohee", "m75bPHXaTys3htRJomws", False),
    ("민수", "minsu", "mHPXbVvpm3qsoibstfmX", False),
    ("세빈", "sebin", "n2OeC5bVKZf0vZAdLtur", False),
    ("재현", "jaehyeon", "n9heEw7UdkprdSaJo46S", False),
    ("미연", "miyeon", "nFEbQaFlh8W98gix7Wsp", False),
    ("준영", "joonyoung", "ooaB6VajCv6nFO2YL2rM", False),
    ("성호", "seongho", "s5mb7z4HRU58FOsZCtUx", False),
    ("나연", "nayeon", "uZxyTKOBuDM0NHQ15jHW", False),
    ("박준영", "parkjoonyoung", "xm1nnEvCzxbyr95xFjVX", False),
    ("동현", "donghyeon", "yIWmW3d6rdVKjvflZj9Z", False),
    ("진욱", "jinwook", "yOlN3CvHeec8699B9Xxh", False),
    ("준호", "joonho", "yzQ6zn6egYJfBXf4exYk", False),
    ("종호", "jongho", "zpOJLXVqfRWIoxkHxEQi", False),
    ("재성", "jaeseong", "zrhAI4LNdCRd9qWyBhTM", False)
]

print(f"Updating {len(remaining_personas)} personas...")

# Generate update commands
for korean_name, english_name, doc_id, has_additional in remaining_personas:
    image_urls = {
        "thumb": {"jpg": f"https://teamsona.work/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"https://teamsona.work/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"https://teamsona.work/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"https://teamsona.work/{english_name}/main_large.jpg"},
        "original": {"jpg": f"https://teamsona.work/{english_name}/main_original.jpg"}
    }
    
    if has_additional:
        image_urls["additional"] = [{"jpg": f"https://teamsona.work/{english_name}/image1_medium.jpg"}]
        # Special cases with 2 additional images
        if korean_name in ["Dr. 박지은", "하연"]:
            image_urls["additional"].append({"jpg": f"https://teamsona.work/{english_name}/image2_medium.jpg"})
    
    print(f"\n# {korean_name} ({english_name})")
    print(f"ID: {doc_id}")
    print(f"Has additional images: {has_additional}")