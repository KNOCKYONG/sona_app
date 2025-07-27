#!/usr/bin/env python3
"""
Batch update Firebase personas with imageUrls
"""

import json

# Mapping of Korean names to document IDs and English names
personas_mapping = {
    "채연": {"id": "6O8OkOqi1iWV6NPu2L6e", "english": "chaeyeon"},
    "Dr. 박지은": {"id": "5Q3POc7ean9ynSEOCV8M", "english": "dr-park-jieun"},
    "하연": {"id": "8VAZ6GQN3ubrI3CkTJWP", "english": "hayeon"},
    "혜진": {"id": "Di1rns1v30eYwMRSn4v3", "english": "hyejin"},
    "정훈": {"id": "ADQdsSbeHQ5ASTAMXy2j", "english": "jeonghoon"},
    "지우": {"id": "AY3RsMbb9B3In4tFRZyn", "english": "jiwoo"},
    "상훈": {"id": "7vBP8KtEsKdulKHzAa4x", "english": "sanghoon"},
    "수진": {"id": "8JqUxsfrStSPpjxLAGPA", "english": "sujin"},
    "예림": {"id": "1uvYHUIVEc9jf3yjdLoF", "english": "yerim"},
    "예슬": {"id": "1aD0ZX6NFq3Ij2FScLCK", "english": "yeseul"},
    "윤미": {"id": "5ztpOgh1ncDSR8L9IXOY", "english": "yoonmi"}
}

def main():
    print("Batch Firebase Update Script")
    print("=" * 60)
    
    # Process each persona
    successful = []
    failed = []
    
    for korean_name, info in personas_mapping.items():
        doc_id = info["id"]
        english_name = info["english"]
        
        print(f"\nUpdating: {korean_name} (ID: {doc_id})")
        
        # Load the update data
        json_file = f"firebase_update_{english_name}.json"
        try:
            with open(json_file, 'r', encoding='utf-8') as f:
                update_data = json.load(f)
            
            print(f"  Loaded data from: {json_file}")
            print(f"  Document ID: {doc_id}")
            print(f"  Update data ready")
            
            # Save update command for MCP
            cmd_file = f"mcp_cmd_{english_name}.txt"
            with open(cmd_file, 'w', encoding='utf-8') as f:
                f.write(f"Collection: personas\n")
                f.write(f"Document ID: {doc_id}\n")
                f.write(f"Update data: {json.dumps(update_data, ensure_ascii=False)}\n")
            
            successful.append(korean_name)
            
        except Exception as e:
            print(f"  ERROR: {e}")
            failed.append(korean_name)
    
    print("\n" + "=" * 60)
    print(f"Summary:")
    print(f"  Successful preparations: {len(successful)}")
    print(f"  Failed: {len(failed)}")
    
    if successful:
        print(f"\nReady to update: {', '.join(successful)}")
    
    if failed:
        print(f"\nFailed: {', '.join(failed)}")

if __name__ == "__main__":
    main()