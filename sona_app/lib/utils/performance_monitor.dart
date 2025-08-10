import 'package:flutter/foundation.dart';

/// 성능 모니터링 유틸리티
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<double>> _metrics = {};
  
  /// 측정 시작
  static void startMeasure(String name) {
    _startTimes[name] = DateTime.now();
  }
  
  /// 측정 종료 및 결과 반환
  static double endMeasure(String name) {
    final startTime = _startTimes[name];
    if (startTime == null) {
      debugPrint('⚠️ No start time for measure: $name');
      return 0;
    }
    
    final duration = DateTime.now().difference(startTime).inMilliseconds.toDouble();
    
    // 메트릭 저장
    _metrics[name] ??= [];
    _metrics[name]!.add(duration);
    
    // 최근 100개만 유지
    if (_metrics[name]!.length > 100) {
      _metrics[name] = _metrics[name]!.skip(_metrics[name]!.length - 100).toList();
    }
    
    _startTimes.remove(name);
    
    // 로그 출력 (디버그 모드에서만)
    if (kDebugMode) {
      debugPrint('⏱️ $name: ${duration.toStringAsFixed(2)}ms');
    }
    
    return duration;
  }
  
  /// 평균 시간 계산
  static double getAverageTime(String name) {
    final times = _metrics[name];
    if (times == null || times.isEmpty) return 0;
    
    final sum = times.reduce((a, b) => a + b);
    return sum / times.length;
  }
  
  /// 성능 리포트 출력
  static void printReport() {
    if (_metrics.isEmpty) {
      debugPrint('📊 No performance metrics collected');
      return;
    }
    
    debugPrint('\n' + '=' * 50);
    debugPrint('📊 PERFORMANCE REPORT');
    debugPrint('=' * 50);
    
    _metrics.forEach((name, times) {
      if (times.isNotEmpty) {
        final avg = times.reduce((a, b) => a + b) / times.length;
        final min = times.reduce((a, b) => a < b ? a : b);
        final max = times.reduce((a, b) => a > b ? a : b);
        
        debugPrint('\n[$name]');
        debugPrint('  Samples: ${times.length}');
        debugPrint('  Average: ${avg.toStringAsFixed(2)}ms');
        debugPrint('  Min: ${min.toStringAsFixed(2)}ms');
        debugPrint('  Max: ${max.toStringAsFixed(2)}ms');
        
        // 성능 평가
        if (avg > 1000) {
          debugPrint('  ⚠️ SLOW (>1s)');
        } else if (avg > 500) {
          debugPrint('  ⚠️ MODERATE (500ms-1s)');
        } else if (avg > 100) {
          debugPrint('  ✅ GOOD (100-500ms)');
        } else {
          debugPrint('  🚀 EXCELLENT (<100ms)');
        }
      }
    });
    
    debugPrint('\n' + '=' * 50 + '\n');
  }
  
  /// 메트릭 초기화
  static void reset() {
    _startTimes.clear();
    _metrics.clear();
  }
  
  /// 프레임 드롭 감지
  static void monitorFrames(Function() callback) {
    final stopwatch = Stopwatch()..start();
    
    callback();
    
    stopwatch.stop();
    
    // 16ms = 60fps, 33ms = 30fps
    if (stopwatch.elapsedMilliseconds > 16) {
      debugPrint('⚠️ Frame drop detected: ${stopwatch.elapsedMilliseconds}ms');
    }
  }
}