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
    // Firebase 권한 오류는 로그인하지 않은 사용자에게 정상적인 상황
    if (error.toString().contains('permission-denied')) {
      if (kDebugMode) {
        debugPrint('📋 Permission denied in $context (expected for non-logged-in users)');
      }
      return; // Don't treat as error
    }
    
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
      return error.toString().replaceAll('Exception: ', '');
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