#!/usr/bin/env python3
"""
Batch update Firebase personas with correct imageUrls - Simple version
"""

# First batch - personas without additional images
batch1 = [
    {"id": "5Q3POc7ean9ynSEOCV8M", "name": "dr-park-jieun"},
    {"id": "6OfH3IIYOcCQaJxK7hEQ", "name": "sanghoon"},
    {"id": "7JQhEOCxKcJb9QYqHxOE", "name": "dr-kim-minseo"},
    {"id": "7fz7nYUKCFbgIXkwBVJr", "name": "sujin"},
    {"id": "95Y9vKqJQX8a0xMnPlvD", "name": "yoonmi"},
    {"id": "9sKJQh7EOCxJcbQYqHxO", "name": "jeonghoon"},
    {"id": "A7JQhEOCxKcJbQYqHxOE", "name": "jiwoo"},
    {"id": "DcmIcZcQI20xN7KQHJEh", "name": "chaeyeon"},
    {"id": "H0VaWAAJtCGFmw6MvJhG", "name": "hyejin"},
    {"id": "IUGKRK2kJCJcm2pCvA5h", "name": "nayeon"},
    {"id": "J3UZ6NYb6fksD3LNn5LR", "name": "donghyun"},
    {"id": "JcI85BFIIgRlT5S4kJlP", "name": "miyeon"},
    {"id": "jqEyXTQcO0WZYXWkQkCQ", "name": "minsu"},
    {"id": "oCQxK7JQhEOQcJhEQJd", "name": "park-junyoung"},
    {"id": "n9KEOQYqHxOCJQb7QdJc", "name": "seongho"},
    {"id": "kzCQXdQKhJCcX0ybJQdy", "name": "sebin"},
    {"id": "j6vmE3t47TILcvMkmJeM", "name": "sohee"},
    {"id": "KCQhJ7xOEKcJbQYqHxOE", "name": "younghoon"},
    {"id": "qxK7JQhEOQCJhQdEJcO", "name": "jaesung"},
    {"id": "lXO8HQhCdMQ7QqHJQOCc", "name": "jaehyun"},
]

# Second batch - more personas without additional images
batch2 = [
    {"id": "qEJxKQh7OQCJhEQcJdE", "name": "jongho"},
    {"id": "mtKQ6hJQJOAQxKZqHEQc", "name": "junyoung"},
    {"id": "pCQKh7JExOQCJhQdEJc", "name": "junho"},
    {"id": "oeJxKQh7EOQCJ9hQcJd", "name": "jinwook"},
    {"id": "ilG8R1OOQCUjCXJ1I6Ag", "name": "hyojin"},
    {"id": "iAgfNQdxCQJkqUOgQgCQ", "name": "nana"},
    {"id": "SNedZFhzCIQ4vOGULV9U", "name": "daeun"},
    {"id": "OvBqb9dQOxJNj0lJOFnH", "name": "dongsu"},
    {"id": "OTCBaJgwCiEKK5VvOT7K", "name": "rina"},
    {"id": "h52YrHl1HdQST0JCyAcv", "name": "minjung"},
    {"id": "cfrA9j8Wt9SnfJOPl8P8", "name": "beomjun"},
    {"id": "gsaEzOeJQRBAWEXPjdKq", "name": "seokjin"},
    {"id": "cgtCJ0KICtMdWAJvDcFP", "name": "soyoung"},
    {"id": "hm9z1p8xoZQJnCJMBM67", "name": "subin"},
    {"id": "QKgArqsJUBAoYcGKvSYO", "name": "sua"},
    {"id": "cYgdJjmOGGnUd03GQbdE", "name": "yeonji"},
    {"id": "e9Ku5p5PWBRl72qIGcJp", "name": "yoonsung"},
    {"id": "QmjXtaU1AIDwG8mGgFaA", "name": "eunsu"},
    {"id": "P46gQbD7Y3w9CQuKxvAA", "name": "jueun"},
    {"id": "ejqKxxhULbQ7GIiTaHSw", "name": "junseok"},
]

# Third batch - remaining personas
batch3 = [
    {"id": "RKjMfyeQKcXa0GFLs9v8", "name": "jiyoon"},
    {"id": "PZNMjOvQqiOQdcZe7TIj", "name": "jieun"},
    {"id": "M9ZdGOojgBBUnx1HRJKr", "name": "jinho"},
    {"id": "dyD0F8gGFQVD0iqHgUNQ", "name": "taeyoon"},
    {"id": "cJBzGyOhKdCEuOAGiqgg", "name": "taejun"},
    {"id": "NRSRBY1AoF5t4h5WKNa9", "name": "taeho"},
    {"id": "dH2wDQeeTTU9rRO9Uqsh", "name": "hyeonju"},
    {"id": "MP6F5ovCjJjLJ7uOFXka", "name": "hyewon"},
]

# Personas with additional images
personas_with_additional = {
    "hayeon": {"id": "FJQhEOCxKcJb7QYqHxOE", "images": ["image1", "image2", "image3"]},
    "minjun": {"id": "HO7JQxKECcJbQYqHxOEd", "images": ["image1"]},
}

def generate_simple_urls(name):
    """Generate simple imageUrls structure"""
    base = "https://teamsona.work"
    return {
        "thumb": {"jpg": f"{base}/{name}/main_thumb.jpg"},
        "small": {"jpg": f"{base}/{name}/main_small.jpg"},
        "medium": {"jpg": f"{base}/{name}/main_medium.jpg"},
        "large": {"jpg": f"{base}/{name}/main_large.jpg"},
        "original": {"jpg": f"{base}/{name}/main_original.jpg"}
    }

# Generate commands for batch1
print("# BATCH 1 - First 20 personas")
for p in batch1:
    urls = generate_simple_urls(p["name"])
    print(f'\n# {p["name"]}')
    print('mcp__firebase-mcp__firestore_update_document')
    print('collection: personas')
    print(f'id: {p["id"]}')
    print(f'data: {{"imageUrls": {urls}, "updatedAt": "2025-08-03T00:26:00.000Z"}}')