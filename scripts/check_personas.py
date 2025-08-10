import firebase_admin
from firebase_admin import credentials, firestore
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 페르소나 목록 가져오기
personas = db.collection('personas').limit(10).get()

print("사용 가능한 페르소나 목록:")
print("-" * 40)
for p in personas:
    data = p.to_dict()
    print(f"ID: {p.id}")
    print(f"  이름: {data.get('name', 'Unknown')}")
    print(f"  MBTI: {data.get('mbti', 'N/A')}")
    print()