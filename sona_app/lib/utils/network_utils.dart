import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class NetworkUtils {
  static final Connectivity _connectivity = Connectivity();

  /// 현재 네트워크 연결 상태 확인
  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Network check error: $e');
      return false;
    }
  }

  /// 네트워크 연결 상태 스트림
  static Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// 네트워크 연결 확인 후 작업 실행
  static Future<T?> executeWithNetworkCheck<T>({
    required Future<T> Function() action,
    required BuildContext context,
    VoidCallback? onNoConnection,
  }) async {
    final isConnected = await NetworkUtils.isConnected();

    if (!isConnected) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.checkInternetConnection),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      onNoConnection?.call();
      return null;
    }

    return await action();
  }

  /// 연결 타입별 메시지
  static String getConnectionMessage(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi 연결됨';
      case ConnectivityResult.mobile:
        return '모바일 데이터 연결됨';
      case ConnectivityResult.ethernet:
        return '이더넷 연결됨';
      case ConnectivityResult.none:
        return '인터넷 연결 없음';
      case ConnectivityResult.bluetooth:
        return '블루투스 연결됨';
      case ConnectivityResult.vpn:
        return 'VPN 연결됨';
      case ConnectivityResult.other:
        return '기타 연결';
    }
  }
}
