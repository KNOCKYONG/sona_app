import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

/// SharedPreferences 싱글톤 관리 클래스
/// 앱 전체에서 하나의 인스턴스만 사용하여 성능 최적화
class PreferencesManager {
  // Private constructor
  PreferencesManager._();
  
  static SharedPreferences? _prefs;
  
  /// SharedPreferences 인스턴스 가져오기
  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
  
  /// 초기화 (앱 시작 시 호출)
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// 인스턴스가 초기화되었는지 확인
  static bool get isInitialized => _prefs != null;
  
  /// 동기적으로 접근 (초기화된 경우에만 사용)
  static SharedPreferences get syncInstance {
    if (_prefs == null) {
      throw StateError('PreferencesManager not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // Convenience methods
  
  /// String 값 저장
  static Future<bool> setString(String key, String value) async {
    final prefs = await instance;
    return prefs.setString(key, value);
  }
  
  /// String 값 가져오기
  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }
  
  /// int 값 저장
  static Future<bool> setInt(String key, int value) async {
    final prefs = await instance;
    return prefs.setInt(key, value);
  }
  
  /// int 값 가져오기
  static Future<int?> getInt(String key) async {
    final prefs = await instance;
    return prefs.getInt(key);
  }
  
  /// bool 값 저장
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await instance;
    return prefs.setBool(key, value);
  }
  
  /// bool 값 가져오기
  static Future<bool?> getBool(String key) async {
    final prefs = await instance;
    return prefs.getBool(key);
  }
  
  /// double 값 저장
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await instance;
    return prefs.setDouble(key, value);
  }
  
  /// double 값 가져오기
  static Future<double?> getDouble(String key) async {
    final prefs = await instance;
    return prefs.getDouble(key);
  }
  
  /// StringList 저장
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await instance;
    return prefs.setStringList(key, value);
  }
  
  /// StringList 가져오기
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await instance;
    return prefs.getStringList(key);
  }
  
  /// JSON 객체 저장
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final prefs = await instance;
    return prefs.setString(key, jsonEncode(value));
  }
  
  /// JSON 객체 가져오기
  static Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await instance;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  /// 키 존재 여부 확인
  static Future<bool> containsKey(String key) async {
    final prefs = await instance;
    return prefs.containsKey(key);
  }
  
  /// 특정 키 삭제
  static Future<bool> remove(String key) async {
    final prefs = await instance;
    return prefs.remove(key);
  }
  
  /// 모든 데이터 삭제
  static Future<bool> clear() async {
    final prefs = await instance;
    return prefs.clear();
  }
  
  // App-specific convenience methods
  
  /// 디바이스 ID 가져오기
  static Future<String?> getDeviceId() => getString(AppConstants.deviceIdKey);
  
  /// 디바이스 ID 저장
  static Future<bool> setDeviceId(String deviceId) => 
      setString(AppConstants.deviceIdKey, deviceId);
  
  
  /// 스와이프한 페르소나 ID 목록 가져오기
  static Future<List<String>> getSwipedPersonas() async => 
      await getStringList(AppConstants.swipedPersonasKey) ?? [];
  
  /// 스와이프한 페르소나 ID 목록 저장
  static Future<bool> setSwipedPersonas(List<String> personaIds) => 
      setStringList(AppConstants.swipedPersonasKey, personaIds);
  
  /// 마지막 동기화 시간 가져오기
  static Future<DateTime?> getLastSyncTime() async {
    final timestamp = await getInt(AppConstants.lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  
  /// 마지막 동기화 시간 저장
  static Future<bool> setLastSyncTime(DateTime time) => 
      setInt(AppConstants.lastSyncKey, time.millisecondsSinceEpoch);
}