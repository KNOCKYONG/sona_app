import json
import os
import sys
import io
from datetime import datetime
from chat_improvement_validator import ChatImprovementValidator, validate_chat_improvements

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

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
        print("검증 결과를 찾을 수 없습니다. 먼저 chat_improvement_validator.py를 실행하세요.")
        return
    
    # 최신 검증 결과 로드
    validation_files.sort(key=lambda x: x[1], reverse=True)
    latest_validation = validation_files[0][0]
    
    with open(latest_validation, 'r', encoding='utf-8') as f:
        validation_data = json.load(f)
    
    print("[적용 준비] 대화 개선 적용 준비")
    print("="*80)
    print(f" 검증 결과 분석: {latest_validation}")
    print(f"  - 총 개선 시도: {validation_data['total_improvements']}건")
    print(f"  - 적용 가능한 개선: {validation_data['applied_improvements']}건")
    print(f"  - 적용률: {validation_data['apply_rate']:.1f}%")
    
    # 적용할 개선사항 추출
    improvements_to_apply = []
    for result in validation_data['detailed_results']:
        if result['applied']:
            improvements_to_apply.append(result)
    
    if not improvements_to_apply:
        print("\n[경고] 적용할 개선사항이 없습니다.")
        return
    
    # 개선 패턴 분석
    print("\n 적용할 개선 패턴:")
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
            print(f"\n[적용] {pattern_name} 패턴: {len(examples)}건")
            # 첫 번째 예시만 출력
            if examples:
                ex = examples[0]
                print(f"   예시: {ex['original_response'][:30]}...")
                print(f"      → {ex['improved_response'][:30]}...")
    
    # 적용 가이드 생성
    print("\n" + "="*80)
    print(" 적용 가이드:")
    print("\n1. SecurityAwarePostProcessor 업데이트:")
    print("   - _softenExpression 메서드 강화")
    print("   - _isQuestion 메서드 개선")
    print("   - _cleanupText 메서드에서 물음표 처리 강화")
    
    print("\n2. ChatOrchestrator 업데이트:")
    print("   - _analyzeContextRelevance 메서드에 직접 답변 로직 추가")
    print("   - 스포일러 컨텍스트 인식 강화")
    print("   - '직접 보다' vs '직접 만나다' 구분 로직")
    
    print("\n3. OptimizedPromptService 업데이트:")
    print("   - 직접적인 답변 가이드라인 강화")
    print("   - 공감 표현 템플릿 추가")
    print("   - 스포일러 대화 가이드라인 명확화")
    
    # 개선 효과 요약
    print("\n" + "="*80)
    print(" 예상 개선 효과:")
    
    total_original_score = sum(imp['original_score'] for imp in improvements_to_apply)
    total_improved_score = sum(imp['improved_score'] for imp in improvements_to_apply)
    avg_improvement = (total_improved_score - total_original_score) / len(improvements_to_apply)
    
    print(f"  - 평균 점수 향상: {avg_improvement:.1f}점")
    print(f"  - 평균 개선율: {sum(imp['improvement_rate'] for imp in improvements_to_apply) / len(improvements_to_apply):.1f}%")
    
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
    
    print(f"\n 개선 보고서 저장: {report_path}")
    print("\n[적용] 개선사항을 코드에 적용할 준비가 완료되었습니다!")

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
    parser = argparse.ArgumentParser(description='대화 개선 적용 도구')
    parser.add_argument('--command', choices=['improve', 'apply'], default='improve',
                       help='improve: 전체 개선 프로세스, apply: 검증된 개선사항만 적용')
    args = parser.parse_args()
    
    if args.command == 'improve':
        chat_error_improvement_command()
    else:
        apply_validated_improvements()