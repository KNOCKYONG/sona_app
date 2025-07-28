import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../../models/message.dart';
import '../../models/persona.dart';

class CacheManager {
  static CacheManager? _instance;
  static CacheManager get instance => _instance ??= CacheManager._();
  
  CacheManager._();
  
  static const String _imageCacheDirName = 'image_cache';
  static const String _chatCacheDirName = 'chat_cache';
  static const String _personaCacheDirName = 'persona_cache';
  
  // 캐시 설정
  static const int _maxImageCacheSize = 100 * 1024 * 1024; // 100MB
  static const int _maxChatCacheSize = 50 * 1024 * 1024; // 50MB
  static const Duration _imageCacheExpiry = Duration(days: 7);
  static const Duration _chatCacheExpiry = Duration(days: 30);
  static const Duration _personaCacheExpiry = Duration(days: 1);
  
  Directory? _cacheDir;
  Directory? _imageCacheDir;
  Directory? _chatCacheDir;
  Directory? _personaCacheDir;
  
  /// 캐시 매니저 초기화
  Future<void> initialize() async {
    try {
      _cacheDir = await getTemporaryDirectory();
      
      // 캐시 디렉토리 생성
      _imageCacheDir = Directory('${_cacheDir!.path}/$_imageCacheDirName');
      _chatCacheDir = Directory('${_cacheDir!.path}/$_chatCacheDirName');
      _personaCacheDir = Directory('${_cacheDir!.path}/$_personaCacheDirName');
      
      await _imageCacheDir!.create(recursive: true);
      await _chatCacheDir!.create(recursive: true);
      await _personaCacheDir!.create(recursive: true);
      
      // 앱 시작 시 만료된 캐시 정리
      _cleanExpiredCache();
    } catch (e) {
      if (kDebugMode) {
        print('CacheManager initialization error: $e');
      }
    }
  }
  
  /// 이미지 캐시 저장
  Future<bool> cacheImage(String url, Uint8List data) async {
    try {
      if (_imageCacheDir == null) await initialize();
      
      final hash = _generateHash(url);
      final file = File('${_imageCacheDir!.path}/$hash');
      
      await file.writeAsBytes(data);
      
      // 메타데이터 저장
      await _saveImageMetadata(hash, url, data.length);
      
      // 캐시 크기 체크 및 정리
      await _checkAndCleanImageCache();
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Image cache save error: $e');
      }
      return false;
    }
  }
  
  /// 이미지 캐시 조회
  Future<Uint8List?> getCachedImage(String url) async {
    try {
      if (_imageCacheDir == null) await initialize();
      
      final hash = _generateHash(url);
      final file = File('${_imageCacheDir!.path}/$hash');
      
      if (!await file.exists()) return null;
      
      // 만료 체크
      if (await _isImageCacheExpired(hash)) {
        await _removeImageCache(hash);
        return null;
      }
      
      return await file.readAsBytes();
    } catch (e) {
      if (kDebugMode) {
        print('Image cache read error: $e');
      }
      return null;
    }
  }
  
  /// 대화 캐시 저장
  Future<bool> cacheMessages(String chatId, List<Message> messages) async {
    try {
      if (_chatCacheDir == null) await initialize();
      
      final file = File('${_chatCacheDir!.path}/$chatId.json');
      final data = {
        'messages': messages.map((m) => m.toJson()).toList(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await file.writeAsString(jsonEncode(data));
      
      // 캐시 크기 체크
      await _checkAndCleanChatCache();
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Chat cache save error: $e');
      }
      return false;
    }
  }
  
  /// 대화 캐시 조회
  Future<List<Message>?> getCachedMessages(String chatId) async {
    try {
      if (_chatCacheDir == null) await initialize();
      
      final file = File('${_chatCacheDir!.path}/$chatId.json');
      
      if (!await file.exists()) return null;
      
      final content = await file.readAsString();
      final data = jsonDecode(content);
      
      // 만료 체크
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(data['cachedAt']);
      if (DateTime.now().difference(cachedAt) > _chatCacheExpiry) {
        await file.delete();
        return null;
      }
      
      final messagesList = data['messages'] as List;
      return messagesList.map((m) => Message.fromJson(m)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Chat cache read error: $e');
      }
      return null;
    }
  }
  
  /// 페르소나 캐시 저장
  Future<bool> cachePersonas(List<Persona> personas) async {
    try {
      if (_personaCacheDir == null) await initialize();
      
      final file = File('${_personaCacheDir!.path}/personas.json');
      final data = {
        'personas': personas.map((p) => p.toJson()).toList(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Persona cache save error: $e');
      }
      return false;
    }
  }
  
  /// 페르소나 캐시 조회
  Future<List<Persona>?> getCachedPersonas() async {
    try {
      if (_personaCacheDir == null) await initialize();
      
      final file = File('${_personaCacheDir!.path}/personas.json');
      
      if (!await file.exists()) return null;
      
      final content = await file.readAsString();
      final data = jsonDecode(content);
      
      // 만료 체크
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(data['cachedAt']);
      if (DateTime.now().difference(cachedAt) > _personaCacheExpiry) {
        await file.delete();
        return null;
      }
      
      final personasList = data['personas'] as List;
      return personasList.map((p) => Persona.fromJson(p)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Persona cache read error: $e');
      }
      return null;
    }
  }
  
  /// 캐시 크기 조회
  Future<Map<String, int>> getCacheSizes() async {
    try {
      if (_cacheDir == null) await initialize();
      
      final imageSize = await _getDirectorySize(_imageCacheDir!);
      final chatSize = await _getDirectorySize(_chatCacheDir!);
      final personaSize = await _getDirectorySize(_personaCacheDir!);
      
      return {
        'image': imageSize,
        'chat': chatSize,
        'persona': personaSize,
        'total': imageSize + chatSize + personaSize,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Cache size calculation error: $e');
      }
      return {'image': 0, 'chat': 0, 'persona': 0, 'total': 0};
    }
  }
  
  /// 첫 로그인 체크
  Future<bool> isFirstTimeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return !prefs.containsKey('has_seen_tutorial');
    } catch (e) {
      if (kDebugMode) {
        print('First time user check error: $e');
      }
      return true; // 에러 시 첫 사용자로 간주
    }
  }
  
  /// 튜토리얼 완료 표시
  Future<void> markTutorialCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_tutorial', true);
      await prefs.setInt('tutorial_completed_at', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('Mark tutorial completed error: $e');
      }
    }
  }
  
  /// 튜토리얼 상태 리셋 (개발용)
  Future<void> resetTutorialStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_seen_tutorial');
      await prefs.remove('tutorial_completed_at');
      if (kDebugMode) {
        print('Tutorial status reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Reset tutorial status error: $e');
      }
    }
  }
  
  /// 전체 캐시 정리
  Future<bool> clearAllCache() async {
    try {
      if (_cacheDir == null) await initialize();
      
      if (await _imageCacheDir!.exists()) {
        await _imageCacheDir!.delete(recursive: true);
        await _imageCacheDir!.create();
      }
      
      if (await _chatCacheDir!.exists()) {
        await _chatCacheDir!.delete(recursive: true);
        await _chatCacheDir!.create();
      }
      
      if (await _personaCacheDir!.exists()) {
        await _personaCacheDir!.delete(recursive: true);
        await _personaCacheDir!.create();
      }
      
      // SharedPreferences의 캐시 메타데이터도 정리
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Clear all cache error: $e');
      }
      return false;
    }
  }
  
  /// 특정 타입 캐시 정리
  Future<bool> clearCache(String type) async {
    try {
      Directory? targetDir;
      switch (type) {
        case 'image':
          targetDir = _imageCacheDir;
          break;
        case 'chat':
          targetDir = _chatCacheDir;
          break;
        case 'persona':
          targetDir = _personaCacheDir;
          break;
      }
      
      if (targetDir != null && await targetDir.exists()) {
        await targetDir.delete(recursive: true);
        await targetDir.create();
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Clear $type cache error: $e');
      }
      return false;
    }
  }
  
  // Private 메서드들
  
  String _generateHash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  Future<void> _saveImageMetadata(String hash, String url, int size) async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = {
      'url': url,
      'size': size,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString('cache_image_$hash', jsonEncode(metadata));
  }
  
  Future<bool> _isImageCacheExpired(String hash) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadataStr = prefs.getString('cache_image_$hash');
      
      if (metadataStr == null) return true;
      
      final metadata = jsonDecode(metadataStr);
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(metadata['cachedAt']);
      
      return DateTime.now().difference(cachedAt) > _imageCacheExpiry;
    } catch (e) {
      return true;
    }
  }
  
  Future<void> _removeImageCache(String hash) async {
    try {
      final file = File('${_imageCacheDir!.path}/$hash');
      if (await file.exists()) {
        await file.delete();
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cache_image_$hash');
    } catch (e) {
      if (kDebugMode) {
        print('Remove image cache error: $e');
      }
    }
  }
  
  Future<void> _checkAndCleanImageCache() async {
    try {
      final currentSize = await _getDirectorySize(_imageCacheDir!);
      
      if (currentSize > _maxImageCacheSize) {
        await _cleanImageCacheBySize();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Image cache cleanup error: $e');
      }
    }
  }
  
  Future<void> _checkAndCleanChatCache() async {
    try {
      final currentSize = await _getDirectorySize(_chatCacheDir!);
      
      if (currentSize > _maxChatCacheSize) {
        await _cleanChatCacheBySize();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Chat cache cleanup error: $e');
      }
    }
  }
  
  Future<void> _cleanImageCacheBySize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_image_')).toList();
      
      // 캐시된 시간 순으로 정렬 (오래된 것부터)
      final cacheInfos = <Map<String, dynamic>>[];
      
      for (final key in keys) {
        final metadataStr = prefs.getString(key);
        if (metadataStr != null) {
          final metadata = jsonDecode(metadataStr);
          metadata['key'] = key;
          metadata['hash'] = key.replaceFirst('cache_image_', '');
          cacheInfos.add(metadata);
        }
      }
      
      cacheInfos.sort((a, b) => a['cachedAt'].compareTo(b['cachedAt']));
      
      // 절반 정도 삭제
      final deleteCount = (cacheInfos.length * 0.5).round();
      
      for (int i = 0; i < deleteCount && i < cacheInfos.length; i++) {
        await _removeImageCache(cacheInfos[i]['hash']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clean image cache by size error: $e');
      }
    }
  }
  
  Future<void> _cleanChatCacheBySize() async {
    try {
      final files = await _chatCacheDir!.list().toList();
      files.sort((a, b) {
        return a.statSync().modified.compareTo(b.statSync().modified);
      });
      
      // 절반 정도 삭제
      final deleteCount = (files.length * 0.5).round();
      
      for (int i = 0; i < deleteCount && i < files.length; i++) {
        if (files[i] is File) {
          await (files[i] as File).delete();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clean chat cache by size error: $e');
      }
    }
  }
  
  Future<void> _cleanExpiredCache() async {
    try {
      // 만료된 이미지 캐시 정리
      final prefs = await SharedPreferences.getInstance();
      final imageKeys = prefs.getKeys().where((key) => key.startsWith('cache_image_')).toList();
      
      for (final key in imageKeys) {
        final hash = key.replaceFirst('cache_image_', '');
        if (await _isImageCacheExpired(hash)) {
          await _removeImageCache(hash);
        }
      }
      
      // 만료된 대화 캐시 정리
      if (await _chatCacheDir!.exists()) {
        final files = await _chatCacheDir!.list().toList();
        
        for (final entity in files) {
          if (entity is File) {
            final stat = await entity.stat();
            if (DateTime.now().difference(stat.modified) > _chatCacheExpiry) {
              await entity.delete();
            }
          }
        }
      }
      
      // 만료된 페르소나 캐시 정리
      final personaFile = File('${_personaCacheDir!.path}/personas.json');
      if (await personaFile.exists()) {
        final stat = await personaFile.stat();
        if (DateTime.now().difference(stat.modified) > _personaCacheExpiry) {
          await personaFile.delete();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clean expired cache error: $e');
      }
    }
  }
  
  Future<int> _getDirectorySize(Directory directory) async {
    int size = 0;
    
    try {
      if (await directory.exists()) {
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            size += await entity.length();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Directory size calculation error: $e');
      }
    }
    
    return size;
  }
}