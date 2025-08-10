@echo off
echo ========================================
echo Sona App - 전체 테스트 실행
echo ========================================
echo.

echo [1/8] UserRetentionService 테스트 실행...
flutter test test/services/retention_test.dart
echo.

echo [2/8] PersonalizedGrowthService 테스트 실행...
flutter test test/services/growth_test.dart
echo.

echo [3/8] ConflictResolutionService 테스트 실행...
flutter test test/services/conflict_test.dart
echo.

echo [4/8] VirtualDailyLifeService 테스트 실행...
flutter test test/services/daily_test.dart
echo.

echo [5/8] SpecialDayMemoryService 테스트 실행...
flutter test test/services/memory_test.dart
echo.

echo [6/8] ComplexEmotionService 테스트 실행...
flutter test test/services/emotion_test.dart
echo.

echo [7/8] ChatOrchestrator 통합 테스트 실행...
flutter test test/integration/orchestrator_test.dart
echo.

echo [8/8] 전체 테스트 실행...
flutter test
echo.

echo ========================================
echo 모든 테스트 완료!
echo ========================================
pause