#!/usr/bin/env python3
"""
통합 페르소나 배치 업데이트 도구
여러 개의 업데이트 스크립트를 하나로 통합한 버전

사용법:
    python persona_batch_updater.py --mode [all|remaining|specific] --batch-size 5
"""

import json
import time
import argparse
from datetime import datetime
from typing import List, Dict, Optional
import os
import sys

# Firebase Admin SDK 설정
try:
    import firebase_admin
    from firebase_admin import credentials, firestore
    
    # Firebase 초기화
    if not firebase_admin._apps:
        service_account_path = os.path.join(
            os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
            'firebase-service-account-key.json'
        )
        cred = credentials.Certificate(service_account_path)
        firebase_admin.initialize_app(cred)
    
    db = firestore.client()
except ImportError:
    print("Error: firebase-admin 패키지가 설치되지 않았습니다.")
    print("설치: pip install firebase-admin")
    sys.exit(1)
except FileNotFoundError:
    print("Error: firebase-service-account-key.json 파일을 찾을 수 없습니다.")
    sys.exit(1)

# 전체 페르소나 매핑 데이터
ALL_PERSONAS = [
    {"korean": "예슬", "english": "yeseul", "doc_id": "1aD0ZX6NFq3Ij2FScLCK"},
    {"korean": "예림", "english": "yerim", "doc_id": "1uvYHUIVEc9jf3yjdLoF"},
    {"korean": "Dr. 박지은", "english": "dr-park-jieun", "doc_id": "5Q3POc7ean9ynSEOCV8M"},
    {"korean": "상훈", "english": "sanghoon", "doc_id": "6OfH3IIYOcCQaJxK7hEQ"},
    {"korean": "Dr. 김민서", "english": "dr-kim-minseo", "doc_id": "7JQhEOCxKcJb9QYqHxOE"},
    {"korean": "수진", "english": "sujin", "doc_id": "7fz7nYUKCFbgIXkwBVJr"},
    {"korean": "윤미", "english": "yoonmi", "doc_id": "95Y9vKqJQX8a0xMnPlvD"},
    {"korean": "정훈", "english": "jeonghoon", "doc_id": "9sKJQh7EOCxJcbQYqHxO"},
    {"korean": "지우", "english": "jiwoo", "doc_id": "A7JQhEOCxKcJbQYqHxOE"},
    {"korean": "채연", "english": "chaeyeon", "doc_id": "DcmIcZcQI20xN7KQHJEh"},
    {"korean": "하연", "english": "hayeon", "doc_id": "8VAZ6GQN3ubrI3CkTJWP"},
    {"korean": "혜진", "english": "hyejin", "doc_id": "H0VaWAAJtCGFmw6MvJhG"},
    {"korean": "민준", "english": "minjun", "doc_id": "HO7JQxKECcJbQYqHxOEd"},
    {"korean": "나연", "english": "nayeon", "doc_id": "IUGKRK2kJCJcm2pCvA5h"},
    {"korean": "동현", "english": "donghyun", "doc_id": "J3UZ6NYb6fksD3LNn5LR"},
    {"korean": "미연", "english": "miyeon", "doc_id": "JcI85BFIIgRlT5S4kJlP"},
    {"korean": "민수", "english": "minsu", "doc_id": "jqEyXTQcO0WZYXWkQkCQ"},
    {"korean": "박준영", "english": "park-junyoung", "doc_id": "oCQxK7JQhEOQcJhEQJd"},
    {"korean": "성호", "english": "seongho", "doc_id": "n9KEOQYqHxOCJQb7QdJc"},
    {"korean": "세빈", "english": "sebin", "doc_id": "kzCQXdQKhJCcX0ybJQdy"},
    {"korean": "소희", "english": "sohee", "doc_id": "j6vmE3t47TILcvMkmJeM"},
    {"korean": "영훈", "english": "younghoon", "doc_id": "KCQhJ7xOEKcJbQYqHxOE"},
    {"korean": "재성", "english": "jaesung", "doc_id": "qxK7JQhEOQCJhQdEJcO"},
    {"korean": "재현", "english": "jaehyun", "doc_id": "lXO8HQhCdMQ7QqHJQOCc"},
    {"korean": "종호", "english": "jongho", "doc_id": "qEJxKQh7OQCJhEQcJdE"},
    {"korean": "준영", "english": "junyoung", "doc_id": "mtKQ6hJQJOAQxKZqHEQc"},
    {"korean": "준호", "english": "junho", "doc_id": "pCQKh7JExOQCJhQdEJc"},
    {"korean": "진욱", "english": "jinwook", "doc_id": "oeJxKQh7EOQCJ9hQcJd"},
    {"korean": "효진", "english": "hyojin", "doc_id": "ilG8R1OOQCUjCXJ1I6Ag"},
    {"korean": "나나", "english": "nana", "doc_id": "iAgfNQdxCQJkqUOgQgCQ"},
    {"korean": "다은", "english": "daeun", "doc_id": "SNedZFhzCIQ4vOGULV9U"},
    {"korean": "동수", "english": "dongsu", "doc_id": "OvBqb9dQOxJNj0lJOFnH"},
    {"korean": "리나", "english": "rina", "doc_id": "OTCBaJgwCiEKK5VvOT7K"},
    {"korean": "민정", "english": "minjung", "doc_id": "h52YrHl1HdQST0JCyAcv"},
    {"korean": "범준", "english": "beomjun", "doc_id": "cfrA9j8Wt9SnfJOPl8P8"},
    {"korean": "석진", "english": "seokjin", "doc_id": "gsaEzOeJQRBAWEXPjdKq"},
    {"korean": "소영", "english": "soyoung", "doc_id": "cgtCJ0KICtMdWAJvDcFP"},
    {"korean": "수빈", "english": "subin", "doc_id": "hm9z1p8xoZQJnCJMBM67"},
    {"korean": "승호", "english": "seungho", "doc_id": "hwPJOQqC7QYhdEOJKcbJ"},
    {"korean": "시연", "english": "siyeon", "doc_id": "h01KQAQhGdCAYJJOJJCQ"},
    {"korean": "영미", "english": "youngmi", "doc_id": "hfKQCPQSJCQqJRJO2BLz"},
    {"korean": "윤서", "english": "yoonseo", "doc_id": "hjgGJQJJJ1HEKhOCQU0O"},
    {"korean": "윤지", "english": "yunji", "doc_id": "gqJOxHKQ7JhQdCEOJEc"},
    {"korean": "유진", "english": "yujin", "doc_id": "gQEJQCQSJCJJQvO1CvOl"},
    {"korean": "은지", "english": "eunji", "doc_id": "i5O7CGQUJFQJHJOvD8Pn"},
    {"korean": "인성", "english": "inseong", "doc_id": "hdKOQJCQhJ7xEJQcJdOE"},
    {"korean": "재민", "english": "jaemin", "doc_id": "gJCQhJ7KQxEOCJhQdcJE"},
    {"korean": "지훈", "english": "jihoon", "doc_id": "fpJxQh7EOCKQJhQcJdE"},
    {"korean": "태민", "english": "taemin", "doc_id": "fJQCKh7xOEQJhQcdJE"},
    {"korean": "현우", "english": "hyunwoo", "doc_id": "efQOxJKh7EQCJhQcdJE"},
    {"korean": "지윤", "english": "jiyoon", "doc_id": "A7JQhEOCxKcJbQYqHxOF"}
]

class PersonaBatchUpdater:
    """페르소나 배치 업데이트 관리 클래스"""
    
    def __init__(self, batch_size: int = 5):
        self.batch_size = batch_size
        self.success_count = 0
        self.error_count = 0
        self.errors = []
        
    def generate_image_urls(self, english_name: str) -> Dict:
        """표준 imageUrls 구조 생성"""
        base_url = f"https://teamsona.work/personas/{english_name}"
        
        return {
            "thumb": {"jpg": f"{base_url}/main_thumb.jpg"},
            "small": {"jpg": f"{base_url}/main_small.jpg"},
            "medium": {"jpg": f"{base_url}/main_medium.jpg"},
            "large": {"jpg": f"{base_url}/main_large.jpg"},
            "original": {"jpg": f"{base_url}/main_original.jpg"}
        }
    
    def update_persona(self, persona: Dict) -> bool:
        """단일 페르소나 업데이트"""
        try:
            doc_ref = db.collection('personas').document(persona['doc_id'])
            
            # 현재 데이터 확인
            doc = doc_ref.get()
            if not doc.exists:
                print(f"  ❌ {persona['korean']}: 문서를 찾을 수 없음")
                self.errors.append(f"{persona['korean']}: 문서 없음")
                return False
            
            # 업데이트 데이터 준비
            image_urls = self.generate_image_urls(persona['english'])
            update_data = {
                'imageUrls': image_urls,
                'updatedAt': firestore.SERVER_TIMESTAMP
            }
            
            # 업데이트 실행
            doc_ref.update(update_data)
            print(f"  ✅ {persona['korean']} ({persona['english']}): 업데이트 완료")
            self.success_count += 1
            return True
            
        except Exception as e:
            print(f"  ❌ {persona['korean']}: 오류 - {str(e)}")
            self.errors.append(f"{persona['korean']}: {str(e)}")
            self.error_count += 1
            return False
    
    def update_batch(self, personas: List[Dict]) -> None:
        """배치 단위로 페르소나 업데이트"""
        for persona in personas:
            self.update_persona(persona)
            time.sleep(0.2)  # Rate limiting
    
    def update_all(self) -> None:
        """모든 페르소나 업데이트"""
        print(f"\n📦 전체 {len(ALL_PERSONAS)}개 페르소나 업데이트 시작...")
        print(f"배치 크기: {self.batch_size}개씩 처리\n")
        
        # 배치 처리
        for i in range(0, len(ALL_PERSONAS), self.batch_size):
            batch = ALL_PERSONAS[i:i+self.batch_size]
            batch_num = (i // self.batch_size) + 1
            total_batches = (len(ALL_PERSONAS) + self.batch_size - 1) // self.batch_size
            
            print(f"배치 {batch_num}/{total_batches} 처리 중...")
            self.update_batch(batch)
            
            # 마지막 배치가 아니면 잠시 대기
            if i + self.batch_size < len(ALL_PERSONAS):
                print(f"  다음 배치까지 1초 대기...\n")
                time.sleep(1)
    
    def check_remaining(self) -> List[Dict]:
        """imageUrls가 없는 페르소나 확인"""
        remaining = []
        
        for persona in ALL_PERSONAS:
            try:
                doc_ref = db.collection('personas').document(persona['doc_id'])
                doc = doc_ref.get()
                
                if doc.exists:
                    data = doc.to_dict()
                    if not data.get('imageUrls'):
                        remaining.append(persona)
            except Exception as e:
                print(f"확인 오류 - {persona['korean']}: {str(e)}")
        
        return remaining
    
    def update_remaining(self) -> None:
        """imageUrls가 없는 페르소나만 업데이트"""
        print("\n🔍 남은 페르소나 확인 중...")
        remaining = self.check_remaining()
        
        if not remaining:
            print("✅ 모든 페르소나가 이미 업데이트되었습니다!")
            return
        
        print(f"\n📦 {len(remaining)}개 페르소나 업데이트 필요")
        for persona in remaining:
            print(f"  - {persona['korean']} ({persona['english']})")
        
        print(f"\n업데이트 시작...")
        for i in range(0, len(remaining), self.batch_size):
            batch = remaining[i:i+self.batch_size]
            batch_num = (i // self.batch_size) + 1
            total_batches = (len(remaining) + self.batch_size - 1) // self.batch_size
            
            print(f"\n배치 {batch_num}/{total_batches} 처리 중...")
            self.update_batch(batch)
            
            if i + self.batch_size < len(remaining):
                time.sleep(1)
    
    def update_specific(self, persona_names: List[str]) -> None:
        """특정 페르소나만 업데이트"""
        personas_to_update = []
        
        for name in persona_names:
            found = False
            for persona in ALL_PERSONAS:
                if persona['korean'] == name or persona['english'] == name:
                    personas_to_update.append(persona)
                    found = True
                    break
            
            if not found:
                print(f"⚠️  '{name}' 페르소나를 찾을 수 없습니다.")
        
        if personas_to_update:
            print(f"\n📦 {len(personas_to_update)}개 페르소나 업데이트...")
            self.update_batch(personas_to_update)
    
    def print_summary(self) -> None:
        """업데이트 결과 요약 출력"""
        print("\n" + "="*50)
        print("📊 업데이트 완료 요약")
        print("="*50)
        print(f"✅ 성공: {self.success_count}개")
        print(f"❌ 실패: {self.error_count}개")
        
        if self.errors:
            print("\n오류 상세:")
            for error in self.errors:
                print(f"  - {error}")
        
        print(f"\n완료 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(description='페르소나 배치 업데이트 도구')
    parser.add_argument('--mode', choices=['all', 'remaining', 'specific'], 
                      default='remaining',
                      help='업데이트 모드 선택')
    parser.add_argument('--batch-size', type=int, default=5,
                      help='배치 크기 (기본값: 5)')
    parser.add_argument('--personas', nargs='+',
                      help='특정 페르소나 이름들 (specific 모드에서 사용)')
    
    args = parser.parse_args()
    
    # 업데이터 인스턴스 생성
    updater = PersonaBatchUpdater(batch_size=args.batch_size)
    
    # 모드별 실행
    if args.mode == 'all':
        updater.update_all()
    elif args.mode == 'remaining':
        updater.update_remaining()
    elif args.mode == 'specific':
        if not args.personas:
            print("Error: specific 모드에서는 --personas 옵션이 필요합니다.")
            print("예: --mode specific --personas 예슬 수진 하연")
            sys.exit(1)
        updater.update_specific(args.personas)
    
    # 결과 출력
    updater.print_summary()

if __name__ == "__main__":
    main()