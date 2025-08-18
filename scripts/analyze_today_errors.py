"""
오늘 발생한 대화 오류만 분석하는 스크립트
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta
import json
import sys
import io
import os
from analyze_chat_errors import ContextAnalyzer, print_analysis_summary, save_analysis_results

# UTF-8 인코딩 설정
import locale
if sys.platform == 'win32':
    # Windows에서 UTF-8 출력 활성화
    import os
    os.system('chcp 65001 > nul 2>&1')  # UTF-8 코드 페이지 설정

# Firebase 초기화
try:
    if not firebase_admin._apps:
        # 상위 디렉토리에서 서비스 계정 키 파일 찾기
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

def analyze_today_errors():
    """오늘 발생한 오류만 분석합니다."""
    
    # 오늘 날짜 계산 (UTC 기준)
    from datetime import timezone
    today_start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
    
    print(f"Date: {today_start.strftime('%Y-%m-%d')} Error Analysis")
    print("="*80)
    
    # 오늘 생성된 문서 조회
    today_reports = db.collection('chat_error_fix')\
        .where('created_at', '>=', today_start)\
        .get()
    
    if not today_reports:
        print("No new errors today.")
        return
    
    print(f"Today's errors: {len(today_reports)}\n")
    
    # 맥락 분석기 초기화
    analyzer = ContextAnalyzer()
    analyses = []
    
    # 각 보고서 분석
    for doc in today_reports:
        data = doc.to_dict()
        error_key = data.get('error_key', 'Unknown')
        persona_name = data.get('persona_name', 'Unknown')
        persona_id = data.get('persona', 'Unknown')
        chat_messages = data.get('chat', [])
        created_at = data.get('created_at')
        
        # 시간 표시
        if created_at:
            time_str = created_at.strftime('%H:%M:%S')
        else:
            time_str = 'Unknown'
            
        print(f"[{time_str}] Analyzing: {error_key} - {persona_name}")
        
        # 대화 분석 수행
        analysis = analyzer.analyze_conversation(
            messages=chat_messages,
            persona_name=persona_name,
            persona_id=persona_id,
            error_key=error_key
        )
        analyses.append(analysis)
        
        # 분석 완료 후 체크 표시 (옵션)
        # 주석 해제하면 분석 후 자동으로 체크됨
        # doc.reference.update({'is_check': True})
    
    # 분석 결과 출력
    print_analysis_summary(analyses)
    
    # 결과 저장
    if analyses:
        summary_path, detailed_path = save_analysis_results(analyses, output_dir="analysis_results/today")
        print(f"\nCompleted: {len(today_reports)} errors analyzed today")
        
        # 심각한 문제가 있으면 경고
        critical_count = sum(1 for a in analyses for i in a.context_issues if i.severity.value == "critical")
        if critical_count > 0:
            print(f"\nWarning: {critical_count} critical issues found!")
            print("Immediate attention required.")
    
    return analyses

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='오늘 발생한 채팅 오류만 분석')
    parser.add_argument('--mark-checked', action='store_true', 
                       help='분석 후 is_check를 true로 표시')
    args = parser.parse_args()
    
    results = analyze_today_errors()
    
    # --mark-checked 옵션이 있으면 체크 표시
    if args.mark_checked and results:
        today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
        today_reports = db.collection('chat_error_fix')\
            .where('created_at', '>=', today_start)\
            .get()
        
        for doc in today_reports:
            doc.reference.update({'is_check': True})
        
        print(f"Marked {len(today_reports)} documents as checked.")