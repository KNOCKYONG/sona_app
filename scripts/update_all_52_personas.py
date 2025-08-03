#!/usr/bin/env python3
"""
Update all 52 personas with correct imageUrls based on Firebase documents
"""

import json
from datetime import datetime

# Firebase document mapping based on actual Firebase data
# 이름 -> (Firebase Document ID, 영문명)
PERSONA_MAPPING = {
    # Verified from Firebase
    "예슬": ("1aD0ZX6NFq3Ij2FScLCK", "yeseul"),
    "예림": ("1uvYHUIVEc9jf3yjdLoF", "yerim"),
    "Dr. 박지은": ("5Q3POc7ean9ynSEOCV8M", "dr-park-jieun"),
    "윤미": ("5ztpOgh1ncDSR8L9IXOY", "yoonmi"),
    "채연": ("6O8OkOqi1iWV6NPu2L6e", "chaeyeon"),
    "상훈": ("7vBP8KtEsKdulKHzAa4x", "sanghoon"),
    "수진": ("8JqUxsfrStSPpjxLAGPA", "sujin"),
    "하연": ("8VAZ6GQN3ubrI3CkTJWP", "hayeon"),
    "정훈": ("ADQdsSbeHQ5ASTAMXy2j", "jeonghoon"),
    "지우": ("AY3RsMbb9B3In4tFRZyn", "jiwoo"),
    "혜진": ("Di1rns1v30eYwMRSn4v3", "hyejin"),
    "Dr. 김민서": ("FlkZESLYuuUOMrgL40j3", "dr-kim-minseo"),
    "민준": ("GqDNfytwDZCLVFaPczt4", "minjun"),
    "나연": ("uZxyTKOBuDM0NHQ15jHW", "nayeon"),
    "동현": ("yIWmW3d6rdVKjvflZj9Z", "donghyun"),
    "미연": ("nFEbQaFlh8W98gix7Wsp", "miyeon"),
    "민수": ("mHPXbVvpm3qsoibstfmX", "minsu"),
    "박준영": ("xm1nnEvCzxbyr95xFjVX", "park-junyoung"),
    "성호": ("s5mb7z4HRU58FOsZCtUx", "seongho"),
    "세빈": ("n2OeC5bVKZf0vZAdLtur", "sebin"),
    "소희": ("m75bPHXaTys3htRJomws", "sohee"),
    "영훈": ("GYWpfNnGK0d2rOmZu37j", "younghoon"),
    "재성": ("zrhAI4LNdCRd9qWyBhTM", "jaesung"),
    "재현": ("n9heEw7UdkprdSaJo46S", "jaehyun"),
    "종호": ("zpOJLXVqfRWIoxkHxEQi", "jongho"),
    "준영": ("ooaB6VajCv6nFO2YL2rM", "junyoung"),
    "준호": ("yzQ6zn6egYJfBXf4exYk", "junho"),
    "진욱": ("yOlN3CvHeec8699B9Xxh", "jinwook"),
    "효진": ("m0OjpI1G2QUyWsCbfBar", "hyojin"),
    "나나": ("lTeLKtF3vSiPrV7au13c", "nana"),
    "다은": ("VOvVoFFLAT1B0nZCvcGA", "daeun"),
    "동수": ("O0GdFmJHSsauN2s1jAwK", "dongsu"),
    "리나": ("NQlqZmBLVGcyaxmSkaTA", "rina"),
    "민정": ("lASQiz4d9la0HVctfIhp", "minjung"),
    "범준": ("fAFCIq2g9PDZ6MLBSPO2", "beomjun"),
    "석진": ("l7XWWwDhqNWKP1ATY1w6", "seokjin"),
    "소영": ("ff0gDvhcdm8yMzwBOELD", "soyoung"),
    "수빈": ("lAw4LoIE6StxojBv7nHv", "subin"),
    "수아": ("RaXtRq57hhyJ8dd0Pe6M", "sua"),
    "연지": ("e63LQ1CLOL5H7MEfdaUL", "yeonji"),
    "윤성": ("i73Xr9knkmkWO2P0GkC6", "yoonsung"),
    "은수": ("Reuj9HLk5E8PQ66FJxJ3", "eunsu"),
    "주은": ("OmpQ91evcAxDnJTgNPAR", "jueun"),
    "준석": ("jH7p24z8PMer56NFFLsZ", "junseok"),
    "지윤": ("VJdrEsBk2aLmSPhVXe1p", "jiyoon"),
    "지은": ("QbjX9EJ0A2Mzzq2YfWRa", "jieun"),
    "진호": ("KinhtKcnmBc0FmdrhgCy", "jinho"),
    "태윤": ("i2pkSXV9AjT4t6P4H7Zn", "taeyoon"),
    "태준": ("dXBlte1vcAyXGKIwNIgk", "taejun"),
    "태호": ("MbYfxxIOOH47PqpmXk3v", "taeho"),
    "현주": ("gjNWbPRb9QHxxJMsNeJH", "hyeonju"),
    "혜원": ("MVWyUpcOsG058yxXqdjP", "hyewon")
}

# Personas with additional images (from R2 bucket)
PERSONAS_WITH_ADDITIONAL = {
    "yeseul": ["image1", "image2"],
    "hayeon": ["image1", "image2", "image3"],
    "minjun": ["image1"]
}

def generate_image_urls(english_name):
    """Generate imageUrls structure for persona"""
    base_url = "https://teamsona.work/personas"
    
    # Basic structure matching Persona model
    image_urls = {
        "thumb": {"jpg": f"{base_url}/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{base_url}/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{base_url}/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{base_url}/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{base_url}/{english_name}/main_original.jpg"}
    }
    
    # Add additional images if available
    if english_name in PERSONAS_WITH_ADDITIONAL:
        additional_images = PERSONAS_WITH_ADDITIONAL[english_name]
        
        # Add mainImageUrls for backward compatibility
        image_urls["mainImageUrls"] = {
            "thumb": f"{base_url}/{english_name}/main_thumb.jpg",
            "small": f"{base_url}/{english_name}/main_small.jpg",
            "medium": f"{base_url}/{english_name}/main_medium.jpg",
            "large": f"{base_url}/{english_name}/main_large.jpg",
            "original": f"{base_url}/{english_name}/main_original.jpg"
        }
        
        # Add additionalImageUrls
        image_urls["additionalImageUrls"] = {}
        for img in additional_images:
            img_num = img.replace("image", "")
            image_urls["additionalImageUrls"][img] = {
                "thumb": f"{base_url}/{english_name}/image{img_num}_thumb.jpg",
                "small": f"{base_url}/{english_name}/image{img_num}_small.jpg",
                "medium": f"{base_url}/{english_name}/image{img_num}_medium.jpg",
                "large": f"{base_url}/{english_name}/image{img_num}_large.jpg",
                "original": f"{base_url}/{english_name}/image{img_num}_original.jpg"
            }
    
    return image_urls

def generate_updates():
    """Generate update commands for all personas"""
    print(f"=== Updating All 52 Personas ===")
    print(f"Generated at: {datetime.utcnow().isoformat()}Z")
    print()
    
    success_count = 0
    batch_size = 10
    batch_num = 1
    
    personas_list = list(PERSONA_MAPPING.items())
    
    for i in range(0, len(personas_list), batch_size):
        batch = personas_list[i:i + batch_size]
        print(f"\n{'='*60}")
        print(f"BATCH {batch_num} - {len(batch)} personas")
        print(f"{'='*60}\n")
        
        for korean_name, (doc_id, english_name) in batch:
            image_urls = generate_image_urls(english_name)
            
            print(f"# [{success_count + 1}/52] {korean_name} ({english_name})")
            print(f"# Document ID: {doc_id}")
            
            # Update data
            update_data = {
                "imageUrls": image_urls,
                "updatedAt": datetime.utcnow().isoformat() + "Z"
            }
            
            # Print command
            print("mcp__firebase-mcp__firestore_update_document")
            print("collection: personas")
            print(f"id: {doc_id}")
            print(f"data: {json.dumps(update_data, ensure_ascii=False)}")
            print()
            
            success_count += 1
        
        batch_num += 1
        
        if i + batch_size < len(personas_list):
            print("\n# Continue with next batch...")
    
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"Total personas: {len(PERSONA_MAPPING)}")
    print(f"Personas with additional images: {len(PERSONAS_WITH_ADDITIONAL)}")
    print("\nAll 52 personas prepared for update!")

if __name__ == "__main__":
    generate_updates()