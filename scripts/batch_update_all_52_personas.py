#!/usr/bin/env python3
"""
Batch update all 52 personas with Firebase MCP
"""

from datetime import datetime
from persona_name_mapping import PERSONA_NAME_MAPPING

# R2 base URL
R2_PUBLIC_URL = "https://teamsona.work"

# All 52 personas with Firebase IDs
BATCH_1 = [
    ("예림", "1uvYHUIVEc9jf3yjdLoF", "yerim", ["image1", "image2"]),
    ("Dr. 박지은", "5Q3POc7ean9ynSEOCV8M", "dr-park-jieun", ["image1", "image2"]),
    ("윤미", "5ztpOgh1ncDSR8L9IXOY", "yoonmi", ["image1"]),
    ("채연", "6O8OkOqi1iWV6NPu2L6e", "chaeyeon", None),
    ("상훈", "7vBP8KtEsKdulKHzAa4x", "sanghoon", None),
    ("수진", "8JqUxsfrStSPpjxLAGPA", "sujin", None),
    ("하연", "8VAZ6GQN3ubrI3CkTJWP", "hayeon", ["image1", "image2"]),
    ("정훈", "ADQdsSbeHQ5ASTAMXy2j", "jeonghoon", ["image1"]),
    ("지우", "AY3RsMbb9B3In4tFRZyn", "jiwoo", None),
    ("혜진", "Di1rns1v30eYwMRSn4v3", "hyejin", ["image1"])
]

BATCH_2 = [
    ("Dr. 김민서", "FlkZESLYuuUOMrgL40j3", "dr-kim-minseo", None),
    ("민준", "GqDNfytwDZCLVFaPczt4", "minjun", ["image1", "image2", "image3"]),
    ("나연", "uZxyTKOBuDM0NHQ15jHW", "nayeon", None),
    ("동현", "yIWmW3d6rdVKjvflZj9Z", "donghyun", None),
    ("미연", "nFEbQaFlh8W98gix7Wsp", "miyeon", None),
    ("민수", "mHPXbVvpm3qsoibstfmX", "minsu", None),
    ("박준영", "xm1nnEvCzxbyr95xFjVX", "park-junyoung", None),
    ("성호", "s5mb7z4HRU58FOsZCtUx", "seongho", None),
    ("세빈", "n2OeC5bVKZf0vZAdLtur", "sebin", None),
    ("소희", "m75bPHXaTys3htRJomws", "sohee", None)
]

BATCH_3 = [
    ("영훈", "GYWpfNnGK0d2rOmZu37j", "younghoon", None),
    ("재성", "zrhAI4LNdCRd9qWyBhTM", "jaesung", None),
    ("재현", "n9heEw7UdkprdSaJo46S", "jaehyun", None),
    ("종호", "zpOJLXVqfRWIoxkHxEQi", "jongho", None),
    ("준영", "ooaB6VajCv6nFO2YL2rM", "junyoung", None),
    ("준호", "yzQ6zn6egYJfBXf4exYk", "junho", None),
    ("진욱", "yOlN3CvHeec8699B9Xxh", "jinwook", None),
    ("효진", "m0OjpI1G2QUyWsCbfBar", "hyojin", None),
    ("나나", "lTeLKtF3vSiPrV7au13c", "nana", ["image1", "image2"]),
    ("다은", "VOvVoFFLAT1B0nZCvcGA", "daeun", None)
]

BATCH_4 = [
    ("동수", "O0GdFmJHSsauN2s1jAwK", "dongsu", None),
    ("리나", "NQlqZmBLVGcyaxmSkaTA", "rina", None),
    ("민정", "lASQiz4d9la0HVctfIhp", "minjung", None),
    ("범준", "fAFCIq2g9PDZ6MLBSPO2", "beomjun", None),
    ("석진", "l7XWWwDhqNWKP1ATY1w6", "seokjin", None),
    ("소영", "ff0gDvhcdm8yMzwBOELD", "soyoung", None),
    ("수빈", "lAw4LoIE6StxojBv7nHv", "subin", None),
    ("수아", "RaXtRq57hhyJ8dd0Pe6M", "sua", None),
    ("연지", "e63LQ1CLOL5H7MEfdaUL", "yeonji", ["image1"]),
    ("윤성", "i73Xr9knkmkWO2P0GkC6", "yoonsung", None)
]

BATCH_5 = [
    ("은수", "Reuj9HLk5E8PQ66FJxJ3", "eunsu", None),
    ("주은", "OmpQ91evcAxDnJTgNPAR", "jueun", None),
    ("준석", "jH7p24z8PMer56NFFLsZ", "junseok", None),
    ("지윤", "VJdrEsBk2aLmSPhVXe1p", "jiyoon", None),
    ("지은", "QbjX9EJ0A2Mzzq2YfWRa", "jieun", None),
    ("진호", "KinhtKcnmBc0FmdrhgCy", "jinho", None),
    ("태윤", "i2pkSXV9AjT4t6P4H7Zn", "taeyoon", None),
    ("태준", "dXBlte1vcAyXGKIwNIgk", "taejun", None),
    ("태호", "MbYfxxIOOH47PqpmXk3v", "taeho", None),
    ("현주", "gjNWbPRb9QHxxJMsNeJH", "hyeonju", None),
    ("혜원", "MVWyUpcOsG058yxXqdjP", "hyewon", None)
]

def generate_image_urls(english_name, additional_images=None):
    """Generate imageUrls structure"""
    image_urls = {
        "thumb": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"}
    }
    
    if additional_images:
        # Add mainImageUrls
        image_urls["mainImageUrls"] = {
            "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg",
            "small": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg",
            "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg",
            "large": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg",
            "original": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"
        }
        
        # Add additionalImageUrls
        image_urls["additionalImageUrls"] = {}
        for img in additional_images:
            num = img.replace("image", "")
            image_urls["additionalImageUrls"][img] = {
                "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/{img}_thumb.jpg",
                "small": f"{R2_PUBLIC_URL}/personas/{english_name}/{img}_small.jpg",
                "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/{img}_medium.jpg",
                "large": f"{R2_PUBLIC_URL}/personas/{english_name}/{img}_large.jpg",
                "original": f"{R2_PUBLIC_URL}/personas/{english_name}/{img}_original.jpg"
            }
    
    return image_urls

def print_batch_commands(batch_num, personas):
    print(f"\n# === BATCH {batch_num} ({len(personas)} personas) ===\n")
    
    for korean_name, doc_id, english_name, additional in personas:
        image_urls = generate_image_urls(english_name, additional)
        
        update_data = {
            "imageUrls": image_urls,
            "updatedAt": f"2025-08-03T01:30:00.000Z"
        }
        
        print(f"# {korean_name} ({english_name})")
        print(f"mcp__firebase-mcp__firestore_update_document")
        print(f"collection: personas")
        print(f"id: {doc_id}")
        print(f"data: {update_data}")
        print()

def main():
    print("=== Batch Update Commands for All 52 Personas ===")
    print("Note: 예슬(yeseul) already updated")
    
    print_batch_commands(1, BATCH_1)
    print_batch_commands(2, BATCH_2)
    print_batch_commands(3, BATCH_3)
    print_batch_commands(4, BATCH_4)
    print_batch_commands(5, BATCH_5)
    
    print("\nTotal: 51 personas to update (excluding 예슬)")
    print("All batches ready for execution!")

if __name__ == "__main__":
    main()