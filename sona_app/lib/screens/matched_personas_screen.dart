import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/persona/persona_service.dart';
import '../models/persona.dart';
import '../services/relationship/relation_score_service.dart';
import '../services/auth/auth_service.dart';

class MatchedPersonasScreen extends StatefulWidget {
  const MatchedPersonasScreen({super.key});
  
  @override
  State<MatchedPersonasScreen> createState() => _MatchedPersonasScreenState();
}

class _MatchedPersonasScreenState extends State<MatchedPersonasScreen> {
  final Map<String, int> _cachedLikes = {};
  bool _hasPreloaded = false;

  @override
  void initState() {
    super.initState();
    _preloadLikes();
  }
  
  Future<void> _preloadLikes() async {
    if (_hasPreloaded) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final userId = authService.user?.uid;
    
    if (userId != null && personaService.matchedPersonas.isNotEmpty) {
      await RelationScoreService.instance.preloadLikes(
        userId: userId,
        personaIds: personaService.matchedPersonas.map((p) => p.id).toList(),
      );
      
      // 로컬 캐시 업데이트
      if (mounted) {
        setState(() {
          for (final persona in personaService.matchedPersonas) {
            final likes = RelationScoreService.instance.getCachedLikes(
              userId: userId,
              personaId: persona.id,
            );
            _cachedLikes[persona.id] = likes > 0 ? likes : persona.likes;
          }
          _hasPreloaded = true;
        });
      }
    }
  }
  
  int _getCachedLikes(BuildContext context, Persona persona) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid;
    
    if (userId == null) return persona.likes;
    
    // 로컬 캐시 먼저 확인
    if (_cachedLikes.containsKey(persona.id)) {
      return _cachedLikes[persona.id]!;
    }
    
    // 캐시가 없으면 RelationScoreService의 캐시 사용
    final likes = RelationScoreService.instance.getCachedLikes(
      userId: userId,
      personaId: persona.id,
    );
    
    return likes > 0 ? likes : persona.likes;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          '매칭된 소나',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PersonaService>(
        builder: (context, personaService, child) {
          final matchedPersonas = personaService.matchedPersonas;
          
          if (matchedPersonas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '아직 매칭된 소나가 없어요',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '새로운 소나를 만나보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matchedPersonas.length,
            itemBuilder: (context, index) {
              final persona = matchedPersonas[index];
              return _PersonaCard(
                persona: persona,
                getCachedLikes: _getCachedLikes,
              );
            },
          );
        },
      ),
    );
  }
}

class _PersonaCard extends StatelessWidget {
  final Persona persona;
  final int Function(BuildContext, Persona) getCachedLikes;
  
  const _PersonaCard({
    required this.persona,
    required this.getCachedLikes,
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat',
              arguments: persona,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 프로필 이미지
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: persona.getThumbnailUrl() != null
                        ? CachedNetworkImage(
                            imageUrl: persona.getThumbnailUrl()!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            persona.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 친밀도 표시 (like score와 뱃지) - 캐시 사용
                          Builder(
                            builder: (context) {
                              final likes = getCachedLikes(context, persona);
                              final visualInfo = RelationScoreService.instance.getVisualInfo(likes);
                              
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 하트 아이콘
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: visualInfo.heart,
                                  ),
                                  const SizedBox(width: 4),
                                  // 친밀도 숫자
                                  Text(
                                    visualInfo.formattedLikes,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: visualInfo.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${persona.age}세 • ${persona.personality}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 화살표
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}