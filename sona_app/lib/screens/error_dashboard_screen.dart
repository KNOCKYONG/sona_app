import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_error_report.dart';
import '../helpers/firebase_helper.dart';
import '../services/chat/error_recovery_service.dart';

/// 대화 오류 대시보드 화면
/// 관리자가 발생한 오류들을 모니터링할 수 있는 화면
class ErrorDashboardScreen extends StatefulWidget {
  const ErrorDashboardScreen({super.key});

  @override
  State<ErrorDashboardScreen> createState() => _ErrorDashboardScreenState();
}

class _ErrorDashboardScreenState extends State<ErrorDashboardScreen> {
  String _selectedFilter = 'all'; // all, persona, type
  String? _selectedPersona;
  String? _selectedErrorType;
  
  // 페르소나별 에러 통계
  final Map<String, int> _personaErrorCounts = {};
  final Map<String, int> _errorTypeCounts = {};
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화 오류 대시보드'),
        backgroundColor: const Color(0xFFFF6B9D),
      ),
      body: Column(
        children: [
          // 필터 섹션
          _buildFilterSection(),
          
          // 통계 섹션
          _buildStatisticsSection(),
          
          // 에러 리스트
          Expanded(
            child: _buildErrorList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '필터',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('전체'),
                selected: _selectedFilter == 'all',
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = 'all';
                    _selectedPersona = null;
                    _selectedErrorType = null;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('페르소나별'),
                selected: _selectedFilter == 'persona',
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = 'persona';
                  });
                },
              ),
              ChoiceChip(
                label: const Text('에러 타입별'),
                selected: _selectedFilter == 'type',
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = 'type';
                  });
                },
              ),
            ],
          ),
          if (_selectedFilter == 'persona') ...[
            const SizedBox(height: 8),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseHelper.chatErrorFix
                  .orderBy('created_at', descending: true)
                  .limit(100)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                
                final personas = <String>{};
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  personas.add(data['persona_name'] ?? 'Unknown');
                }
                
                return Wrap(
                  spacing: 8,
                  children: personas.map((persona) => FilterChip(
                    label: Text(persona),
                    selected: _selectedPersona == persona,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPersona = selected ? persona : null;
                      });
                    },
                  )).toList(),
                );
              },
            ),
          ],
          if (_selectedFilter == 'type') ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['api_key_error', 'timeout', 'rate_limit', 'server_error', 'unknown']
                  .map((type) => FilterChip(
                    label: Text(_getErrorTypeLabel(type)),
                    selected: _selectedErrorType == type,
                    onSelected: (selected) {
                      setState(() {
                        _selectedErrorType = selected ? type : null;
                      });
                    },
                  )).toList(),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStatisticsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHelper.chatErrorFix
          .orderBy('created_at', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // 통계 계산
        _personaErrorCounts.clear();
        _errorTypeCounts.clear();
        
        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final personaName = data['persona_name'] ?? 'Unknown';
          final errorType = data['error_type'] ?? 'unknown';
          
          _personaErrorCounts[personaName] = (_personaErrorCounts[personaName] ?? 0) + 1;
          _errorTypeCounts[errorType] = (_errorTypeCounts[errorType] ?? 0) + 1;
        }
        
        // 가장 많은 에러가 발생한 페르소나
        final topPersona = _personaErrorCounts.entries.isNotEmpty
            ? _personaErrorCounts.entries.reduce((a, b) => a.value > b.value ? a : b)
            : null;
            
        // 가장 많이 발생한 에러 타입
        final topErrorType = _errorTypeCounts.entries.isNotEmpty
            ? _errorTypeCounts.entries.reduce((a, b) => a.value > b.value ? a : b)
            : null;
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '에러 통계',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: '총 에러 수',
                      value: snapshot.data!.docs.length.toString(),
                      icon: Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      title: '가장 많은 에러',
                      value: topPersona?.key ?? 'N/A',
                      subtitle: '${topPersona?.value ?? 0}건',
                      icon: Icons.person,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      title: '주요 에러 타입',
                      value: _getErrorTypeLabel(topErrorType?.key ?? 'unknown'),
                      subtitle: '${topErrorType?.value ?? 0}건',
                      icon: Icons.warning,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildErrorList() {
    Query query = FirebaseHelper.chatErrorFix.orderBy('created_at', descending: true);
    
    // 필터 적용
    if (_selectedFilter == 'persona' && _selectedPersona != null) {
      query = query.where('persona_name', isEqualTo: _selectedPersona);
    } else if (_selectedFilter == 'type' && _selectedErrorType != null) {
      query = query.where('error_type', isEqualTo: _selectedErrorType);
    }
    
    return StreamBuilder<QuerySnapshot>(
      stream: query.limit(50).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('에러 리포트가 없습니다.'),
          );
        }
        
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final errorReport = ChatErrorReport.fromMap(
              doc.data() as Map<String, dynamic>,
            );
            
            return _buildErrorItem(errorReport);
          },
        );
      },
    );
  }
  
  Widget _buildErrorItem(ChatErrorReport errorReport) {
    final isProblematic = ErrorRecoveryService.instance.isPersonaProblematic(errorReport.personaId);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isProblematic ? Colors.red.withValues(alpha: 0.05) : null,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getErrorTypeColor(errorReport.errorType ?? 'unknown'),
          child: Text(
            errorReport.personaName.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Row(
          children: [
            Text(errorReport.personaName),
            const SizedBox(width: 8),
            if (errorReport.occurrenceCount > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${errorReport.occurrenceCount}회',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            const SizedBox(width: 4),
            if (isProblematic)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '문제 발생',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getErrorTypeLabel(errorReport.errorType ?? 'unknown'),
              style: TextStyle(
                color: _getErrorTypeColor(errorReport.errorType ?? 'unknown'),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatDateTime(errorReport.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errorReport.errorMessage != null) ...[
                  const Text(
                    '에러 메시지:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      errorReport.errorMessage!,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const Text(
                  '최근 대화:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...errorReport.recentChats.map((msg) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: msg.isFromUser ? Colors.blue.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.isFromUser ? '사용자: ' : '${errorReport.personaName}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(msg.content),
                      ),
                    ],
                  ),
                )),
                if (errorReport.userMessage != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    '사용자 메시지:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(errorReport.userMessage!),
                ],
                if (errorReport.occurrenceCount > 1) ...[
                  const SizedBox(height: 12),
                  const Text(
                    '발생 정보:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '첫 발생: ${errorReport.firstOccurred != null ? _formatDateTime(errorReport.firstOccurred!) : "N/A"}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '마지막 발생: ${errorReport.lastOccurred != null ? _formatDateTime(errorReport.lastOccurred!) : "N/A"}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '총 ${errorReport.occurrenceCount}회 발생',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getErrorTypeLabel(String type) {
    switch (type) {
      case 'api_key_error':
        return 'API 키 오류';
      case 'timeout':
        return '타임아웃';
      case 'rate_limit':
        return '요청 제한';
      case 'server_error':
        return '서버 오류';
      case 'auth_error':
        return '인증 오류';
      default:
        return '알 수 없음';
    }
  }
  
  Color _getErrorTypeColor(String type) {
    switch (type) {
      case 'api_key_error':
      case 'auth_error':
        return Colors.red;
      case 'timeout':
        return Colors.orange;
      case 'rate_limit':
        return Colors.amber;
      case 'server_error':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}