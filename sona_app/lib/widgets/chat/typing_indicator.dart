import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/persona/persona_service.dart';

/// iOS Messages-style typing indicator with smooth animations
class TypingIndicator extends StatefulWidget {
  final String? personaName;

  const TypingIndicator({
    super.key,
    this.personaName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    // Fade in/out animation for the whole indicator
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),  // Smooth fade in
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    // iOS-style pulse animation for dots - smooth wave effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1400),  // Optimal speed
      vsync: this,
    )..repeat();

    // Create staggered animations for each dot - wave pattern
    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _pulseController,
          curve: Interval(
            index * 0.2,  // Sequential timing
            0.4 + index * 0.2,  // Wave effect
            curve: Curves.easeInOutSine,  // Smooth sine wave
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personaService = Provider.of<PersonaService>(context);
    final persona = personaService.currentPersona;
    final thumbnailUrl = persona?.getThumbnailUrl();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Persona profile image (matching message bubble style)
            if (persona != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          fit: BoxFit.cover,
                          memCacheWidth: 72,
                          memCacheHeight: 72,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFFFF6B9D),
                              size: 20,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFFFF6B9D),
                            size: 20,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // iOS-style typing bubble
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA), // iOS gray bubble color
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _dotAnimations[index],
                    builder: (context, child) {
                      // 더 미묘한 애니메이션 - 크기 변화 줄이고 투명도 위주로
                      final scale = 0.8 + (_dotAnimations[index].value * 0.2);  // 크기 변화 최소화
                      final opacity = 0.3 + (_dotAnimations[index].value * 0.7);  // 투명도 변화 증가
                      
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: index == 1 ? 3 : 2,
                        ),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              width: 8,  // 약간 작게
                              height: 8,  // 약간 작게
                              decoration: BoxDecoration(
                                color: const Color(0xFF8E8E93), // iOS dot color
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

