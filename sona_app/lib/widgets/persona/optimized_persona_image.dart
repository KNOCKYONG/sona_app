import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/persona.dart';
import '../../services/persona/image_optimization_service.dart';
import '../../services/persona/cloudflare_r2_service.dart';
import '../../l10n/app_localizations.dart';

/// 최적화된 페르소나 이미지 위젯
/// 크기에 따라 적절한 이미지를 로드하고 캐싱
class OptimizedPersonaImage extends StatelessWidget {
  final Persona persona;
  final ImageSize imageSize;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoading;

  const OptimizedPersonaImage({
    super.key,
    required this.persona,
    required this.imageSize,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showLoading = true,
  });

  // 팩토리 생성자들 - 용도별 이미지
  factory OptimizedPersonaImage.thumbnail({
    required Persona persona,
    double size = 60,
    BorderRadius? borderRadius,
  }) {
    return OptimizedPersonaImage(
      persona: persona,
      imageSize: ImageSize.thumbnail,
      width: size,
      height: size,
      borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
    );
  }

  factory OptimizedPersonaImage.card({
    required Persona persona,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return OptimizedPersonaImage(
      persona: persona,
      imageSize: ImageSize.small,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }

  factory OptimizedPersonaImage.profile({
    required Persona persona,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return OptimizedPersonaImage(
      persona: persona,
      imageSize: ImageSize.medium,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
    );
  }

  factory OptimizedPersonaImage.fullScreen({
    required Persona persona,
    double? width,
    double? height,
  }) {
    return OptimizedPersonaImage(
      persona: persona,
      imageSize: ImageSize.large,
      width: width,
      height: height,
      borderRadius: BorderRadius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    // CachedNetworkImage 최적화 설정
    final cacheConfig =
        ImageCacheConfig.cacheDuration[imageSize] ?? const Duration(days: 7);
    final memCacheSize = ImageCacheConfig.memCacheSize[imageSize] ?? 20;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 150), // 200 -> 150
        fadeOutDuration: const Duration(milliseconds: 50),  // 100 -> 50
        // 메모리 캐시 크기 제한
        memCacheWidth: _getMemCacheWidth(),
        memCacheHeight: _getMemCacheHeight(),
        // 캐시 매니저 설정
        cacheKey: '${persona.id}_${imageSize.suffix}',
        // 로딩 중 표시
        placeholder: showLoading
            ? (context, url) => placeholder ?? _buildLoadingWidget()
            : null,
        // 에러 위젯
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(),
        // 고급 설정
        httpHeaders: {
          'Cache-Control': 'max-age=${cacheConfig.inSeconds}',
        },
      ),
    );
  }

  String? _getImageUrl() {
    // 새로운 R2 이미지 구조 사용
    if (persona.imageUrls != null) {
      // R2 구조에서 크기별 URL 가져오기
      switch (imageSize) {
        case ImageSize.thumbnail:
          return persona.getThumbnailUrl();
        case ImageSize.small:
          return persona.getSmallImageUrl();
        case ImageSize.medium:
          return persona.getMediumImageUrl();
        case ImageSize.large:
          return persona.getLargeImageUrl();
        case ImageSize.original:
          return persona.getOriginalImageUrl();
      }
    }

    // 폴백: photoUrls 사용
    if (persona.photoUrls.isNotEmpty) {
      return persona.photoUrls.first;
    }

    return null;
  }

  int? _getMemCacheWidth() {
    // 메모리 캐시용 크기 제한
    switch (imageSize) {
      case ImageSize.thumbnail:
        return 150;
      case ImageSize.small:
        return 300;
      case ImageSize.medium:
        return 600;
      case ImageSize.large:
        return 1200;
      case ImageSize.original:
        return null; // 원본은 제한 없음
    }
  }

  int? _getMemCacheHeight() {
    // 정사각형이 아닌 경우 높이도 계산
    if (width != null && height != null) {
      final aspectRatio = height! / width!;
      final cacheWidth = _getMemCacheWidth();
      return cacheWidth != null ? (cacheWidth * aspectRatio).round() : null;
    }
    return _getMemCacheWidth(); // 정사각형 가정
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B9D)),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: (width ?? 60) * 0.5,
        color: Colors.grey[400],
      ),
    );
  }
}

/// 이미지 갤러리용 최적화 위젯
class OptimizedPersonaGallery extends StatefulWidget {
  final Persona persona;
  final int initialIndex;

  const OptimizedPersonaGallery({
    super.key,
    required this.persona,
    this.initialIndex = 0,
  });

  @override
  State<OptimizedPersonaGallery> createState() =>
      _OptimizedPersonaGalleryState();
}

class _OptimizedPersonaGalleryState extends State<OptimizedPersonaGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = widget.persona.getAllImageUrls(size: 'large');

    if (imageUrls.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noImageAvailable),
      );
    }

    return Stack(
      children: [
        // 이미지 뷰어
        PageView.builder(
          controller: _pageController,
          itemCount: imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, size: 64),
                ),
              ),
            );
          },
        ),

        // 인디케이터
        if (imageUrls.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
