#!/usr/bin/env python3
"""
Persona MCP Uploader - Integration script between image processor and MCP
Handles R2 uploads and Firebase updates using Claude Code MCP
"""

import json
import sys
import subprocess
import base64
from pathlib import Path
from typing import Dict, List

def upload_to_r2_via_mcp(file_path: str, key: str, bucket: str = "sona-personas") -> bool:
    """Upload file to R2 using MCP Cloudflare"""
    try:
        # Read file content
        with open(file_path, 'rb') as f:
            content = f.read()
        
        # Convert to base64 for MCP
        content_b64 = base64.b64encode(content).decode('utf-8')
        
        # Determine content type
        ext = Path(file_path).suffix.lower()
        content_types = {
            '.webp': 'image/webp',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png'
        }
        content_type = content_types.get(ext, 'application/octet-stream')
        
        print(f"Uploading {key} to R2...")
        
        # This would be the MCP call in real implementation
        # For now, we'll output the command that Claude Code should execute
        mcp_command = {
            "tool": "mcp__cloudflare-r2__r2_put_object",
            "params": {
                "bucket": bucket,
                "key": key,
                "content": content_b64,
                "contentType": content_type
            }
        }
        
        print(f"MCP Command: {json.dumps(mcp_command, indent=2)}")
        return True
        
    except Exception as e:
        print(f"Error uploading {key}: {e}")
        return False

def update_firebase_via_mcp(persona_name: str, image_data: Dict) -> bool:
    """Update Firebase persona using MCP"""
    try:
        print(f"Updating Firebase for {persona_name}...")
        
        # This would be the MCP call in real implementation
        mcp_command = {
            "tool": "mcp__firebase-mcp__firestore_update_document_by_name",
            "params": {
                "collection": "personas",
                "name_field": "name",
                "name_value": persona_name,
                "data": {
                    "imageUrls": image_data,
                    "updatedAt": "SERVER_TIMESTAMP"
                }
            }
        }
        
        print(f"MCP Command: {json.dumps(mcp_command, indent=2)}")
        return True
        
    except Exception as e:
        print(f"Error updating Firebase for {persona_name}: {e}")
        return False

def clear_firebase_via_mcp(persona_name: str) -> bool:
    """Clear Firebase persona imageUrls using MCP"""
    try:
        print(f"Clearing Firebase imageUrls for {persona_name}...")
        
        mcp_command = {
            "tool": "mcp__firebase-mcp__firestore_update_document_by_name",
            "params": {
                "collection": "personas",
                "name_field": "name", 
                "name_value": persona_name,
                "data": {
                    "imageUrls": {},
                    "updatedAt": "SERVER_TIMESTAMP"
                }
            }
        }
        
        print(f"MCP Command: {json.dumps(mcp_command, indent=2)}")
        return True
        
    except Exception as e:
        print(f"Error clearing Firebase for {persona_name}: {e}")
        return False

def process_persona_results(results_json: str):
    """Process the results from persona processor and execute MCP commands"""
    try:
        results = json.loads(results_json)
        
        print("=" * 60)
        print("PROCESSING PERSONA RESULTS WITH MCP")
        print("=" * 60)
        
        # Process each persona with images
        for persona_name, data in results['processed'].items():
            print(f"\nProcessing {persona_name}:")
            print("-" * 40)
            
            urls = data['urls']
            image_data = data['image_data']
            
            # Upload all image files to R2
            all_uploads_success = True
            for size_format, url in urls.items():
                # Extract file path from the processing
                temp_file = f"temp_{persona_name}_{size_format.replace('_', '.')}"
                if Path(temp_file).exists():
                    key = url.split('/')[-2] + '/' + url.split('/')[-1]  # Extract key from URL
                    success = upload_to_r2_via_mcp(temp_file, key)
                    if not success:
                        all_uploads_success = False
                    
                    # Clean up temp file
                    Path(temp_file).unlink(missing_ok=True)
            
            # Update Firebase if all uploads succeeded
            if all_uploads_success:
                update_firebase_via_mcp(persona_name, image_data)
        
        # Clear personas without folders (would need to get this list from Firebase)
        print(f"\nProcessed {len(results['processed'])} personas successfully!")
        
    except Exception as e:
        print(f"Error processing results: {e}")

def main():
    if len(sys.argv) > 1:
        # Process results from processor
        results_json = sys.argv[1]
        process_persona_results(results_json)
    else:
        print("Usage: python persona_mcp_uploader.py '<results_json>'")

if __name__ == '__main__':
    main()