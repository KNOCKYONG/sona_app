import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 커스텀 캐시 매니저 - 영구 캐싱 설정
class CustomCacheManager {
  static const key = 'libCachedImageData';
  static CacheManager instance = CacheManager(
    Config(
      key,
      // 오래된 파일 삭제 안함 (영구 캐싱)
      stalePeriod: const Duration(days: 365), // 1년
      maxNrOfCacheObjects: 1000, // 최대 1000개 이미지
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

/// 페르소나 이미지 전용 캐시 매니저
class PersonaCacheManager {
  static const key = 'personaImageCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      // 페르소나 이미지는 영구 보관
      stalePeriod: const Duration(days: 365), // 1년
      maxNrOfCacheObjects: 500, // 최대 500개 (페르소나 수 x 이미지 크기)
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
