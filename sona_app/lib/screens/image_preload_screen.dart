import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cache/image_preload_service.dart';
import '../services/persona/persona_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ImagePreloadScreen extends StatefulWidget {
  const ImagePreloadScreen({super.key});

  @override
  State<ImagePreloadScreen> createState() => _ImagePreloadScreenState();
}

class _ImagePreloadScreenState extends State<ImagePreloadScreen> {
  final ImagePreloadService _preloadService = ImagePreloadService.instance;
  bool _isPreloading = false;
  double _progress = 0.0;
  int _totalImages = 0;
  int _loadedImages = 0;

  @override
  void initState() {
    super.initState();
    _startPreloading();
  }

  Future<void> _startPreloading() async {
    // 이미 프리로딩이 완료되었는지 확인
    final isCompleted = await _preloadService.isPreloadCompleted();
    if (isCompleted) {
      debugPrint('✅ Images already preloaded, skipping...');
      _navigateToPersonaSelection();
      return;
    }

    setState(() {
      _isPreloading = true;
    });

    // 진행률 스트림 구독
    _preloadService.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _progress = progress;
          // 서비스에서 정보 가져오기
          _totalImages = _preloadService.totalImages;
          _loadedImages = _preloadService.loadedImages;
        });
      }
    });

    // 페르소나 목록 가져오기
    final personaService = Provider.of<PersonaService>(context, listen: false);
    // PersonaService 초기화가 이미 되어 있다고 가정
    final personas = personaService.allPersonas;

    debugPrint('🖼️ Starting preload for ${personas.length} personas');

    // 이미지 프리로딩 시작
    await _preloadService.preloadAllPersonaImages(personas);

    // 완료 후 페르소나 선택 화면으로 이동
    if (mounted) {
      _navigateToPersonaSelection();
    }
  }

  void _navigateToPersonaSelection() {
    Navigator.of(context).pushReplacementNamed('/persona-selection');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE5EC),
              Color(0xFFFFB3C6),
              Color(0xFFFF6B9D),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 또는 아이콘
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 40),

                // 제목
                const Text(
                  '프로필 설정 중',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // 설명
                Text(
                  '페르소나 이미지를 준비하고 있어요',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // 진행률 표시
                Container(
                  width: 280,
                  child: Column(
                    children: [
                      // 진행률 바 컨테이너
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.3),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Stack(
                            children: [
                              // 진행률 바
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 278 * _progress,
                                height: 14,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                              // 반짝이는 효과
                              if (_progress > 0 && _progress < 1)
                                Positioned(
                                  left: 278 * _progress - 30,
                                  child: Container(
                                    width: 30,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0),
                                          Colors.white.withOpacity(0.6),
                                          Colors.white.withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 퍼센트 표시 (크고 명확하게)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${(_progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 다운로드 개수 표시
                      if (_isPreloading && _totalImages > 0)
                        Text(
                          '$_loadedImages / $_totalImages 이미지',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        Text(
                          '페르소나 정보를 확인하고 있어요...',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 로딩 중 메시지
                if (_isPreloading && _totalImages == 0)
                  const Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '페르소나들이 준비 중이에요...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                // 건너뛰기 버튼 (선택사항)
                if (_isPreloading)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: TextButton(
                      onPressed: _navigateToPersonaSelection,
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
