#!/usr/bin/env python3
"""
Check all personas in R2 and identify which have additional images
This script is for reference - actual checking needs to be done via MCP
"""

# 아직 업데이트하지 않은 페르소나들 (Firebase ID와 영문 이름)
remaining_personas = [
    ("gjNWbPRb9QHxxJMsNeJH", "hyeonju"),
    ("i2pkSXV9AjT4t6P4H7Zn", "taeyoon"),
    ("i73Xr9knkmkWO2P0GkC6", "yoonseong"),
    ("jH7p24z8PMer56NFFLsZ", "joonseok"),
    ("l7XWWwDhqNWKP1ATY1w6", "seokjin"),
    ("lASQiz4d9la0HVctfIhp", "minjeong"),
    ("lAw4LoIE6StxojBv7nHv", "soobin"),
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

print(f"Remaining personas to check: {len(remaining_personas)}")
for doc_id, english_name in remaining_personas:
    print(f"- {english_name}: {doc_id}")