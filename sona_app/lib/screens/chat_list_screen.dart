import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/chat/chat_service.dart';
import '../services/persona/persona_service.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../services/auth/device_id_service.dart';
import '../models/persona.dart';
import '../models/message.dart';
import '../widgets/common/sona_logo.dart';
import '../widgets/persona/optimized_persona_image.dart';
import '../services/relationship/relation_score_service.dart';
import '../l10n/app_localizations.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // false로 설정하여 매번 새로고침
  
  bool _isLoading = false;
  bool _hasInitialized = false;
  final Map<String, bool> _leftChatStatus = {};
  
  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드를 지연시켜서 context가 준비된 후 실행
    Future.microtask(() => _loadInitialData());
  }
  
  Future<void> _loadInitialData() async {
    if (!mounted || _hasInitialized) return;
    _hasInitialized = true;
    await _initializeChatList();
  }
  

  /// 🔄 채팅 목록 초기화 및 새로고침
  Future<void> _initializeChatList() async {
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
      
      // 2. UserService에서 사용자 정보 설정
      if (userService.currentUser != null && authService.user != null) {
        debugPrint('🔐 Setting user info for chat list: ${userService.currentUser!.gender}, genderAll: ${userService.currentUser!.genderAll}');
        personaService.setCurrentUser(userService.currentUser!);
      }
      
      // 3. 🔥 PersonaService가 초기화되지 않았으면 초기화
      if (personaService.matchedPersonas.isEmpty) {
        debugPrint('🔄 Initializing PersonaService for chat list...');
        await personaService.initialize(userId: currentUserId);
      }
      
      // 4. 매칭된 페르소나들의 채팅 메시지 로드
      final matchedPersonas = personaService.matchedPersonas;
      debugPrint('📱 Loading messages for ${matchedPersonas.length} matched personas');
      
      // 병렬로 모든 페르소나의 메시지 로드 (성능 개선)
      if (matchedPersonas.isNotEmpty) {
        final loadFutures = <Future<void>>[];
        for (final persona in matchedPersonas) {
          debugPrint('📨 Loading messages for persona: ${persona.name} (${persona.id})');
          // loadChatHistory를 사용하여 전체 채팅 기록 로드
          loadFutures.add(chatService.loadChatHistory(currentUserId, persona.id));
        }
        
        // 모든 메시지 로드 대기
        await Future.wait(loadFutures);
      } else {
        debugPrint('⚠️ No matched personas found - user might need to swipe more');
      }
      
      // 5. 채팅방 나가기 상태 확인
      if (currentUserId != null && currentUserId.isNotEmpty) {
        try {
          final chatsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('chats')
              .get();
              
          _leftChatStatus.clear();
          for (var doc in chatsSnapshot.docs) {
            final data = doc.data();
            if (data['leftChat'] == true) {
              _leftChatStatus[doc.id] = true;
            }
          }
          debugPrint('📋 Left chat status loaded: ${_leftChatStatus.length} chats left');
        } catch (e) {
          debugPrint('Error loading leftChat status: $e');
        }
      }
      
      // 6. UI 강제 새로고침
      if (mounted) {
        setState(() {});
      }
      
    } catch (e) {
      debugPrint('❌ Error initializing chat list: $e');
    }
  }

  String _getLastMessagePreview(List<Message> messages, String personaName) {
    final localizations = AppLocalizations.of(context)!;

    if (messages.isEmpty) return localizations.waitingForChat(personaName);
    
    final lastMessage = messages.last;
    
    // 튜토리얼 시작 메시지인 경우 개인화된 메시지로 변경
    if (lastMessage.content == localizations.startConversation || lastMessage.content == localizations.startConversationWithSona) {
      return localizations.waitingForChat(personaName);
    }
    
    String preview = '';
    if (lastMessage.isFromUser) {
      preview = '${AppLocalizations.of(context)!.me}: ';
    }
    
    if (lastMessage.type == MessageType.image) {
      preview += '📷 ${AppLocalizations.of(context)!.photo}';
    } else if (lastMessage.type == MessageType.voice) {
      preview += localizations.voiceMessage;
    } else {
      preview += lastMessage.content;
    }
    
    return preview;
  }

  String _getLastMessageTime(List<Message> messages) {
    if (messages.isEmpty) return '';
    
    final lastMessage = messages.last;
    
    // 튜토리얼 시작 메시지인 경우 시간 표시하지 않음
    final localizations = AppLocalizations.of(context)!;
    if (lastMessage.content == localizations.startConversation || lastMessage.content == localizations.startConversationWithSona) {
      return '';
    }
    
    final now = DateTime.now();
    final messageTime = lastMessage.timestamp;
    final difference = now.difference(messageTime);
    
    if (difference.inDays > 0) {
      return AppLocalizations.of(context)!.daysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return AppLocalizations.of(context)!.hoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes);
    } else {
      return AppLocalizations.of(context)!.justNow;
    }
  }

  Future<int> _getLikes(BuildContext context, Persona persona) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid;
    
    if (userId == null) return persona.likes ?? 0;
    
    return await RelationScoreService.instance.getLikes(
      userId: userId,
      personaId: persona.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요
    
    // Cache theme and colors for performance
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    // 화면이 처음 빌드될 때 데이터 로드
    if (!_hasInitialized && !_isLoading) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await _loadInitialData();
          _isLoading = false;
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.refreshingChatList),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              try {
                // 전체 채팅 목록 새로고침
                await _initializeChatList();
                
                if (mounted) {
                  final personaService = Provider.of<PersonaService>(context, listen: false);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.refreshComplete(personaService.matchedPersonas.length)),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.refreshFailed),
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
          final matchedPersonas = List<Persona>.from(personaService.matchedPersonas)
              .where((persona) => _leftChatStatus[persona.id] != true)
              .toList();
          
          // Sort personas by last interaction (message or match time)
          matchedPersonas.sort((a, b) {
            final messagesA = chatService.getMessages(a.id);
            final messagesB = chatService.getMessages(b.id);
            
            // Get last interaction time for A
            DateTime? lastTimeA;
            if (messagesA.isNotEmpty) {
              lastTimeA = messagesA.last.timestamp;
            } else if (a.matchedAt != null) {
              lastTimeA = a.matchedAt;
            }
            
            // Get last interaction time for B
            DateTime? lastTimeB;
            if (messagesB.isNotEmpty) {
              lastTimeB = messagesB.last.timestamp;
            } else if (b.matchedAt != null) {
              lastTimeB = b.matchedAt;
            }
            
            // If both have no interaction time, maintain original order
            if (lastTimeA == null && lastTimeB == null) return 0;
            if (lastTimeA == null) return 1;
            if (lastTimeB == null) return -1;
            
            return lastTimeB.compareTo(lastTimeA); // Descending order (newest first)
          });
          
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
                      Navigator.pushReplacementNamed(context, '/persona-selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
          
          return ListView.builder(
            itemCount: matchedPersonas.length,
            itemBuilder: (context, index) {
              final persona = matchedPersonas[index];
              // 매번 최신 메시지를 가져오도록 함
              final messages = List<Message>.from(chatService.getMessages(persona.id));
              
              // 🔧 FIX: 안전한 hasUnread 계산 및 마지막 메시지 그룹 카운트
              bool hasUnread = false;
              int unreadPersonaMessageCount = 0;
              int lastPersonaMessageGroupCount = 0;
              
              try {
                // Count unread messages from persona (not user)
                unreadPersonaMessageCount = messages.where((msg) => 
                  !msg.isFromUser && (msg.isRead == false || msg.isRead == null)
                ).length;
                hasUnread = unreadPersonaMessageCount > 0;
                
                // 마지막 페르소나 메시지 그룹의 개수 계산
                if (messages.isNotEmpty && hasUnread) {
                  // 뒤에서부터 연속된 페르소나 메시지 개수 세기
                  for (int i = messages.length - 1; i >= 0; i--) {
                    if (!messages[i].isFromUser && (messages[i].isRead == false || messages[i].isRead == null)) {
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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: persona,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      // 프로필 이미지
                      Stack(
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
                                  border: Border.all(color: theme.cardColor, width: 2),
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
                                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                            color: textTheme.bodyLarge?.color,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // 친밀도 표시 (like score와 뱃지)
                                      FutureBuilder<int>(
                                        future: _getLikes(context, persona),
                                        builder: (context, snapshot) {
                                          final likes = snapshot.data ?? persona.likes ?? 0;
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
                                ),
                                if (messages.isNotEmpty)
                                  Text(
                                    _getLastMessageTime(messages),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hasUnread ? colorScheme.primary : textTheme.bodySmall?.color,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isTyping ? AppLocalizations.of(context)!.isTyping(persona.name) : _getLastMessagePreview(messages, persona.name),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hasUnread || isTyping ? textTheme.bodyLarge?.color : textTheme.bodySmall?.color,
                                      fontWeight: hasUnread || isTyping ? FontWeight.w500 : FontWeight.normal,
                                      fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasUnread && lastPersonaMessageGroupCount > 0 && !isTyping)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          );
        },
      ),
    );
  }
}