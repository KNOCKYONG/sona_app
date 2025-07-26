import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/persona.dart';

/// Optimized PersonaCard with performance improvements:
/// - Const constructors and pre-calculated values
/// - Optimized overlay rendering with safer color calculations
/// - Reduced widget rebuilds with separate stateless widgets
/// - Cached gradients and shadows
/// - Lazy loading for images
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
  static const _shadowColor = Color(0x20000000);
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPhoto() {
    if (_currentPhotoIndex < widget.persona.photoUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(borderRadius: _cardRadius),
      child: ClipRRect(
        borderRadius: _cardRadius,
        child: Stack(
          children: [
            // Photo PageView
            _PhotoPageView(
              photoUrls: widget.persona.photoUrls,
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPhotoIndex = index;
                });
              },
            ),
            
            // Photo counter (top right)
            if (widget.persona.photoUrls.length > 1)
              _PhotoCounter(
                current: _currentPhotoIndex,
                total: widget.persona.photoUrls.length,
              ),
            
            // Photo indicators (bottom)
            if (widget.persona.photoUrls.length > 1)
              _PhotoIndicators(
                count: widget.persona.photoUrls.length,
                currentIndex: _currentPhotoIndex,
              ),
            
            // Navigation areas
            if (widget.persona.photoUrls.length > 1)
              _NavigationAreas(
                currentIndex: _currentPhotoIndex,
                maxIndex: widget.persona.photoUrls.length - 1,
                onPrevious: _previousPhoto,
                onNext: _nextPhoto,
              ),
            
            // Gradient overlay
            const _GradientOverlay(),
            
            // Persona info
            _PersonaInfo(persona: widget.persona),
            
            // Swipe overlay
            _SwipeOverlay(
              horizontal: widget.horizontalThresholdPercentage,
              vertical: widget.verticalThresholdPercentage,
            ),
            
            // Relationship badge
            if (widget.persona.relationshipScore > 0)
              _RelationshipBadge(
                persona: widget.persona,
                hasMultiplePhotos: widget.persona.photoUrls.length > 1,
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

// Persona info widget
class _PersonaInfo extends StatelessWidget {
  final Persona persona;

  const _PersonaInfo({required this.persona});

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
              if (persona.isExpert) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      const Text('전문가', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
              
              // 이름
              Flexible(
                child: Text(
                  persona.isExpert && persona.profession != null
                      ? 'Dr. ${persona.name}'
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
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.4,
            ),
            maxLines: 2,
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

// Swipe overlay widget with optimized color calculations
class _SwipeOverlay extends StatelessWidget {
  final double horizontal;
  final double vertical;

  const _SwipeOverlay({
    required this.horizontal,
    required this.vertical,
  });

  Color _getOverlayColor() {
    // Check for invalid values
    if (horizontal.isNaN || horizontal.isInfinite || 
        vertical.isNaN || vertical.isInfinite) {
      return Colors.transparent;
    }

    // Clamp values to safe range
    final safeHorizontal = horizontal.clamp(-1.0, 1.0);
    final safeVertical = vertical.clamp(-1.0, 1.0);
    
    // Calculate opacity (0.0 to 0.5)
    double opacity(double value) => (value.abs() * 0.5).clamp(0.0, 0.5);

    // Check thresholds and return appropriate color
    if (safeVertical < -0.1) {
      return Colors.blue.withValues(alpha: opacity(safeVertical));
    } else if (safeHorizontal > 0.1) {
      return const Color(0xFFFF6B9D).withValues(alpha: opacity(safeHorizontal));
    } else if (safeHorizontal < -0.1) {
      return Colors.grey.withValues(alpha: opacity(safeHorizontal));
    }
    
    return Colors.transparent;
  }

  Widget? _getOverlayIcon() {
    // Check for invalid values
    if (horizontal.isNaN || horizontal.isInfinite || 
        vertical.isNaN || vertical.isInfinite) {
      return null;
    }

    final safeHorizontal = horizontal.clamp(-1.0, 1.0);
    final safeVertical = vertical.clamp(-1.0, 1.0);
    
    if (safeVertical < -0.1) {
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