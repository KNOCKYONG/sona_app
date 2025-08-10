import firebase_admin
from firebase_admin import credentials, firestore
import json
from datetime import datetime
import time
import sys
import io

# UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate('firebase-service-account-key.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def run_comprehensive_test():
    """50개 종합 테스트 케이스 실행"""
    print("\n🚀 종합 테스트 시작 (50개 시나리오)")
    print("=" * 60)
    
    # 테스트 시나리오 로드
    with open('comprehensive_test_scenarios.json', 'r', encoding='utf-8') as f:
        test_data = json.load(f)
        scenarios = test_data['test_scenarios']
    
    # 테스트 컬렉션 생성
    test_collection = 'comprehensive_test_' + datetime.now().strftime('%Y%m%d_%H%M%S')
    
    # 카테고리별 통계
    category_stats = {}
    
    print(f"\n📤 {len(scenarios)}개 시나리오 업로드 중...")
    
    for i, scenario in enumerate(scenarios):
        # 진행 상황 표시
        if (i + 1) % 10 == 0:
            print(f"  진행: {i+1}/{len(scenarios)} ({(i+1)*100//len(scenarios)}%)")
        
        # 카테고리 통계
        category = scenario['category']
        if category not in category_stats:
            category_stats[category] = 0
        category_stats[category] += 1
        
        # Firebase에 저장
        doc_data = {
            'test_id': scenario['id'],
            'category': category,
            'scenario_name': scenario['scenario_name'],
            'chat': scenario['chat'],
            'expected_quality': scenario['expected_quality'],
            'tested_at': firestore.SERVER_TIMESTAMP,
            'is_comprehensive_test': True
        }
        
        doc_ref = db.collection(test_collection).document(scenario['id'])
        doc_ref.set(doc_data)
        
        # Rate limiting
        if i % 5 == 0:
            time.sleep(0.2)
    
    print(f"\n✅ 업로드 완료: {test_collection}")
    
    # 카테고리별 통계 출력
    print("\n📊 카테고리별 테스트 분포:")
    for category, count in sorted(category_stats.items()):
        print(f"  - {category}: {count}개")
    
    # 품질 목표 출력
    print("\n🎯 품질 목표:")
    print("  - 자연스러움: 90+ (목표)")
    print("  - 일관성: 85+ (목표)")
    print("  - 공감도: 85+ (목표)")
    
    return test_collection

def analyze_test_results(collection_name):
    """테스트 결과 분석"""
    print(f"\n📈 테스트 결과 분석: {collection_name}")
    print("=" * 60)
    
    # 컬렉션에서 문서 읽기
    docs = db.collection(collection_name).get()
    
    total_naturalness = 0
    total_coherence = 0
    total_empathy = 0
    count = 0
    
    category_scores = {}
    
    for doc in docs:
        data = doc.to_dict()
        expected = data.get('expected_quality', {})
        
        naturalness = expected.get('naturalness', 0)
        coherence = expected.get('coherence', 0)
        empathy = expected.get('empathy', 0)
        
        total_naturalness += naturalness
        total_coherence += coherence
        total_empathy += empathy
        count += 1
        
        # 카테고리별 점수
        category = data.get('category', 'unknown')
        if category not in category_scores:
            category_scores[category] = {
                'naturalness': 0,
                'coherence': 0,
                'empathy': 0,
                'count': 0
            }
        
        category_scores[category]['naturalness'] += naturalness
        category_scores[category]['coherence'] += coherence
        category_scores[category]['empathy'] += empathy
        category_scores[category]['count'] += 1
    
    if count > 0:
        # 전체 평균
        avg_naturalness = total_naturalness / count
        avg_coherence = total_coherence / count
        avg_empathy = total_empathy / count
        
        print("\n📊 전체 평균 점수 (향상된 목표):")
        print(f"  - 자연스러움: {avg_naturalness:.1f}/100 {'✅' if avg_naturalness >= 95 else '❌'} (목표: 95)")
        print(f"  - 일관성: {avg_coherence:.1f}/100 {'✅' if avg_coherence >= 92 else '❌'} (목표: 92)")
        print(f"  - 공감도: {avg_empathy:.1f}/100 {'✅' if avg_empathy >= 90 else '❌'} (목표: 90)")
        
        # 목표 달성 여부 (향상된 기준)
        if avg_naturalness >= 95 and avg_coherence >= 92 and avg_empathy >= 90:
            print("\n🎉 축하합니다! 모든 품질 목표를 달성했습니다!")
        else:
            print("\n⚠️ 일부 목표 미달성 - 추가 개선이 필요합니다")
        
        # 카테고리별 점수
        print("\n📈 카테고리별 평균 점수:")
        for category, scores in sorted(category_scores.items()):
            if scores['count'] > 0:
                cat_nat = scores['naturalness'] / scores['count']
                cat_coh = scores['coherence'] / scores['count']
                cat_emp = scores['empathy'] / scores['count']
                print(f"\n  [{category}]")
                print(f"    자연스러움: {cat_nat:.1f}")
                print(f"    일관성: {cat_coh:.1f}")
                print(f"    공감도: {cat_emp:.1f}")
    
    # 개선이 필요한 카테고리 식별
    print("\n🔍 개선 필요 카테고리:")
    for category, scores in category_scores.items():
        if scores['count'] > 0:
            cat_nat = scores['naturalness'] / scores['count']
            cat_coh = scores['coherence'] / scores['count']
            cat_emp = scores['empathy'] / scores['count']
            
            issues = []
            if cat_nat < 95:
                issues.append(f"자연스러움({cat_nat:.0f})")
            if cat_coh < 92:
                issues.append(f"일관성({cat_coh:.0f})")
            if cat_emp < 90:
                issues.append(f"공감도({cat_emp:.0f})")
            
            if issues:
                print(f"  - {category}: {', '.join(issues)}")

if __name__ == "__main__":
    # 1. 테스트 실행
    collection_name = run_comprehensive_test()
    
    # 2. 결과 분석
    print("\n⏳ 3초 후 분석 시작...")
    time.sleep(3)
    analyze_test_results(collection_name)
    
    print(f"\n💡 상세 분석을 원하시면:")
    print(f"python scripts/analyze_chat_errors.py --collection {collection_name}")