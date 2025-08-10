#!/usr/bin/env python3
"""
빠른 성능 테스트 스크립트 (50턴)
"""

import os
import sys
import time
import random
import json
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import psutil
import statistics

# Firebase 초기화
def initialize_firebase():
    """Firebase Admin SDK 초기화"""
    try:
        if not firebase_admin._apps:
            service_account_path = os.path.join(
                os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                'firebase-service-account-key.json'
            )
            
            if not os.path.exists(service_account_path):
                print(f"[ERROR] Firebase 서비스 계정 키 파일을 찾을 수 없습니다: {service_account_path}")
                sys.exit(1)
            
            cred = credentials.Certificate(service_account_path)
            firebase_admin.initialize_app(cred)
            print("[OK] Firebase 초기화 완료")
    except Exception as e:
        print(f"[ERROR] Firebase 초기화 실패: {e}")
        sys.exit(1)

# 메시지 패턴
MESSAGE_PATTERNS = [
    "안녕하세요!", "뭐해요?", "오늘 날씨 어때요?", 
    "좋은 아침이에요", "잘 지내셨어요?", "영화 좋아해요?",
    "how are you?", "what's up?", "네", "맞아요", "ㅋㅋㅋ"
]

class QuickTester:
    def __init__(self, user_id: str, persona_id: str):
        self.db = firestore.client()
        self.user_id = user_id
        self.persona_id = persona_id
        self.messages_sent = 0
        self.messages_received = 0
        self.response_times = []
        self.errors = []
        self.start_time = None
        
    def send_message(self, content: str) -> bool:
        """메시지 전송"""
        try:
            message_data = {
                'content': content,
                'timestamp': firestore.SERVER_TIMESTAMP,
                'isFromUser': True,
                'personaId': self.persona_id,
                'type': 'text',
                'isRead': False,
            }
            
            self.db.collection('users').document(self.user_id)\
                   .collection('messages').add(message_data)
            
            self.messages_sent += 1
            return True
            
        except Exception as e:
            self.errors.append(f"전송 실패: {str(e)}")
            return False
    
    def wait_for_response(self, timeout: int = 30) -> bool:
        """AI 응답 대기"""
        start_wait = time.time()
        
        while time.time() - start_wait < timeout:
            try:
                # 최근 메시지 조회
                messages = self.db.collection('users').document(self.user_id)\
                                 .collection('messages')\
                                 .order_by('timestamp', direction=firestore.Query.DESCENDING)\
                                 .limit(10)\
                                 .get()
                
                ai_messages = [msg for msg in messages 
                             if msg.to_dict().get('personaId') == self.persona_id 
                             and not msg.to_dict().get('isFromUser', False)]
                
                if len(ai_messages) > self.messages_received:
                    response_time = time.time() - start_wait
                    self.response_times.append(response_time)
                    self.messages_received = len(ai_messages)
                    return True
                    
            except:
                pass
                
            time.sleep(0.5)
        
        return False
    
    def run_test(self, num_turns: int = 50):
        """테스트 실행"""
        print(f"\n[START] {num_turns}턴 빠른 성능 테스트 시작")
        print(f"[USER] {self.user_id}")
        print(f"[PERSONA] {self.persona_id}")
        print("-" * 50)
        
        self.start_time = time.time()
        
        # 초기 메모리 측정
        process = psutil.Process()
        initial_memory = process.memory_info().rss / 1024 / 1024
        print(f"[MEMORY] 초기 메모리: {initial_memory:.1f}MB")
        
        for i in range(1, num_turns + 1):
            # 진행률 표시 (10턴마다)
            if i % 10 == 0:
                elapsed = time.time() - self.start_time
                avg_response = sum(self.response_times) / len(self.response_times) if self.response_times else 0
                current_memory = process.memory_info().rss / 1024 / 1024
                
                print(f"\n[PROGRESS] {i}/{num_turns} ({i/num_turns*100:.1f}%)")
                print(f"  경과: {elapsed:.1f}초, 평균 응답: {avg_response:.2f}초")
                print(f"  메모리: {current_memory:.1f}MB (+{current_memory-initial_memory:.1f}MB)")
            
            # 메시지 전송
            message = random.choice(MESSAGE_PATTERNS)
            
            if self.send_message(message):
                # AI 응답 대기
                if self.wait_for_response():
                    if i % 10 == 0:  # 10턴마다만 표시
                        print(f"  [{i}] 응답 시간: {self.response_times[-1]:.2f}초")
                else:
                    self.errors.append(f"Turn {i}: Response timeout")
                    if i % 10 == 0:
                        print(f"  [{i}] TIMEOUT")
            
            # 대화 간격
            time.sleep(random.uniform(0.2, 0.5))
        
        # 최종 결과
        self.print_results()
    
    def print_results(self):
        """결과 출력"""
        total_time = time.time() - self.start_time
        process = psutil.Process()
        final_memory = process.memory_info().rss / 1024 / 1024
        
        print("\n" + "=" * 50)
        print("[FINAL RESULTS]")
        print("=" * 50)
        
        print(f"\n[SUMMARY]")
        print(f"  총 시간: {total_time:.1f}초 ({total_time/60:.1f}분)")
        print(f"  전송: {self.messages_sent}, 응답: {self.messages_received}")
        print(f"  응답률: {self.messages_received/self.messages_sent*100:.1f}%")
        print(f"  오류: {len(self.errors)}건")
        
        if self.response_times:
            print(f"\n[RESPONSE TIME]")
            print(f"  평균: {statistics.mean(self.response_times):.2f}초")
            print(f"  중간값: {statistics.median(self.response_times):.2f}초")
            print(f"  최소: {min(self.response_times):.2f}초")
            print(f"  최대: {max(self.response_times):.2f}초")
            if len(self.response_times) > 1:
                print(f"  표준편차: {statistics.stdev(self.response_times):.2f}초")
        
        print(f"\n[MEMORY]")
        print(f"  최종: {final_memory:.1f}MB")
        
        # 성능 분석
        print(f"\n[ANALYSIS]")
        if self.response_times:
            avg_response = statistics.mean(self.response_times)
            if avg_response > 5:
                print("  [!] 응답 시간이 느립니다 (평균 5초 초과)")
            elif avg_response > 3:
                print("  [!] 응답 시간이 다소 느립니다 (평균 3-5초)")
            else:
                print("  [OK] 응답 시간이 양호합니다 (평균 3초 이하)")
            
            if len(self.response_times) > 1:
                std_dev = statistics.stdev(self.response_times)
                if std_dev > 3:
                    print("  [!] 응답 시간 편차가 큽니다 (표준편차 3초 초과)")
                else:
                    print("  [OK] 응답 시간이 일정합니다")
        
        response_rate = self.messages_received/self.messages_sent if self.messages_sent > 0 else 0
        if response_rate < 0.9:
            print(f"  [!] 응답률이 낮습니다 ({response_rate*100:.1f}%)")
        else:
            print(f"  [OK] 응답률이 양호합니다 ({response_rate*100:.1f}%)")
        
        # 결과 저장
        self.save_results()
    
    def save_results(self):
        """결과 JSON 저장"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        results = {
            'test_info': {
                'user_id': self.user_id,
                'persona_id': self.persona_id,
                'timestamp': timestamp,
                'duration': time.time() - self.start_time if self.start_time else 0,
                'messages_sent': self.messages_sent,
                'messages_received': self.messages_received
            },
            'performance': {
                'response_times': self.response_times,
                'avg_response': statistics.mean(self.response_times) if self.response_times else 0,
                'median_response': statistics.median(self.response_times) if self.response_times else 0,
                'min_response': min(self.response_times) if self.response_times else 0,
                'max_response': max(self.response_times) if self.response_times else 0,
                'std_dev': statistics.stdev(self.response_times) if len(self.response_times) > 1 else 0
            },
            'errors': self.errors
        }
        
        os.makedirs('test_results', exist_ok=True)
        filename = f'test_results/quick_test_{timestamp}.json'
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        
        print(f"\n[SAVED] {filename}")

def main():
    """메인 함수"""
    # Firebase 초기화
    initialize_firebase()
    
    # 테스트 실행
    user_id = "05SMvhBIw7WEf6pNXyN4zcBhLvr2"
    persona_id = "1aD0ZX6NFq3Ij2FScLCK"
    
    tester = QuickTester(user_id, persona_id)
    tester.run_test(50)

if __name__ == "__main__":
    main()