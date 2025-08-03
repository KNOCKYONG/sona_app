# 이미지 프리로딩 및 캐싱 최적화 구현

## 구현 내용

### 1. 이미지 프리로딩 서비스 (`ImagePreloadService`)
- **위치**: `lib/services/cache/image_preload_service.dart`
- **기능**: 
  - 최초 로그인 시 모든 페르소나 이미지를 로컬에 다운로드
  - 배치 다운로드 (5개씩 병렬 처리)
  - 다운로드 진행률 추적
  - SharedPreferences로 완료 상태 저장

### 2. 프리로딩 화면 (`ImagePreloadScreen`)
- **위치**: `lib/screens/image_preload_screen.dart`
- **기능**:
  - 다운로드 진행률 표시 (퍼센트)
  - 로딩 애니메이션
  - 건너뛰기 옵션
  - 이미 완료된 경우 자동 스킵

### 3. 커스텀 캐시 매니저 (`PersonaCacheManager`)
- **위치**: `lib/config/custom_cache_manager.dart`
- **설정**:
  - 영구 캐싱 (1년 유지)
  - 최대 500개 이미지 저장
  - 페르소나 이미지 전용 저장소

### 4. 캐시 관리 기능
- **위치**: `lib/screens/settings_screen.dart`
- **기능**:
  - 현재 캐시 크기 확인
  - 캐시 삭제 기능
  - 용량 표시 (B, KB, MB, GB)

## 최적화 효과

### Before (기존)
- R2 URL 체크로 인한 초기 로딩 지연
- 매번 네트워크에서 이미지 다운로드
- 네트워크 상태에 따른 불안정한 로딩

### After (개선)
- 최초 로그인 시 모든 이미지 프리로딩
- 로컬 캐시에서 즉시 로드
- 영구 캐싱으로 재다운로드 최소화
- 네트워크 독립적인 빠른 로딩

## 구현 세부사항

### 1. Welcome Screen 수정
```dart
// 이미지 프리로딩이 필요한지 확인
final preloadService = ImagePreloadService.instance;
final isPreloaded = await preloadService.isPreloadCompleted();

if (!isPreloaded) {
  // 프리로딩이 필요한 경우
  Navigator.of(context).pushReplacementNamed('/image-preload');
} else {
  // 이미 프리로딩이 완료된 경우
  Navigator.of(context).pushReplacementNamed('/persona-selection');
}
```

### 2. PersonaCard 수정
```dart
// 커스텀 캐시 매니저 사용
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: PersonaCacheManager.instance,
  // ... 기타 설정
);
```

### 3. 캐시 크기 계산
```dart
// DefaultCacheManager와 PersonaCacheManager 크기 합산
final defaultCacheInfo = await DefaultCacheManager().store.getFileSystem();
final personaCacheInfo = await PersonaCacheManager.instance.store.getFileSystem();
// 디렉토리 크기 계산
```

## 사용자 경험 개선

1. **첫 로그인**
   - Welcome 화면 → 이미지 프리로딩 화면 → 페르소나 선택
   - 진행률 표시로 투명한 프로세스
   - 건너뛰기 옵션 제공

2. **재방문 사용자**
   - 프리로딩 화면 스킵
   - 즉시 페르소나 카드 표시
   - 빠른 이미지 로딩

3. **설정에서 캐시 관리**
   - 현재 사용 중인 저장 공간 확인
   - 필요시 캐시 삭제로 공간 확보
   - 삭제 후 자동 재다운로드

## 주의사항

1. **네트워크 사용량**
   - 최초 로그인 시 대량의 이미지 다운로드
   - WiFi 환경 권장

2. **저장 공간**
   - 페르소나 수에 따라 수백 MB 사용 가능
   - 정기적인 캐시 관리 필요

3. **캐시 무효화**
   - 이미지 URL 변경 시 자동 재다운로드
   - 수동 캐시 삭제 후 재다운로드 필요