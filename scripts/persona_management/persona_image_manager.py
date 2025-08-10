#!/usr/bin/env python3
"""
통합 페르소나 이미지 관리 도구
이미지 URL 업데이트, 검증, R2 연동 등 이미지 관련 모든 작업 통합

사용법:
    python persona_image_manager.py --action [update|check|optimize] [옵션]
"""

import json
import os
import sys
import argparse
import requests
from datetime import datetime
from typing import List, Dict, Optional, Tuple
from PIL import Image
import io

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

class PersonaImageManager:
    """페르소나 이미지 관리 클래스"""
    
    def __init__(self):
        self.base_url = "https://teamsona.work/personas"
        self.local_assets_path = os.path.join(
            os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
            'assets', 'personas'
        )
        self.image_sizes = ['thumb', 'small', 'medium', 'large', 'original']
        
    def generate_image_urls(self, english_name: str) -> Dict:
        """표준 imageUrls 구조 생성"""
        base_url = f"{self.base_url}/{english_name}"
        
        return {
            "thumb": {"jpg": f"{base_url}/main_thumb.jpg"},
            "small": {"jpg": f"{base_url}/main_small.jpg"},
            "medium": {"jpg": f"{base_url}/main_medium.jpg"},
            "large": {"jpg": f"{base_url}/main_large.jpg"},
            "original": {"jpg": f"{base_url}/main_original.jpg"}
        }
    
    def check_r2_image(self, url: str) -> Tuple[bool, Optional[int]]:
        """R2의 이미지 URL 확인"""
        try:
            response = requests.head(url, timeout=5)
            if response.status_code == 200:
                content_length = response.headers.get('Content-Length')
                return True, int(content_length) if content_length else None
            return False, None
        except Exception:
            return False, None
    
    def check_persona_images(self, persona_name: str) -> Dict:
        """특정 페르소나의 모든 이미지 확인"""
        results = {}
        image_urls = self.generate_image_urls(persona_name)
        
        for size, urls in image_urls.items():
            url = urls.get('jpg')
            if url:
                exists, file_size = self.check_r2_image(url)
                results[size] = {
                    'url': url,
                    'exists': exists,
                    'size': file_size
                }
        
        return results
    
    def update_firebase_urls(self, doc_id: str, english_name: str) -> bool:
        """Firebase의 imageUrls 필드 업데이트"""
        try:
            doc_ref = db.collection('personas').document(doc_id)
            image_urls = self.generate_image_urls(english_name)
            
            doc_ref.update({
                'imageUrls': image_urls,
                'updatedAt': firestore.SERVER_TIMESTAMP
            })
            return True
        except Exception as e:
            print(f"Error updating {doc_id}: {str(e)}")
            return False
    
    def scan_local_images(self) -> Dict:
        """로컬 assets 폴더의 이미지 스캔"""
        if not os.path.exists(self.local_assets_path):
            print(f"경로를 찾을 수 없습니다: {self.local_assets_path}")
            return {}
        
        personas = {}
        for folder in os.listdir(self.local_assets_path):
            folder_path = os.path.join(self.local_assets_path, folder)
            if os.path.isdir(folder_path):
                images = {}
                for size in self.image_sizes:
                    image_path = os.path.join(folder_path, f"main_{size}.jpg")
                    if os.path.exists(image_path):
                        file_size = os.path.getsize(image_path)
                        images[size] = {
                            'path': image_path,
                            'size': file_size
                        }
                
                if images:
                    personas[folder] = images
        
        return personas
    
    def optimize_image(self, input_path: str, output_path: str, 
                      size: Tuple[int, int], quality: int = 95) -> bool:
        """이미지 최적화"""
        try:
            with Image.open(input_path) as img:
                # EXIF 회전 정보 처리
                img = img.convert('RGB')
                
                # 리사이즈 (비율 유지)
                img.thumbnail(size, Image.Resampling.LANCZOS)
                
                # 저장
                img.save(output_path, 'JPEG', quality=quality, optimize=True)
                return True
        except Exception as e:
            print(f"이미지 최적화 오류: {str(e)}")
            return False
    
    def batch_optimize_images(self, persona_folder: str) -> Dict:
        """페르소나 폴더의 모든 이미지 최적화"""
        sizes = {
            'thumb': (150, 150),
            'small': (300, 300),
            'medium': (600, 600),
            'large': (1200, 1200),
            'original': None  # 원본 유지
        }
        
        source_folder = os.path.join(self.local_assets_path, persona_folder)
        if not os.path.exists(source_folder):
            print(f"폴더를 찾을 수 없습니다: {source_folder}")
            return {}
        
        # 원본 이미지 찾기
        original_image = None
        for file in os.listdir(source_folder):
            if file.lower().endswith(('.jpg', '.jpeg', '.png')):
                original_image = os.path.join(source_folder, file)
                break
        
        if not original_image:
            print(f"원본 이미지를 찾을 수 없습니다: {persona_folder}")
            return {}
        
        results = {}
        for size_name, dimensions in sizes.items():
            output_path = os.path.join(source_folder, f"main_{size_name}.jpg")
            
            if size_name == 'original':
                # 원본은 품질만 조정
                success = self.optimize_image(original_image, output_path, 
                                            (10000, 10000), quality=98)
            else:
                success = self.optimize_image(original_image, output_path, 
                                            dimensions, quality=95)
            
            results[size_name] = {
                'success': success,
                'path': output_path if success else None
            }
        
        return results
    
    def verify_all_personas(self) -> Dict:
        """모든 페르소나의 이미지 상태 확인"""
        personas_ref = db.collection('personas')
        personas = personas_ref.stream()
        
        report = {
            'total': 0,
            'complete': 0,
            'incomplete': [],
            'missing': []
        }
        
        for persona in personas:
            report['total'] += 1
            data = persona.to_dict()
            name = data.get('name', 'Unknown')
            image_urls = data.get('imageUrls', {})
            
            if not image_urls:
                report['missing'].append(name)
            else:
                # 모든 크기의 이미지가 있는지 확인
                has_all = all(
                    size in image_urls and 
                    image_urls[size].get('jpg')
                    for size in self.image_sizes
                )
                
                if has_all:
                    report['complete'] += 1
                else:
                    report['incomplete'].append(name)
        
        return report

def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(description='페르소나 이미지 관리 도구')
    parser.add_argument('--action', 
                      choices=['update', 'check', 'optimize', 'verify'],
                      default='verify',
                      help='실행할 작업')
    parser.add_argument('--persona', 
                      help='특정 페르소나 이름 (영문)')
    parser.add_argument('--doc-id',
                      help='Firebase 문서 ID')
    parser.add_argument('--all', action='store_true',
                      help='모든 페르소나 처리')
    
    args = parser.parse_args()
    manager = PersonaImageManager()
    
    if args.action == 'update':
        if args.persona and args.doc_id:
            success = manager.update_firebase_urls(args.doc_id, args.persona)
            if success:
                print(f"✅ {args.persona} 이미지 URL 업데이트 완료")
            else:
                print(f"❌ {args.persona} 업데이트 실패")
        else:
            print("Error: --persona와 --doc-id가 필요합니다")
    
    elif args.action == 'check':
        if args.persona:
            print(f"\n🔍 {args.persona} 이미지 확인 중...")
            results = manager.check_persona_images(args.persona)
            
            for size, info in results.items():
                status = "✅" if info['exists'] else "❌"
                size_str = f"({info['size']} bytes)" if info['size'] else ""
                print(f"  {status} {size}: {size_str}")
        else:
            print("Error: --persona가 필요합니다")
    
    elif args.action == 'optimize':
        if args.persona:
            print(f"\n🎨 {args.persona} 이미지 최적화 중...")
            results = manager.batch_optimize_images(args.persona)
            
            for size, info in results.items():
                status = "✅" if info['success'] else "❌"
                print(f"  {status} {size}")
        else:
            print("Error: --persona가 필요합니다")
    
    elif args.action == 'verify':
        print("\n📊 전체 페르소나 이미지 상태 확인 중...")
        report = manager.verify_all_personas()
        
        print(f"\n총 페르소나: {report['total']}개")
        print(f"✅ 완전: {report['complete']}개")
        print(f"⚠️  불완전: {len(report['incomplete'])}개")
        print(f"❌ 누락: {len(report['missing'])}개")
        
        if report['incomplete']:
            print("\n불완전한 페르소나:")
            for name in report['incomplete'][:10]:
                print(f"  - {name}")
            if len(report['incomplete']) > 10:
                print(f"  ... 외 {len(report['incomplete'])-10}개")
        
        if report['missing']:
            print("\n이미지 누락 페르소나:")
            for name in report['missing'][:10]:
                print(f"  - {name}")
            if len(report['missing']) > 10:
                print(f"  ... 외 {len(report['missing'])-10}개")

if __name__ == "__main__":
    main()