# 추가 이미지 로드 기능 구현

## 개요
사용자가 앱을 사용하는 동안 새로운 페르소나나 이미지가 추가되었을 때, 이를 자동으로 감지하고 다운로드하는 기능을 구현했습니다.

## 주요 기능

### 1. 새로운 이미지 감지
- `ImagePreloadService.hasNewImages()`: 새로운 이미지가 있는지 확인
- SharedPreferences에 저장된 이미지 목록과 현재 페르소나의 이미지 URL 비교
- 새로운 이미지 URL이 발견되면 true 반환

### 2. 선택적 이미지 다운로드
- `ImagePreloadService.preloadNewImages()`: 새로운 이미지만 다운로드
- 기존에 다운로드한 이미지는 건너뛰고 새로운 이미지만 처리
- 5개씩 배치로 병렬 다운로드

### 3. 새로고침 시 새 이미지 체크
- 사용자가 새로고침 버튼을 누를 때 새로운 이미지 확인
- 새로운 이미지가 있으면 `RefreshDownloadScreen`으로 이동
- 진행률 표시와 함께 이미지 다운로드

### 4. 백그라운드 이미지 업데이트
- 앱이 백그라운드에서 다시 활성화될 때 자동 체크
- 사용자 경험을 방해하지 않고 조용히 다운로드
- `_checkForNewImagesInBackground()` 메서드 사용

### 5. 초기 로드 시 체크
- PersonaService 초기화 시 새로운 이미지 체크
- `checkAndDownloadNewImages()` 메서드로 자동 다운로드

## 구현 상세

### PersonaService 변경사항
```dart
/// 새로운 이미지 체크 및 다운로드
Future<void> checkAndDownloadNewImages() async {
  final imagePreloadService = ImagePreloadService.instance;
  final allPersonasWithImages = _allPersonas.where((p) => _hasR2Image(p)).toList();
  
  final hasNewImages = await imagePreloadService.hasNewImages(allPersonasWithImages);
  
  if (hasNewImages) {
    await imagePreloadService.preloadNewImages(allPersonasWithImages);
  }
}
```

### RefreshDownloadScreen
- 새로운 화면 추가: 이미지 다운로드 진행률 표시
- 시각적 로딩바와 함께 다운로드 개수 표시
- 다운로드 완료 후 자동으로 페르소나 선택 화면으로 이동

### PersonaSelectionScreen 변경사항
1. 새로고침 버튼 로직 수정:
   - 새로운 이미지 체크
   - 이미지가 있으면 다운로드 화면으로 이동
   - 없으면 바로 새로고침

2. 백그라운드 체크 추가:
   ```dart
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
     if (state == AppLifecycleState.resumed) {
       // 기존 일일 새로고침 체크
       personaService.checkAndPerformDailyRefresh();
       
       // 새로운 이미지 백그라운드 체크
       _checkForNewImagesInBackground();
     }
   }
   ```

## 사용자 경험 개선

1. **즉각적인 반응**: 새로운 페르소나가 추가되면 다음 새로고침 시 자동으로 다운로드
2. **진행률 표시**: 다운로드 중 시각적 피드백 제공
3. **백그라운드 업데이트**: 앱 사용 중 자동으로 새 이미지 다운로드
4. **효율적인 다운로드**: 이미 캐시된 이미지는 건너뛰고 새 이미지만 다운로드

## 주의사항

1. **네트워크 사용량**: 새로운 이미지 다운로드 시 데이터 사용
2. **저장 공간**: 추가 이미지는 로컬 캐시에 저장됨
3. **성능**: 백그라운드 다운로드는 앱 성능에 영향을 최소화하도록 구현