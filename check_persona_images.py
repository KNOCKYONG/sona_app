#!/usr/bin/env python3
"""
Check persona images in Firebase and verify URLs
"""

import json

# Personas to check
personas_to_check = [
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
]

# Expected URL structure
def get_expected_urls(english_name, has_additional=False):
    base_url = "https://teamsona.work"
    sizes = ["thumb", "small", "medium", "large", "original"]
    
    urls = {
        "imageUrls": {}
    }
    
    # Main image URLs
    for size in sizes:
        urls["imageUrls"][size] = {
            "jpg": f"{base_url}/{english_name}/main_{size}.jpg"
        }
    
    # Additional images if exists
    if has_additional:
        urls["imageUrls"]["additional"] = []
        # Check for image1, image2, etc.
        for i in range(1, 3):  # Check up to 2 additional images
            urls["imageUrls"]["additional"].append({
                "jpg": f"{base_url}/{english_name}/image{i}_medium.jpg"
            })
    
    return urls

# Personas known to have multiple images
multiple_images_personas = [
    "dr-park-jieun", "hayeon", "jiyoo", "johyejin", "hyeongjoon", 
    "jisoo", "dayoung", "kyeongho", "leesoyeon", "kimtaehyeong", 
    "sonyoojin", "yoona", "eunji", "jiyul", "seojoon", "seongmin", 
    "daeho", "sooyeon", "woojin", "dongho", "seonho", "seongwoo", 
    "seri", "jihu", "hanul", "leejoonho", "nana"
]

print("Checking persona image URLs in Firebase...")
print("=" * 80)

# Print expected URLs for first 10 personas
for doc_id, korean_name, english_name in personas_to_check:
    has_additional = english_name in multiple_images_personas
    expected = get_expected_urls(english_name, has_additional)
    
    print(f"\n{korean_name} ({english_name}) - ID: {doc_id}")
    print(f"Has additional images: {has_additional}")
    print(f"Expected imageUrls structure:")
    print(json.dumps(expected, indent=2, ensure_ascii=False))
    print("-" * 40)

print("\n\nPERSONAS WITH MULTIPLE IMAGES:")
for name in multiple_images_personas:
    print(f"- {name}")

print("\n\nNOTE: Use Firebase MCP to check actual values and compare with expected URLs")
print("Command: mcp__firebase-mcp__firestore_get_document")