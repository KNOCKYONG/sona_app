import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/chat/core/chat_service.dart';
import '../services/persona/persona_service.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/ui/haptic_service.dart';
import '../services/storage/guest_conversation_service.dart';
import '../services/block_service.dart';
import '../models/persona.dart';
import '../models/message.dart';
import '../widgets/common/sona_logo.dart';
import '../widgets/persona/optimized_persona_image.dart';
import '../services/relationship/relation_score_service.dart';
import '../widgets/skeleton/skeleton_widgets.dart';
import '../l10n/app_localizations.dart';
import '../utils/localization_helper.dart';
import 'chat_screen.dart';
import '../utils/performance_monitor.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // false로 설정하여 매번 새로고침

  bool _isLoading = false;
  bool _hasInitialized = false;
  final Map<String, bool> _leftChatStatus = {};
  final Map<String, int> _cachedLikes = {}; // Like score 로컬 캐시
  DateTime _lastRefreshTime = DateTime.now(); // 마지막 새로고침 시간
  final BlockService _blockService = BlockService(); // 차단 서비스

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드를 지연시켜서 context가 준비된 후 실행
    Future.microtask(() => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    if (!mounted || _hasInitialized) return;
    _hasInitialized = true;
    
    // 데이터가 오래된 경우에만 새로고침 (30초)
    final now = DateTime.now();
    if (now.difference(_lastRefreshTime).inSeconds > 30) {
      await _initializeChatList();
      _lastRefreshTime = now;
    }
  }

  /// 🔄 채팅 목록 초기화 및 새로고침
  Future<void> _initializeChatList() async {
    // 성능 측정 시작
    PerformanceMonitor.startMeasure('chat_list_init');
    
    final chatService = Provider.of<ChatService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    try {
      // 1. 🔧 현재 사용자 ID 확보 (DeviceIdService 사용)
      final currentUserId = await DeviceIdService.getCurrentUserId(
        firebaseUserId: authService.user?.uid,
      );

      debugPrint('🆔 Chat list using userId: $currentUserId');

      // 서비스들에 사용자 ID 설정
      chatService.setCurrentUserId(currentUserId);
      personaService.setCurrentUserId(currentUserId);
      
      // BlockService 초기화
      await _blockService.initialize(currentUserId);

      // 2. UserService에서 사용자 정보 설정
      if (userService.currentUser != null && authService.user != null) {
        debugPrint(
            '🔐 Setting user info for chat list: ${userService.currentUser!.gender}, genderAll: ${userService.currentUser!.genderAll}');
        personaService.setCurrentUser(userService.currentUser!);
      }

      // 3. 🔥 PersonaService가 초기화되지 않았으면 초기화
      if (personaService.allPersonas.isEmpty) {
        debugPrint('🔄 PersonaService not initialized, initializing now...');
        await personaService.initialize(userId: currentUserId);
      } else if (!personaService.matchedPersonasLoaded) {
        debugPrint('🔄 Loading matched personas for chat list...');
        await personaService.loadMatchedPersonasIfNeeded();
      } else {
        debugPrint('✅ PersonaService already initialized with ${personaService.matchedPersonas.length} matched personas');
      }

      // 4. 매칭된 페르소나들의 채팅 메시지 로드
      final matchedPersonas = personaService.matchedPersonas;
      debugPrint(
          '📱 Loading messages for ${matchedPersonas.length} matched personas');

      // 병렬로 모든 페르소나의 메시지 로드 (성능 개선)
      if (matchedPersonas.isNotEmpty) {
        // 메시지 로드 성능 측정
        PerformanceMonitor.startMeasure('message_load');
        
        // 보이는 항목만 먼저 로드 (최대 5개)
        final visiblePersonas = matchedPersonas.take(5).toList();
        final invisiblePersonas = matchedPersonas.skip(5).toList();
        
        // 보이는 항목 먼저 로드
        final visibleFutures = <Future<void>>[];
        for (final persona in visiblePersonas) {
          debugPrint(
              '📨 Priority loading messages for: ${persona.name} (${persona.id})');
          visibleFutures
              .add(chatService.loadChatHistory(currentUserId, persona.id));
        }
        await Future.wait(visibleFutures);
        
        final loadTime = PerformanceMonitor.endMeasure('message_load');
        debugPrint('📊 Visible messages loaded in ${loadTime}ms');
        
        // UI 업데이트 - 한 번만 호출
        if (mounted) {
          setState(() {
            _isLoading = false;  // 로딩 완료 표시
          });
        }
        
        // 나머지 백그라운드에서 로드
        if (invisiblePersonas.isNotEmpty) {
          // 백그라운드 로딩 중 플래그 설정
          bool _backgroundLoading = true;
          
          final invisibleFutures = <Future<void>>[];
          for (final persona in invisiblePersonas) {
            debugPrint(
                '📨 Background loading messages for: ${persona.name} (${persona.id})');
            invisibleFutures
                .add(chatService.loadChatHistory(currentUserId, persona.id));
          }
          Future.wait(invisibleFutures).then((_) {
            // 백그라운드 로딩 완료 후 한 번만 업데이트
            if (mounted && _backgroundLoading) {
              _backgroundLoading = false;
              setState(() {});
            }
          });
        }

        // Like scores 병렬 프리로드 (성능 개선)
        if (currentUserId.isNotEmpty) {
          // 비동기로 Like scores 프리로드
          RelationScoreService.instance.preloadLikes(
            userId: currentUserId,
            personaIds: matchedPersonas.map((p) => p.id).toList(),
          ).then((_) {
            // 로컬 캐시 업데이트
            for (final persona in matchedPersonas) {
              final likes = RelationScoreService.instance.getCachedLikes(
                userId: currentUserId,
                personaId: persona.id,
              );
              _cachedLikes[persona.id] = likes > 0 ? likes : persona.likes;
            }
            if (mounted) setState(() {});
          });
        }
      } else {
        debugPrint(
            '⚠️ No matched personas found - user might need to swipe more');
      }

      // 5. 채팅방 나가기 상태 확인
      _leftChatStatus.clear();
      
      // Check if user is guest
      final isGuest = await userService.isGuestUser;
      
      if (isGuest) {
        // Load from local storage for guest users
        try {
          final guestLeftStatuses = await GuestConversationService.instance.getAllLeftChatStatuses();
          _leftChatStatus.addAll(guestLeftStatuses);
          debugPrint('📋 Guest left chat status loaded: ${_leftChatStatus.length} chats left');
        } catch (e) {
          debugPrint('Error loading guest leftChat status: $e');
        }
      } else if (currentUserId.isNotEmpty) {
        // Load from Firebase for authenticated users
        try {
          final chatsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('chats')
              .get();

          for (var doc in chatsSnapshot.docs) {
            final data = doc.data();
            if (data['leftChat'] == true) {
              _leftChatStatus[doc.id] = true;
            }
          }
          debugPrint(
              '📋 User left chat status loaded: ${_leftChatStatus.length} chats left');
        } catch (e) {
          debugPrint('Error loading leftChat status: $e');
        }
      }

      // 6. UI 강제 새로고침
      if (mounted) {
        setState(() {});
      }
      
      // 전체 초기화 시간 측정
      final totalTime = PerformanceMonitor.endMeasure('chat_list_init');
      debugPrint('📊 Total chat list init time: ${totalTime}ms');
      
      // 성능 리포트 출력 (디버그 모드)
      if (totalTime > 1000) {
        PerformanceMonitor.printReport();
      }
    } catch (e) {
      debugPrint('❌ Error initializing chat list: $e');
      PerformanceMonitor.endMeasure('chat_list_init');
    }
  }

  /// Extract only Korean content from message, removing all translations
  String _extractKoreanContent(String content) {
    // Check if content has [KO] tag
    if (content.contains('[KO]')) {
      final koIndex = content.indexOf('[KO]');
      final koreanStart = koIndex + 4; // '[KO]'.length = 4
      
      // Find where Korean content ends (at the next language tag or end of string)
      final possibleTags = ['[EN]', '[JA]', '[ZH]', '[ES]', '[FR]', '[DE]', '[IT]', '[PT]', '[RU]', '[AR]', '[TH]', '[ID]', '[MS]', '[VI]'];
      
      int koreanEnd = content.length;
      for (final tag in possibleTags) {
        final tagIndex = content.indexOf(tag, koreanStart);
        if (tagIndex != -1 && tagIndex < koreanEnd) {
          koreanEnd = tagIndex;
        }
      }
      
      return content.substring(koreanStart, koreanEnd).trim();
    }
    
    // If no [KO] tag, check if there are other language tags to remove
    final tagPattern = RegExp(r'\[(EN|JA|ZH|ES|FR|DE|IT|PT|RU|AR|TH|ID|MS|VI)\]');
    if (tagPattern.hasMatch(content)) {
      // If other language tags exist, take content before the first tag
      final firstMatch = tagPattern.firstMatch(content);
      if (firstMatch != null) {
        return content.substring(0, firstMatch.start).trim();
      }
    }
    
    // No tags found, return original content
    return content.trim();
  }

  String _getLastMessagePreview(List<Message> messages, String personaName) {
    final localizations = AppLocalizations.of(context)!;

    // 메시지가 비어있거나 로딩 중인 경우
    if (messages.isEmpty) {
      return localizations.waitingForChat(personaName);
    }

    // 튜토리얼 메시지 필터링 - 실제 대화만 찾기
    final realMessages = messages.where((m) => 
      m.content != localizations.startConversation &&
      m.content != localizations.startConversationWithSona
    ).toList();
    
    // 실제 메시지가 없는 경우에만 "대화를 기다리고 있어요" 표시
    if (realMessages.isEmpty) {
      return localizations.waitingForChat(personaName);
    }

    // 실제 마지막 메시지 사용
    final lastMessage = realMessages.last;

    String preview = '';
    if (lastMessage.isFromUser) {
      preview = '${AppLocalizations.of(context)!.me}: ';
    }

    if (lastMessage.type == MessageType.image) {
      preview += '📷 ${AppLocalizations.of(context)!.photo}';
    } else if (lastMessage.type == MessageType.voice) {
      preview += localizations.voiceMessage;
    } else {
      // Extract only Korean content, removing all translations
      preview += _extractKoreanContent(lastMessage.content);
    }

    return preview;
  }

  String _getLastMessageTime(List<Message> messages, {DateTime? matchedAt}) {
    // 튜토리얼 메시지 필터링 - 실제 대화만 찾기
    final localizations = AppLocalizations.of(context)!;
    final realMessages = messages.where((m) => 
      m.content != localizations.startConversation &&
      m.content != localizations.startConversationWithSona
    ).toList();
    
    if (realMessages.isEmpty) {
      // If no real messages but we have matchedAt, show that time
      if (matchedAt != null) {
        final now = DateTime.now();
        final difference = now.difference(matchedAt);
        
        if (difference.inDays > 0) {
          return AppLocalizations.of(context)!.daysAgo(difference.inDays, 'days ago');
        } else if (difference.inHours > 0) {
          return AppLocalizations.of(context)!.hoursAgo(difference.inHours, 'hours ago');
        } else if (difference.inMinutes > 0) {
          return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes, 'minutes ago');
        } else {
          return AppLocalizations.of(context)!.justNow;
        }
      }
      return '';
    }

    // Use real last message for time
    final lastMessage = realMessages.last;
    final locale = Localizations.localeOf(context);
    return LocalizationHelper.formatRelativeTime(lastMessage.timestamp, locale);
  }

  // 예측 프리로드를 위한 메서드
  Future<void> _preloadChatData(Persona persona) async {
    try {
      final personaService =
          Provider.of<PersonaService>(context, listen: false);
      final chatService = Provider.of<ChatService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.user?.uid;
      
      if (userId == null) return;
      
      // 이미 선택된 페르소나면 스킵
      if (personaService.currentPersona?.id == persona.id) return;
      
      // 병렬로 프리로드
      await Future.wait([
        // 페르소나 선택 프리로드 - clearPrevious를 false로 설정하여 데이터 유지
        personaService.selectPersona(persona, clearPrevious: false),
        // 채팅 히스토리 프리로드 (이미 로드된 경우 빠르게 리턴)
        chatService.loadChatHistory(userId, persona.id),
      ]);
      
      debugPrint('🚀 Preloaded chat data for ${persona.name}');
    } catch (e) {
      debugPrint('⚠️ Failed to preload chat data: $e');
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

    // 백그라운드에서 업데이트된 값 반영
    if (likes > 0) {
      _cachedLikes[persona.id] = likes;
    }

    return likes > 0 ? likes : persona.likes;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요

    // Cache theme and colors for performance
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 화면이 처음 빌드될 때 데이터 로드 (중복 방지)
    if (!_hasInitialized && !_isLoading) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await _loadInitialData();
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SonaLogoSmall(size: 32),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.chats,
              style: TextStyle(
                color: textTheme.headlineSmall?.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.iconTheme.color),
            onPressed: () async {
              // 🔄 수동 새로고침
              // 로딩 인디케이터 표시
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.refreshingChatList),
                    duration: const Duration(seconds: 2),
                  ),
                );

              try {
                // 전체 채팅 목록 새로고침
                await _initializeChatList();

                if (mounted) {
                  final personaService =
                      Provider.of<PersonaService>(context, listen: false);
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .refreshComplete(
                                personaService.matchedPersonas.length)),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.refreshFailed),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {
              // 검색 기능 추가 예정
            },
          ),
        ],
      ),
      body: Consumer2<PersonaService, ChatService>(
        builder: (context, personaService, chatService, child) {
          // leftChat 상태가 아닌 페르소나만 필터링
          final matchedPersonas =
              List<Persona>.from(personaService.matchedPersonas)
                  .where((persona) => _leftChatStatus[persona.id] != true)
                  .toList();

          // Sort personas by last interaction (message or match time)
          matchedPersonas.sort((a, b) {
            final messagesA = chatService.getMessages(a.id);
            final messagesB = chatService.getMessages(b.id);

            // Get last interaction time for A
            DateTime? lastTimeA;
            if (messagesA.isNotEmpty) {
              // Filter out tutorial messages for timestamp
              final realMessagesA = messagesA.where((m) => 
                m.content != AppLocalizations.of(context)!.startConversation &&
                m.content != AppLocalizations.of(context)!.startConversationWithSona
              ).toList();
              if (realMessagesA.isNotEmpty) {
                lastTimeA = realMessagesA.last.timestamp;
              }
            }
            // Fallback to matchedAt if no messages
            lastTimeA ??= a.matchedAt ?? DateTime.now().subtract(const Duration(days: 30));

            // Get last interaction time for B
            DateTime? lastTimeB;
            if (messagesB.isNotEmpty) {
              // Filter out tutorial messages for timestamp
              final realMessagesB = messagesB.where((m) => 
                m.content != AppLocalizations.of(context)!.startConversation &&
                m.content != AppLocalizations.of(context)!.startConversationWithSona
              ).toList();
              if (realMessagesB.isNotEmpty) {
                lastTimeB = realMessagesB.last.timestamp;
              }
            }
            // Fallback to matchedAt if no messages
            lastTimeB ??= b.matchedAt ?? DateTime.now().subtract(const Duration(days: 30));

            return lastTimeB
                .compareTo(lastTimeA); // Descending order (newest first)
          });

          // Show skeleton loading while loading initial data
          if (_isLoading && matchedPersonas.isEmpty) {
            return SkeletonListView(
              itemBuilder: () => const ChatListItemSkeleton(),
              itemCount: 5,
              padding: const EdgeInsets.symmetric(vertical: 8),
            );
          }

          if (matchedPersonas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.noMatchedPersonas,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textTheme.headlineSmall?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.meetNewPersonas,
                    style: TextStyle(
                      fontSize: 16,
                      color: textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/persona-selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.meetPersonas,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Haptic feedback when pull-to-refresh triggers
              await HapticService.mediumImpact();
              await _initializeChatList();
            },
            child: ListView.builder(
              itemCount: matchedPersonas.length,
              itemBuilder: (context, index) {
              final persona = matchedPersonas[index];
              
              // 차단된 페르소나는 표시하지 않음
              if (_blockService.isBlocked(persona.id)) {
                return const SizedBox.shrink();
              }
              // 매번 최신 메시지를 가져오도록 함
              final messages =
                  List<Message>.from(chatService.getMessages(persona.id));

              // 🔧 FIX: 안전한 hasUnread 계산 및 마지막 메시지 그룹 카운트
              bool hasUnread = false;
              int unreadPersonaMessageCount = 0;
              int lastPersonaMessageGroupCount = 0;

              try {
                // Count unread messages from persona (not user)
                unreadPersonaMessageCount = messages
                    .where((msg) =>
                        !msg.isFromUser &&
                        (msg.isRead == false || msg.isRead == null))
                    .length;
                hasUnread = unreadPersonaMessageCount > 0;

                // 마지막 페르소나 메시지 그룹의 개수 계산
                if (messages.isNotEmpty && hasUnread) {
                  // 뒤에서부터 연속된 페르소나 메시지 개수 세기
                  for (int i = messages.length - 1; i >= 0; i--) {
                    if (!messages[i].isFromUser &&
                        (messages[i].isRead == false ||
                            messages[i].isRead == null)) {
                      lastPersonaMessageGroupCount++;
                    } else {
                      // 사용자 메시지나 읽은 메시지를 만나면 중단
                      break;
                    }
                  }
                }
              } catch (e) {
                debugPrint('❌ Error calculating hasUnread: $e');
                hasUnread = false;
              }
              final isTyping = chatService.isPersonaTyping(persona.id);

              return InkWell(
                onTap: () async {
                  // iOS-style light haptic for list item tap
                  await HapticService.lightImpact();
                  
                  // 프리로드 완료 대기 (최대 100ms)
                  await Future.wait([
                    _preloadChatData(persona),
                    Future.delayed(const Duration(milliseconds: 100)),
                  ]).timeout(
                    const Duration(milliseconds: 100),
                    onTimeout: () => [],
                  );
                  
                  // Use platform-aware navigation for iOS back swipe gesture support
                  Navigator.push(
                    context,
                    Platform.isIOS
                      ? CupertinoPageRoute(
                          builder: (context) => const ChatScreen(),
                          settings: RouteSettings(
                            name: '/chat',
                            arguments: persona,
                          ),
                        )
                      : PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return const ChatScreen();
                          },
                          settings: RouteSettings(
                            name: '/chat',
                            arguments: persona,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            // Smooth slide from right animation for Android
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeOutCubic;

                            var tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );

                            var offsetAnimation = animation.drive(tween);

                            // Add fade effect for smoother transition
                            var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Interval(0.0, 0.3),
                              ),
                            );

                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: fadeAnimation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 350),
                        ),
                  );
                },
                onLongPress: () {
                  // 길게 눌렀을 때도 프리로드
                  _preloadChatData(persona);
                },
                onHover: (hovering) {
                  // 마우스 호버 시 프리로드 (웹)
                  if (hovering) {
                    _preloadChatData(persona);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 프로필 이미지 with Hero animation
                      Hero(
                        tag: 'persona_avatar_${persona.id}',
                        child: Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: OptimizedPersonaImage.thumbnail(
                                persona: persona,
                                size: 60,
                              ),
                            ),
                          ),
                          // 관계 점수 뱃지
                          if (persona.likes > 80)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: theme.cardColor, width: 2),
                                ),
                                child: const Center(
                                  child: const Text(
                                    '❤️',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 채팅 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          persona.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: hasUnread
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: textTheme.bodyLarge?.color,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // 친밀도 표시 (like score와 뱃지) - 캐시 사용
                                      Builder(
                                        builder: (context) {
                                          final likes =
                                              _getCachedLikes(context, persona);
                                          final visualInfo =
                                              RelationScoreService.instance
                                                  .getVisualInfo(likes);

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
                                ),
                                Text(
                                  _getLastMessageTime(messages, matchedAt: persona.matchedAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hasUnread
                                        ? colorScheme.primary
                                        : textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isTyping
                                        ? AppLocalizations.of(context)!
                                            .isTyping(persona.name)
                                        : _getLastMessagePreview(
                                            messages, persona.name),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hasUnread || isTyping
                                          ? textTheme.bodyLarge?.color
                                          : textTheme.bodySmall?.color,
                                      fontWeight: hasUnread || isTyping
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                      fontStyle: isTyping
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasUnread &&
                                    lastPersonaMessageGroupCount > 0 &&
                                    !isTyping)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      lastPersonaMessageGroupCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }
}
