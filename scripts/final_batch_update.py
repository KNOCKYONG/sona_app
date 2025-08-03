#!/usr/bin/env python3
"""
Final batch update for remaining personas
"""

remaining_updates = [
    ("RaXtRq57hhyJ8dd0Pe6M", "sua"),
    ("Reuj9HLk5E8PQ66FJxJ3", "eunsu"),
    ("VJdrEsBk2aLmSPhVXe1p", "jiyoon"),
    ("VOvVoFFLAT1B0nZCvcGA", "daeun"),
    ("dXBlte1vcAyXGKIwNIgk", "taejoon"),
    ("e63LQ1CLOL5H7MEfdaUL", "yeonji"),
    ("fAFCIq2g9PDZ6MLBSPO2", "beomjoon"),
    ("ff0gDvhcdm8yMzwBOELD", "soyoung"),
    ("gjNWbPRb9QHxxJMsNeJH", "hyeonju"),
    ("i2pkSXV9AjT4t6P4H7Zn", "taeyoon"),
    ("i73Xr9knkmkWO2P0GkC6", "yoonseong"),
    ("jH7p24z8PMer56NFFLsZ", "joonseok"),
    ("l7XWWwDhqNWKP1ATY1w6", "seokjin"),
    ("lASQiz4d9la0HVctfIhp", "minjeong"),
    ("lAw4LoIE6StxojBv7nHv", "soobin"),
    ("lTeLKtF3vSiPrV7au13c", "nana"),
    ("m0OjpI1G2QUyWsCbfBar", "hyojin"),
    ("m75bPHXaTys3htRJomws", "sohee"),
    ("mHPXbVvpm3qsoibstfmX", "minsu"),
    ("n2OeC5bVKZf0vZAdLtur", "sebin"),
    ("n9heEw7UdkprdSaJo46S", "jaehyeon"),
    ("nFEbQaFlh8W98gix7Wsp", "miyeon"),
    ("ooaB6VajCv6nFO2YL2rM", "joonyoung"),
    ("s5mb7z4HRU58FOsZCtUx", "seongho"),
    ("uZxyTKOBuDM0NHQ15jHW", "nayeon"),
    ("xm1nnEvCzxbyr95xFjVX", "parkjoonyoung"),
    ("yIWmW3d6rdVKjvflZj9Z", "donghyeon"),
    ("yOlN3CvHeec8699B9Xxh", "jinwook"),
    ("yzQ6zn6egYJfBXf4exYk", "joonho"),
    ("zpOJLXVqfRWIoxkHxEQi", "jongho"),
    ("zrhAI4LNdCRd9qWyBhTM", "jaeseong")
]

print(f"Total remaining personas to update: {len(remaining_updates)}")

for doc_id, english_name in remaining_updates:
    print(f"Update {english_name}: {doc_id}")