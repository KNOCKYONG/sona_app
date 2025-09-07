import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/persona.dart';
import '../services/persona/persona_creation_service.dart';
import '../services/persona/persona_service.dart';
import '../services/ui/haptic_service.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';
import '../services/purchase/purchase_service.dart';
import '../widgets/persona/persona_profile_viewer.dart';
import 'create_persona_screen.dart';
import 'chat_screen.dart';

class MyPersonasScreen extends StatefulWidget {
  const MyPersonasScreen({Key? key}) : super(key: key);

  @override
  State<MyPersonasScreen> createState() => _MyPersonasScreenState();
}

class _MyPersonasScreenState extends State<MyPersonasScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PersonaCreationService _personaCreationService = PersonaCreationService();
  
  List<Persona> _myPersonas = [];
  List<Persona> _pendingPersonas = [];
  List<Persona> _approvedPersonas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMyPersonas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMyPersonas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final personas = await _personaCreationService.getMyPersonas();
      
      debugPrint('📋 Loaded ${personas.length} personas');
      for (var persona in personas) {
        debugPrint('👤 ${persona.name}: ${persona.photoUrls.length} photos');
        if (persona.photoUrls.isNotEmpty) {
          debugPrint('   🖼️ Main photo: ${persona.photoUrls.first}');
        }
      }
      
      setState(() {
        _myPersonas = personas;
        _pendingPersonas = personas.where((p) => p.isShare && !p.isConfirm).toList();
        _approvedPersonas = personas.where((p) => p.isShare && p.isConfirm).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading personas: $e');
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.myPersonas,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: localizations.all), // "전체"
            Tab(text: localizations.pendingApproval), // "승인 대기"
            Tab(text: localizations.approved), // "공개됨"
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonaList(_myPersonas),
          _buildPersonaList(_pendingPersonas),
          _buildPersonaList(_approvedPersonas),
        ],
      ),
      floatingActionButton: _myPersonas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _createNewPersona,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                localizations.createPersona,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  Widget _buildPersonaList(List<Persona> personas) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (personas.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadMyPersonas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: personas.length,
        itemBuilder: (context, index) {
          return _buildPersonaCard(personas[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final localizations = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noPersonasYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.createYourFirstPersona,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createNewPersona,
              icon: const Icon(Icons.add, size: 28),
              label: Text(
                localizations.createPersona,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonaCard(Persona persona) {
    final localizations = AppLocalizations.of(context)!;
    
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
      child: InkWell(
        onTap: () => _viewPersonaDetail(persona),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 프로필 이미지
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () => _showPersonaProfile(context, persona),
                  child: ClipOval(
                    child: persona.photoUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: persona.photoUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 페르소나 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            persona.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${persona.age} ${persona.mbti}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      persona.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // 상태 표시
                        if (persona.isShare) ...[
                          Icon(
                            persona.isConfirm ? Icons.public : Icons.hourglass_empty,
                            size: 16,
                            color: persona.isConfirm ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            persona.isConfirm 
                                ? localizations.approved
                                : localizations.pendingApproval,
                            style: TextStyle(
                              fontSize: 12,
                              color: persona.isConfirm ? Colors.green : Colors.orange,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            localizations.privatePersona,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // 대화 시작 버튼과 메뉴 버튼
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 대화 시작 버튼
                  IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _startChat(persona),
                    tooltip: localizations.startConversation,
                  ),
                  // 메뉴 버튼
                  PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      _editPersona(persona);
                      break;
                    case 'delete':
                      _deletePersona(persona);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  // 승인되지 않은 페르소나만 수정 가능
                  if (!persona.isConfirm)
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 8),
                          Text(localizations.edit),
                        ],
                      ),
                    ),
                  // 승인된 페르소나는 삭제 메뉴 숨김
                  if (!persona.isConfirm)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            localizations.delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNewPersona() async {
    await HapticService.selectionClick();
    
    // 무료 사용자 제한 체크 (3개)
    if (_myPersonas.length >= 3) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.personaLimitReached),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePersonaScreen(),
      ),
    );
    
    if (result == true) {
      await _loadMyPersonas();
    }
  }

  void _viewPersonaDetail(Persona persona) async {
    await HapticService.lightImpact();
    // TODO: 페르소나 상세 화면으로 이동
  }

  Future<void> _startChat(Persona persona) async {
    await HapticService.selectionClick();
    
    // PersonaService를 통해 매칭 처리
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;
    
    // 이미 매칭되어 있는지 확인
    final isAlreadyMatched = personaService.matchedPersonas.any((p) => p.id == persona.id);
    
    if (isAlreadyMatched) {
      // 이미 매칭된 경우 현재 페르소나 설정하고 채팅 화면으로 이동
      await personaService.setCurrentPersona(persona);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      }
    } else {
      // 매칭되지 않은 경우 확인 다이얼로그 표시
      final purchaseService = Provider.of<PurchaseService>(context, listen: false);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(localizations.startConversation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.startChatWithPersona(persona.name)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      localizations.useOneHeart,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${localizations.ownedHearts}: ${purchaseService.hearts}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(localizations.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(localizations.confirm),
              ),
            ],
          );
        },
      );
      
      if (confirmed != true) {
        return; // 사용자가 취소한 경우
      }
      
      // 매칭되지 않은 경우 매칭 처리 (하트 1개 소모)
      try {
        // 매칭 처리 - persona 객체와 purchaseService도 함께 전달
        final success = await personaService.matchWithPersona(
          persona.id,
          personaObject: persona,
          purchaseService: purchaseService,
        );
        if (success) {
          // 매칭 성공 후 페르소나 설정
          await personaService.setCurrentPersona(persona);
          await HapticService.success();
          
          // 채팅 화면으로 이동
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          }
        } else {
          await HapticService.error();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.matchingFailed),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        await HapticService.error();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.failedToStartConversation),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editPersona(Persona persona) async {
    await HapticService.selectionClick();
    
    // 승인된 페르소나는 수정 불가
    if (persona.isConfirm) {
      await HapticService.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cannotEditApprovedPersona),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    // 수정 화면으로 이동 (기존 데이터 전달)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePersonaScreen(editingPersona: persona),
      ),
    );
    
    if (result == true) {
      await _loadMyPersonas();
    }
  }
  
  void _showPersonaProfile(BuildContext context, Persona persona) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PersonaProfileViewer(
            persona: persona,
            onClose: () {},
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// 대화방 삭제 (페르소나와 관련된 모든 데이터)
  Future<void> _deleteChatRoom(String personaId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      
      final userId = currentUser.uid;
      final docId = '${userId}_$personaId';
      
      // 1. user_persona_relationships 삭제
      await FirebaseFirestore.instance
          .collection(AppConstants.userPersonaRelationshipsCollection)
          .doc(docId)
          .delete();
      
      // 2. messages 커렉션 삭제 (대화 내용)
      final messagesQuery = await FirebaseFirestore.instance
          .collection(AppConstants.messagesCollection)
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .get();
      
      // 배치로 삭제
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in messagesQuery.docs) {
        batch.delete(doc.reference);
      }
      
      // 3. conversation_memories 커렉션 삭제 (대화 기억)
      final memoriesQuery = await FirebaseFirestore.instance
          .collection('conversation_memories')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .get();
      
      for (final doc in memoriesQuery.docs) {
        batch.delete(doc.reference);
      }
      
      // 4. conversation_summaries 커렉션 삭제 (대화 요약)
      final summariesQuery = await FirebaseFirestore.instance
          .collection('conversation_summaries')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .get();
      
      for (final doc in summariesQuery.docs) {
        batch.delete(doc.reference);
      }
      
      // 배치 커밋
      await batch.commit();
      
      debugPrint('✅ Chat room deleted for persona: $personaId');
    } catch (e) {
      debugPrint('❌ Error deleting chat room: $e');
    }
  }

  void _deletePersona(Persona persona) async {
    await HapticService.selectionClick();
    final localizations = AppLocalizations.of(context)!;
    
    // 승인된 페르소나는 삭제 불가
    if (persona.isConfirm) {
      await HapticService.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.cannotDeleteApprovedPersona),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    // 대화 중인지 확인
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final isMatched = personaService.matchedPersonas.any((p) => p.id == persona.id);
    
    // 경고 메시지 결정
    String warningMessage;
    if (isMatched) {
      warningMessage = localizations.deletePersonaWithConversation;
    } else if (persona.isShare) {
      warningMessage = localizations.sharedPersonaDeleteWarning;
    } else {
      warningMessage = localizations.deletePersonaConfirm;
    }
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePersona),
        content: Text(warningMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // 대화방 삭제 (매칭된 경우)
      if (isMatched) {
        await _deleteChatRoom(persona.id);
        // PersonaService에서 매칭된 페르소나 목록에서도 제거
        personaService.removeFromMatchedPersonas(persona.id);
      }
      
      final success = await _personaCreationService.deleteCustomPersona(persona.id);
      
      if (success) {
        await HapticService.success();
        await _loadMyPersonas();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.personaDeleted),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await HapticService.error();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.deleteFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}