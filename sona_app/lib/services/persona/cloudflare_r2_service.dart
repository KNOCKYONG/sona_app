import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'image_optimization_service.dart';

/// Cloudflare R2 서비스
/// MCP를 통한 업로드와 Public URL을 통한 다운로드 관리
class CloudflareR2Service {
  // R2 버킷 정보 (환경변수에서 로드)
  static String get bucketName =>
      dotenv.env['R2_BUCKET_NAME'] ?? 'sona-personas';
  static String get publicUrl => dotenv.env['R2_PUBLIC_URL'] ?? '';
  static String get accountId => dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  static String get apiToken => dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';
  static String get accessKeyId => dotenv.env['R2_ACCESS_KEY_ID'] ?? '';
  static String get secretAccessKey => dotenv.env['R2_SECRET_ACCESS_KEY'] ?? '';

  // 이미지 URL 구조
  // https://pub-{hash}.r2.dev/{bucket}/personas/{personaId}/{size}.webp

  /// 페르소나 이미지 세트 업로드
  /// MCP를 통해 업로드하고 URL들을 반환
  static Future<PersonaImageUrls> uploadPersonaImages({
    required String personaId,
    required Uint8List mainImage,
    List<Uint8List>? additionalImages,
    bool includeOriginal = false,
  }) async {
    debugPrint('🚀 Starting persona image upload for: $personaId');

    try {
      // 1. 메인 이미지 최적화
      final mainOptimized = await ImageOptimizationService.optimizeImage(
        mainImage,
        includeOriginal: includeOriginal,
      );

      // 2. 각 사이즈별로 R2에 업로드
      final mainUrls = <ImageSize, String>{};

      for (final entry in mainOptimized.images.entries) {
        final size = entry.key;
        final imageData = entry.value;

        final path = 'personas/$personaId/main_${size.suffix}.jpg';

        // R2 API를 통한 업로드
        final uploadSuccess = await uploadToR2(path, imageData);
        if (uploadSuccess) {
          final url = generatePublicUrl(path);
          mainUrls[size] = url;
          debugPrint(
              '✅ Uploaded main ${size.suffix}: ${ImageOptimizationService.formatBytes(mainOptimized.fileSizes[size]!)}');
        } else {
          debugPrint('❌ Failed to upload main image ${size.suffix}');
        }
      }

      // 3. 추가 이미지들 처리
      final additionalUrls = <int, Map<ImageSize, String>>{};

      if (additionalImages != null) {
        for (int i = 0; i < additionalImages.length; i++) {
          final optimized = await ImageOptimizationService.optimizeImage(
            additionalImages[i],
            includeOriginal: false, // 추가 이미지는 원본 제외
          );

          final urls = <ImageSize, String>{};

          for (final entry in optimized.images.entries) {
            final size = entry.key;
            final imageData = entry.value;

            final path = 'personas/$personaId/sub${i}_${size.suffix}.jpg';

            // R2 API를 통한 업로드
            final uploadSuccess = await uploadToR2(path, imageData);
            if (!uploadSuccess) {
              debugPrint('❌ Failed to upload additional image $i ${size.suffix}');
              continue;
            }
            final url = generatePublicUrl(path);
            urls[size] = url;
          }

          additionalUrls[i] = urls;
          debugPrint('📤 Uploaded additional image $i');
        }
      }

      // 4. 결과 반환
      return PersonaImageUrls(
        personaId: personaId,
        mainImageUrls: mainUrls,
        additionalImageUrls: additionalUrls,
      );
    } catch (e) {
      debugPrint('❌ Error uploading persona images: $e');
      rethrow;
    }
  }

  /// 이미지 URL 생성 (크기별)
  static String getImageUrl(String personaId, ImageSize size,
      {bool isMain = true, int? index}) {
    final prefix = isMain ? 'main' : 'sub$index';
    final path = 'personas/$personaId/${prefix}_${size.suffix}.jpg';
    return generatePublicUrl(path);
  }

  /// Public URL 생성
  static String generatePublicUrl(String path) {
    // 실제 R2 Public URL 형식
    // 예: https://pub-abc123.r2.dev/personas/...
    if (publicUrl.isNotEmpty) {
      // R2 public URL is configured to serve the bucket directly
      return '$publicUrl/$path';
    }

    // 개발 중 임시 URL
    return 'https://pub-demo.r2.dev/$path';
  }

  /// 이미지 프리로드 (썸네일만)
  static Future<void> preloadThumbnails(
      BuildContext context, List<String> personaIds) async {
    debugPrint('🔄 Preloading ${personaIds.length} thumbnails...');

    for (final personaId in personaIds) {
      final url = getImageUrl(personaId, ImageSize.thumbnail);

      try {
        await precacheImage(
          NetworkImage(url),
          context,
        );
      } catch (e) {
        debugPrint('⚠️ Failed to preload thumbnail for $personaId: $e');
      }
    }

    debugPrint('✅ Thumbnail preloading complete');
  }

  /// 이미지 삭제 (MCP 통해)
  static Future<bool> deletePersonaImages(String personaId) async {
    try {
      // TODO: MCP를 통한 실제 삭제 구현
      debugPrint('🗑️ Deleting images for persona: $personaId');

      // 모든 크기의 이미지 삭제
      for (final size in ImageSize.values) {
        final mainPath = 'personas/$personaId/main_${size.suffix}.webp';
        // MCP delete 호출
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error deleting persona images: $e');
      return false;
    }
  }

  /// R2에 실제 파일 업로드 (S3 API 사용)
  static Future<bool> uploadToR2(String path, Uint8List data) async {
    try {
      // R2 S3 API 자격 증명
      final endpoint = dotenv.env['R2_ENDPOINT'] ?? '';
      
      if (accessKeyId.isEmpty || secretAccessKey.isEmpty || endpoint.isEmpty) {
        debugPrint('❌ R2 S3 credentials not configured in .env file');
        return false;
      }
      
      // S3 요청 준비
      final now = DateTime.now().toUtc();
      final dateStamp = DateFormat('yyyyMMdd').format(now);
      final amzDate = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(now);
      
      // 요청 헤더
      final host = Uri.parse(endpoint).host;
      final contentType = 'image/jpeg';
      final contentLength = data.length.toString();
      
      // Canonical Request 생성
      final canonicalUri = '/$bucketName/$path';
      final canonicalQueryString = '';
      final payloadHash = sha256.convert(data).toString();
      
      final canonicalHeaders = 
        'content-length:$contentLength\n' +
        'content-type:$contentType\n' +
        'host:$host\n' +
        'x-amz-content-sha256:$payloadHash\n' +
        'x-amz-date:$amzDate\n';
      
      final signedHeaders = 'content-length;content-type;host;x-amz-content-sha256;x-amz-date';
      
      final canonicalRequest = 
        'PUT\n' +
        '$canonicalUri\n' +
        '$canonicalQueryString\n' +
        '$canonicalHeaders\n' +
        '$signedHeaders\n' +
        '$payloadHash';
      
      // String to Sign 생성
      final algorithm = 'AWS4-HMAC-SHA256';
      // R2는 'auto' region을 사용
      final credentialScope = '$dateStamp/auto/s3/aws4_request';
      final stringToSign = 
        '$algorithm\n' +
        '$amzDate\n' +
        '$credentialScope\n' +
        sha256.convert(utf8.encode(canonicalRequest)).toString();
      
      // Signing Key 생성
      final kDate = Hmac(sha256, utf8.encode('AWS4$secretAccessKey'))
          .convert(utf8.encode(dateStamp));
      final kRegion = Hmac(sha256, kDate.bytes)
          .convert(utf8.encode('auto'));  // R2는 'auto' region 사용
      final kService = Hmac(sha256, kRegion.bytes)
          .convert(utf8.encode('s3'));
      final kSigning = Hmac(sha256, kService.bytes)
          .convert(utf8.encode('aws4_request'));
      
      // 서명 생성
      final signature = Hmac(sha256, kSigning.bytes)
          .convert(utf8.encode(stringToSign))
          .toString();
      
      // Authorization 헤더
      final authorization = 
        '$algorithm Credential=$accessKeyId/$credentialScope, ' +
        'SignedHeaders=$signedHeaders, Signature=$signature';
      
      // HTTP 요청 실행
      final response = await http.put(
        Uri.parse('$endpoint/$bucketName/$path'),
        headers: {
          'Authorization': authorization,
          'Content-Type': contentType,
          'Content-Length': contentLength,
          'Host': host,
          'x-amz-content-sha256': payloadHash,
          'x-amz-date': amzDate,
        },
        body: data,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Successfully uploaded to R2 via S3 API: $path');
        return true;
      } else {
        debugPrint('❌ R2 S3 upload failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error uploading to R2 via S3 API: $e');
      return false;
    }
  }

  /// 버킷 통계 조회 (MCP 통해)
  static Future<BucketStats> getBucketStats() async {
    try {
      // TODO: MCP를 통한 실제 통계 조회
      return BucketStats(
        totalSize: 0,
        objectCount: 0,
        bandwidthUsed: 0,
      );
    } catch (e) {
      debugPrint('❌ Error getting bucket stats: $e');
      rethrow;
    }
  }
}

/// 페르소나 이미지 URL 세트
class PersonaImageUrls {
  final String personaId;
  final Map<ImageSize, String> mainImageUrls;
  final Map<int, Map<ImageSize, String>> additionalImageUrls;

  PersonaImageUrls({
    required this.personaId,
    required this.mainImageUrls,
    required this.additionalImageUrls,
  });

  /// 메인 이미지 URL 가져오기
  String? getMainUrl(ImageSize size) => mainImageUrls[size];

  /// 추가 이미지 URL 가져오기
  String? getAdditionalUrl(int index, ImageSize size) {
    return additionalImageUrls[index]?[size];
  }

  /// 모든 URL 리스트로 변환 (호환성)
  List<String> toPhotoUrls() {
    final urls = <String>[];

    // 메인 이미지 (medium 크기)
    final mainMedium = mainImageUrls[ImageSize.medium];
    if (mainMedium != null) {
      urls.add(mainMedium);
    }

    // 추가 이미지들 (medium 크기)
    for (final urlMap in additionalImageUrls.values) {
      final medium = urlMap[ImageSize.medium];
      if (medium != null) {
        urls.add(medium);
      }
    }

    return urls;
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'personaId': personaId,
      'mainImageUrls': mainImageUrls.map((k, v) => MapEntry(k.suffix, v)),
      'additionalImageUrls': additionalImageUrls.map(
        (k, v) =>
            MapEntry(k.toString(), v.map((k2, v2) => MapEntry(k2.suffix, v2))),
      ),
    };
  }

  /// JSON에서 생성
  factory PersonaImageUrls.fromJson(Map<String, dynamic> json) {
    final mainUrls = <ImageSize, String>{};
    final mainUrlsJson = json['mainImageUrls'] as Map<String, dynamic>;

    for (final size in ImageSize.values) {
      final url = mainUrlsJson[size.suffix];
      if (url != null) {
        mainUrls[size] = url;
      }
    }

    final additionalUrls = <int, Map<ImageSize, String>>{};
    final additionalJson = json['additionalImageUrls'] as Map<String, dynamic>?;

    if (additionalJson != null) {
      additionalJson.forEach((key, value) {
        final index = int.parse(key);
        final urls = <ImageSize, String>{};

        final urlMap = value as Map<String, dynamic>;
        for (final size in ImageSize.values) {
          final url = urlMap[size.suffix];
          if (url != null) {
            urls[size] = url;
          }
        }

        additionalUrls[index] = urls;
      });
    }

    return PersonaImageUrls(
      personaId: json['personaId'],
      mainImageUrls: mainUrls,
      additionalImageUrls: additionalUrls,
    );
  }
}

/// 버킷 통계
class BucketStats {
  final int totalSize;
  final int objectCount;
  final int bandwidthUsed;

  BucketStats({
    required this.totalSize,
    required this.objectCount,
    required this.bandwidthUsed,
  });
}
