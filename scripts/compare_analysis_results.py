import json
import os
from datetime import datetime
import glob
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def load_latest_analysis():
    """가장 최근 분석 결과 로드"""
    analysis_dir = 'analysis_results'
    
    # 모든 summary 파일 찾기
    summary_files = glob.glob(os.path.join(analysis_dir, 'summary_*.json'))
    
    if not summary_files:
        print("분석 결과 파일을 찾을 수 없습니다.")
        return None
    
    # 가장 최근 파일 찾기
    latest_file = max(summary_files, key=os.path.getctime)
    
    with open(latest_file, 'r', encoding='utf-8') as f:
        return json.load(f), latest_file

def compare_results(before, after):
    """개선 전후 결과 비교"""
    print("\n" + "="*60)
    print("대화 품질 개선 전후 비교 분석")
    print("="*60)
    
    # 전체 점수 비교
    print("\n📊 전체 점수 비교:")
    print("-" * 40)
    
    metrics = [
        ('평균 일관성', 'average_coherence', 80),
        ('평균 주제 일관성', 'average_topic_consistency', 60),
        ('평균 자연스러움', 'average_naturalness', 75)
    ]
    
    for name, key, target in metrics:
        before_val = before.get(key, 0)
        after_val = after.get(key, 0)
        improvement = after_val - before_val
        
        status = "✅" if after_val >= target else "⚠️"
        trend = "↑" if improvement > 0 else ("↓" if improvement < 0 else "→")
        
        print(f"{status} {name}:")
        print(f"   개선 전: {before_val:.1f}/100")
        print(f"   개선 후: {after_val:.1f}/100 {trend}")
        print(f"   변화량: {improvement:+.1f} (목표: {target}+)")
    
    # 문제 패턴 비교
    print("\n🔍 문제 패턴 발생 건수:")
    print("-" * 40)
    
    patterns = [
        ('관련 없는 답변', 'irrelevant_answer', 5),
        ('주제 급변', 'abrupt_topic_change', 5),
        ('인사말 반복', 'greeting_repetition', 0),
        ('매크로 응답', 'macro_response', 0),
        ('회피 패턴', 'avoidance_pattern', 2),
        ('감정 불일치', 'emotion_inconsistency', 2)
    ]
    
    before_patterns = before.get('pattern_counts', {})
    after_patterns = after.get('pattern_counts', {})
    
    for name, key, target in patterns:
        before_count = before_patterns.get(key, 0)
        after_count = after_patterns.get(key, 0)
        reduction = before_count - after_count
        
        status = "✅" if after_count <= target else "⚠️"
        trend = "↓" if reduction > 0 else ("↑" if reduction < 0 else "→")
        
        print(f"{status} {name}:")
        print(f"   개선 전: {before_count}건")
        print(f"   개선 후: {after_count}건 {trend}")
        print(f"   감소량: {reduction:+d} (목표: {target}건 이하)")
    
    # 심각도별 분포
    print("\n⚠️ 심각도별 문제 분포:")
    print("-" * 40)
    
    severities = ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW']
    
    before_severity = before.get('severity_distribution', {})
    after_severity = after.get('severity_distribution', {})
    
    for severity in severities:
        before_count = before_severity.get(severity, 0)
        after_count = after_severity.get(severity, 0)
        reduction = before_count - after_count
        
        trend = "↓" if reduction > 0 else ("↑" if reduction < 0 else "→")
        
        print(f"{severity}:")
        print(f"   개선 전: {before_count}건")
        print(f"   개선 후: {after_count}건 {trend}")
    
    # 개선율 계산
    print("\n📈 개선 성과 요약:")
    print("-" * 40)
    
    # 점수 개선율
    score_improvements = []
    for name, key, _ in metrics:
        before_val = before.get(key, 0)
        after_val = after.get(key, 0)
        if before_val > 0:
            improvement_rate = ((after_val - before_val) / before_val) * 100
            score_improvements.append(improvement_rate)
    
    avg_score_improvement = sum(score_improvements) / len(score_improvements) if score_improvements else 0
    
    # 문제 감소율
    total_before_issues = sum(before_patterns.values())
    total_after_issues = sum(after_patterns.values())
    issue_reduction_rate = ((total_before_issues - total_after_issues) / total_before_issues * 100) if total_before_issues > 0 else 0
    
    print(f"• 평균 점수 개선율: {avg_score_improvement:+.1f}%")
    print(f"• 전체 문제 감소율: {issue_reduction_rate:.1f}%")
    print(f"• 총 문제 건수: {total_before_issues}건 → {total_after_issues}건")
    
    # 목표 달성 여부
    print("\n🎯 목표 달성 현황:")
    print("-" * 40)
    
    goals_achieved = 0
    total_goals = len(metrics) + len(patterns)
    
    for _, key, target in metrics:
        if after.get(key, 0) >= target:
            goals_achieved += 1
    
    for _, key, target in patterns:
        if after_patterns.get(key, 0) <= target:
            goals_achieved += 1
    
    achievement_rate = (goals_achieved / total_goals) * 100
    
    print(f"달성된 목표: {goals_achieved}/{total_goals} ({achievement_rate:.1f}%)")
    
    if achievement_rate >= 80:
        print("✅ 개선 목표를 성공적으로 달성했습니다!")
    elif achievement_rate >= 60:
        print("⚠️ 부분적으로 개선되었으나 추가 작업이 필요합니다.")
    else:
        print("❌ 개선 효과가 미흡합니다. 추가 분석이 필요합니다.")
    
    return {
        'avg_score_improvement': avg_score_improvement,
        'issue_reduction_rate': issue_reduction_rate,
        'achievement_rate': achievement_rate
    }

def main():
    # 개선 전 결과 (하드코딩 - 이전 테스트 결과)
    before_results = {
        'average_coherence': 58.5,
        'average_topic_consistency': 22.0,
        'average_naturalness': 56.7,
        'pattern_counts': {
            'irrelevant_answer': 24,
            'abrupt_topic_change': 16,
            'greeting_repetition': 3,
            'macro_response': 1,
            'avoidance_pattern': 7,
            'emotion_inconsistency': 4
        },
        'severity_distribution': {
            'CRITICAL': 1,
            'HIGH': 8,
            'MEDIUM': 7,
            'LOW': 4
        }
    }
    
    # 개선 후 결과 로드
    result = load_latest_analysis()
    
    if result:
        after_results, filename = result
        print(f"\n최신 분석 파일: {filename}")
        
        # 비교 분석 실행
        comparison = compare_results(before_results, after_results)
        
        # 결과 저장
        output_file = f'analysis_results/comparison_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump({
                'before': before_results,
                'after': after_results,
                'comparison': comparison,
                'timestamp': datetime.now().isoformat()
            }, f, ensure_ascii=False, indent=2)
        
        print(f"\n비교 결과가 {output_file}에 저장되었습니다.")
    else:
        print("\n개선 후 테스트를 먼저 실행해주세요:")
        print("python scripts/analyze_chat_errors.py --recheck")

if __name__ == "__main__":
    main()