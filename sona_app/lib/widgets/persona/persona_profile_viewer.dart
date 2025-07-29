import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/persona.dart';
import '../../services/relationship/relationship_visual_system.dart';
import '../../utils/like_formatter.dart';

class PersonaProfileViewer extends StatefulWidget {
  final Persona persona;
  final VoidCallback? onClose;

  const PersonaProfileViewer({
    super.key,
    required this.persona,
    this.onClose,
  });

  @override
  State<PersonaProfileViewer> createState() => _PersonaProfileViewerState();
}

class _PersonaProfileViewerState extends State<PersonaProfileViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPhotoIndex = 0;
  bool _showDetails = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPhotoTap(TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.localPosition.dx;
    
    if (tapPosition < screenWidth * 0.3) {
      // 왼쪽 탭 - 이전 사진
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
    } else if (tapPosition > screenWidth * 0.7) {
      // 오른쪽 탭 - 다음 사진
      final allImageUrls = widget.persona.getAllImageUrls(size: 'large');
      if (_currentPhotoIndex < allImageUrls.length - 1) {
        setState(() {
          _currentPhotoIndex++;
        });
        _pageController.animateToPage(
          _currentPhotoIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // 중앙 탭 - 상세 정보 토글
      setState(() {
        _showDetails = !_showDetails;
      });
    }
  }

  Future<void> _closeModal() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {}, // 배경 탭 방지
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: SafeArea(
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  // 아래로 스와이프하면 닫기
                  if (details.primaryVelocity! > 300) {
                    _closeModal();
                  }
                },
                child: Column(
                  children: [
                    // 상단 바
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _closeModal,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.persona.name}, ${widget.persona.age}, ${widget.persona.mbti}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 40), // 균형을 위한 공간
                        ],
                      ),
                    ),
                    
                    // 카드 영역
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              // 사진 페이지뷰
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPhotoIndex = index;
                                    });
                                  },
                                  itemCount: widget.persona.getAllImageUrls(size: 'large').length,
                                  itemBuilder: (context, index) {
                                    final allImageUrls = widget.persona.getAllImageUrls(size: 'large');
                                    return GestureDetector(
                                      onTapUp: _onPhotoTap,
                                      child: CachedNetworkImage(
                                        imageUrl: allImageUrls[index],
                                        fit: BoxFit.cover,
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
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              // 사진 인디케이터
                              Builder(builder: (context) {
                                final allImageUrls = widget.persona.getAllImageUrls(size: 'large');
                                if (allImageUrls.length > 1) {
                                  return Positioned(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    child: Row(
                                      children: List.generate(
                                        allImageUrls.length,
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
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              
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
                              
                              // 페르소나 정보
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _showDetails ? _buildDetailedInfo() : _buildBasicInfo(),
                                ),
                              ),
                              
                              // 관계 상태 배지 (시각적 요소)
                              if (widget.persona.relationshipScore > 0)
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: _buildRelationshipBadge(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // 하단 안내 텍스트
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '아래로 스와이프하여 닫기',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 전문가 뱃지 제거됨
            
            // 이름
            Flexible(
              child: Text(
                widget.persona.name,
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
              '탭하여 자세히 보기',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 전문가 뱃지 제거됨
            
            // 이름
            Flexible(
              child: Text(
                widget.persona.name,
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
        ),
        const SizedBox(height: 12),
        
        // 성격 특성
        if (widget.persona.personality.isNotEmpty) ...[
          const Text(
            '성격',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.persona.personality,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
  
  Widget _buildRelationshipBadge() {
    final likes = widget.persona.relationshipScore ?? 0;
    final color = RelationshipColorSystem.getRelationshipColor(likes);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
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
    );
  }
} 