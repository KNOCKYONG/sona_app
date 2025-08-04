#!/usr/bin/env python
# -*- coding: utf-8 -*-
import json
import os
from datetime import datetime
from chat_improvement_validator import ChatImprovementValidator, validate_chat_improvements

def apply_validated_improvements():
    """검증된 개선사항을 실제 앱에 적용하기 위한 보고서 생성"""
    
    # 최신 검증 결과 찾기
    analysis_dir = os.path.join(os.path.dirname(__file__), "analysis_results")
    validation_files = []
    
    for filename in os.listdir(analysis_dir):
        if filename.startswith("validation_") and filename.endswith(".json"):
            file_path = os.path.join(analysis_dir, filename)
            validation_files.append((file_path, os.path.getmtime(file_path)))
    
    if not validation_files:
        print("No validation results found. Run chat_improvement_validator.py first.")
        return
    
    # 최신 검증 결과 로드
    validation_files.sort(key=lambda x: x[1], reverse=True)
    latest_validation = validation_files[0][0]
    
    with open(latest_validation, 'r', encoding='utf-8') as f:
        validation_data = json.load(f)
    
    print("[READY] Preparing to apply chat improvements")
    print("="*80)
    print(f"[ANALYSIS] Validation results: {latest_validation}")
    print(f"  - Total improvement attempts: {validation_data['total_improvements']}")
    print(f"  - Applicable improvements: {validation_data['applied_improvements']}")
    print(f"  - Apply rate: {validation_data['apply_rate']:.1f}%")
    
    # 적용할 개선사항 추출
    improvements_to_apply = []
    for result in validation_data['detailed_results']:
        if result['applied']:
            improvements_to_apply.append(result)
    
    if not improvements_to_apply:
        print("\n[WARNING] No improvements to apply.")
        return
    
    # 개선 패턴 분석
    print("\n[PATTERNS] Improvements to apply:")
    improvement_patterns = {
        'question_mark': [],
        'expression_softening': [],
        'empathy': [],
        'direct_answer': [],
        'spoiler': [],
        'context': []
    }
    
    for imp in improvements_to_apply:
        original = imp['original_response']
        improved = imp['improved_response']
        
        # 패턴 분류
        if not original.endswith('?') and improved.endswith('?'):
            improvement_patterns['question_mark'].append(imp)
        
        if ('나요' in original or '습니까' in original) and '어요' in improved:
            improvement_patterns['expression_softening'].append(imp)
        
        if '그런 감정' in original or '그런 기분' in original:
            improvement_patterns['empathy'].append(imp)
        
        if '뭐해' in imp['user_message'] or '뭐하고' in imp['user_message']:
            improvement_patterns['direct_answer'].append(imp)
        
        if '스포' in imp['user_message']:
            improvement_patterns['spoiler'].append(imp)
        
        if '직접' in imp['user_message']:
            improvement_patterns['context'].append(imp)
    
    # 패턴별 요약
    for pattern_name, examples in improvement_patterns.items():
        if examples:
            print(f"\n[APPLY] {pattern_name} pattern: {len(examples)} cases")
            # 첫 번째 예시만 출력
            if examples:
                ex = examples[0]
                print(f"   Example: {ex['original_response'][:30]}...")
                print(f"         -> {ex['improved_response'][:30]}...")
    
    # 적용 가이드 생성
    print("\n" + "="*80)
    print("[GUIDE] Implementation guide:")
    print("\n1. SecurityAwarePostProcessor updates:")
    print("   - Enhance _softenExpression method")
    print("   - Improve _isQuestion detection")
    print("   - Strengthen question mark handling in _cleanupText")
    
    print("\n2. ChatOrchestrator updates:")
    print("   - Add direct answer logic to _analyzeContextRelevance")
    print("   - Enhance spoiler context recognition")
    print("   - Distinguish 'watch directly' vs 'meet directly'")
    
    print("\n3. OptimizedPromptService updates:")
    print("   - Strengthen direct answer guidelines")
    print("   - Add empathy expression templates")
    print("   - Clarify spoiler conversation guidelines")
    
    # 개선 효과 요약
    print("\n" + "="*80)
    print("[EFFECT] Expected improvement effects:")
    
    total_original_score = sum(imp['original_score'] for imp in improvements_to_apply)
    total_improved_score = sum(imp['improved_score'] for imp in improvements_to_apply)
    avg_improvement = (total_improved_score - total_original_score) / len(improvements_to_apply)
    
    print(f"  - Average score improvement: {avg_improvement:.1f} points")
    print(f"  - Average improvement rate: {sum(imp['improvement_rate'] for imp in improvements_to_apply) / len(improvements_to_apply):.1f}%")
    
    # 적용 보고서 저장
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_path = os.path.join(analysis_dir, f"improvement_report_{timestamp}.json")
    
    report = {
        'timestamp': timestamp,
        'validation_source': latest_validation,
        'total_improvements': len(improvements_to_apply),
        'improvement_patterns': {k: len(v) for k, v in improvement_patterns.items()},
        'avg_score_improvement': avg_improvement,
        'detailed_improvements': improvements_to_apply,
        'implementation_guide': {
            'SecurityAwarePostProcessor': [
                'Enhance _softenExpression method',
                'Improve _isQuestion detection',
                'Strengthen question mark handling in _cleanupText'
            ],
            'ChatOrchestrator': [
                'Add direct answer logic to _analyzeContextRelevance',
                'Enhance spoiler context recognition',
                'Distinguish "watch directly" vs "meet directly"'
            ],
            'OptimizedPromptService': [
                'Strengthen direct answer guidelines',
                'Add empathy expression templates',
                'Clarify spoiler conversation guidelines'
            ]
        }
    }
    
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)
    
    print(f"\n[SAVED] Improvement report saved: {report_path}")
    print("\n[COMPLETE] Ready to apply improvements to code!")

def chat_error_improvement_command():
    """'대화 에러 개선' 명령어 실행"""
    print("Chat Error Improvement Process Started...")
    print("="*80)
    
    # 1단계: 검증 실행
    print("\n[Step 1] Validating improvements...")
    validation_results = validate_chat_improvements()
    
    if not validation_results:
        print("No errors to validate.")
        return
    
    # 2단계: 개선사항 적용 준비
    print("\n[Step 2] Preparing to apply improvements...")
    apply_validated_improvements()
    
    print("\n[Complete] Chat error improvement process complete!")
    print("Next steps:")
    print("1. Check the generated improvement_report")
    print("2. Apply verified improvements to service files")
    print("3. Restart the app to test improvements")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='Chat improvement application tool')
    parser.add_argument('--command', choices=['improve', 'apply'], default='improve',
                       help='improve: full improvement process, apply: apply verified improvements only')
    args = parser.parse_args()
    
    if args.command == 'improve':
        chat_error_improvement_command()
    else:
        apply_validated_improvements()