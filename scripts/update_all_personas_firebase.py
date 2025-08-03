#!/usr/bin/env python3
"""
Update all 52 personas in Firebase with correct imageUrls structure
"""

import json
from datetime import datetime
from pathlib import Path
from persona_name_mapping import get_english_name, get_korean_name, PERSONA_NAME_MAPPING

# R2 base URL
R2_PUBLIC_URL = "https://teamsona.work"

# Firebase document mapping (from previous scripts)
PERSONA_FIREBASE_IDS = {
    "예슬": "1aD0ZX6NFq3Ij2FScLCK",
    "예림": "1uvYHUIVEc9jf3yjdLoF",
    "Dr. 박지은": "5Q3POc7ean9ynSEOCV8M",
    "윤미": "5ztpOgh1ncDSR8L9IXOY",
    "채연": "6O8OkOqi1iWV6NPu2L6e",
    "상훈": "7vBP8KtEsKdulKHzAa4x",
    "수진": "8JqUxsfrStSPpjxLAGPA",
    "하연": "8VAZ6GQN3ubrI3CkTJWP",
    "정훈": "ADQdsSbeHQ5ASTAMXy2j",
    "지우": "AY3RsMbb9B3In4tFRZyn",
    "혜진": "Di1rns1v30eYwMRSn4v3",
    "Dr. 김민서": "FlkZESLYuuUOMrgL40j3",
    "민준": "GqDNfytwDZCLVFaPczt4",
    "나연": "uZxyTKOBuDM0NHQ15jHW",
    "동현": "yIWmW3d6rdVKjvflZj9Z",
    "미연": "nFEbQaFlh8W98gix7Wsp",
    "민수": "mHPXbVvpm3qsoibstfmX",
    "박준영": "xm1nnEvCzxbyr95xFjVX",
    "성호": "s5mb7z4HRU58FOsZCtUx",
    "세빈": "n2OeC5bVKZf0vZAdLtur",
    "소희": "m75bPHXaTys3htRJomws",
    "영훈": "GYWpfNnGK0d2rOmZu37j",
    "재성": "zrhAI4LNdCRd9qWyBhTM",
    "재현": "n9heEw7UdkprdSaJo46S",
    "종호": "zpOJLXVqfRWIoxkHxEQi",
    "준영": "ooaB6VajCv6nFO2YL2rM",
    "준호": "yzQ6zn6egYJfBXf4exYk",
    "진욱": "yOlN3CvHeec8699B9Xxh",
    "효진": "m0OjpI1G2QUyWsCbfBar",
    "나나": "lTeLKtF3vSiPrV7au13c",
    "다은": "VOvVoFFLAT1B0nZCvcGA",
    "동수": "O0GdFmJHSsauN2s1jAwK",
    "리나": "NQlqZmBLVGcyaxmSkaTA",
    "민정": "lASQiz4d9la0HVctfIhp",
    "범준": "fAFCIq2g9PDZ6MLBSPO2",
    "석진": "l7XWWwDhqNWKP1ATY1w6",
    "소영": "ff0gDvhcdm8yMzwBOELD",
    "수빈": "lAw4LoIE6StxojBv7nHv",
    "수아": "RaXtRq57hhyJ8dd0Pe6M",
    "연지": "e63LQ1CLOL5H7MEfdaUL",
    "윤성": "i73Xr9knkmkWO2P0GkC6",
    "은수": "Reuj9HLk5E8PQ66FJxJ3",
    "주은": "OmpQ91evcAxDnJTgNPAR",
    "준석": "jH7p24z8PMer56NFFLsZ",
    "지윤": "VJdrEsBk2aLmSPhVXe1p",
    "지은": "QbjX9EJ0A2Mzzq2YfWRa",
    "진호": "KinhtKcnmBc0FmdrhgCy",
    "태윤": "i2pkSXV9AjT4t6P4H7Zn",
    "태준": "dXBlte1vcAyXGKIwNIgk",
    "태호": "MbYfxxIOOH47PqpmXk3v",
    "현주": "gjNWbPRb9QHxxJMsNeJH",
    "혜원": "MVWyUpcOsG058yxXqdjP"
}

def scan_local_personas():
    """Scan local assets to find personas with additional images"""
    assets_dir = Path(r"C:\Users\yong\sonaapp\assets\personas")
    
    personas_with_additional = {}
    
    if assets_dir.exists():
        for item in assets_dir.iterdir():
            if item.is_dir():
                english_name = item.name
                
                # Count additional images
                additional_images = []
                idx = 1
                while True:
                    if (item / f"image{idx}_thumb.jpg").exists():
                        additional_images.append(idx)
                        idx += 1
                    else:
                        break
                
                if additional_images:
                    personas_with_additional[english_name] = additional_images
    
    return personas_with_additional

def generate_image_urls(english_name, has_additional=None):
    """Generate correct imageUrls structure for Persona model"""
    # Basic structure that matches Persona model's getAllImageUrls method
    image_urls = {
        "thumb": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"}
    }
    
    # Add additional images if available
    if has_additional:
        # Add mainImageUrls for backward compatibility
        image_urls["mainImageUrls"] = {
            "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg",
            "small": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg",
            "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg",
            "large": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg",
            "original": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"
        }
        
        # Add additionalImageUrls
        image_urls["additionalImageUrls"] = {}
        for idx in has_additional:
            image_urls["additionalImageUrls"][f"image{idx}"] = {
                "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_thumb.jpg",
                "small": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_small.jpg",
                "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_medium.jpg",
                "large": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_large.jpg",
                "original": f"{R2_PUBLIC_URL}/personas/{english_name}/image{idx}_original.jpg"
            }
    
    return image_urls

def main():
    print("=== Firebase Update Script for All 52 Personas ===")
    print(f"Generated at: {datetime.utcnow().isoformat()}Z\n")
    
    # Scan for personas with additional images
    personas_with_additional = scan_local_personas()
    print(f"Found {len(personas_with_additional)} personas with additional images:")
    for english_name, images in personas_with_additional.items():
        korean_name = get_korean_name(english_name)
        print(f"  - {korean_name} ({english_name}): {len(images)} additional images")
    
    print("\nGenerating update commands for all 52 personas...\n")
    
    # Process all personas
    batch_num = 1
    batch_size = 10
    count = 0
    
    for korean_name, doc_id in PERSONA_FIREBASE_IDS.items():
        if count % batch_size == 0 and count > 0:
            batch_num += 1
            print(f"\n# === BATCH {batch_num} ===\n")
        
        english_name = PERSONA_NAME_MAPPING[korean_name]
        has_additional = personas_with_additional.get(english_name)
        
        # Generate imageUrls
        image_urls = generate_image_urls(english_name, has_additional)
        
        # Prepare update data
        update_data = {
            "imageUrls": image_urls,
            "updatedAt": datetime.utcnow().isoformat() + "Z"
        }
        
        count += 1
        print(f"# [{count}/52] {korean_name} ({english_name})")
        print(f"mcp__firebase-mcp__firestore_update_document")
        print(f"collection: personas")
        print(f"id: {doc_id}")
        print(f"data: {json.dumps(update_data, ensure_ascii=False)}")
        
        if has_additional:
            print(f"# Note: Has {len(has_additional)} additional images")
        
        print()
    
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"Total personas: {len(PERSONA_FIREBASE_IDS)}")
    print(f"Personas with additional images: {len(personas_with_additional)}")
    print("All commands generated!")

if __name__ == "__main__":
    main()