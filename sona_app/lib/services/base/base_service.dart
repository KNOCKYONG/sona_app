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
        return '등록되지 않은 이메일입니다. 회원가입을 먼저 진행해주세요.';
      } else if (errorString.contains('[firebase_auth/wrong-password]')) {
        return '비밀번호가 일치하지 않습니다. 다시 확인해주세요.';
      } else if (errorString.contains('[firebase_auth/invalid-email]')) {
        return '올바른 이메일 형식이 아닙니다.';
      } else if (errorString.contains('[firebase_auth/user-disabled]')) {
        return '비활성화된 계정입니다. 고객센터에 문의해주세요.';
      } else if (errorString.contains('[firebase_auth/too-many-requests]')) {
        return '너무 많은 로그인 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      } else if (errorString.contains('[firebase_auth/email-already-in-use]')) {
        return '이미 사용 중인 이메일입니다.';
      } else if (errorString.contains('[firebase_auth/weak-password]')) {
        return '비밀번호는 최소 6자 이상이어야 합니다.';
      } else if (errorString.contains('[firebase_auth/operation-not-allowed]')) {
        return '이메일/비밀번호 로그인이 비활성화되어 있습니다. 관리자에게 문의해주세요.';
      } else if (errorString.contains('[firebase_auth/invalid-credential]')) {
        return '이메일 또는 비밀번호가 올바르지 않습니다.';
      }
      
      // 기타 Firebase 에러
      if (errorString.contains('[firebase_auth/')) {
        return errorString.replaceAll('Exception: ', '').replaceAll('[firebase_auth/', '[').replaceAll(']', '] ');
      }
      
      return errorString.replaceAll('Exception: ', '');
    }
    return '알 수 없는 오류가 발생했습니다';
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