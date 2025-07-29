import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎨 관계 시각화 시스템
/// 
/// 색상, 뱃지, 링, 하트 등 시각적 요소로 관계를 표현
class RelationshipVisualSystem {
  // 싱글톤 패턴
  static final RelationshipVisualSystem _instance = RelationshipVisualSystem._internal();
  factory RelationshipVisualSystem() => _instance;
  RelationshipVisualSystem._internal();
}

/// 색상 기반 관계 표현
class RelationshipColorSystem {
  /// 관계 점수에 따른 색상 반환
  static Color getRelationshipColor(int likes) {
    if (likes < 500) {
      // 친구: 파란색 → 하늘색
      return Color.lerp(
        Colors.blue[700]!, 
        Colors.lightBlue[400]!, 
        (likes / 500).clamp(0.0, 1.0)
      )!;
    } else if (likes < 2000) {
      // 썸: 하늘색 → 분홍색
      return Color.lerp(
        Colors.lightBlue[400]!, 
        Colors.pink[300]!, 
        ((likes - 500) / 1500).clamp(0.0, 1.0)
      )!;
    } else if (likes < 5000) {
      // 연애: 분홍색 → 빨간색
      return Color.lerp(
        Colors.pink[300]!, 
        Colors.red[400]!, 
        ((likes - 2000) / 3000).clamp(0.0, 1.0)
      )!;
    } else {
      // 깊은 사랑: 빨간색 → 와인색 → 금색
      if (likes < 10000) {
        return Color.lerp(
          Colors.red[400]!, 
          const Color(0xFF722F37), // 와인색
          ((likes - 5000) / 5000).clamp(0.0, 1.0)
        )!;
      } else {
        // 10K+ 금색 계열로 전환
        return Color.lerp(
          const Color(0xFF722F37),
          const Color(0xFFFFD700), // 금색
          ((likes - 10000) / 10000).clamp(0.0, 1.0)
        )!;
      }
    }
  }
  
  /// 다크모드 대응 색상
  static Color getAdaptiveColor(BuildContext context, int likes) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = getRelationshipColor(likes);
    
    if (isDark) {
      // 다크모드에서는 채도를 높이고 명도 조정
      final hslColor = HSLColor.fromColor(baseColor);
      return hslColor
        .withSaturation((hslColor.saturation * 1.2).clamp(0.0, 1.0))
        .withLightness((hslColor.lightness * 1.1).clamp(0.0, 0.8))
        .toColor();
    }
    
    return baseColor;
  }
}

/// 미니멀 뱃지 시스템
class RelationshipBadgeSystem {
  /// 관계 깊이를 나타내는 기하학적 뱃지
  static Widget getBadge(int likes, {double size = 12}) {
    // 도형 진화: ● → ♦ → ★ → ✦
    if (likes < 1000) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: RelationshipColorSystem.getRelationshipColor(likes),
        ),
      );
    } else if (likes < 5000) {
      return Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: size * 0.8,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: RelationshipColorSystem.getRelationshipColor(likes),
          ),
        ),
      );
    } else if (likes < 10000) {
      return Icon(
        Icons.star,
        size: size,
        color: RelationshipColorSystem.getRelationshipColor(likes),
      );
    } else {
      // 10K+ 특별한 빛나는 별
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.star,
            size: size,
            color: const Color(0xFFFFD700),
          ),
          Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.6),
                  blurRadius: size * 0.5,
                  spreadRadius: size * 0.2,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

/// 링 시스템 (인스타그램 스토리 스타일)
class RelationshipRingSystem {
  static Widget buildRing({
    required int likes,
    required Widget child,
    double size = 60,
  }) {
    final rings = _calculateRings(likes);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // 다중 링 효과
        ...rings.map((ring) => Container(
          width: size + ring.offset,
          height: size + ring.offset,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ring.color,
              width: ring.width,
            ),
            boxShadow: ring.isGlowing ? [
              BoxShadow(
                color: ring.color.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ] : null,
          ),
        )),
        // 중앙 콘텐츠
        SizedBox(
          width: size,
          height: size,
          child: child,
        ),
      ],
    );
  }
  
  static List<RingData> _calculateRings(int likes) {
    final rings = <RingData>[];
    
    if (likes >= 100) {
      rings.add(RingData(
        color: Colors.blue.withOpacity(0.5),
        width: 2,
        offset: 4,
        isGlowing: false,
      ));
    }
    
    if (likes >= 1000) {
      rings.add(RingData(
        color: Colors.pink.withOpacity(0.6),
        width: 2.5,
        offset: 8,
        isGlowing: false,
      ));
    }
    
    if (likes >= 5000) {
      rings.add(RingData(
        color: Colors.red.withOpacity(0.7),
        width: 3,
        offset: 12,
        isGlowing: false,
      ));
    }
    
    if (likes >= 10000) {
      // 금색 빛나는 링
      rings.add(RingData(
        color: const Color(0xFFFFD700),
        width: 3,
        offset: 16,
        isGlowing: true,
      ));
    }
    
    return rings;
  }
}

/// 하트 진화 시스템
class HeartEvolutionSystem {
  static Widget getHeart(int likes, {double size = 16}) {
    // 하트 모양과 효과가 진화
    if (likes < 500) {
      // 기본 하트 (윤곽선)
      return Icon(
        Icons.favorite_outline,
        color: Colors.blue[400],
        size: size,
      );
    } else if (likes < 2000) {
      // 채워진 하트
      return Icon(
        Icons.favorite,
        color: Colors.pink[300],
        size: size,
      );
    } else if (likes < 5000) {
      // 반짝이는 하트
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.red[400],
            size: size,
          ),
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: size * 0.4,
            ),
          ),
        ],
      );
    } else if (likes < 10000) {
      // 불타는 하트 (그라데이션)
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.red[600]!,
            Colors.orange[400]!,
            Colors.yellow[600]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds),
        child: Icon(
          Icons.favorite,
          size: size,
          color: Colors.white,
        ),
      );
    } else {
      // 황금 하트
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            const Color(0xFFFFD700),
            const Color(0xFFFFA500),
            const Color(0xFFFFD700),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Icon(
          Icons.favorite,
          size: size,
          color: Colors.white,
        ),
      );
    }
  }
}

/// 링 데이터 모델
class RingData {
  final Color color;
  final double width;
  final double offset;
  final bool isGlowing;
  
  RingData({
    required this.color,
    required this.width,
    required this.offset,
    required this.isGlowing,
  });
}