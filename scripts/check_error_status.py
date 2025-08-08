#!/usr/bin/env python3
"""
Firebase chat_error_fix 컬렉션 상태 확인
"""

import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import firebase_admin
from firebase_admin import credentials, firestore

# Firebase Admin SDK 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def check_error_status():
    """오류 보고서 상태 확인"""
    try:
        # chat_error_fix 컬렉션 참조
        collection_ref = db.collection('chat_error_fix')
        
        # 모든 문서 가져오기
        all_docs = collection_ref.stream()
        
        checked_count = 0
        unchecked_count = 0
        
        print("=== Chat Error Fix Collection Status ===\n")
        
        for doc in all_docs:
            data = doc.to_dict()
            is_checked = data.get('is_check', False)
            error_key = data.get('error_key', 'Unknown')
            persona_name = data.get('persona_name', 'Unknown')
            
            if is_checked:
                checked_count += 1
                status = "[CHECKED]"
            else:
                unchecked_count += 1
                status = "[UNCHECKED]"
            
            print(f"{status} {doc.id} - Persona: {persona_name}, Key: {error_key}")
        
        print(f"\n=== Summary ===")
        print(f"Total: {checked_count + unchecked_count}")
        print(f"Checked: {checked_count}")
        print(f"Unchecked: {unchecked_count}")
        
    except Exception as e:
        print(f"[ERROR] {e}")

if __name__ == "__main__":
    check_error_status()