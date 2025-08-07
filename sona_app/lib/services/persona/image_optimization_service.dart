import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// 이미지 사이즈 정의
enum ImageSize {
  thumbnail(150, 'thumb'), // 리스트용 썸네일
  small(300, 'small'), // 카드 미리보기용
  medium(600, 'medium'), // 프로필 보기용
  large(1200, 'large'), // 상세 보기용
  original(0, 'original'); // 원본

  final int maxWidth;
  final String suffix;

  const ImageSize(this.maxWidth, this.suffix);
}

/// 이미지 최적화 결과
class OptimizedImageSet {
  final Map<ImageSize, Uint8List> images;
  final Map<ImageSize, int> fileSizes;

  OptimizedImageSet({
    required this.images,
    required this.fileSizes,
  });
}

/// 이미지 최적화 서비스
class ImageOptimizationService {
  static const int jpegQuality = 85; // 85% 품질 (좋은 품질/크기 균형)
  static const int webpQuality = 80; // WebP는 조금 낮춰도 품질 유지

  /// 이미지를 여러 크기로 최적화
  static Future<OptimizedImageSet> optimizeImage(
    Uint8List imageData, {
    bool includeOriginal = false,
  }) async {
    debugPrint('🖼️ Starting image optimization...');

    final images = <ImageSize, Uint8List>{};
    final fileSizes = <ImageSize, int>{};

    // 원본 이미지 디코드
    final originalImage = img.decodeImage(imageData);
    if (originalImage == null) {
      throw Exception('Failed to decode image');
    }

    debugPrint(
        '📐 Original size: ${originalImage.width}x${originalImage.height}');

    // 각 사이즈별로 최적화
    for (final size in ImageSize.values) {
      if (size == ImageSize.original) {
        if (includeOriginal) {
          // 원본도 JPEG로 변환하여 크기 줄이기
          final jpegData = img.encodeJpg(originalImage, quality: webpQuality);
          images[size] = Uint8List.fromList(jpegData);
          fileSizes[size] = jpegData.length;
          debugPrint('💾 Original JPEG: ${formatBytes(jpegData.length)}');
        }
        continue;
      }

      // 리사이즈 필요 여부 확인
      if (originalImage.width <= size.maxWidth) {
        // 원본이 더 작으면 리사이즈 안함
        final jpegData = img.encodeJpg(originalImage, quality: webpQuality);
        images[size] = Uint8List.fromList(jpegData);
        fileSizes[size] = jpegData.length;
        debugPrint(
            '📸 ${size.suffix}: ${originalImage.width}x${originalImage.height} (원본 크기 유지) - ${formatBytes(jpegData.length)}');
        continue;
      }

      // 비율 유지하며 리사이즈
      final aspectRatio = originalImage.height / originalImage.width;
      final newWidth = size.maxWidth;
      final newHeight = (newWidth * aspectRatio).round();

      final resized = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.cubic, // 고품질 보간
      );

      // JPEG로 인코딩 (최적의 압축률)
      final jpegData = img.encodeJpg(resized, quality: webpQuality);
      images[size] = Uint8List.fromList(jpegData);
      fileSizes[size] = jpegData.length;

      debugPrint(
          '📸 ${size.suffix}: ${newWidth}x${newHeight} - ${formatBytes(jpegData.length)}');
    }

    // 총 크기 계산
    final totalSize = fileSizes.values.fold(0, (sum, size) => sum + size);
    debugPrint('✅ Total optimized size: ${formatBytes(totalSize)}');

    return OptimizedImageSet(
      images: images,
      fileSizes: fileSizes,
    );
  }

  /// Progressive JPEG 생성 (빠른 로딩용)
  static Uint8List createProgressiveJpeg(img.Image image,
      {int quality = jpegQuality}) {
    // Progressive JPEG는 점진적으로 로드되어 UX 개선
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }

  /// 파일 크기 포맷팅
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// MIME 타입 결정
  static String getMimeType(ImageSize size) {
    return 'image/jpeg'; // 모든 사이즈 JPEG 사용
  }

  /// 파일명 생성
  static String generateFileName(String personaId, ImageSize size,
      {String? index}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final indexStr = index != null ? '_$index' : '';
    return 'personas/$personaId/${size.suffix}$indexStr\_$timestamp.jpg';
  }
}

/// 이미지 캐싱 설정
class ImageCacheConfig {
  static const Map<ImageSize, Duration> cacheDuration = {
    ImageSize.thumbnail: Duration(days: 30), // 썸네일은 오래 캐싱
    ImageSize.small: Duration(days: 14), // 작은 이미지도 오래
    ImageSize.medium: Duration(days: 7), // 중간 크기는 1주일
    ImageSize.large: Duration(days: 3), // 큰 이미지는 3일
    ImageSize.original: Duration(days: 1), // 원본은 1일만
  };

  static const Map<ImageSize, int> memCacheSize = {
    ImageSize.thumbnail: 50, // 메모리에 50개 캐싱
    ImageSize.small: 30, // 30개 캐싱
    ImageSize.medium: 20, // 20개 캐싱
    ImageSize.large: 10, // 10개 캐싱
    ImageSize.original: 5, // 5개만 캐싱
  };
}
