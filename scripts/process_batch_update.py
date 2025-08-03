#!/usr/bin/env python3
"""
Process batch updates using Firebase MCP
"""

import json
import sys
import time
from datetime import datetime

def load_batch_file(filename):
    """Load a batch JSON file"""
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {filename}: {e}")
        return None

def update_persona(persona_data):
    """Update a single persona using Firebase MCP"""
    print(f"\n📝 Updating {persona_data['korean']} ({persona_data['english']})")
    print(f"   Document ID: {persona_data['id']}")
    
    # Prepare update data
    update_data = {
        "imageUrls": persona_data["imageUrls"],
        "updatedAt": persona_data["updatedAt"]
    }
    
    # Print the MCP command for manual execution
    print("\n# Execute this command:")
    print("mcp__firebase-mcp__firestore_update_document")
    print(f"collection: personas")
    print(f"id: {persona_data['id']}")
    print(f"data: {json.dumps(update_data, ensure_ascii=False)}")
    
    return True

def process_batch(batch_file):
    """Process a batch of persona updates"""
    print(f"\n{'='*60}")
    print(f"Processing: {batch_file}")
    print(f"{'='*60}")
    
    personas = load_batch_file(batch_file)
    if not personas:
        return False
    
    print(f"\nLoaded {len(personas)} personas from batch file")
    
    success_count = 0
    for i, persona in enumerate(personas, 1):
        print(f"\n[{i}/{len(personas)}] ", end="")
        if update_persona(persona):
            success_count += 1
            # Small delay between updates to avoid overwhelming Firebase
            if i < len(personas):
                time.sleep(0.5)
    
    print(f"\n✅ Successfully prepared {success_count}/{len(personas)} updates")
    return success_count == len(personas)

def main():
    if len(sys.argv) < 2:
        print("Usage: python process_batch_update.py <batch_file.json>")
        print("\nExample:")
        print("  python process_batch_update.py updates/batch_01.json")
        print("\nTo process all batches:")
        print("  python process_all_batches.py")
        return
    
    batch_file = sys.argv[1]
    process_batch(batch_file)

if __name__ == "__main__":
    main()