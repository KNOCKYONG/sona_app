#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
대화 품질 개선 검증 스크립트
개선된 코드로 동일한 테스트 시나리오를 재분석하여 개선 효과를 측정합니다.
"""

import subprocess
import sys
import os
import json
import time
from datetime import datetime
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def print_header(text):
    """헤더 출력"""
    print("\n" + "="*60)
    print(text.center(60))
    print("="*60)

def run_analysis():
    """분석 실행"""
    print("\n🔄 테스트 시나리오 재분석 중...")
    
    try:
        # analyze_chat_errors.py 실행
        result = subprocess.run(
            [sys.executable, 'scripts/analyze_chat_errors.py', '--recheck'],
            capture_output=True,
            text=True,
            encoding='utf-8'
        )
        
        if result.returncode == 0:
            print("✅ 분석 완료!")
            return True
        else:
            print(f"❌ 분석 실패: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ 실행 오류: {e}")
        return False

def run_comparison():
    """비교 분석 실행"""
    print("\n📊 개선 전후 비교 분석 중...")
    
    try:
        # compare_analysis_results.py 실행
        result = subprocess.run(
            [sys.executable, 'scripts/compare_analysis_results.py'],
            capture_output=True,
            text=True,
            encoding='utf-8'
        )
        
        print(result.stdout)
        
        if result.returncode == 0:
            return True
        else:
            print(f"❌ 비교 실패: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ 실행 오류: {e}")
        return False

def generate_report():
    """최종 보고서 생성"""
    print("\n📝 개선 보고서 생성 중...")
    
    report = []
    report.append("# 대화 품질 개선 검증 보고서")
    report.append(f"\n생성 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append("\n## 실행된 개선사항")
    report.append("### 1. ChatOrchestrator")
    report.append("- 질문 유형 분석 강화")
    report.append("- 직접 답변 필수 로직 추가")
    report.append("- 이전 질문 무시 방지")
    report.append("\n### 2. OptimizedPromptService")
    report.append("- 회피 방지 가이드라인 강화")
    report.append("- 직접 답변 예시 추가")
    report.append("- 첫 인사 아이스브레이킹 개선")
    report.append("\n### 3. SecurityAwarePostProcessor")
    report.append("- 매크로 응답 감지 시스템 구현")
    report.append("- 자연스러운 표현 변환 확대")
    report.append("- 최근 응답 추적 및 유사도 계산")
    
    # 최신 분석 결과 로드
    import glob
    analysis_dir = 'analysis_results'
    comparison_files = glob.glob(os.path.join(analysis_dir, 'comparison_*.json'))
    
    if comparison_files:
        latest_comparison = max(comparison_files, key=os.path.getctime)
        with open(latest_comparison, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        report.append("\n## 개선 성과")
        comparison = data.get('comparison', {})
        report.append(f"- 평균 점수 개선율: {comparison.get('avg_score_improvement', 0):+.1f}%")
        report.append(f"- 전체 문제 감소율: {comparison.get('issue_reduction_rate', 0):.1f}%")
        report.append(f"- 목표 달성률: {comparison.get('achievement_rate', 0):.1f}%")
        
        # 주요 개선 지표
        before = data.get('before', {})
        after = data.get('after', {})
        
        report.append("\n## 주요 지표 변화")
        report.append(f"- 일관성: {before.get('average_coherence', 0):.1f} → {after.get('average_coherence', 0):.1f}")
        report.append(f"- 주제 일관성: {before.get('average_topic_consistency', 0):.1f} → {after.get('average_topic_consistency', 0):.1f}")
        report.append(f"- 자연스러움: {before.get('average_naturalness', 0):.1f} → {after.get('average_naturalness', 0):.1f}")
        
        # 성과 평가
        achievement_rate = comparison.get('achievement_rate', 0)
        report.append("\n## 최종 평가")
        
        if achievement_rate >= 80:
            report.append("✅ **성공**: 개선 목표를 성공적으로 달성했습니다!")
            report.append("- 대부분의 지표가 목표치를 달성했습니다.")
            report.append("- 대화 품질이 크게 향상되었습니다.")
        elif achievement_rate >= 60:
            report.append("⚠️ **부분 성공**: 개선이 이루어졌으나 추가 작업이 필요합니다.")
            report.append("- 일부 지표는 개선되었으나 목표에 미달합니다.")
            report.append("- 추가적인 최적화가 권장됩니다.")
        else:
            report.append("❌ **개선 필요**: 효과가 미흡하여 추가 분석이 필요합니다.")
            report.append("- 대부분의 지표가 목표를 달성하지 못했습니다.")
            report.append("- 근본적인 접근 방식 재검토가 필요합니다.")
    
    # 보고서 저장
    report_file = f'IMPROVEMENT_REPORT_{datetime.now().strftime("%Y%m%d_%H%M%S")}.md'
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(report))
    
    print(f"✅ 보고서가 {report_file}에 저장되었습니다.")
    
    # 보고서 내용 출력
    print("\n" + "="*60)
    print('\n'.join(report))
    print("="*60)

def main():
    """메인 실행 함수"""
    print_header("대화 품질 개선 검증 시스템")
    
    print("\n이 스크립트는 다음 작업을 수행합니다:")
    print("1. 동일한 20개 테스트 시나리오 재분석")
    print("2. 개선 전후 결과 비교")
    print("3. 개선 효과 보고서 생성")
    
    print("\n⏳ 검증을 시작합니다...")
    time.sleep(1)
    
    # 1단계: 재분석 실행
    if not run_analysis():
        print("\n❌ 분석 실행에 실패했습니다.")
        return
    
    time.sleep(1)
    
    # 2단계: 비교 분석
    if not run_comparison():
        print("\n❌ 비교 분석에 실패했습니다.")
        return
    
    time.sleep(1)
    
    # 3단계: 보고서 생성
    generate_report()
    
    print("\n✅ 모든 검증 작업이 완료되었습니다!")
    print("\n다음 단계:")
    print("1. 생성된 보고서를 검토하세요")
    print("2. 목표를 달성하지 못한 지표가 있다면 추가 개선을 진행하세요")
    print("3. 실제 사용자 테스트를 통해 개선 효과를 검증하세요")

if __name__ == "__main__":
    main()