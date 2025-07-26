import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/persona.dart';

class PersonaCardSimple extends StatefulWidget {
  final Persona persona;
  final double horizontalThresholdPercentage;
  final double verticalThresholdPercentage;

  const PersonaCardSimple({
    super.key,
    required this.persona,
    this.horizontalThresholdPercentage = 0.0,
    this.verticalThresholdPercentage = 0.0,
  });

  @override
  State<PersonaCardSimple> createState() => _PersonaCardSimpleState();
}

class _PersonaCardSimpleState extends State<PersonaCardSimple> {
  late PageController _pageController;
  int _currentPhotoIndex = 0;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _currentPhotoIndex = 0;
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPhotoTap(TapUpDetails details) {
    // 🔧 FIX: 안전한 photoUrls 접근
    if (widget.persona.photoUrls.isEmpty) {
      debugPrint('❌ No photos available for navigation');
      return;
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.localPosition.dx; // globalPosition 대신 localPosition 사용
    
    debugPrint('Photo tap detected at position: $tapPosition (screen width: $screenWidth)');
    debugPrint('Current photo index: $_currentPhotoIndex of ${widget.persona.photoUrls.length}');
    
    if (tapPosition < screenWidth * 0.3) {
      // 왼쪽 탭 - 이전 사진
      debugPrint('Left tap detected');
      if (_currentPhotoIndex > 0) {
        setState(() {
          _currentPhotoIndex--;
        });
        _pageController.animateToPage(
          _currentPhotoIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        debugPrint('Moved to photo index: $_currentPhotoIndex');
      }
    } else if (tapPosition > screenWidth * 0.7) {
      // 오른쪽 탭 - 다음 사진
      debugPrint('Right tap detected');
      if (_currentPhotoIndex < widget.persona.photoUrls.length - 1) {
        setState(() {
          _currentPhotoIndex++;
        });
        _pageController.animateToPage(
          _currentPhotoIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        debugPrint('Moved to photo index: $_currentPhotoIndex');
      }
    } else {
      // 중앙 탭 - 상세 정보 토글
      debugPrint('Center tap detected');
      setState(() {
        _showDetails = !_showDetails;
      });
    }
  }

  Color _getOverlayColor() {
    // Super Like을 가장 먼저 체크 (우선순위) - 전문가가 아닐 때만
    if (widget.verticalThresholdPercentage < -0.1) {
      if (widget.persona.isExpert) {
        // 전문가는 Super like 대신 like 색상으로
        return const Color(0xFFFF6B9D).withOpacity(widget.verticalThresholdPercentage.abs() * 0.7); // Pink (Like)
      } else {
        return const Color(0xFF1976D2).withOpacity(widget.verticalThresholdPercentage.abs() * 0.7); // Deeper Blue (Super Like)
      }
    } else if (widget.horizontalThresholdPercentage > 0.1) {
      return const Color(0xFFFF6B9D).withOpacity(widget.horizontalThresholdPercentage * 0.7); // Pink (Like)
    } else if (widget.horizontalThresholdPercentage < -0.1) {
      return Colors.grey.withOpacity(widget.horizontalThresholdPercentage.abs() * 0.7); // Grey (Pass)
    }
    return Colors.transparent;
  }

  Widget _getOverlayIcon() {
    // Super Like을 가장 먼저 체크 (우선순위) - 전문가가 아닐 때만
    if (widget.verticalThresholdPercentage < -0.1) {
      if (widget.persona.isExpert) {
        // 전문가는 Super like 대신 일반 like 아이콘
        return const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 80,
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
    } else if (widget.horizontalThresholdPercentage > 0.1) {
      return const Icon(
        Icons.favorite,
        color: Colors.white,
        size: 80,
      );
    } else if (widget.horizontalThresholdPercentage < -0.1) {
      return const Icon(
        Icons.close,
        color: Colors.white,
        size: 80,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 사진 페이지뷰
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
                itemCount: widget.persona.photoUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPhotoIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  // 🔧 FIX: 안전한 인덱스 접근
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
              ),
            ),
          ),
          
          // 사진 인디케이터
          if (widget.persona.photoUrls.length > 1)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  widget.persona.photoUrls.length,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: index == _currentPhotoIndex
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showDetails ? _buildDetailedInfo() : _buildBasicInfo(),
            ),
          ),
          
          // 스와이프 오버레이
          if (widget.horizontalThresholdPercentage.abs() > 0.1 ||
              widget.verticalThresholdPercentage.abs() > 0.1)
            Container(
              decoration: BoxDecoration(
                color: _getOverlayColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _getOverlayIcon(),
              ),
            ),
          
          // 관계 상태 배지 (이미 매칭된 경우)
          if (widget.persona.relationshipScore > 0)
            Positioned(
              top: 16,
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
          
          // 탭 감지를 위한 투명한 레이어
          Positioned.fill(
            child: GestureDetector(
              onTapUp: _onPhotoTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey('basic'),
      children: [
        // 이름, 나이, MBTI를 한 줄에 배치 (전문가 뱃지 포함)
        Row(
          children: [
            // 전문가 뱃지를 이름 앞에 표시
            if (widget.persona.isExpert) ...[
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
                widget.persona.isExpert && widget.persona.profession != null
                    ? 'Dr. ${widget.persona.name}'
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
        Text(
          widget.persona.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.persona.photoUrls.length > 1) ...[
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
    );
  }

  Widget _buildDetailedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey('detailed'),
      children: [
        Row(
          children: [
            Text(
              widget.persona.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.persona.age}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.persona.mbti,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          '성격',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.persona.personality,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.persona.relationshipScore > 0) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Color(0xFFFF6B9D),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '관계 점수: ${widget.persona.relationshipScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}