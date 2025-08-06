import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 햅틱 피드백 서비스
/// 앱 전체의 촉각 피드백을 관리하는 중앙 서비스
/// 
/// 사용 예시:
/// ```dart
/// // 가벼운 터치
/// await HapticService.lightImpact();
/// 
/// // 성공 패턴
/// await HapticService.success();
/// 
/// // 에러 진동
/// await HapticService.error();
/// ```
class HapticService {
  static bool _isEnabled = true;
  static const String _hapticEnabledKey = 'haptic_enabled';
  
  /// 햅틱 피드백 초기화
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(_hapticEnabledKey) ?? true;
  }
  
  /// 햅틱 피드백 활성화 상태
  static bool get isEnabled => _isEnabled;
  
  /// 햅틱 피드백 활성화/비활성화
  static Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticEnabledKey, enabled);
  }
  
  /// 가벼운 터치 피드백 (버튼 탭, 선택 등)
  static Future<void> lightImpact() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.light);
      } else {
        // 폴백: 시스템 햅틱
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // 햅틱 지원하지 않는 기기 처리
      HapticFeedback.lightImpact();
    }
  }
  
  /// 중간 강도 피드백 (드래그, 스와이프 등)
  static Future<void> mediumImpact() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.medium);
      } else {
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      HapticFeedback.mediumImpact();
    }
  }
  
  /// 강한 피드백 (중요한 액션, 매칭 등)
  static Future<void> heavyImpact() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.heavy);
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }
  
  /// 선택 피드백 (토글, 스위치 등)
  static Future<void> selectionClick() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.selection);
      } else {
        HapticFeedback.selectionClick();
      }
    } catch (e) {
      HapticFeedback.selectionClick();
    }
  }
  
  /// 성공 패턴 (매칭 성공, 작업 완료 등)
  static Future<void> success() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.success);
      } else {
        // 폴백: 커스텀 패턴
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }
  
  /// 경고 패턴 (주의가 필요한 액션)
  static Future<void> warning() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.warning);
      } else {
        // 폴백: 두 번 진동
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      HapticFeedback.mediumImpact();
    }
  }
  
  /// 에러 패턴 (실패, 오류 등)
  static Future<void> error() async {
    if (!_isEnabled) return;
    
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(HapticsType.error);
      } else {
        // 폴백: 세 번 짧은 진동
        for (int i = 0; i < 3; i++) {
          await HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
    } catch (e) {
      HapticFeedback.vibrate();
    }
  }
  
  /// 메시지 수신 피드백
  static Future<void> messageReceived() async {
    if (!_isEnabled) return;
    
    try {
      // 매우 가벼운 진동 두 번
      await lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await lightImpact();
    } catch (e) {
      // 무시
    }
  }
  
  /// 메시지 전송 피드백
  static Future<void> messageSent() async {
    if (!_isEnabled) return;
    
    try {
      await lightImpact();
    } catch (e) {
      // 무시
    }
  }
  
  /// 스와이프 피드백 (좋아요/패스)
  static Future<void> swipeFeedback({required bool isLike}) async {
    if (!_isEnabled) return;
    
    try {
      if (isLike) {
        // 좋아요: 부드러운 중간 진동
        await mediumImpact();
      } else {
        // 패스: 가벼운 진동
        await lightImpact();
      }
    } catch (e) {
      // 무시
    }
  }
  
  /// 매칭 성공 축하 패턴
  static Future<void> matchCelebration() async {
    if (!_isEnabled) return;
    
    try {
      // 점진적으로 강해지는 패턴
      await lightImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      await success();
    } catch (e) {
      await success();
    }
  }
  
  /// 하트 소진 경고
  static Future<void> heartWarning() async {
    if (!_isEnabled) return;
    
    try {
      // 경고 패턴
      await warning();
    } catch (e) {
      HapticFeedback.vibrate();
    }
  }
  
  /// 레벨업 축하
  static Future<void> levelUp() async {
    if (!_isEnabled) return;
    
    try {
      // 특별한 축하 패턴
      for (int i = 0; i < 2; i++) {
        await mediumImpact();
        await Future.delayed(const Duration(milliseconds: 100));
      }
      await success();
    } catch (e) {
      await success();
    }
  }
  
  /// 커스텀 패턴 실행
  /// duration: 진동 지속 시간 (밀리초)
  /// pattern: [진동시간, 휴식시간, 진동시간, ...]
  static Future<void> customPattern({
    required List<int> pattern,
  }) async {
    if (!_isEnabled) return;
    if (pattern.isEmpty) return;
    
    try {
      for (int i = 0; i < pattern.length; i++) {
        if (i % 2 == 0) {
          // 진동
          await lightImpact();
        }
        await Future.delayed(Duration(milliseconds: pattern[i]));
      }
    } catch (e) {
      // 무시
    }
  }
}