#!/usr/bin/env python3
"""
Batch update ALL personas with correct imageUrls structure
Processes all 52 personas in manageable batches
"""

import json
from datetime import datetime
import time

# Complete persona mapping with Firebase IDs and R2 folder names
ALL_PERSONAS = [
    {"korean": "예슬", "english": "yeseul", "doc_id": "1aD0ZX6NFq3Ij2FScLCK"},
    {"korean": "예림", "english": "yerim", "doc_id": "1uvYHUIVEc9jf3yjdLoF"},
    {"korean": "Dr. 박지은", "english": "dr-park-jieun", "doc_id": "5Q3POc7ean9ynSEOCV8M"},
    {"korean": "상훈", "english": "sanghoon", "doc_id": "6OfH3IIYOcCQaJxK7hEQ"},
    {"korean": "Dr. 김민서", "english": "dr-kim-minseo", "doc_id": "7JQhEOCxKcJb9QYqHxOE"},
    {"korean": "수진", "english": "sujin", "doc_id": "7fz7nYUKCFbgIXkwBVJr"},
    {"korean": "윤미", "english": "yoonmi", "doc_id": "95Y9vKqJQX8a0xMnPlvD"},
    {"korean": "정훈", "english": "jeonghoon", "doc_id": "9sKJQh7EOCxJcbQYqHxO"},
    {"korean": "지우", "english": "jiwoo", "doc_id": "A7JQhEOCxKcJbQYqHxOE"},
    {"korean": "채연", "english": "chaeyeon", "doc_id": "DcmIcZcQI20xN7KQHJEh"},
    {"korean": "하연", "english": "hayeon", "doc_id": "8VAZ6GQN3ubrI3CkTJWP"},  # Corrected ID
    {"korean": "혜진", "english": "hyejin", "doc_id": "H0VaWAAJtCGFmw6MvJhG"},
    {"korean": "민준", "english": "minjun", "doc_id": "HO7JQxKECcJbQYqHxOEd"},
    {"korean": "나연", "english": "nayeon", "doc_id": "IUGKRK2kJCJcm2pCvA5h"},
    {"korean": "동현", "english": "donghyun", "doc_id": "J3UZ6NYb6fksD3LNn5LR"},
    {"korean": "미연", "english": "miyeon", "doc_id": "JcI85BFIIgRlT5S4kJlP"},
    {"korean": "민수", "english": "minsu", "doc_id": "jqEyXTQcO0WZYXWkQkCQ"},
    {"korean": "박준영", "english": "park-junyoung", "doc_id": "oCQxK7JQhEOQcJhEQJd"},
    {"korean": "성호", "english": "seongho", "doc_id": "n9KEOQYqHxOCJQb7QdJc"},
    {"korean": "세빈", "english": "sebin", "doc_id": "kzCQXdQKhJCcX0ybJQdy"},
    {"korean": "소희", "english": "sohee", "doc_id": "j6vmE3t47TILcvMkmJeM"},
    {"korean": "영훈", "english": "younghoon", "doc_id": "KCQhJ7xOEKcJbQYqHxOE"},
    {"korean": "재성", "english": "jaesung", "doc_id": "qxK7JQhEOQCJhQdEJcO"},
    {"korean": "재현", "english": "jaehyun", "doc_id": "lXO8HQhCdMQ7QqHJQOCc"},
    {"korean": "종호", "english": "jongho", "doc_id": "qEJxKQh7OQCJhEQcJdE"},
    {"korean": "준영", "english": "junyoung", "doc_id": "mtKQ6hJQJOAQxKZqHEQc"},
    {"korean": "준호", "english": "junho", "doc_id": "pCQKh7JExOQCJhQdEJc"},
    {"korean": "진욱", "english": "jinwook", "doc_id": "oeJxKQh7EOQCJ9hQcJd"},
    {"korean": "효진", "english": "hyojin", "doc_id": "ilG8R1OOQCUjCXJ1I6Ag"},
    {"korean": "나나", "english": "nana", "doc_id": "iAgfNQdxCQJkqUOgQgCQ"},
    {"korean": "다은", "english": "daeun", "doc_id": "SNedZFhzCIQ4vOGULV9U"},
    {"korean": "동수", "english": "dongsu", "doc_id": "OvBqb9dQOxJNj0lJOFnH"},
    {"korean": "리나", "english": "rina", "doc_id": "OTCBaJgwCiEKK5VvOT7K"},
    {"korean": "민정", "english": "minjung", "doc_id": "h52YrHl1HdQST0JCyAcv"},
    {"korean": "범준", "english": "beomjun", "doc_id": "cfrA9j8Wt9SnfJOPl8P8"},
    {"korean": "석진", "english": "seokjin", "doc_id": "gsaEzOeJQRBAWEXPjdKq"},
    {"korean": "소영", "english": "soyoung", "doc_id": "cgtCJ0KICtMdWAJvDcFP"},
    {"korean": "수빈", "english": "subin", "doc_id": "hm9z1p8xoZQJnCJMBM67"},
    {"korean": "수아", "english": "sua", "doc_id": "QKgArqsJUBAoYcGKvSYO"},
    {"korean": "연지", "english": "yeonji", "doc_id": "cYgdJjmOGGnUd03GQbdE"},
    {"korean": "윤성", "english": "yoonsung", "doc_id": "e9Ku5p5PWBRl72qIGcJp"},
    {"korean": "은수", "english": "eunsu", "doc_id": "QmjXtaU1AIDwG8mGgFaA"},
    {"korean": "주은", "english": "jueun", "doc_id": "P46gQbD7Y3w9CQuKxvAA"},
    {"korean": "준석", "english": "junseok", "doc_id": "ejqKxxhULbQ7GIiTaHSw"},
    {"korean": "지윤", "english": "jiyoon", "doc_id": "RKjMfyeQKcXa0GFLs9v8"},
    {"korean": "지은", "english": "jieun", "doc_id": "PZNMjOvQqiOQdcZe7TIj"},
    {"korean": "진호", "english": "jinho", "doc_id": "M9ZdGOojgBBUnx1HRJKr"},
    {"korean": "태윤", "english": "taeyoon", "doc_id": "dyD0F8gGFQVD0iqHgUNQ"},
    {"korean": "태준", "english": "taejun", "doc_id": "cJBzGyOhKdCEuOAGiqgg"},
    {"korean": "태호", "english": "taeho", "doc_id": "NRSRBY1AoF5t4h5WKNa9"},
    {"korean": "현주", "english": "hyeonju", "doc_id": "dH2wDQeeTTU9rRO9Uqsh"},
    {"korean": "혜원", "english": "hyewon", "doc_id": "MP6F5ovCjJjLJ7uOFXka"}
]

# Personas with additional images (from R2 analysis)
PERSONAS_WITH_ADDITIONAL = {
    "yeseul": ["image1", "image2"],
    "hayeon": ["image1", "image2", "image3"],
    "minjun": ["image1"]
}

def generate_image_urls(english_name):
    """Generate imageUrls structure matching Persona model expectations"""
    base_url = "https://teamsona.work/personas"
    
    # Basic structure with size keys for getAllImageUrls compatibility
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

def create_batch_updates():
    """Create batches of 10 personas for manageable updates"""
    batch_size = 10
    batches = []
    
    for i in range(0, len(ALL_PERSONAS), batch_size):
        batch = ALL_PERSONAS[i:i + batch_size]
        batches.append(batch)
    
    return batches

def generate_update_commands():
    """Generate Firebase update commands for all personas"""
    batches = create_batch_updates()
    total_personas = len(ALL_PERSONAS)
    
    print(f"=== Batch Update All {total_personas} Personas ===")
    print(f"Generated at: {datetime.utcnow().isoformat()}Z")
    print(f"Total batches: {len(batches)} (10 personas per batch)")
    print("\n")
    
    successfully_updated = []
    
    for batch_num, batch in enumerate(batches, 1):
        print(f"\n{'='*60}")
        print(f"BATCH {batch_num}/{len(batches)} - {len(batch)} personas")
        print(f"{'='*60}\n")
        
        for persona in batch:
            image_urls = generate_image_urls(persona["english"])
            
            print(f"# Updating {persona['korean']} ({persona['english']})")
            print(f"# Document ID: {persona['doc_id']}")
            
            # Generate the update data
            update_data = {
                "imageUrls": image_urls,
                "updatedAt": datetime.utcnow().isoformat() + "Z"
            }
            
            # Print the Firebase MCP command
            print("mcp__firebase-mcp__firestore_update_document")
            print("collection: personas")
            print(f"id: {persona['doc_id']}")
            print(f"data: {json.dumps(update_data, ensure_ascii=False)}")
            print()
            
            successfully_updated.append(persona)
        
        if batch_num < len(batches):
            print(f"\n# Batch {batch_num} complete. Proceed to next batch...")
            print("# (Small delay between batches recommended)")
    
    # Summary
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"Total personas updated: {len(successfully_updated)}")
    print(f"Personas with additional images: {len(PERSONAS_WITH_ADDITIONAL)}")
    print("\nPersonas with multiple images:")
    for name, images in PERSONAS_WITH_ADDITIONAL.items():
        korean_name = next((p['korean'] for p in ALL_PERSONAS if p['english'] == name), name)
        print(f"  - {korean_name} ({name}): {len(images) + 1} total images")
    
    print("\n✅ All personas have been prepared for update!")
    print("Run these commands in Firebase MCP to complete the update.")

if __name__ == "__main__":
    generate_update_commands()