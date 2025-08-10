import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import json
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
try:
    # 상위 디렉토리에서 서비스 계정 키 파일 찾기
    import os
    service_account_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'firebase-service-account-key.json')
    if not os.path.exists(service_account_path):
        # scripts 폴더 내에서 찾기
        service_account_path = 'firebase-service-account-key.json'
    
    cred = credentials.Certificate(service_account_path)
    firebase_admin.initialize_app(cred)
except ValueError:
    # 이미 초기화된 경우
    pass
except FileNotFoundError:
    print("Error: firebase-service-account-key.json 파일을 찾을 수 없습니다.")
    print("프로젝트 루트 또는 scripts 폴더에 파일을 배치해주세요.")
    sys.exit(1)

db = firestore.client()

def upload_test_scenarios():
    """테스트 시나리오를 Firebase에 업로드합니다."""
    
    # JSON 파일 읽기
    with open('test_chat_scenarios.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    scenarios = data['test_scenarios']
    uploaded_count = 0
    
    print(f"📤 {len(scenarios)}개의 테스트 시나리오를 업로드합니다...")
    
    for scenario in scenarios:
        # Firebase 문서 형식으로 변환
        error_doc = {
            'error_key': scenario['id'],
            'persona': scenario['persona_id'],
            'persona_name': scenario['persona_name'],
            'chat': scenario['chat'],
            'created_at': firestore.SERVER_TIMESTAMP,
            'is_test': True,  # 테스트 데이터임을 표시
            'is_check': False,  # 분석 대상
            'expected_issues': scenario.get('expected_issues', []),
            'scenario_name': scenario['scenario_name']
        }
        
        # Firebase에 업로드
        try:
            db.collection('chat_error_fix').document(scenario['id']).set(error_doc)
            print(f"✅ {scenario['id']}: {scenario['scenario_name']} - 업로드 완료")
            uploaded_count += 1
        except Exception as e:
            print(f"❌ {scenario['id']}: {scenario['scenario_name']} - 업로드 실패: {e}")
    
    print(f"\n📊 업로드 결과: {uploaded_count}/{len(scenarios)} 성공")
    return uploaded_count

def clean_test_data():
    """이전 테스트 데이터를 삭제합니다."""
    print("🧹 이전 테스트 데이터를 정리합니다...")
    
    # is_test가 True인 문서들 조회
    test_docs = db.collection('chat_error_fix').where('is_test', '==', True).get()
    
    deleted_count = 0
    for doc in test_docs:
        doc.reference.delete()
        deleted_count += 1
    
    print(f"✅ {deleted_count}개의 이전 테스트 데이터 삭제 완료")
    return deleted_count

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='테스트 시나리오 업로드 도구')
    parser.add_argument('--clean', action='store_true', help='이전 테스트 데이터 삭제')
    args = parser.parse_args()
    
    if args.clean:
        clean_test_data()
    
    upload_test_scenarios()