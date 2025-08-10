#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
빠른 대화 오류 확인 스크립트
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def check_errors():
    """최근 대화 오류 확인"""
    print("대화 오류 확인 중...")
    print("=" * 60)
    
    try:
        # 체크되지 않은 오류 확인
        error_collection = db.collection('chat_error_fix')
        
        # 최근 오류 가져오기 (인덱스 없이)
        recent_query = error_collection.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(20)
        all_docs = recent_query.get()
        
        # 체크되지 않은 것 필터링
        unchecked_docs = [doc for doc in all_docs if not doc.to_dict().get('is_check', False)][:5]
        
        if unchecked_docs:
            print(f"\n[체크되지 않은 오류] {len(unchecked_docs)}개")
            print("-" * 60)
            
            for i, doc in enumerate(unchecked_docs, 1):
                data = doc.to_dict()
                print(f"\n{i}. 페르소나: {data.get('persona_name', '알 수 없음')}")
                print(f"   시간: {data.get('timestamp', '')}")
                print(f"   플랫폼: {data.get('platform', 'Unknown')}")
                
                # 대화 내용 미리보기
                messages = data.get('messages', [])
                if messages and len(messages) >= 2:
                    last_user = None
                    last_ai = None
                    
                    for msg in messages[-4:]:
                        if msg.get('isUser'):
                            last_user = msg.get('content', '')[:100]
                        else:
                            last_ai = msg.get('content', '')[:100]
                    
                    if last_user:
                        print(f"   사용자: {last_user}")
                    if last_ai:
                        print(f"   AI: {last_ai}")
                
                # 오류 설명
                error_desc = data.get('error_description', '')
                if error_desc:
                    print(f"   문제: {error_desc[:100]}")
                
                print(f"   문서 ID: {doc.id}")
        else:
            print("\n체크되지 않은 오류가 없습니다.")
            
        # 최근 오류 (체크 여부 무관)
        print("\n" + "=" * 60)
        print("[최근 오류 전체] (최근 5개)")
        print("-" * 60)
        
        # 이미 가져온 문서에서 최근 5개만 표시
        for i, doc in enumerate(all_docs[:5], 1):
            data = doc.to_dict()
            check_status = "✓" if data.get('is_check') else "✗"
            print(f"\n{i}. [{check_status}] {data.get('persona_name', '알 수 없음')} - {data.get('timestamp', '')[:19]}")
            
    except Exception as e:
        print(f"\n오류 발생: {e}")
        if "Quota exceeded" in str(e):
            print("\nFirebase 할당량이 초과되었습니다. 내일 다시 시도해주세요.")

if __name__ == "__main__":
    check_errors()