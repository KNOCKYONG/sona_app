import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../persona/optimized_persona_image.dart';
import '../../l10n/app_localizations.dart';

/// 채팅 리스트용 최적화된 아이템 위젯
class ChatListItem extends StatelessWidget {
  final Persona persona;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnread;
  final VoidCallback onTap;
  
  const ChatListItem({
    super.key,
    required this.persona,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.hasUnread,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: OptimizedPersonaImage.thumbnail(
        persona: persona,
        size: 56,
      ),
      title: Text(
        persona.name,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: hasUnread ? Colors.black87 : Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: hasUnread ? const Color(0xFFFF6B9D) : Colors.grey,
            ),
          ),
          if (hasUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B9D),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
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
}

/// 페르소나 카드 미니 버전 (리스트뷰용)
class PersonaCardMini extends StatelessWidget {
  final Persona persona;
  final VoidCallback? onTap;
  
  const PersonaCardMini({
    super.key,
    required this.persona,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 최적화된 이미지 - 카드용 small 사이즈 사용
            Positioned.fill(
              child: OptimizedPersonaImage.card(
                persona: persona,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            
            // 그라디언트 오버레이
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            
            // 정보
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        persona.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${persona.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    persona.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}