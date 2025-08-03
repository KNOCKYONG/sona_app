#!/usr/bin/env python3
"""
Fix Firebase imageUrls structure to match Persona model expectations
"""

import asyncio
from datetime import datetime

# Test with yeseul first
test_personas = [
    {
        "name": "예슬",
        "english_name": "yeseul",
        "doc_id": "1aD0ZX6NFq3Ij2FScLCK",
        "has_additional": ["image1", "image2"]  # yeseul has image1 and image2
    }
]

# All personas that need updating
all_personas = [
    # Personas with main images only
    {"name": "예림", "english_name": "yerim", "doc_id": "1uvYHUIVEc9jf3yjdLoF", "has_additional": []},
    {"name": "Dr. 박지은", "english_name": "dr-park-jieun", "doc_id": "5Q3POc7ean9ynSEOCV8M", "has_additional": []},
    {"name": "상훈", "english_name": "sanghoon", "doc_id": "6OfH3IIYOcCQaJxK7hEQ", "has_additional": []},
    {"name": "Dr. 김민서", "english_name": "dr-kim-minseo", "doc_id": "7JQhEOCxKcJb9QYqHxOE", "has_additional": []},
    {"name": "수진", "english_name": "sujin", "doc_id": "7fz7nYUKCFbgIXkwBVJr", "has_additional": []},
    {"name": "윤미", "english_name": "yoonmi", "doc_id": "95Y9vKqJQX8a0xMnPlvD", "has_additional": []},
    {"name": "정훈", "english_name": "jeonghoon", "doc_id": "9sKJQh7EOCxJcbQYqHxO", "has_additional": []},
    {"name": "지우", "english_name": "jiwoo", "doc_id": "A7JQhEOCxKcJbQYqHxOE", "has_additional": []},
    {"name": "채연", "english_name": "chaeyeon", "doc_id": "DcmIcZcQI20xN7KQHJEh", "has_additional": []},
    {"name": "하연", "english_name": "hayeon", "doc_id": "FJQhEOCxKcJb7QYqHxOE", "has_additional": ["image1", "image2", "image3"]},
    {"name": "혜진", "english_name": "hyejin", "doc_id": "H0VaWAAJtCGFmw6MvJhG", "has_additional": []},
    
    # Add more personas with additional images
    {"name": "민준", "english_name": "minjun", "doc_id": "HO7JQxKECcJbQYqHxOEd", "has_additional": ["image1"]},
    {"name": "세리", "english_name": "seri", "doc_id": "ZOHzAcNSZhhxVMaJcTD6", "has_additional": ["image1"]},
    {"name": "대호", "english_name": "daeho", "doc_id": "Xng9XS0sEBkOAaY7V8yO", "has_additional": ["image1"]},
    {"name": "우진", "english_name": "woojin", "doc_id": "YBhKx4nfBsT7yEpvXVH9", "has_additional": ["image1"]},
    
    # Add remaining personas...
]

def generate_image_urls(english_name, has_additional):
    """Generate imageUrls structure that matches Persona model expectations"""
    base_url = "https://teamsona.work"
    
    # Basic structure with size keys directly
    image_urls = {
        "thumb": {"jpg": f"{base_url}/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"{base_url}/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"{base_url}/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"{base_url}/{english_name}/main_large.jpg"},
        "original": {"jpg": f"{base_url}/{english_name}/main_original.jpg"}
    }
    
    # If there are additional images, add them in a structure that getAllImageUrls can handle
    if has_additional:
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
        for img in has_additional:
            img_num = img.replace("image", "")
            image_urls["additionalImageUrls"][img] = {
                "thumb": f"{base_url}/{english_name}/image{img_num}_thumb.jpg",
                "small": f"{base_url}/{english_name}/image{img_num}_small.jpg",
                "medium": f"{base_url}/{english_name}/image{img_num}_medium.jpg",
                "large": f"{base_url}/{english_name}/image{img_num}_large.jpg",
                "original": f"{base_url}/{english_name}/image{img_num}_original.jpg"
            }
    
    return image_urls

def print_update_command(persona):
    """Print Firebase MCP update command"""
    image_urls = generate_image_urls(persona["english_name"], persona["has_additional"])
    
    print(f"\n# Updating {persona['name']} ({persona['english_name']})")
    print(f"# Document ID: {persona['doc_id']}")
    print(f"# Has additional images: {len(persona['has_additional'])} images")
    
    # Format for MCP command
    print("\nmcp__firebase-mcp__firestore_update_document")
    print("collection: personas")
    print(f"id: {persona['doc_id']}")
    print(f"data: {{")
    print(f'  "imageUrls": {image_urls},')
    print(f'  "updatedAt": "{datetime.utcnow().isoformat()}Z"')
    print(f"}}")
    print("\n" + "="*80)

if __name__ == "__main__":
    print("=== Firebase ImageUrls Structure Fix ===")
    print(f"Generated at: {datetime.utcnow().isoformat()}Z")
    
    print("\n\n=== TEST: Updating Yeseul First ===")
    for persona in test_personas:
        print_update_command(persona)
    
    print("\n\n=== OPTIONAL: Update All Personas ===")
    print("# Uncomment below to update all personas")
    print("# for persona in all_personas:")
    print("#     print_update_command(persona)")