import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat/chat_service.dart';
import '../services/persona/persona_service.dart';
import '../services/auth/auth_service.dart';
import '../services/purchase/subscription_service.dart';
import '../services/auth/device_id_service.dart';
import '../models/persona.dart';
import '../models/message.dart';
import '../widgets/common/sona_logo.dart';
import '../widgets/persona/optimized_persona_image.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // false로 설정하여 매번 새로고침
  
  bool _isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    // 채팅 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChatList();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면이 표시될 때마다 데이터 새로고침
    if (!_isRefreshing) {
      _isRefreshing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _initializeChatList();
        _isRefreshing = false;
      });
    }
  }
  
  void _refreshChatList() {
    // Firebase에서 다시 로드하지 않고 UI만 새로고침
    final chatService = Provider.of<ChatService>(context, listen: false);
    chatService.notifyListeners();
  }

  /// 🔄 채팅 목록 초기화 및 새로고침
  Future<void> _initializeChatList() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscriptionService = Provider.of<SubscriptionService>(context, listen: false);
    
    try {
      // 1. 🔧 현재 사용자 ID 확보 (DeviceIdService 사용)
      final currentUserId = await DeviceIdService.getCurrentUserId(
        firebaseUserId: authService.user?.uid,
      );
      
      debugPrint('🆔 Chat list using userId: $currentUserId');
      
      // 서비스들에 사용자 ID 설정
      chatService.setCurrentUserId(currentUserId);
      personaService.setCurrentUserId(currentUserId);
      
      if (authService.user != null) {
        subscriptionService.loadSubscription(authService.user!.uid);
      } else {
        // DeviceId 기반 구독 (무료)
        subscriptionService.loadSubscription(currentUserId);
      }
      
      // 2. 🔥 PersonaService 완전 새로고침 (매칭된 페르소나 최신 상태 로드)
      debugPrint('🔄 Refreshing PersonaService for chat list...');
      await personaService.initialize(userId: currentUserId);
      
      // 3. 매칭된 페르소나들의 채팅 메시지 로드
      final matchedPersonas = personaService.matchedPersonas;
      debugPrint('📱 Loading messages for ${matchedPersonas.length} matched personas');
      
      for (final persona in matchedPersonas) {
        debugPrint('📨 Loading messages for persona: ${persona.name} (${persona.id})');
        await chatService.loadChatHistory(currentUserId, persona.id);
      }
      
      if (matchedPersonas.isEmpty) {
        debugPrint('⚠️ No matched personas found - user might need to swipe more');
      }
      
      // 4. UI 강제 새로고침
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Error initializing chat list: $e');
    }
  }

  String _getLastMessagePreview(List<Message> messages, String personaName) {
    if (messages.isEmpty) return '$personaName님이 대화를 기다리고 있어요.';
    
    final lastMessage = messages.last;
    
    // 튜토리얼 시작 메시지인 경우 개인화된 메시지로 변경
    if (lastMessage.content == '대화를 시작해보세요!') {
      return '$personaName님이 대화를 기다리고 있어요.';
    }
    
    String preview = '';
    if (lastMessage.isFromUser) {
      preview = '나: ';
    }
    
    if (lastMessage.type == MessageType.image) {
      preview += '📷 사진';
    } else if (lastMessage.type == MessageType.voice) {
      preview += '🎤 음성 메시지';
    } else {
      preview += lastMessage.content;
    }
    
    return preview;
  }

  String _getLastMessageTime(List<Message> messages) {
    if (messages.isEmpty) return '';
    
    final lastMessage = messages.last;
    
    // 튜토리얼 시작 메시지인 경우 시간 표시하지 않음
    if (lastMessage.content == '대화를 시작해보세요!') {
      return '';
    }
    
    final now = DateTime.now();
    final messageTime = lastMessage.timestamp;
    final difference = now.difference(messageTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SonaLogoSmall(size: 32),
            const SizedBox(width: 12),
            Text(
              '채팅',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall?.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: () async {
              // 🔄 수동 새로고침
              final personaService = Provider.of<PersonaService>(context, listen: false);
              final authService = Provider.of<AuthService>(context, listen: false);
              
              // 로딩 인디케이터 표시
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('매칭된 페르소나를 새로고침하는 중...'),
                  duration: Duration(seconds: 2),
                ),
              );
              
              try {
                // 🔧 DeviceIdService로 사용자 ID 확보
                final currentUserId = await DeviceIdService.getCurrentUserId(
                  firebaseUserId: authService.user?.uid,
                );
                
                await personaService.initialize(userId: currentUserId);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('새로고침 완료! ${personaService.matchedPersonas.length}명의 매칭된 페르소나'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('새로고침 실패. 다시 시도해주세요.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // 검색 기능 추가 예정
            },
          ),
        ],
      ),
      body: Consumer2<PersonaService, ChatService>(
        builder: (context, personaService, chatService, child) {
          final matchedPersonas = List<Persona>.from(personaService.matchedPersonas);
          
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
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '아직 매칭된 페르소나가 없어요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '새로운 페르소나를 만나러 가볼까요?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/persona-selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '페르소나 만나기',
                      style: TextStyle(
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
              debugPrint('Chat list - Persona: ${persona.name}, Messages: ${messages.length}');
              if (messages.isNotEmpty) {
                try {
                  debugPrint('Last message: ${messages.last.content}');
                  final unreadCount = messages.where((m) => !m.isFromUser && m.isRead != true).length;
                  if (unreadCount > 0) {
                    debugPrint('🔴 Still have $unreadCount unread messages for ${persona.name}');
                  }
                } catch (e) {
                  debugPrint('❌ Error accessing last message: $e');
                }
              }
              
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
                
                if (hasUnread) {
                  debugPrint('🔴 Unread messages for ${persona.name}: $unreadPersonaMessageCount');
                  messages.where((msg) => !msg.isFromUser && (msg.isRead == false || msg.isRead == null)).forEach((msg) {
                    debugPrint('  - Unread: ${msg.content.substring(0, 30 < msg.content.length ? 30 : msg.content.length)}... isRead: ${msg.isRead}');
                  });
                }
                
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
                    color: Theme.of(context).cardColor,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.2),
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
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                          if (persona.relationshipScore > 80)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
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
                                Text(
                                  persona.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                if (messages.isNotEmpty)
                                  Text(
                                    _getLastMessageTime(messages),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hasUnread ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isTyping ? '${persona.name}님이 입력 중...' : _getLastMessagePreview(messages, persona.name),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hasUnread || isTyping ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodySmall?.color,
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
                                      color: Theme.of(context).colorScheme.primary,
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