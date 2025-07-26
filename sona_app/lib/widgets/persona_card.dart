import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/persona.dart';

/// Optimized PersonaCard with performance improvements and R2 image support:
/// - R2 image loading with fallback to photoUrls
/// - Const constructors and pre-calculated values
/// - Optimized overlay rendering with safer color calculations
/// - Reduced widget rebuilds with separate stateless widgets
/// - Expert badge support
/// - Cached gradients and shadows
class PersonaCard extends StatefulWidget {
  final Persona persona;
  final double horizontalThresholdPercentage;
  final double verticalThresholdPercentage;

  const PersonaCard({
    super.key,
    required this.persona,
    this.horizontalThresholdPercentage = 0.0,
    this.verticalThresholdPercentage = 0.0,
  });

  @override
  State<PersonaCard> createState() => _PersonaCardState();
}

class _PersonaCardState extends State<PersonaCard> {
  int _currentPhotoIndex = 0;
  late final PageController _pageController;

  // Pre-calculated static values
  static const _cardRadius = BorderRadius.all(Radius.circular(16));
  static const _gradientColors = [Colors.transparent, Color(0xCC000000)];
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPersonaImage() {
    // R2 이미지 URL 확인
    final r2ImageUrl = widget.persona.getMediumImageUrl();
    
    // 디버그 정보 출력
    debugPrint('=== PersonaCard Image Debug ===');
    debugPrint('Persona: ${widget.persona.name}');
    debugPrint('imageUrls raw: ${widget.persona.imageUrls}');
    debugPrint('getMediumImageUrl result: $r2ImageUrl');
    
    // 영문 URL은 인코딩 없이 그대로 사용
    final urlToUse = r2ImageUrl;
    
    // R2 URL이 잘못된 형식인지 확인
    if (urlToUse != null) {
      debugPrint('🔷 Final URL to use: $urlToUse');
    }
    
    // R2 이미지가 있고 유효한 경우 (커스텀 도메인 포함)
    if (urlToUse != null && (urlToUse.contains('r2.dev') || urlToUse.contains('teamsona.work'))) {
      // WebP URL을 JPEG로 변경 시도
      final jpegUrl = urlToUse.endsWith('.webp') 
          ? urlToUse.replaceAll('.webp', '.jpg')
          : urlToUse;
          
      return CachedNetworkImage(
        imageUrl: jpegUrl,  // JPEG URL 사용
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6B9D),
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          // JPEG 실패 시 WebP 시도
          if (jpegUrl != r2ImageUrl && r2ImageUrl != null) {
            return CachedNetworkImage(
              imageUrl: r2ImageUrl!,  // 원본 WebP URL
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF6B9D),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
              memCacheWidth: 800,
              memCacheHeight: 1200,
            );
          }
          // 이미 JPEG인 경우 플레이스홀더
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            ),
          );
        },
        memCacheWidth: 800,
        memCacheHeight: 1200,
      );
    }
    
    // R2 이미지가 없으면 플레이스홀더 표시
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }
  
  void _nextPhoto() {
    if (widget.persona.photoUrls.isEmpty) return;
    
    if (_currentPhotoIndex < widget.persona.photoUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPhoto() {
    if (widget.persona.photoUrls.isEmpty) return;
    
    if (_currentPhotoIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if using R2 image
    final hasR2Image = widget.persona.getMediumImageUrl()?.contains('r2.dev') ?? false;
    
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(borderRadius: _cardRadius),
      child: ClipRRect(
        borderRadius: _cardRadius,
        child: Stack(
          children: [
            // Photo display (R2 image or PageView)
            _buildPersonaImage(),
            
            // Photo counter (top right) - only for multiple photos and no R2 image
            if (widget.persona.photoUrls.length > 1 && !hasR2Image)
              _PhotoCounter(
                current: _currentPhotoIndex,
                total: widget.persona.photoUrls.length,
              ),
            
            // Photo indicators (bottom) - only for multiple photos and no R2 image
            if (widget.persona.photoUrls.length > 1 && !hasR2Image)
              _PhotoIndicators(
                count: widget.persona.photoUrls.length,
                currentIndex: _currentPhotoIndex,
              ),
            
            // Navigation areas - only for multiple photos and no R2 image
            if (widget.persona.photoUrls.length > 1 && !hasR2Image)
              _NavigationAreas(
                currentIndex: _currentPhotoIndex,
                maxIndex: widget.persona.photoUrls.length - 1,
                onPrevious: _previousPhoto,
                onNext: _nextPhoto,
              ),
            
            // Gradient overlay
            const _GradientOverlay(),
            
            // Persona info with expert badge
            _PersonaInfo(
              persona: widget.persona,
              isExpert: widget.persona.isExpert || 
                        widget.persona.role == 'expert' || 
                        widget.persona.role == 'specialist' || 
                        widget.persona.name.contains('Dr.'),
            ),
            
            // Swipe overlay with safe color handling
            _SwipeOverlay(
              horizontal: widget.horizontalThresholdPercentage,
              vertical: widget.verticalThresholdPercentage,
              isExpert: widget.persona.isExpert || 
                        widget.persona.role == 'expert' || 
                        widget.persona.role == 'specialist' || 
                        widget.persona.name.contains('Dr.'),
            ),
            
            // Relationship badge
            if (widget.persona.relationshipScore > 0)
              _RelationshipBadge(
                persona: widget.persona,
                hasMultiplePhotos: widget.persona.photoUrls.length > 1 && !hasR2Image,
              ),
          ],
        ),
      ),
    );
  }
}

// Photo PageView widget
class _PhotoPageView extends StatelessWidget {
  final List<String> photoUrls;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const _PhotoPageView({
    required this.photoUrls,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return const _PlaceholderImage();
    }

    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        if (index >= photoUrls.length) {
          return const _PlaceholderImage();
        }
        
        return CachedNetworkImage(
          imageUrl: photoUrls[index],
          fit: BoxFit.cover,
          // Use lower resolution for placeholder
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B9D),
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const _PlaceholderImage(),
          // Memory cache size optimization
          memCacheWidth: 800,
          memCacheHeight: 1200,
        );
      },
    );
  }
}

// Placeholder image widget
class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }
}

// Photo counter widget
class _PhotoCounter extends StatelessWidget {
  final int current;
  final int total;

  const _PhotoCounter({
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${current + 1}/$total',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Photo indicators widget
class _PhotoIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PhotoIndicators({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation areas widget
class _NavigationAreas extends StatelessWidget {
  final int currentIndex;
  final int maxIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _NavigationAreas({
    required this.currentIndex,
    required this.maxIndex,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Row(
        children: [
          // Left navigation
          Expanded(
            child: GestureDetector(
              onTap: currentIndex > 0 ? onPrevious : null,
              behavior: HitTestBehavior.opaque,
              child: currentIndex > 0
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          '‹',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          // Right navigation
          Expanded(
            child: GestureDetector(
              onTap: currentIndex < maxIndex ? onNext : null,
              behavior: HitTestBehavior.opaque,
              child: currentIndex < maxIndex
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '›',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

// Gradient overlay widget
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _PersonaCardState._gradientColors,
          ),
        ),
        child: SizedBox(height: 200),
      ),
    );
  }
}

// Persona info widget with expert badge support
class _PersonaInfo extends StatelessWidget {
  final Persona persona;
  final bool isExpert;

  const _PersonaInfo({
    required this.persona,
    required this.isExpert,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 전문가 뱃지를 이름 앞에 표시
              if (isExpert) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              
              // 이름
              Flexible(
                child: Text(
                  isExpert && persona.profession != null
                      ? (persona.name.contains('Dr.') ? persona.name : 'Dr. ${persona.name}')
                      : persona.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              
              // 나이
              Text(
                '${persona.age}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 6),
              
              // MBTI
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                ),
                child: Text(
                  persona.mbti,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 전문 분야 표시 (전문가인 경우)
          if (isExpert && persona.profession != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              child: Text(
                persona.profession!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            persona.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.4,
            ),
            maxLines: isExpert ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (persona.photoUrls.length > 1) ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.white60,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '좌우 탭으로 사진 넘기기',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Swipe overlay widget with optimized color calculations and expert support
class _SwipeOverlay extends StatelessWidget {
  final double horizontal;
  final double vertical;
  final bool isExpert;

  const _SwipeOverlay({
    required this.horizontal,
    required this.vertical,
    required this.isExpert,
  });

  Color _getOverlayColor() {
    // Complete safety checks with default transparent color
    try {
      // Check for invalid values
      if (horizontal.isNaN || horizontal.isInfinite || 
          vertical.isNaN || vertical.isInfinite) {
        return const Color(0x00000000); // Fully transparent
      }

      // Clamp values to safe range
      final safeHorizontal = horizontal.clamp(-1.0, 1.0);
      final safeVertical = vertical.clamp(-1.0, 1.0);
      
      // Safe opacity calculation (0.0 to 0.5)
      double calculateSafeOpacity(double value) {
        final absValue = value.abs().clamp(0.0, 1.0);
        return (absValue * 0.5).clamp(0.0, 0.5);
      }

      // Check thresholds and return appropriate color
      if (safeVertical < -0.1) {
        final opacity = calculateSafeOpacity(safeVertical);
        if (isExpert) {
          // Experts use like color instead of super like
          return Color.fromRGBO(255, 107, 157, opacity); // Pink (Like)
        } else {
          return Color.fromRGBO(25, 118, 210, opacity); // Blue (Super Like)
        }
      } else if (safeHorizontal > 0.1) {
        final opacity = calculateSafeOpacity(safeHorizontal);
        return Color.fromRGBO(255, 107, 157, opacity); // Pink (Like)
      } else if (safeHorizontal < -0.1) {
        final opacity = calculateSafeOpacity(safeHorizontal);
        return Color.fromRGBO(158, 158, 158, opacity); // Grey (Pass)
      }
    } catch (e) {
      debugPrint('Error in _getOverlayColor: $e');
    }
    
    return const Color(0x00000000); // Default transparent
  }

  Widget? _getOverlayIcon() {
    try {
      // Check for invalid values
      if (horizontal.isNaN || horizontal.isInfinite || 
          vertical.isNaN || vertical.isInfinite) {
        return null;
      }

      final safeHorizontal = horizontal.clamp(-1.0, 1.0);
      final safeVertical = vertical.clamp(-1.0, 1.0);
      
      if (safeVertical < -0.1) {
        if (isExpert) {
          // Experts show like icon instead of super like
          return const Text('💕', style: TextStyle(fontSize: 60));
        } else {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💫', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'SUPER\nLIKE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          );
        }
      } else if (safeHorizontal > 0.1) {
        return const Text('💕', style: TextStyle(fontSize: 60));
      } else if (safeHorizontal < -0.1) {
        return const Text(
          '✕',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in _getOverlayIcon: $e');
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getOverlayColor();
    if (color == Colors.transparent) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _getOverlayIcon() ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// Relationship badge widget
class _RelationshipBadge extends StatelessWidget {
  final Persona persona;
  final bool hasMultiplePhotos;

  const _RelationshipBadge({
    required this.persona,
    required this.hasMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: hasMultiplePhotos ? 50 : 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B9D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              persona.getRelationshipType().displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}