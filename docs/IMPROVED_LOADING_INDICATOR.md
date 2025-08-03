# 개선된 로딩 인디케이터

## 개요
사용자가 로딩 진행률을 명확하게 볼 수 있도록 UI를 개선했습니다.

## 주요 개선사항

### 1. RefreshDownloadScreen 개선
- **항상 표시되는 진행률 바**: 이미지 개수와 관계없이 항상 진행률 바 표시
- **크고 명확한 퍼센트 표시**: 32px 크기의 굵은 폰트로 퍼센트 표시
- **배경 컨테이너 추가**: 반투명 배경으로 가독성 향상
- **진행률 바 크기 증가**: 12px → 16px로 더 크게 표시
- **테두리 추가**: 진행률 바에 테두리를 추가하여 더 명확하게 표시

### 2. ImagePreloadScreen 동일하게 개선
- RefreshDownloadScreen과 동일한 디자인 적용
- 일관된 사용자 경험 제공

### 3. 시각적 개선사항
```dart
// 퍼센트 표시 스타일
Container(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    '${(_progress * 100).toStringAsFixed(0)}%',
    style: const TextStyle(
      fontSize: 32,  // 크고 명확한 크기
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.5,  // 가독성 향상
    ),
  ),
)
```

### 4. 상태별 메시지
- **이미지 확인 중**: "새로운 이미지 확인 중..."
- **다운로드 중**: "X / Y 이미지" 
- **대기 중**: "새로운 페르소나를 찾고 있어요..."

### 5. 애니메이션 효과
- 진행률 바의 부드러운 애니메이션 (300ms)
- 반짝이는 효과가 진행률에 따라 이동
- 더 큰 반짝임 효과 (20px → 30px)

## 사용자 이탈 방지
1. **즉각적인 시각 피드백**: 0%부터 진행률 표시
2. **큰 퍼센트 숫자**: 멀리서도 진행 상황 확인 가능
3. **명확한 진행 상태**: 현재 무엇을 하고 있는지 텍스트로 표시
4. **프로페셔널한 디자인**: 신뢰감을 주는 UI

## 기술적 구현
- AnimatedContainer로 부드러운 전환 효과
- StreamBuilder 패턴으로 실시간 업데이트
- 조건부 렌더링으로 상황별 적절한 UI 표시