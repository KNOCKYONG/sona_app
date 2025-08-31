import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/persona.dart';
import '../../services/relationship/relationship_visual_system.dart';
import '../../utils/like_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../../config/custom_cache_manager.dart';
import 'persona_profile_viewer.dart';

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
  final bool isEnabled;

  const PersonaCard({
    super.key,
    required this.persona,
    this.horizontalThresholdPercentage = 0.0,
    this.verticalThresholdPercentage = 0.0,
    this.isEnabled = true,
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
    // 모든 이미지 URL 가져오기 (medium 크기)
    final allImageUrls = widget.persona.getAllImageUrls(size: 'medium');

    // 이미지가 없는 경우 플레이스홀더 표시
    if (allImageUrls.isEmpty) {
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

    // 단일 이미지인 경우
    if (allImageUrls.length == 1) {
      final imageUrl = allImageUrls.first;
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheManager: PersonaCacheManager.instance,
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

    // 여러 이미지인 경우 PageView 사용
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPhotoIndex = index;
        });
      },
      physics: const NeverScrollableScrollPhysics(), // 스와이프는 탭으로만
      itemCount: allImageUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = allImageUrls[index];
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheManager: PersonaCacheManager.instance,
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
      },
    );
  }

  void _nextPhoto() {
    final allImageUrls = widget.persona.getAllImageUrls(size: 'medium');
    if (allImageUrls.isEmpty) return;

    if (_currentPhotoIndex < allImageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPhoto() {
    final allImageUrls = widget.persona.getAllImageUrls(size: 'medium');
    if (allImageUrls.isEmpty) return;

    if (_currentPhotoIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if using multiple images
    final allImageUrls = widget.persona.getAllImageUrls(size: 'medium');
    final hasMultipleImages = allImageUrls.length > 1;

    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(borderRadius: _cardRadius),
      child: ClipRRect(
        borderRadius: _cardRadius,
        child: Stack(
          children: [
            // Photo display (PageView or single image)
            _buildPersonaImage(),

            // Gradient overlay
            const _GradientOverlay(),

            // Swipe overlay with safe color handling
            _SwipeOverlay(
              horizontal: widget.horizontalThresholdPercentage,
              vertical: widget.verticalThresholdPercentage,
            ),

            // Photo counter (top right) - only for multiple photos
            if (hasMultipleImages)
              _PhotoCounter(
                current: _currentPhotoIndex,
                total: allImageUrls.length,
              ),

            // Photo indicators (bottom) - only for multiple photos
            if (hasMultipleImages)
              _PhotoIndicators(
                count: allImageUrls.length,
                currentIndex: _currentPhotoIndex,
              ),

            // Relationship badge
            if (widget.persona.likes > 0)
              _RelationshipBadge(
                persona: widget.persona,
                hasMultiplePhotos: hasMultipleImages,
              ),

            // Navigation areas - only for multiple photos (moved before persona info)
            if (hasMultipleImages)
              _NavigationAreas(
                currentIndex: _currentPhotoIndex,
                maxIndex: allImageUrls.length - 1,
                onPrevious: _previousPhoto,
                onNext: _nextPhoto,
              ),

            // Persona info with expert badge - LAST to be on top for tap detection
            _PersonaInfo(
              persona: widget.persona,
              isEnabled: widget.isEnabled,
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
          cacheManager: PersonaCacheManager.instance,
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
    return Stack(
      children: [
        // 왼쪽 화살표
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: currentIndex > 0 ? onPrevious : null,
              child: currentIndex > 0
                  ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: 30,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        // 오른쪽 화살표
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: currentIndex < maxIndex ? onNext : null,
              child: currentIndex < maxIndex
                  ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
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
  final bool isEnabled;

  const _PersonaInfo({
    required this.persona,
    this.isEnabled = true,
  });

  void _showPersonaProfile(BuildContext context, Persona persona) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PersonaProfileViewer(
            persona: persona,
            onClose: () {},
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,  // Changed from 20 to 0 for full bottom coverage
      left: 0,    // Changed from 20 to 0 for full width
      right: 0,   // Changed from 20 to 0 for full width
      child: GestureDetector(
        onTap: isEnabled ? () => _showPersonaProfile(context, persona) : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Add dark gradient background for better text readability
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20), // Added top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // 이름
                  Flexible(
                    child: Text(
                      persona.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black.withValues(alpha: 0.9),
                          ),
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 나이
                  Text(
                    '${persona.age}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),

                  // MBTI
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5), width: 1),
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
              Text(
                persona.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 16,
                  height: 1.4,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ],
                ),
                maxLines: null,  // Changed from 2 to null to show full description
                overflow: TextOverflow.visible,  // Changed from ellipsis to visible
              ),
            // 여러 이미지가 있을 때 안내 표시
            Builder(builder: (context) {
              final allImageUrls = persona.getAllImageUrls(size: 'medium');
              if (allImageUrls.length > 1) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.touch_app,
                          color: Colors.white60,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.tapToSwipePhotos,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            ],
          ),
        ),
      ),
    );
  }
}

// Swipe overlay widget with optimized color calculations and expert support
class _SwipeOverlay extends StatefulWidget {
  final double horizontal;
  final double vertical;

  const _SwipeOverlay({
    required this.horizontal,
    required this.vertical,
  });

  @override
  State<_SwipeOverlay> createState() => _SwipeOverlayState();
}

class _SwipeOverlayState extends State<_SwipeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Color? _currentColor;
  Widget? _currentIcon;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150), // Fast transition
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_SwipeOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newColor = _getOverlayColor();
    final newIcon = _getOverlayIcon();

    // Only animate if there's an actual change
    if (newColor != _currentColor ||
        newIcon.runtimeType != _currentIcon.runtimeType) {
      _currentColor = newColor;
      _currentIcon = newIcon;

      if (newColor != Colors.transparent) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  Color _getOverlayColor() {
    // Complete safety checks with default transparent color
    try {
      // Check for invalid values
      if (widget.horizontal.isNaN ||
          widget.horizontal.isInfinite ||
          widget.vertical.isNaN ||
          widget.vertical.isInfinite) {
        return const Color(0x00000000); // Fully transparent
      }

      // Clamp values to safe range
      final safeHorizontal = widget.horizontal.clamp(-1.0, 1.0);
      final safeVertical = widget.vertical.clamp(-1.0, 1.0);

      // Safe opacity calculation (0.0 to 0.7 for better visibility)
      double calculateSafeOpacity(double value) {
        final absValue = value.abs().clamp(0.0, 1.0);
        return (absValue * 0.7).clamp(0.0, 0.7); // Increased from 0.5 to 0.7
      }

      // Prioritize horizontal movement over vertical for clearer direction detection
      final horizontalDominant =
          safeHorizontal.abs() > safeVertical.abs() * 1.5;

      // Check thresholds with horizontal priority
      if (horizontalDominant) {
        if (safeHorizontal < -0.1) {
          final opacity = calculateSafeOpacity(safeHorizontal);
          return Color.fromRGBO(96, 96, 96, opacity); // Darker grey for Pass
        } else if (safeHorizontal > 0.1) {
          final opacity = calculateSafeOpacity(safeHorizontal);
          return Color.fromRGBO(255, 107, 157, opacity); // Pink (Like)
        }
      } else {
        // Only check vertical if it's clearly dominant
        if (safeVertical < -0.15 && safeHorizontal.abs() < 0.1) {
          // Increased threshold
          final opacity = calculateSafeOpacity(safeVertical);
          return Color.fromRGBO(25, 118, 210, opacity); // Blue (Super Like)
        }
      }
    } catch (e) {
      debugPrint('Error in _getOverlayColor: $e');
    }

    return const Color(0x00000000); // Default transparent
  }

  Widget? _getOverlayIcon() {
    try {
      // Check for invalid values
      if (widget.horizontal.isNaN ||
          widget.horizontal.isInfinite ||
          widget.vertical.isNaN ||
          widget.vertical.isInfinite) {
        return null;
      }

      final safeHorizontal = widget.horizontal.clamp(-1.0, 1.0);
      final safeVertical = widget.vertical.clamp(-1.0, 1.0);

      // Prioritize horizontal movement over vertical for clearer direction detection
      final horizontalDominant =
          safeHorizontal.abs() > safeVertical.abs() * 1.5;

      // Check thresholds with horizontal priority
      if (horizontalDominant) {
        if (safeHorizontal < -0.1) {
          // Enhanced Pass icon with border for better visibility
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Text(
              '✕',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80, // Increased from 60 to 80
                fontWeight: FontWeight.w900, // Bolder
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          );
        } else if (safeHorizontal > 0.1) {
          return const Text('💕',
              style: TextStyle(fontSize: 70)); // Increased size
        }
      } else {
        // Only show vertical icons if clearly dominant
        if (safeVertical < -0.15 && safeHorizontal.abs() < 0.1) {
          // Increased threshold
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💫', style: TextStyle(fontSize: 60)), // Increased from 50
              SizedBox(height: 8),
              Text(
                'SUPER\nLIKE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Increased from 16
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }
    } catch (e) {
      debugPrint('Error in _getOverlayIcon: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getOverlayColor();
    final icon = _getOverlayIcon();

    if (color == Colors.transparent || color == const Color(0x00000000)) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 100), // Smooth color transition
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: icon ?? const SizedBox.shrink(),
            ),
          ),
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
    final likes = persona.likes ?? 0;
    final color = RelationshipColorSystem.getRelationshipColor(likes);

    return Positioned(
      top: hasMultiplePhotos ? 50 : 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 하트 아이콘
            SizedBox(
              width: 16,
              height: 16,
              child: HeartEvolutionSystem.getHeart(likes, size: 16),
            ),
            const SizedBox(width: 6),
            // Like 수
            Text(
              LikeFormatter.format(likes),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            // 뱃지
            SizedBox(
              width: 14,
              height: 14,
              child: RelationshipBadgeSystem.getBadge(likes, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
