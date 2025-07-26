import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/persona.dart';

class PersonaCardNew extends StatefulWidget {
  final Persona persona;
  final double horizontalThresholdPercentage;
  final double verticalThresholdPercentage;

  const PersonaCardNew({
    super.key,
    required this.persona,
    this.horizontalThresholdPercentage = 0.0,
    this.verticalThresholdPercentage = 0.0,
  });

  @override
  State<PersonaCardNew> createState() => _PersonaCardNewState();
}

class _PersonaCardNewState extends State<PersonaCardNew> {
  int _currentPhotoIndex = 0;
  late PageController _pageController;

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

  void _nextPhoto() {
    // 🔧 FIX: 안전한 photoUrls 접근
    if (widget.persona.photoUrls.isEmpty) return;
    
    if (_currentPhotoIndex < widget.persona.photoUrls.length - 1) {
      setState(() {
        _currentPhotoIndex++;
      });
      _pageController.animateToPage(
        _currentPhotoIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPhoto() {
    // 🔧 FIX: 안전한 photoUrls 접근
    if (widget.persona.photoUrls.isEmpty) return;
    
    if (_currentPhotoIndex > 0) {
      setState(() {
        _currentPhotoIndex--;
      });
      _pageController.animateToPage(
        _currentPhotoIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _getOverlayColor() {
    // 완전한 안전 장치: 기본값부터 투명색으로 설정
    try {
      // 입력값 기본 검증
      final horizontal = widget.horizontalThresholdPercentage;
      final vertical = widget.verticalThresholdPercentage;
      
      // 모든 비정상적인 값들을 먼저 차단
      if (horizontal.isNaN || horizontal.isInfinite || 
          vertical.isNaN || vertical.isInfinite) {
        return const Color(0x00000000); // 완전 투명
      }

      // 안전한 범위 체크
      final safeHorizontal = horizontal.clamp(-1.0, 1.0);
      final safeVertical = vertical.clamp(-1.0, 1.0);
      
      // 안전한 opacity 계산 (0.0 ~ 0.5 범위로 제한)
      double calculateSafeOpacity(double value) {
        final absValue = value.abs().clamp(0.0, 1.0);
        return (absValue * 0.5).clamp(0.0, 0.5);
      }

      // Super Like을 가장 먼저 체크 (우선순위) - 전문가가 아닐 때만
      if (safeVertical < -0.1) {
        final opacity = calculateSafeOpacity(safeVertical);
        if (widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) {
          // 전문가는 Super like 대신 like 색상으로
          return Color.fromRGBO(255, 107, 157, opacity); // Pink (Like)
        } else {
          return Color.fromRGBO(25, 118, 210, opacity); // Deeper Blue (Super Like)
        }
      } else if (safeHorizontal > 0.1) {
        final opacity = calculateSafeOpacity(safeHorizontal);
        // Color.fromRGBO를 사용하여 더 안전한 색상 생성
        return Color.fromRGBO(255, 107, 157, opacity); // Pink (Like)
      } else if (safeHorizontal < -0.1) {
        final opacity = calculateSafeOpacity(safeHorizontal);
        return Color.fromRGBO(158, 158, 158, opacity); // Grey (Pass)
      }
      
    } catch (e, stackTrace) {
      // 모든 오류를 캐치하고 로그 출력
      debugPrint('Critical error in _getOverlayColor: $e');
      debugPrint('Stack trace: $stackTrace');
    }
    
    // 기본적으로 완전 투명 반환
    return const Color(0x00000000);
  }

  bool _shouldShowOverlay() {
    try {
      final horizontal = widget.horizontalThresholdPercentage;
      final vertical = widget.verticalThresholdPercentage;
      
      // NaN이나 무한대 값 체크
      if (horizontal.isNaN || horizontal.isInfinite || 
          vertical.isNaN || vertical.isInfinite) {
        return false;
      }
      
      // 안전한 범위 체크
      final safeHorizontal = horizontal.clamp(-1.0, 1.0);
      final safeVertical = vertical.clamp(-1.0, 1.0);
      
      return safeHorizontal.abs() > 0.1 || safeVertical.abs() > 0.1;
    } catch (e) {
      debugPrint('Error in _shouldShowOverlay: $e');
      return false;
    }
  }

  Widget _getOverlayIcon() {
    try {
      final horizontal = widget.horizontalThresholdPercentage;
      final vertical = widget.verticalThresholdPercentage;
      
      // NaN이나 무한대 값 체크
      if (horizontal.isNaN || horizontal.isInfinite || 
          vertical.isNaN || vertical.isInfinite) {
        return const SizedBox.shrink();
      }
      
      // 안전한 범위로 클램프
      final safeHorizontal = horizontal.clamp(-1.0, 1.0);
      final safeVertical = vertical.clamp(-1.0, 1.0);
      
      // Super Like을 가장 먼저 체크 (우선순위) - 전문가가 아닐 때만
      if (safeVertical < -0.1) {
        if (widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) {
          // 전문가는 Super like 대신 일반 like로 처리
          return const Text(
            '💕',
            style: TextStyle(
              fontSize: 60,
            ),
          );
        } else {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '💫',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
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
        return const Text(
          '💕',
          style: TextStyle(
            fontSize: 60,
          ),
        );
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
      
      return const SizedBox.shrink();
    } catch (e) {
      debugPrint('Error in _getOverlayIcon: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug expert status
    debugPrint('🔍 PersonaCardNew - ${widget.persona.name}: isExpert=${widget.persona.isExpert}, role=${widget.persona.role}, hasDr=${widget.persona.name.contains("Dr.")}');
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 사진 페이지뷰 (스와이프 비활성화)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.persona.photoUrls.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPhotoIndex = index;
                      });
                    },
                    physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
                    itemCount: widget.persona.photoUrls.length,
                    itemBuilder: (context, index) {
                      if (index >= widget.persona.photoUrls.length) {
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
                      
                      return CachedNetworkImage(
                        imageUrl: widget.persona.photoUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF6B9D),
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
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          

          
          // 사진 개수 표시 (인디케이터 대신)
          if (widget.persona.photoUrls.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
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
                      '${_currentPhotoIndex + 1}/${widget.persona.photoUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // 사진 인디케이터 (하단)
          if (widget.persona.photoUrls.length > 1)
            Positioned(
              bottom: 220, // 그라데이션 위에 위치
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.persona.photoUrls.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPhotoIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          
          // 좌우 탭 영역 (사진 전환용)
          if (widget.persona.photoUrls.length > 1)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                children: [
                  // 왼쪽 탭 영역
                  Expanded(
                    child: GestureDetector(
                      onTap: _previousPhoto,
                      child: Container(
                        color: Colors.transparent,
                        height: double.infinity,
                        child: _currentPhotoIndex > 0
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text(
                                    '‹',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  // 오른쪽 탭 영역
                  Expanded(
                    child: GestureDetector(
                      onTap: _nextPhoto,
                      child: Container(
                        color: Colors.transparent,
                        height: double.infinity,
                        child: _currentPhotoIndex < widget.persona.photoUrls.length - 1
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const Text(
                                    '›',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // 그라데이션 오버레이
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          
          // 기본 정보
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 이름, 나이, MBTI를 한 줄에 배치 (전문가 뱃지 포함)
                Row(
                  children: [
                    // 전문가 뱃지를 이름 앞에 표시
                    if (widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) ...[
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
                              color: Colors.black.withOpacity(0.4),
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
                        (widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) && widget.persona.profession != null
                            ? (widget.persona.name.contains('Dr.') ? widget.persona.name : 'Dr. ${widget.persona.name}')
                            : widget.persona.name,
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
                      '${widget.persona.age}',
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
                        widget.persona.mbti,
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
                if ((widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) && widget.persona.profession != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      widget.persona.profession!,
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
                  widget.persona.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  maxLines: (widget.persona.isExpert || widget.persona.role == 'expert' || widget.persona.role == 'specialist' || widget.persona.name.contains('Dr.')) ? 1 : 2, // 전문가는 줄 수 줄임
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                if (widget.persona.photoUrls.length > 1)
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
            ),
          ),
          
          // 스와이프 오버레이 (안전한 처리)
          if (_shouldShowOverlay())
            Builder(
              builder: (context) {
                try {
                  return Container(
                    decoration: BoxDecoration(
                      color: _getOverlayColor(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: _getOverlayIcon(),
                    ),
                  );
                } catch (e) {
                  debugPrint('Error in overlay builder: $e');
                  return const SizedBox.shrink();
                }
              },
            ),
          
          // 관계 상태 배지 (이미 매칭된 경우)
          if (widget.persona.relationshipScore > 0)
            Positioned(
              top: widget.persona.photoUrls.length > 1 ? 50 : 16, // 사진 개수 표시와 겹치지 않도록 조정
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
                      widget.persona.getRelationshipType().displayName,
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
            ),
        ],
      ),
    );
  }
}