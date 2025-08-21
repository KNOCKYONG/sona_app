import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cache/image_preload_service.dart';
import '../services/persona/persona_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// 새로운 이미지 다운로드 화면
/// 무한 스와이프 구현으로 인해 새로고침 기능은 제거됨
/// 새로운 페르소나 이미지가 있을 때만 다운로드 진행
class RefreshDownloadScreen extends StatefulWidget {
  const RefreshDownloadScreen({super.key});

  @override
  State<RefreshDownloadScreen> createState() => _RefreshDownloadScreenState();
}

class _RefreshDownloadScreenState extends State<RefreshDownloadScreen> {
  final ImagePreloadService _preloadService = ImagePreloadService.instance;
  bool _isDownloading = false;
  double _progress = 0.0;
  int _totalImages = 0;
  int _loadedImages = 0;

  @override
  void initState() {
    super.initState();
    _startRefreshAndDownload();
  }

  Future<void> _startRefreshAndDownload() async {
    setState(() {
      _isDownloading = true;
    });

    // 진행률 스트림 구독
    _preloadService.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _progress = progress;
          _totalImages = _preloadService.totalImages;
          _loadedImages = _preloadService.loadedImages;
        });
      }
    });

    // 이 화면은 더 이상 새로고침 기능에 사용되지 않음
    // 새로운 이미지 다운로드만 수행
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final personas = personaService.allPersonas;

    final hasNew = await _preloadService.hasNewImages(personas);
    if (hasNew) {
      await _preloadService.preloadNewImages(personas);
    }

    // 완료 후 페르소나 선택 화면으로 이동
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/persona-selection');
    }
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
                // 아이콘
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 50,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 40),

                // 제목
                Text(
                  AppLocalizations.of(context)!.preparingNewMeeting,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // 설명
                Text(
                  _totalImages > 0
                      ? AppLocalizations.of(context)!.downloadingPersonaImages
                      : AppLocalizations.of(context)!.preparingPersonas,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // 진행률 표시 (항상 표시)
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
                      if (_totalImages > 0)
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
                          '새로운 이미지 확인 중...',
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
                if (_isDownloading && _totalImages == 0)
                  const Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '새로운 페르소나를 찾고 있어요...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
