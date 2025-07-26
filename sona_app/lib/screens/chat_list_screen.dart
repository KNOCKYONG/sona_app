import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/chat_service.dart';
import '../services/persona_service.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';
import '../services/device_id_service.dart';
import '../models/persona.dart';
import '../models/message.dart';
import '../widgets/sona_logo.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    // 채팅 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChatList();
    });
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
        isTutorialMode: authService.isTutorialMode,
      );
      
      debugPrint('🆔 Chat list using userId: $currentUserId');
      
      // 서비스들에 사용자 ID 설정
      chatService.setCurrentUserId(currentUserId);
      personaService.setCurrentUserId(currentUserId);
      
      if (authService.user != null) {
        subscriptionService.loadSubscription(authService.user!.uid);
      } else if (authService.isTutorialMode) {
        subscriptionService.loadSubscription('tutorial_user');
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
        chatService.loadMessages(persona.id);
      }
      
      if (matchedPersonas.isEmpty) {
        debugPrint('⚠️ No matched personas found - user might need to swipe more');
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
    
    if (lastMessage.type == MessageType.image) {
      return '📷 사진';
    } else if (lastMessage.type == MessageType.voice) {
      return '🎤 음성 메시지';
    }
    return lastMessage.content;
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const SonaLogoSmall(size: 32),
            const SizedBox(width: 12),
            const Text(
              '채팅',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
                  actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
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
                  isTutorialMode: authService.isTutorialMode,
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
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // 검색 기능 추가 예정
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Color(0xFFFF6B9D)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/persona-selection');
            },
          ),
        ],
      ),
      body: Consumer2<PersonaService, ChatService>(
        builder: (context, personaService, chatService, child) {
          final matchedPersonas = personaService.matchedPersonas;
          
          if (matchedPersonas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '아직 매칭된 페르소나가 없어요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '새로운 페르소나를 만나러 가볼까요?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/persona-selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
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
              final messages = chatService.getMessages(persona.id);
              debugPrint('Chat list - Persona: ${persona.name}, Messages: ${messages.length}');
              if (messages.isNotEmpty) {
                try {
                  debugPrint('Last message: ${messages.last.content}');
                } catch (e) {
                  debugPrint('❌ Error accessing last message: $e');
                }
              }
              
              // 🔧 FIX: 안전한 hasUnread 계산
              bool hasUnread = false;
              try {
                hasUnread = messages.isNotEmpty && 
                           messages.any((msg) => !msg.isFromUser && (msg.isRead == false));
              } catch (e) {
                debugPrint('❌ Error calculating hasUnread: $e');
                hasUnread = false;
              }
              
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
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
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
                                color: const Color(0xFFFF6B9D).withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: persona.photoUrls.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: persona.photoUrls.first,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person, size: 30),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person, size: 30),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, size: 30),
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
                                  border: Border.all(color: Colors.white, width: 2),
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
                                    color: Colors.black87,
                                  ),
                                ),
                                if (messages.isNotEmpty)
                                  Text(
                                    _getLastMessageTime(messages),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hasUnread ? const Color(0xFFFF6B9D) : Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _getLastMessagePreview(messages, persona.name),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hasUnread ? Colors.black87 : Colors.grey,
                                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasUnread)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF6B9D),
                                      shape: BoxShape.circle,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // 채팅 탭 선택
        selectedItemColor: const Color(0xFFFF6B9D),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '매칭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              // 현재 화면
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/persona-selection');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}