import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../models/persona.dart';
import '../../core/preferences_manager.dart';
import 'dart:async';

/// 이미지 프리로딩 서비스
/// 최초 로그인 시 모든 페르소나 이미지를 로컬에 다운로드하여 캐싱
class ImagePreloadService {
  static final ImagePreloadService _instance = ImagePreloadService._internal();
  factory ImagePreloadService() => _instance;
  ImagePreloadService._internal();
  
  static ImagePreloadService get instance => _instance;
  
  // 프리로딩 상태
  bool _isPreloading = false;
  double _progress = 0.0;
  int _totalImages = 0;
  int _loadedImages = 0;
  final _progressController = StreamController<double>.broadcast();
  
  // 게터
  bool get isPreloading => _isPreloading;
  double get progress => _progress;
  int get totalImages => _totalImages;
  int get loadedImages => _loadedImages;
  Stream<double> get progressStream => _progressController.stream;
  
  // 캐시 키
  static const String _preloadCompletedKey = 'images_preloaded';
  static const String _preloadDateKey = 'images_preload_date';
  static const String _preloadedPersonasKey = 'preloaded_personas';
  static const String _preloadedImagesKey = 'preloaded_images';
  
  /// 이미지 프리로딩이 완료되었는지 확인
  Future<bool> isPreloadCompleted() async {
    return await PreferencesManager.getBool(_preloadCompletedKey) ?? false;
  }
  
  /// 새로운 이미지가 있는지 확인
  Future<bool> hasNewImages(List<Persona> personas) async {
    final prefs = await PreferencesManager.instance;
    final preloadedImages = prefs.getStringList(_preloadedImagesKey) ?? [];
    
    // 모든 이미지 URL 수집
    final currentImages = <String>[];
    for (final persona in personas) {
      currentImages.addAll(persona.getAllImageUrls(size: 'thumb'));
      currentImages.addAll(persona.getAllImageUrls(size: 'small'));
      currentImages.addAll(persona.getAllImageUrls(size: 'medium'));
    }
    
    // 새로운 이미지가 있는지 확인
    for (final imageUrl in currentImages) {
      if (!preloadedImages.contains(imageUrl)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// 새로운 이미지만 다운로드
  Future<void> preloadNewImages(List<Persona> personas) async {
    if (_isPreloading) {
      debugPrint('⚠️ Image preloading already in progress');
      return;
    }
    
    final prefs = await PreferencesManager.instance;
    final preloadedImages = prefs.getStringList(_preloadedImagesKey) ?? [];
    final preloadedImagesSet = preloadedImages.toSet();
    
    debugPrint('🔍 Checking for new images...');
    
    // 새로운 이미지만 수집
    final newImageUrls = <String>[];
    
    for (final persona in personas) {
      // 각 크기별로 새로운 이미지 확인
      final thumbUrls = persona.getAllImageUrls(size: 'thumb');
      final smallUrls = persona.getAllImageUrls(size: 'small');
      final mediumUrls = persona.getAllImageUrls(size: 'medium');
      
      for (final url in [...thumbUrls, ...smallUrls, ...mediumUrls]) {
        if (url.isNotEmpty && !preloadedImagesSet.contains(url)) {
          newImageUrls.add(url);
        }
      }
    }
    
    if (newImageUrls.isEmpty) {
      debugPrint('✅ No new images to download');
      return;
    }
    
    debugPrint('🆕 Found ${newImageUrls.length} new images to download');
    
    _isPreloading = true;
    _progress = 0.0;
    _loadedImages = 0;
    _totalImages = newImageUrls.length;
    
    try {
      // 배치로 다운로드 (동시 다운로드 제한)
      const batchSize = 5;
      for (int i = 0; i < newImageUrls.length; i += batchSize) {
        final batch = newImageUrls.skip(i).take(batchSize).toList();
        
        // 병렬 다운로드
        await Future.wait(
          batch.map((url) => _preloadImage(url)),
          eagerError: false, // 하나가 실패해도 계속 진행
        );
        
        // 진행률 업데이트
        _updateProgress();
      }
      
      // 새로 다운로드한 이미지들을 프리로드 목록에 추가
      final updatedPreloadedImages = [...preloadedImages, ...newImageUrls];
      await prefs.setStringList(_preloadedImagesKey, updatedPreloadedImages);
      
      debugPrint('🎉 New images preloading completed!');
      
    } catch (e) {
      debugPrint('❌ Error during new image preloading: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  /// 모든 페르소나 이미지 프리로딩
  Future<void> preloadAllPersonaImages(List<Persona> personas) async {
    // 이미 프리로딩 중이면 중복 실행 방지
    if (_isPreloading) {
      debugPrint('⚠️ Image preloading already in progress');
      return;
    }
    
    // 이미 프리로딩 완료되었는지 확인
    final isCompleted = await isPreloadCompleted();
    if (isCompleted) {
      debugPrint('✅ Images already preloaded');
      return;
    }
    
    debugPrint('🖼️ Starting image preloading for ${personas.length} personas...');
    _isPreloading = true;
    _progress = 0.0;
    _loadedImages = 0;
    
    try {
      // 모든 이미지 URL 수집
      final imageUrls = <String>[];
      final prefs = await PreferencesManager.instance;
      final preloadedImages = <String>[];
      
      for (final persona in personas) {
        // 썸네일 이미지 (카드에서 사용)
        final thumbUrl = persona.getThumbnailUrl();
        if (thumbUrl != null && thumbUrl.isNotEmpty) {
          imageUrls.add(thumbUrl);
          preloadedImages.add(thumbUrl);
        }
        
        // 작은 이미지 (카드 대체용)
        final smallUrl = persona.getSmallImageUrl();
        if (smallUrl != null && smallUrl.isNotEmpty) {
          imageUrls.add(smallUrl);
          preloadedImages.add(smallUrl);
        }
        
        // 중간 이미지 (프로필 보기용)
        final mediumUrl = persona.getMediumImageUrl();
        if (mediumUrl != null && mediumUrl.isNotEmpty) {
          imageUrls.add(mediumUrl);
          preloadedImages.add(mediumUrl);
        }
        
        // 큰 이미지는 선택적으로 (용량 고려)
        // final largeUrl = persona.getLargeImageUrl();
        // if (largeUrl != null && largeUrl.isNotEmpty) {
        //   imageUrls.add(largeUrl);
        // }
      }
      
      // 프리로드된 이미지 목록 저장
      await prefs.setStringList(_preloadedImagesKey, preloadedImages);
      
      _totalImages = imageUrls.length;
      debugPrint('📊 Found $_totalImages images to preload');
      
      if (_totalImages == 0) {
        _completePreloading();
        return;
      }
      
      // 배치로 다운로드 (동시 다운로드 제한)
      const batchSize = 5;
      for (int i = 0; i < imageUrls.length; i += batchSize) {
        final batch = imageUrls.skip(i).take(batchSize).toList();
        
        // 병렬 다운로드
        await Future.wait(
          batch.map((url) => _preloadImage(url)),
          eagerError: false, // 하나가 실패해도 계속 진행
        );
        
        // 진행률 업데이트
        _updateProgress();
      }
      
      // 프리로딩 완료 표시
      await _completePreloading();
      
    } catch (e) {
      debugPrint('❌ Error during image preloading: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  /// 단일 이미지 프리로드
  Future<void> _preloadImage(String imageUrl) async {
    try {
      debugPrint('📥 Preloading: ${imageUrl.substring(imageUrl.lastIndexOf('/') + 1)}');
      
      // 캐시 매니저를 통해 직접 다운로드
      final cacheManager = DefaultCacheManager();
      
      // 이미지 다운로드 및 캐싱
      final file = await cacheManager.downloadFile(
        imageUrl,
        authHeaders: const {},
      );
      
      if (file != null) {
        debugPrint('✅ Downloaded and cached: ${file.file.path}');
      }
      
      _loadedImages++;
      debugPrint('✅ Loaded $_loadedImages/$_totalImages');
      
    } catch (e) {
      debugPrint('❌ Error preloading image $imageUrl: $e');
      _loadedImages++; // 실패해도 카운트 증가
    }
  }
  
  /// 진행률 업데이트
  void _updateProgress() {
    _progress = _totalImages > 0 ? _loadedImages / _totalImages : 0.0;
    _progressController.add(_progress);
    debugPrint('📊 Progress: ${(_progress * 100).toStringAsFixed(1)}% ($_loadedImages/$_totalImages)');
  }
  
  /// 프리로딩 완료 처리
  Future<void> _completePreloading() async {
    final prefs = await PreferencesManager.instance;
    
    await PreferencesManager.setBool(_preloadCompletedKey, true);
    await PreferencesManager.setString(_preloadDateKey, DateTime.now().toIso8601String());
    
    // 프리로드된 이미지 목록 저장 (처음 프리로딩인 경우)
    if (prefs.getStringList(_preloadedImagesKey) == null) {
      // 빈 리스트로 초기화 (실제 URL은 개별적으로 추가됨)
      await prefs.setStringList(_preloadedImagesKey, []);
    }
    
    _progress = 1.0;
    _progressController.add(_progress);
    
    debugPrint('🎉 Image preloading completed!');
    debugPrint('   Total images: $_totalImages');
    debugPrint('   Successfully loaded: $_loadedImages');
  }
  
  /// 캐시 정리 (필요시 호출)
  Future<void> clearCache() async {
    try {
      await DefaultCacheManager().emptyCache();
      await PreferencesManager.remove(_preloadCompletedKey);
      await PreferencesManager.remove(_preloadDateKey);
      debugPrint('🗑️ Image cache cleared');
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }
  
  /// 캐시 크기 확인
  Future<int> getCacheSize() async {
    try {
      final cacheManager = DefaultCacheManager();
      // TODO: 실제 캐시 크기 계산 로직 구현
      return 0;
    } catch (e) {
      return 0;
    }
  }
  
  void dispose() {
    _progressController.close();
  }
}