#!/usr/bin/env python3
"""
Bulk update all personas with correct imageUrls
"""

# Remaining personas to update
personas_to_update = [
    ("다영", "dayoung", "KJHsrtZQW5gZILz7x6nE", ["image1"]),
    ("경호", "kyeongho", "KYXDNKqXdINAbjgbO2V2", ["image1"]),
    ("Dr. 이서연", "leesoyeon", "LsxnKJozSzRLrLJXCuE6", ["image1"]),
    ("진호", "jinho", "M9ZdGOojgBBUnx1HRJKr", []),
    ("혜원", "hyewon", "MP6F5ovCjJjLJ7uOFXka", []),
    ("태호", "taeho", "NRSRBY1AoF5t4h5WKNa9", []),
    ("리나", "rina", "OTCBaJgwCiEKK5VvOT7K", []),
    ("동수", "dongsu", "OvBqb9dQOxJNj0lJOFnH", []),
    ("주은", "jueun", "P46gQbD7Y3w9CQuKxvAA", []),
    ("변호사 김태형", "kimtaehyeong", "P8FmqxBSCwgOpYw7hyfM", ["image1"]),
    ("지은", "jieun", "PZNMjOvQqiOQdcZe7TIj", []),
    ("수아", "sua", "QKgArqsJUBAoYcGKvSYO", []),
    ("은수", "eunsu", "QmjXtaU1AIDwG8mGgFaA", []),
    ("지윤", "jiyoon", "RKjMfyeQKcXa0GFLs9v8", []),
    ("다은", "daeun", "SNedZFhzCIQ4vOGULV9U", []),
    ("유나", "yoona", "TL4vbiJOQ6Lbe7TtHy5G", ["image1"]),
    ("손유진", "sonyoojin", "TgZ8mQ3zBNHFahk0oN2E", ["image1"]),
    ("은지", "eunji", "VDoGv5Y9miFdxHGkzxQM", ["image1"]),
    ("지율", "jiyul", "WJPsJoS5N9Md19EhIf1z", ["image1"]),
    ("서준", "seojoon", "XKCQdnJnOeZTBpqhGJrC", ["image1"]),
    ("성민", "seongmin", "XOOJDttyJKBdgFb6IVdj", ["image1"]),
    ("대호", "daeho", "Xng9XS0sEBkOAaY7V8yO", ["image1"]),
    ("수연", "sooyeon", "Xx5UoMzBY1SttdXgaebO", ["image1"]),
    ("우진", "woojin", "YBhKx4nfBsT7yEpvXVH9", ["image1"]),
    ("동호", "dongho", "YKyGZgTidBOxlIDXnRhN", ["image1"]),
    ("선호", "seonho", "ZJUHqSMdUy0f4WgsBKLV", ["image1"]),
    ("성우", "seongwoo", "ZKxRzSgGphf8HXMGQevC", ["image1"]),
    ("세리", "seri", "ZOHzAcNSZhhxVMaJcTD6", ["image1"]),
    ("지후", "jihu", "abk90IQsRGrP7ikjbHhN", ["image1"]),
    ("태준", "taejoon", "cJBzGyOhKdCEuOAGiqgg", []),
    ("연지", "yeonji", "cYgdJjmOGGnUd03GQbdE", []),
    ("범준", "beomjoon", "cfrA9j8Wt9SnfJOPl8P8", []),
    ("소영", "soyoung", "cgtCJ0KICtMdWAJvDcFP", []),
    ("현주", "hyeonju", "dH2wDQeeTTU9rRO9Uqsh", []),
    ("태윤", "taeyoon", "dyD0F8gGFQVD0iqHgUNQ", []),
    ("윤성", "yoonseong", "e9Ku5p5PWBRl72qIGcJp", []),
    ("한울", "hanul", "eVPCzRBV8TBl6AH0Poz1", ["image1"]),
    ("준석", "joonseok", "ejqKxxhULbQ7GIiTaHSw", []),
    ("이준호", "leejoonho", "fjhVLOYeGHIjstjlm9b0", ["image1"]),
    ("석진", "seokjin", "gsaEzOeJQRBAWEXPjdKq", []),
    ("민정", "minjeong", "h52YrHl1HdQST0JCyAcv", []),
    ("수빈", "soobin", "hm9z1p8xoZQJnCJMBM67", []),
    ("나나", "nana", "iAgfNQdxCQJkqUOgQgCQ", []),
    ("효진", "hyojin", "ilG8R1OOQCUjCXJ1I6Ag", []),
    ("소희", "sohee", "j6vmE3t47TILcvMkmJeM", []),
    ("민수", "minsu", "jqEyXTQcO0WZYXWkQkCQ", []),
    ("세빈", "sebin", "kzCQXdQKhJCcX0ybJQdy", []),
    ("재현", "jaehyeon", "lXO8HQhCdMQ7QqHJQOCc", []),
    ("미연", "miyeon", "mGCQXJxKhEOQdCQ7JOMy", []),
    ("준영", "joonyoung", "mtKQ6hJQJOAQxKZqHEQc", []),
    ("성호", "seongho", "n9KEOQYqHxOCJQb7QdJc", []),
    ("나연", "nayeon", "nVEQhJ9qKOChEQJb7JQc", []),
    ("박준영", "parkjoonyoung", "oCQxK7JQhEOQcJhEQJd", []),
    ("동현", "donghyeon", "oKCQhE7JQxOCJhEQcJd", []),
    ("진욱", "jinwook", "oeJxKQh7EOQCJ9hQcJd", []),
    ("준호", "joonho", "pCQKh7JExOQCJhQdEJc", []),
    ("종호", "jongho", "qEJxKQh7OQCJhEQcJdE", []),
    ("재성", "jaeseong", "qxK7JQhEOQCJhQdEJcO", [])
]

# Generate Firebase update commands
for korean_name, english_name, doc_id, additional_images in personas_to_update:
    print(f"# Updating {korean_name} ({english_name})")
    print(f"mcp__firebase-mcp__firestore_update_document")
    print(f"collection: personas")
    print(f"id: {doc_id}")
    
    image_urls = {
        "thumb": {"jpg": f"https://teamsona.work/{english_name}/main_thumb.jpg"},
        "small": {"jpg": f"https://teamsona.work/{english_name}/main_small.jpg"},
        "medium": {"jpg": f"https://teamsona.work/{english_name}/main_medium.jpg"},
        "large": {"jpg": f"https://teamsona.work/{english_name}/main_large.jpg"},
        "original": {"jpg": f"https://teamsona.work/{english_name}/main_original.jpg"}
    }
    
    if additional_images:
        image_urls["additional"] = []
        for img in additional_images:
            img_num = img.replace("image", "")
            image_urls["additional"].append({"jpg": f"https://teamsona.work/{english_name}/image{img_num}_medium.jpg"})
    
    print(f'data: {{"imageUrls": {image_urls}}}')
    print()