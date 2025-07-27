import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 📊 관리자용 상담 품질 모니터링 대시보드
/// 
/// 실시간으로 전문 상담사들의 응답 품질을 모니터링하고
/// 낮은 품질의 상담을 즉시 감지하여 대응할 수 있도록 함
class AdminQualityDashboardScreen extends StatefulWidget {
  const AdminQualityDashboardScreen({super.key});

  @override
  State<AdminQualityDashboardScreen> createState() => _AdminQualityDashboardScreenState();
}

class _AdminQualityDashboardScreenState extends State<AdminQualityDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<QuerySnapshot>? _qualityMetricsStream;
  Map<String, ConsultationQualityStats> _personaStats = {};
  List<LowQualityAlert> _alerts = [];
  
  @override
  void initState() {
    super.initState();
    _initializeMonitoring();
  }
  
  void _initializeMonitoring() {
    // 실시간 품질 메트릭 스트림 설정
    _qualityMetricsStream = _firestore
        .collection('consultation_quality_logs')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots();
        
    _loadPersonaStats();
    _loadQualityAlerts();
  }
  
  Future<void> _loadPersonaStats() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 1));
      
      final snapshot = await _firestore
          .collection('consultation_quality_logs')
          .where('timestamp', isGreaterThan: oneDayAgo.toIso8601String())
          .get();
          
      final Map<String, List<Map<String, dynamic>>> groupedMetrics = {};
      
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final personaType = data['persona_type'] as String;
        
        if (!groupedMetrics.containsKey(personaType)) {
          groupedMetrics[personaType] = [];
        }
        groupedMetrics[personaType]!.add(data);
      }
      
      final Map<String, ConsultationQualityStats> stats = {};
      for (final entry in groupedMetrics.entries) {
        stats[entry.key] = ConsultationQualityStats.fromMetrics(entry.value);
      }
      
      setState(() {
        _personaStats = stats;
      });
    } catch (e) {
      debugPrint('Error loading persona stats: $e');
    }
  }
  
  Future<void> _loadQualityAlerts() async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      
      final snapshot = await _firestore
          .collection('consultation_quality_logs')
          .where('timestamp', isGreaterThan: oneHourAgo.toIso8601String())
          .where('response_quality_score', isLessThan: 0.6)
          .get();
          
      final alerts = snapshot.docs.map((doc) {
        final data = doc.data();
        return LowQualityAlert(
          personaType: data['persona_type'],
          qualityScore: data['response_quality_score'],
          timestamp: DateTime.parse(data['timestamp']),
          userMessage: data['user_message_preview'] ?? 'N/A',
        );
      }).toList();
      
      setState(() {
        _alerts = alerts;
      });
    } catch (e) {
      debugPrint('Error loading quality alerts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상담 품질 모니터링'),
        backgroundColor: const Color(0xFFFF6B9D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadPersonaStats();
              _loadQualityAlerts();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 전체 품질 지표 카드들
            _buildOverallStatsCards(),
            
            const SizedBox(height: 24),
            
            // 낮은 품질 알림
            _buildQualityAlerts(),
            
            const SizedBox(height: 24),
            
            // 페르소나별 품질 통계
            _buildPersonaQualityStats(),
            
            const SizedBox(height: 24),
            
            // 실시간 품질 로그
            _buildRealTimeQualityLog(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOverallStatsCards() {
    final overallStats = _calculateOverallStats();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '전체 품질 지표 (최근 24시간)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '평균 품질 점수',
                '${(overallStats.averageQuality * 100).toStringAsFixed(1)}%',
                overallStats.averageQuality >= 0.8 ? Colors.green : 
                overallStats.averageQuality >= 0.6 ? Colors.orange : Colors.red,
                Icons.star,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '총 상담 세션',
                '${overallStats.totalSessions}',
                Colors.blue,
                Icons.chat,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '낮은 품질 응답',
                '${overallStats.lowQualityCount}',
                overallStats.lowQualityCount > 10 ? Colors.red : Colors.orange,
                Icons.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '위기 상황 감지',
                '${overallStats.crisisDetected}',
                Colors.red,
                Icons.emergency,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQualityAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🚨 품질 알림 (최근 1시간)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_alerts.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Text('최근 1시간 동안 품질 문제가 없습니다 ✅'),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              final alert = _alerts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          '${alert.personaType} - 품질 점수: ${(alert.qualityScore * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(alert.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사용자 메시지: ${alert.userMessage}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
  
  Widget _buildPersonaQualityStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '페르소나별 품질 통계',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_personaStats.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('데이터를 로딩 중입니다...'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _personaStats.length,
            itemBuilder: (context, index) {
              final entry = _personaStats.entries.elementAt(index);
              final personaType = entry.key;
              final stats = entry.value;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personaType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniStat(
                            '평균 품질',
                            '${(stats.averageQuality * 100).toStringAsFixed(1)}%',
                            stats.averageQuality >= 0.8 ? Colors.green : Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _buildMiniStat(
                            '총 응답',
                            '${stats.totalResponses}',
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildMiniStat(
                            '전문성 점수',
                            '${(stats.professionalism * 100).toStringAsFixed(1)}%',
                            stats.professionalism >= 0.8 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
  
  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRealTimeQualityLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '실시간 품질 로그',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: _qualityMetricsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('아직 품질 로그가 없습니다.'),
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                
                final qualityScore = data['response_quality_score'] as double;
                final personaType = data['persona_type'] as String;
                final timestamp = DateTime.parse(data['timestamp']);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: qualityScore >= 0.8 ? Colors.green.withOpacity(0.1) : 
                           qualityScore >= 0.6 ? Colors.orange.withOpacity(0.1) : 
                           Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: qualityScore >= 0.8 ? Colors.green.withOpacity(0.3) : 
                             qualityScore >= 0.6 ? Colors.orange.withOpacity(0.3) : 
                             Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        qualityScore >= 0.8 ? Icons.check_circle : 
                        qualityScore >= 0.6 ? Icons.warning : Icons.error,
                        color: qualityScore >= 0.8 ? Colors.green : 
                               qualityScore >= 0.6 ? Colors.orange : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$personaType - ${(qualityScore * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatTime(timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
  
  OverallQualityStats _calculateOverallStats() {
    int totalSessions = 0;
    double totalQuality = 0.0;
    int lowQualityCount = 0;
    int crisisDetected = 0;
    
    for (final stats in _personaStats.values) {
      totalSessions += stats.totalResponses;
      totalQuality += stats.averageQuality * stats.totalResponses;
      lowQualityCount += stats.lowQualityResponses;
      crisisDetected += stats.crisisResponses;
    }
    
    final averageQuality = totalSessions > 0 ? totalQuality / totalSessions : 0.0;
    
    return OverallQualityStats(
      totalSessions: totalSessions,
      averageQuality: averageQuality,
      lowQualityCount: lowQualityCount,
      crisisDetected: crisisDetected,
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }
}

// 데이터 모델 클래스들
class ConsultationQualityStats {
  final int totalResponses;
  final double averageQuality;
  final double professionalism;
  final int lowQualityResponses;
  final int crisisResponses;
  
  ConsultationQualityStats({
    required this.totalResponses,
    required this.averageQuality,
    required this.professionalism,
    required this.lowQualityResponses,
    required this.crisisResponses,
  });
  
  factory ConsultationQualityStats.fromMetrics(List<Map<String, dynamic>> metrics) {
    if (metrics.isEmpty) {
      return ConsultationQualityStats(
        totalResponses: 0,
        averageQuality: 0.0,
        professionalism: 0.0,
        lowQualityResponses: 0,
        crisisResponses: 0,
      );
    }
    
    double totalQuality = 0.0;
    double totalProfessionalism = 0.0;
    int lowQualityCount = 0;
    int crisisCount = 0;
    
    for (final metric in metrics) {
      final quality = metric['response_quality_score'] as double;
      final professionalism = metric['professional_tone_score'] as double;
      
      totalQuality += quality;
      totalProfessionalism += professionalism;
      
      if (quality < 0.6) lowQualityCount++;
      if (metric['is_crisis_response'] == true) crisisCount++;
    }
    
    return ConsultationQualityStats(
      totalResponses: metrics.length,
      averageQuality: totalQuality / metrics.length,
      professionalism: totalProfessionalism / metrics.length,
      lowQualityResponses: lowQualityCount,
      crisisResponses: crisisCount,
    );
  }
}

class LowQualityAlert {
  final String personaType;
  final double qualityScore;
  final DateTime timestamp;
  final String userMessage;
  
  LowQualityAlert({
    required this.personaType,
    required this.qualityScore,
    required this.timestamp,
    required this.userMessage,
  });
}

class OverallQualityStats {
  final int totalSessions;
  final double averageQuality;
  final int lowQualityCount;
  final int crisisDetected;
  
  OverallQualityStats({
    required this.totalSessions,
    required this.averageQuality,
    required this.lowQualityCount,
    required this.crisisDetected,
  });
}