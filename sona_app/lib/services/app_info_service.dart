import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 앱 정보 관리 서비스
class AppInfoService {
  static AppInfoService? _instance;
  static AppInfoService get instance => _instance ??= AppInfoService._();

  AppInfoService._();

  PackageInfo? _packageInfo;

  /// 앱 정보 초기화
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      debugPrint(
          '📱 App Info Loaded: ${_packageInfo?.version}+${_packageInfo?.buildNumber}');
    } catch (e) {
      debugPrint('❌ Failed to load app info: $e');
    }
  }

  /// 앱 버전 가져오기 (예: "1.0.2")
  String get appVersion => _packageInfo?.version ?? '1.0.0';

  /// 빌드 번호 가져오기 (예: "16")
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  /// 전체 버전 문자열 (예: "1.0.2+16")
  String get fullVersion => '$appVersion+$buildNumber';

  /// 앱 이름
  String get appName => _packageInfo?.appName ?? 'SONA';

  /// 패키지 이름
  String get packageName => _packageInfo?.packageName ?? 'com.example.sona_app';

  /// 디버그 정보 출력
  void printDebugInfo() {
    debugPrint('📱 ========== App Info ==========');
    debugPrint('📱 App Name: $appName');
    debugPrint('📱 Package Name: $packageName');
    debugPrint('📱 Version: $appVersion');
    debugPrint('📱 Build Number: $buildNumber');
    debugPrint('📱 Full Version: $fullVersion');
    debugPrint('📱 ================================');
  }
}
