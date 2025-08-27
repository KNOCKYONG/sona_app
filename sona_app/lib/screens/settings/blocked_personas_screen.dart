import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/device_id_service.dart';
import '../../services/block_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class BlockedPersonasScreen extends StatefulWidget {
  const BlockedPersonasScreen({super.key});

  @override
  State<BlockedPersonasScreen> createState() => _BlockedPersonasScreenState();
}

class _BlockedPersonasScreenState extends State<BlockedPersonasScreen> {
  final BlockService _blockService = BlockService();
  List<BlockedPersona> _blockedPersonas = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadBlockedPersonas();
  }

  Future<void> _loadBlockedPersonas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      _userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
      
      debugPrint('🔍 BlockedPersonasScreen - Loading blocked personas');
      debugPrint('   userId: $_userId');
      debugPrint('   isAuthenticated: ${authService.user != null}');
      
      if (_userId != null && _userId!.isNotEmpty) {
        debugPrint('🚀 Initializing BlockService...');
        await _blockService.initialize(_userId!);
        
        debugPrint('📊 Fetching blocked personas...');
        final personas = await _blockService.getBlockedPersonas(_userId!);
        
        debugPrint('✅ Loaded ${personas.length} blocked personas');
        
        if (mounted) {
          setState(() {
            _blockedPersonas = personas;
            _isLoading = false;
          });
        }
      } else {
        debugPrint('⚠️ No userId available');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading blocked personas: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unblockPersona(BlockedPersona persona) async {
    final localizations = AppLocalizations.of(context)!;
    
    // 차단 해제 확인 다이얼로그
    final shouldUnblock = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.unblock),
        content: Text('${persona.personaName}의 차단을 해제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(localizations.unblock),
          ),
        ],
      ),
    );

    if (shouldUnblock == true && _userId != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B9D),
          ),
        ),
      );

      try {
        final success = await _blockService.unblockPersona(
          userId: _userId!,
          personaId: persona.personaId,
        );

        // Close loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.unblockedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            
            // Reload the list
            _loadBlockedPersonas();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('차단 해제에 실패했습니다'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Close loading dialog
        if (mounted) Navigator.of(context).pop();
        
        debugPrint('Error unblocking persona: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류가 발생했습니다: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    if (localizations.isKorean) {
      return DateFormat('yyyy년 MM월 dd일').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.manageBlockedAIs,
          style: TextStyle(
            color: theme.textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B9D),
              ),
            )
          : _blockedPersonas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.noBlockedAIs,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _blockedPersonas.length,
                  itemBuilder: (context, index) {
                    final persona = _blockedPersonas[index];
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          child: Icon(
                            Icons.block,
                            color: Colors.red[600],
                          ),
                        ),
                        title: Text(
                          persona.personaName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (persona.reason != null && persona.reason!.isNotEmpty)
                              Text(
                                '${localizations.blockReason}: ${persona.reason}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              '${localizations.blockedAt}: ${_formatDate(persona.blockedAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () => _unblockPersona(persona),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text(
                            localizations.unblock,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}