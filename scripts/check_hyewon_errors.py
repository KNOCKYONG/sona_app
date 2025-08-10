#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
혜원 페르소나와의 대화 오류를 확인하는 스크립트
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta
import json
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def check_hyewon_errors():
    """혜원과의 최근 대화 오류 확인"""
    print("🔍 혜원 페르소나 대화 오류 확인 중...")
    
    # 최근 7일간의 오류만 확인
    seven_days_ago = datetime.now() - timedelta(days=7)
    
    # chat_error_fix 컬렉션에서 혜원 관련 오류 검색
    error_collection = db.collection('chat_error_fix')
    
    # 페르소나 이름으로 필터링
    query = error_collection.where('persona_name', '==', '혜원').order_by('timestamp', direction=firestore.Query.DESCENDING).limit(10)
    
    try:
        docs = query.get()
        
        if not docs:
            print("❌ 혜원과의 대화 오류가 없습니다.")
            
            # 전체 최근 오류 중 확인
            print("\n📋 최근 오류 목록 (모든 페르소나):")
            all_errors = error_collection.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(5).get()
            
            for doc in all_errors:
                data = doc.to_dict()
                persona = data.get('persona_name', '알 수 없음')
                timestamp = data.get('timestamp', '')
                platform = data.get('platform', 'Unknown')
                device = data.get('device_info', {})
                
                print(f"\n- 페르소나: {persona}")
                print(f"  시간: {timestamp}")
                print(f"  플랫폼: {platform}")
                print(f"  디바이스: {device.get('model', 'Unknown')}")
                print(f"  체크 여부: {'✅' if data.get('is_check') else '❌'}")
                
                # 대화 내용 일부 출력
                messages = data.get('messages', [])
                if messages:
                    print(f"  최근 대화:")
                    for msg in messages[-3:]:
                        role = "👤" if msg.get('isUser') else "🤖"
                        content = msg.get('content', '')[:50]
                        print(f"    {role} {content}...")
            return
            
        print(f"✅ 혜원과의 대화 오류 {len(docs)}개 발견")
        
        for doc in docs:
            data = doc.to_dict()
            print(f"\n{'='*60}")
            print(f"📅 시간: {data.get('timestamp')}")
            print(f"📱 플랫폼: {data.get('platform', 'Unknown')}")
            
            # iOS 디바이스 정보
            device_info = data.get('device_info', {})
            if device_info:
                print(f"📲 디바이스: {device_info.get('model', 'Unknown')}")
                print(f"   OS: {device_info.get('os', 'Unknown')} {device_info.get('os_version', '')}")
            
            # 체크 여부
            is_checked = data.get('is_check', False)
            print(f"✅ 체크 여부: {'완료' if is_checked else '미완료'}")
            
            # 대화 내용
            messages = data.get('messages', [])
            if messages:
                print("\n💬 대화 내용:")
                for i, msg in enumerate(messages):
                    is_user = msg.get('isUser', False)
                    content = msg.get('content', '')
                    timestamp = msg.get('timestamp', '')
                    
                    role = "👤 사용자" if is_user else "🤖 혜원"
                    print(f"\n  [{i+1}] {role} ({timestamp}):")
                    print(f"      {content}")
            
            # 오류 설명
            error_description = data.get('error_description', '')
            if error_description:
                print(f"\n⚠️ 오류 설명: {error_description}")
                
    except Exception as e:
        print(f"❌ 오류 발생: {e}")
        print("\n💡 Firebase 할당량이 초과되었을 수 있습니다.")

if __name__ == "__main__":
    check_hyewon_errors()