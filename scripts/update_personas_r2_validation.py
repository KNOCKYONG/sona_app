#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Firebase personas 컬렉션에 hasValidR2Image 필드를 추가하는 스크립트
R2 이미지 유효성을 미리 검증하여 성능 향상
"""

import json
import os
import sys
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import re

# UTF-8 인코딩 설정
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer)
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer)

# Firebase Admin SDK 초기화
if not firebase_admin._apps:
    # 서비스 계정 키 경로
    cred_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'firebase-service-account-key.json')
    
    if not os.path.exists(cred_path):
        print(f"❌ Firebase 서비스 계정 키를 찾을 수 없습니다: {cred_path}")
        print("   firebase-service-account-key.json 파일을 프로젝트 루트에 추가해주세요.")
        exit(1)
    
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)

db = firestore.client()

def has_r2_image(image_urls):
    """R2 이미지 유효성 빠른 검증"""
    if not image_urls:
        return False
    
    # JSON 문자열로 변환하여 패턴 매칭
    try:
        json_str = json.dumps(image_urls)
        r2_pattern = re.compile(r'(teamsona\.work|r2\.dev|cloudflare|imagedelivery\.net)')
        return bool(r2_pattern.search(json_str))
    except:
        return False

def update_personas_r2_validation():
    """모든 페르소나에 hasValidR2Image 필드 추가"""
    print("🔄 Personas R2 validation 필드 업데이트 시작...")
    
    try:
        # 모든 페르소나 가져오기
        personas_ref = db.collection('personas')
        personas = personas_ref.stream()
        
        total_personas = 0
        updated_personas = 0
        personas_with_r2 = 0
        personas_without_r2 = 0
        
        # 배치 업데이트를 위한 준비
        batch = db.batch()
        batch_count = 0
        
        for persona_doc in personas:
            total_personas += 1
            persona_data = persona_doc.to_dict()
            persona_id = persona_doc.id
            name = persona_data.get('name', 'Unknown')
            
            # imageUrls 필드 확인
            image_urls = persona_data.get('imageUrls')
            current_has_valid_r2 = persona_data.get('hasValidR2Image')
            
            # R2 이미지 유효성 검증
            has_valid_r2 = has_r2_image(image_urls)
            
            # 업데이트 필요한지 확인
            if current_has_valid_r2 != has_valid_r2:
                print(f"  📝 {name}: {current_has_valid_r2} → {has_valid_r2}")
                
                # 배치에 추가
                persona_ref = db.collection('personas').document(persona_id)
                batch.update(persona_ref, {
                    'hasValidR2Image': has_valid_r2,
                    'r2CheckAt': firestore.SERVER_TIMESTAMP
                })
                
                updated_personas += 1
                batch_count += 1
                
                # 500개마다 배치 커밋
                if batch_count >= 500:
                    batch.commit()
                    print(f"  ✅ {batch_count}개 업데이트 완료")
                    batch = db.batch()
                    batch_count = 0
            
            if has_valid_r2:
                personas_with_r2 += 1
            else:
                personas_without_r2 += 1
            
            # 진행 상황 표시
            if total_personas % 10 == 0:
                print(f"  🔍 {total_personas}개 페르소나 처리 중...")
        
        # 남은 배치 커밋
        if batch_count > 0:
            batch.commit()
            print(f"  ✅ 마지막 {batch_count}개 업데이트 완료")
        
        print(f"\n📊 최종 결과:")
        print(f"  - 전체 페르소나: {total_personas}개")
        print(f"  - R2 이미지 있음: {personas_with_r2}개")
        print(f"  - R2 이미지 없음: {personas_without_r2}개")
        print(f"  - 업데이트된 페르소나: {updated_personas}개")
        
    except Exception as e:
        print(f"❌ 오류 발생: {e}")
        import traceback
        traceback.print_exc()

def verify_update():
    """업데이트 검증"""
    print("\n🔍 업데이트 검증 중...")
    
    try:
        # hasValidR2Image 필드가 있는 문서 수 확인
        personas_ref = db.collection('personas')
        
        # true인 문서 수
        true_query = personas_ref.where('hasValidR2Image', '==', True).limit(1000).get()
        true_count = len(true_query)
        
        # false인 문서 수
        false_query = personas_ref.where('hasValidR2Image', '==', False).limit(1000).get()
        false_count = len(false_query)
        
        print(f"  ✅ hasValidR2Image = true: {true_count}개")
        print(f"  ❌ hasValidR2Image = false: {false_count}개")
        
        # 샘플 출력
        print("\n📋 샘플 (R2 이미지 있는 페르소나):")
        for i, doc in enumerate(true_query):
            if i >= 3:
                break
            data = doc.to_dict()
            print(f"  - {data.get('name', 'Unknown')} (ID: {doc.id[:8]}...)")
        
    except Exception as e:
        print(f"❌ 검증 중 오류 발생: {e}")

if __name__ == "__main__":
    update_personas_r2_validation()
    verify_update()