import 'package:flutter/foundation.dart';

/// 모든 서비스의 베이스 클래스
/// 공통 로딩 상태 관리 및 에러 핸들링 제공
abstract class BaseService extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 로딩 상태로 작업 실행
  Future<T?> executeWithLoading<T>(
    Future<T> Function() action, {
    String? errorContext,
    bool showError = true,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await action();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;

      if (showError) {
        _error = _getErrorMessage(e);
      }

      handleError(e, errorContext ?? runtimeType.toString());
      notifyListeners();
      return null;
    }
  }

  /// 로딩 상태 없이 작업 실행
  Future<T?> executeSafely<T>(
    Future<T> Function() action, {
    String? errorContext,
    T? defaultValue,
  }) async {
    try {
      return await action();
    } catch (e) {
      handleError(e, errorContext ?? runtimeType.toString());
      return defaultValue;
    }
  }

  /// 동기 작업을 안전하게 실행
  T? executeSafelySync<T>(
    T Function() action, {
    String? errorContext,
    T? defaultValue,
  }) {
    try {
      return action();
    } catch (e) {
      handleError(e, errorContext ?? runtimeType.toString());
      return defaultValue;
    }
  }

  /// 에러 핸들링
  @protected
  void handleError(dynamic error, String context) {
    if (kDebugMode) {
      debugPrint('Error in $context: $error');
      if (error is Error) {
        debugPrint('Stack trace: ${error.stackTrace}');
      }
    }
  }

  /// 에러 메시지 변환
  @protected
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      final errorString = error.toString();

      // Firebase Auth 에러 코드별 한글 메시지 매핑
      if (errorString.contains('[firebase_auth/network-request-failed]')) {
        return '네트워크 연결을 확인해주세요. 인터넷 연결이 불안정하거나 Firebase 서버에 연결할 수 없습니다.';
      } else if (errorString.contains('[firebase_auth/user-not-found]')) {
        return '등록되지 않은 이메일입니다.\n회원가입을 먼저 진행하거나 이메일을 다시 확인해주세요.';
      } else if (errorString.contains('[firebase_auth/wrong-password]')) {
        return '비밀번호가 일치하지 않습니다.\n비밀번호를 다시 확인하거나 비밀번호 찾기를 이용해주세요.';
      } else if (errorString.contains('[firebase_auth/invalid-email]')) {
        return '올바른 이메일 형식이 아닙니다.\n예: example@email.com';
      } else if (errorString.contains('[firebase_auth/user-disabled]')) {
        return '비활성화된 계정입니다.\n고객센터에 문의해주세요.';
      } else if (errorString.contains('[firebase_auth/too-many-requests]')) {
        return '너무 많은 로그인 시도가 있었습니다.\n잠시 후 다시 시도해주세요.';
      } else if (errorString.contains('[firebase_auth/email-already-in-use]')) {
        return '이미 사용 중인 이메일입니다.\n로그인을 시도하거나 다른 이메일을 사용해주세요.';
      } else if (errorString.contains('[firebase_auth/weak-password]')) {
        return '비밀번호는 최소 6자 이상이어야 합니다.\n더 강력한 비밀번호를 입력해주세요.';
      } else if (errorString
          .contains('[firebase_auth/operation-not-allowed]')) {
        return '이메일/비밀번호 로그인이 비활성화되어 있습니다.\n관리자에게 문의해주세요.';
      } else if (errorString.contains('[firebase_auth/invalid-credential]')) {
        return '이메일 또는 비밀번호가 올바르지 않습니다.\n입력한 정보를 다시 확인해주세요.';
      }

      // Google Sign-In 관련 에러 처리
      if (errorString.contains('google_sign_in') ||
          errorString.contains('GoogleSignIn')) {
        if (errorString.contains('sign_in_canceled') ||
            errorString.contains('cancelled') ||
            errorString.contains('canceled')) {
          return '구글 로그인이 취소되었습니다.\n다시 시도해주세요.';
        } else if (errorString.contains('network_error') ||
            errorString.contains('network')) {
          return '네트워크 연결을 확인하고 다시 시도해주세요.\n인터넷 연결이 불안정합니다.';
        } else if (errorString.contains('sign_in_failed')) {
          return '구글 로그인에 실패했습니다.\nGoogle Play 서비스를 업데이트하고 다시 시도해주세요.';
        } else if (errorString
            .contains('account_exists_with_different_credential')) {
          return '이미 다른 방법으로 가입된 이메일입니다.\n이메일 로그인을 시도해보세요.';
        } else if (errorString.contains('credential_already_in_use')) {
          return '이미 사용 중인 구글 계정입니다.\n다른 계정을 시도하거나 로그인해주세요.';
        } else {
          return '구글 로그인 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';
        }
      }

      // PlatformException 에러 처리 (Google Sign-In에서 자주 발생)
      if (errorString.contains('PlatformException')) {
        if (errorString.contains('sign_in_canceled')) {
          return '구글 로그인이 취소되었습니다.\n다시 시도해주세요.';
        } else if (errorString.contains('sign_in_failed')) {
          // API Exception 10은 Firebase 설정 문제를 나타냄
          if (errorString.contains('ApiException: 10:')) {
            return '구글 로그인 설정에 문제가 있습니다.\n앱을 재설치하거나 관리자에게 문의해주세요.';
          }
          return '구글 로그인에 실패했습니다.\nGoogle Play 서비스를 업데이트하고 다시 시도해주세요.';
        } else if (errorString.contains('network_error')) {
          return '네트워크 연결 오류입니다.\n인터넷 연결을 확인하고 다시 시도해주세요.';
        } else if (errorString.contains('developer_error')) {
          return '구글 로그인 설정에 문제가 있습니다.\n관리자에게 문의해주세요.';
        } else {
          return '구글 로그인 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';
        }
      }

      // 기타 Firebase 에러
      if (errorString.contains('[firebase_auth/')) {
        return errorString
            .replaceAll('Exception: ', '')
            .replaceAll('[firebase_auth/', '[')
            .replaceAll(']', '] ');
      }

      return errorString.replaceAll('Exception: ', '');
    }
    return 'unknownError'; // To be localized in UI layer
  }

  /// 로딩 상태 수동 설정
  @protected
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// 에러 상태 수동 설정
  @protected
  void setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  /// 에러 클리어
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  /// 상태 리셋
  @protected
  void resetState() {
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
