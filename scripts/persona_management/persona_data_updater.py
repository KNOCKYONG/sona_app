#!/usr/bin/env python3
"""
통합 페르소나 데이터 업데이트 도구
설명, 역할, 토픽, 키워드 등 페르소나 데이터 일괄 업데이트

사용법:
    python persona_data_updater.py --field [description|role|topics] --file data.json
"""

import json
import os
import sys
import argparse
from datetime import datetime
from typing import List, Dict, Optional, Any

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

class PersonaDataUpdater:
    """페르소나 데이터 업데이트 관리 클래스"""
    
    def __init__(self):
        self.success_count = 0
        self.error_count = 0
        self.errors = []
        
    def update_persona_field(self, doc_id: str, field_name: str, value: Any) -> bool:
        """단일 페르소나의 특정 필드 업데이트"""
        try:
            doc_ref = db.collection('personas').document(doc_id)
            
            # 문서 존재 확인
            doc = doc_ref.get()
            if not doc.exists:
                print(f"  ❌ 문서 ID {doc_id}: 찾을 수 없음")
                self.errors.append(f"ID {doc_id}: 문서 없음")
                return False
            
            # 업데이트
            update_data = {
                field_name: value,
                'updatedAt': firestore.SERVER_TIMESTAMP
            }
            
            doc_ref.update(update_data)
            persona_name = doc.to_dict().get('name', 'Unknown')
            print(f"  ✅ {persona_name}: {field_name} 업데이트 완료")
            self.success_count += 1
            return True
            
        except Exception as e:
            print(f"  ❌ 오류: {str(e)}")
            self.errors.append(f"ID {doc_id}: {str(e)}")
            self.error_count += 1
            return False
    
    def batch_update_descriptions(self, descriptions: Dict[str, str]) -> None:
        """여러 페르소나의 설명 일괄 업데이트"""
        print(f"\n📝 {len(descriptions)}개 페르소나 설명 업데이트 시작...")
        
        for doc_id, description in descriptions.items():
            self.update_persona_field(doc_id, 'description', description)
    
    def batch_update_roles(self, roles: Dict[str, str]) -> None:
        """여러 페르소나의 역할 일괄 업데이트"""
        print(f"\n👤 {len(roles)}개 페르소나 역할 업데이트 시작...")
        
        for doc_id, role in roles.items():
            self.update_persona_field(doc_id, 'role', role)
    
    def batch_update_topics(self, topics_data: Dict[str, List[str]]) -> None:
        """여러 페르소나의 관심 주제 일괄 업데이트"""
        print(f"\n🏷️ {len(topics_data)}개 페르소나 토픽 업데이트 시작...")
        
        for doc_id, topics in topics_data.items():
            self.update_persona_field(doc_id, 'topics', topics)
    
    def batch_update_keywords(self, keywords_data: Dict[str, List[str]]) -> None:
        """여러 페르소나의 키워드 일괄 업데이트"""
        print(f"\n🔑 {len(keywords_data)}개 페르소나 키워드 업데이트 시작...")
        
        for doc_id, keywords in keywords_data.items():
            self.update_persona_field(doc_id, 'keywords', keywords)
    
    def migrate_topics_to_keywords(self) -> None:
        """모든 페르소나의 topics를 keywords로 마이그레이션"""
        print("\n🔄 topics → keywords 마이그레이션 시작...")
        
        personas_ref = db.collection('personas')
        personas = personas_ref.stream()
        
        migrated = 0
        for persona in personas:
            data = persona.to_dict()
            
            # topics가 있고 keywords가 없는 경우
            if data.get('topics') and not data.get('keywords'):
                doc_ref = personas_ref.document(persona.id)
                doc_ref.update({
                    'keywords': data['topics'],
                    'updatedAt': firestore.SERVER_TIMESTAMP
                })
                print(f"  ✅ {data.get('name', 'Unknown')}: 마이그레이션 완료")
                migrated += 1
        
        print(f"\n총 {migrated}개 페르소나 마이그레이션 완료")
    
    def update_from_json_file(self, file_path: str, field_name: str) -> None:
        """JSON 파일에서 데이터를 읽어 업데이트"""
        if not os.path.exists(file_path):
            print(f"Error: 파일을 찾을 수 없습니다: {file_path}")
            return
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            if field_name == 'description':
                self.batch_update_descriptions(data)
            elif field_name == 'role':
                self.batch_update_roles(data)
            elif field_name == 'topics':
                self.batch_update_topics(data)
            elif field_name == 'keywords':
                self.batch_update_keywords(data)
            else:
                print(f"Error: 지원하지 않는 필드: {field_name}")
                
        except json.JSONDecodeError as e:
            print(f"Error: JSON 파일 파싱 오류: {str(e)}")
        except Exception as e:
            print(f"Error: {str(e)}")
    
    def export_current_data(self, field_name: str, output_file: str) -> None:
        """현재 데이터를 JSON 파일로 내보내기"""
        print(f"\n📤 {field_name} 데이터 내보내기 중...")
        
        personas_ref = db.collection('personas')
        personas = personas_ref.stream()
        
        data = {}
        for persona in personas:
            doc_data = persona.to_dict()
            if field_name in doc_data:
                data[persona.id] = doc_data[field_name]
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"✅ {len(data)}개 페르소나 데이터를 {output_file}에 저장했습니다.")
    
    def verify_data_integrity(self) -> Dict:
        """모든 페르소나의 데이터 무결성 확인"""
        print("\n🔍 데이터 무결성 확인 중...")
        
        personas_ref = db.collection('personas')
        personas = personas_ref.stream()
        
        report = {
            'total': 0,
            'missing_description': [],
            'missing_role': [],
            'missing_keywords': [],
            'missing_imageUrls': []
        }
        
        for persona in personas:
            report['total'] += 1
            data = persona.to_dict()
            name = data.get('name', 'Unknown')
            
            if not data.get('description'):
                report['missing_description'].append(name)
            if not data.get('role'):
                report['missing_role'].append(name)
            if not data.get('keywords'):
                report['missing_keywords'].append(name)
            if not data.get('imageUrls'):
                report['missing_imageUrls'].append(name)
        
        return report
    
    def print_summary(self) -> None:
        """업데이트 결과 요약 출력"""
        print("\n" + "="*50)
        print("📊 업데이트 완료 요약")
        print("="*50)
        print(f"✅ 성공: {self.success_count}개")
        print(f"❌ 실패: {self.error_count}개")
        
        if self.errors:
            print("\n오류 상세:")
            for error in self.errors[:10]:
                print(f"  - {error}")
            if len(self.errors) > 10:
                print(f"  ... 외 {len(self.errors)-10}개")
        
        print(f"\n완료 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(description='페르소나 데이터 업데이트 도구')
    parser.add_argument('--action',
                      choices=['update', 'export', 'migrate', 'verify'],
                      default='verify',
                      help='실행할 작업')
    parser.add_argument('--field',
                      choices=['description', 'role', 'topics', 'keywords'],
                      help='업데이트할 필드')
    parser.add_argument('--file',
                      help='입력/출력 JSON 파일 경로')
    
    args = parser.parse_args()
    updater = PersonaDataUpdater()
    
    if args.action == 'update':
        if not args.field or not args.file:
            print("Error: update 작업에는 --field와 --file이 필요합니다")
            print("예: --action update --field description --file data.json")
            sys.exit(1)
        updater.update_from_json_file(args.file, args.field)
        updater.print_summary()
    
    elif args.action == 'export':
        if not args.field or not args.file:
            print("Error: export 작업에는 --field와 --file이 필요합니다")
            print("예: --action export --field description --file output.json")
            sys.exit(1)
        updater.export_current_data(args.field, args.file)
    
    elif args.action == 'migrate':
        updater.migrate_topics_to_keywords()
    
    elif args.action == 'verify':
        report = updater.verify_data_integrity()
        
        print(f"\n📊 데이터 무결성 보고서")
        print(f"총 페르소나: {report['total']}개")
        
        for field, missing in report.items():
            if field != 'total' and missing:
                field_name = field.replace('missing_', '').replace('_', ' ')
                print(f"\n{field_name} 누락: {len(missing)}개")
                for name in missing[:5]:
                    print(f"  - {name}")
                if len(missing) > 5:
                    print(f"  ... 외 {len(missing)-5}개")

if __name__ == "__main__":
    main()