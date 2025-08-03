#!/usr/bin/env python3
"""
Update personas with multiple images in Firebase
"""

from datetime import datetime
from persona_name_mapping import PERSONA_NAME_MAPPING

# R2 base URL
R2_PUBLIC_URL = "https://teamsona.work"

# 여러 이미지를 가진 페르소나들
PERSONAS_WITH_MULTIPLE_IMAGES = [
    # 3개 이미지
    ("Dr. 박지은", "5Q3POc7ean9ynSEOCV8M", "dr-park-jieun", 3),
    ("예림", "1uvYHUIVEc9jf3yjdLoF", "yerim", 3),
    ("예슬", "1aD0ZX6NFq3Ij2FScLCK", "yeseul", 3),
    ("나나", "lTeLKtF3vSiPrV7au13c", "nana", 3),
    ("민준", "GqDNfytwDZCLVFaPczt4", "minjun", 3),
    ("하연", "8VAZ6GQN3ubrI3CkTJWP", "hayeon", 3),
    
    # 2개 이미지
    ("윤미", "5ztpOgh1ncDSR8L9IXOY", "yoonmi", 2),
    ("정훈", "ADQdsSbeHQ5ASTAMXy2j", "jeonghoon", 2),
    ("연지", "e63LQ1CLOL5H7MEfdaUL", "yeonji", 2),
    ("혜진", "Di1rns1v30eYwMRSn4v3", "hyejin", 2),
]

def generate_complete_image_urls(english_name, image_count):
    """Generate complete imageUrls structure with main and additional images"""
    # 기본 구조 (메인 이미지)
    image_urls = {
        "thumb": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"}
    }
    
    # mainImageUrls 추가
    image_urls["mainImageUrls"] = {
        "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/main_thumb.jpg",
        "small": f"{R2_PUBLIC_URL}/personas/{english_name}/main_small.jpg",
        "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/main_medium.jpg",
        "large": f"{R2_PUBLIC_URL}/personas/{english_name}/main_large.jpg",
        "original": f"{R2_PUBLIC_URL}/personas/{english_name}/main_original.jpg"
    }
    
    # additionalImageUrls 추가
    if image_count > 1:
        image_urls["additionalImageUrls"] = {}
        for i in range(1, image_count):
            image_urls["additionalImageUrls"][f"image{i}"] = {
                "thumb": f"{R2_PUBLIC_URL}/personas/{english_name}/image{i}_thumb.jpg",
                "small": f"{R2_PUBLIC_URL}/personas/{english_name}/image{i}_small.jpg",
                "medium": f"{R2_PUBLIC_URL}/personas/{english_name}/image{i}_medium.jpg",
                "large": f"{R2_PUBLIC_URL}/personas/{english_name}/image{i}_large.jpg",
                "original": f"{R2_PUBLIC_URL}/personas/{english_name}/image{i}_original.jpg"
            }
    
    return image_urls

def main():
    print("=== Update Personas with Multiple Images ===")
    print(f"Total personas to update: {len(PERSONAS_WITH_MULTIPLE_IMAGES)}")
    
    for korean_name, doc_id, english_name, image_count in PERSONAS_WITH_MULTIPLE_IMAGES:
        print(f"\n# {korean_name} ({english_name}) - {image_count} images")
        
        # Generate complete imageUrls
        image_urls = generate_complete_image_urls(english_name, image_count)
        
        # Update data
        update_data = {
            "imageUrls": image_urls,
            "updatedAt": datetime.utcnow().isoformat() + "Z"
        }
        
        print(f"Firebase ID: {doc_id}")
        print(f"Main image URL: {image_urls['mainImageUrls']['medium']}")
        if image_count > 1:
            print(f"Additional images: {', '.join([f'image{i}' for i in range(1, image_count)])}")
        
        print("\nMCP Command:")
        print(f"mcp__firebase-mcp__firestore_update_document")
        print(f"collection: personas")
        print(f"id: {doc_id}")
        print(f"data: {update_data}")
    
    print("\n" + "="*60)
    print("All commands generated!")
    print("Execute the MCP commands above to update Firebase.")

if __name__ == "__main__":
    main()