#!/usr/bin/env python3
"""
Execute batch updates for all personas - automated version
This script generates a shell script that can be executed to update all personas
"""

import json
from datetime import datetime
import os

# Complete persona mapping
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
    {"korean": "하연", "english": "hayeon", "doc_id": "8VAZ6GQN3ubrI3CkTJWP"},
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

# Personas with additional images
PERSONAS_WITH_ADDITIONAL = {
    "yeseul": ["image1", "image2"],
    "hayeon": ["image1", "image2", "image3"],
    "minjun": ["image1"]
}

def generate_image_urls(english_name):
    """Generate imageUrls structure"""
    base_url = "https://teamsona.work/personas"
    
    image_urls = {
        "thumb": {"jpg": f"{base_url}/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{base_url}/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{base_url}/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{base_url}/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{base_url}/{english_name}/main_original.jpg"}
    }
    
    return image_urls

def generate_batch_json_files():
    """Generate JSON files for batch updates"""
    batch_size = 10
    timestamp = datetime.utcnow().isoformat() + "Z"
    
    # Create updates directory
    os.makedirs("updates", exist_ok=True)
    
    batch_files = []
    
    for i in range(0, len(ALL_PERSONAS), batch_size):
        batch_num = (i // batch_size) + 1
        batch = ALL_PERSONAS[i:i + batch_size]
        
        updates = []
        for persona in batch:
            image_urls = generate_image_urls(persona["english"])
            update = {
                "id": persona["doc_id"],
                "korean": persona["korean"],
                "english": persona["english"],
                "imageUrls": image_urls,
                "updatedAt": timestamp
            }
            updates.append(update)
        
        # Save batch to JSON file
        filename = f"updates/batch_{batch_num:02d}.json"
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(updates, f, ensure_ascii=False, indent=2)
        
        batch_files.append(filename)
        print(f"Created {filename} with {len(updates)} personas")
    
    # Create summary file
    summary = {
        "total_personas": len(ALL_PERSONAS),
        "total_batches": len(batch_files),
        "batch_size": batch_size,
        "generated_at": timestamp,
        "personas_with_additional_images": PERSONAS_WITH_ADDITIONAL,
        "batch_files": batch_files
    }
    
    with open("updates/summary.json", 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Created {len(batch_files)} batch files in 'updates' directory")
    print("📄 Summary saved to updates/summary.json")
    
    return batch_files

def main():
    print("=== Generating Batch Update Files ===")
    print(f"Total personas: {len(ALL_PERSONAS)}")
    print()
    
    batch_files = generate_batch_json_files()
    
    print("\n📋 Next Steps:")
    print("1. Review the generated JSON files in the 'updates' directory")
    print("2. Use Firebase MCP to process each batch file")
    print("3. Monitor the app to verify images are displaying correctly")
    
    print("\n💡 To update a batch, use:")
    print("   python scripts/process_batch_update.py updates/batch_01.json")

if __name__ == "__main__":
    main()