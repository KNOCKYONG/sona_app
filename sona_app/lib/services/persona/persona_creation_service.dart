import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../../helpers/firebase_helper.dart';
import '../../core/constants.dart';
import '../base/base_service.dart';
import '../storage/firebase_storage_service.dart';
import 'cloudflare_r2_service.dart';
import 'image_optimization_service.dart';
import 'dart:typed_data';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// MBTI 질문 데이터
class MBTIQuestion {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String typeA; // I/E, S/N, T/F, J/P
  final String typeB;

  const MBTIQuestion({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.typeA,
    required this.typeB,
  });
}

/// 페르소나 생성 서비스
class PersonaCreationService extends BaseService {
  static final PersonaCreationService _instance = PersonaCreationService._internal();
  factory PersonaCreationService() => _instance;
  PersonaCreationService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // MBTI questions are now localized
  static List<MBTIQuestion> getMBTIQuestions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      MBTIQuestion(
        id: 1,
        question: localizations.mbtiQuestion1,
        optionA: localizations.mbtiQuestion1OptionA,
        optionB: localizations.mbtiQuestion1OptionB,
        typeA: 'I',
        typeB: 'E',
      ),
      MBTIQuestion(
        id: 2,
        question: localizations.mbtiQuestion2,
        optionA: localizations.mbtiQuestion2OptionA,
        optionB: localizations.mbtiQuestion2OptionB,
        typeA: 'S',
        typeB: 'N',
      ),
      MBTIQuestion(
        id: 3,
        question: localizations.mbtiQuestion3,
        optionA: localizations.mbtiQuestion3OptionA,
        optionB: localizations.mbtiQuestion3OptionB,
        typeA: 'T',
        typeB: 'F',
      ),
      MBTIQuestion(
        id: 4,
        question: localizations.mbtiQuestion4,
        optionA: localizations.mbtiQuestion4OptionA,
        optionB: localizations.mbtiQuestion4OptionB,
        typeA: 'J',
        typeB: 'P',
      ),
    ];
  }

  // Keep the old static list for backward compatibility (will be removed later)
  // MBTI 질문 리스트 (4개로 간소화)
  static const List<MBTIQuestion> mbtiQuestions = [
    MBTIQuestion(
      id: 1,
      question: '새로운 사람을 만났을 때',
      optionA: '안녕하세요... 반가워요',
      optionB: '오! 반가워! 나는 ○○야!',
      typeA: 'I',
      typeB: 'E',
    ),
    MBTIQuestion(
      id: 2,
      question: '상황을 파악할 때',
      optionA: '구체적으로 뭐가 어떻게 됐어?',
      optionB: '대충 어떤 느낌인지 알 것 같아',
      typeA: 'S',
      typeB: 'N',
    ),
    MBTIQuestion(
      id: 3,
      question: '결정을 내릴 때',
      optionA: '논리적으로 생각해보면...',
      optionB: '네 마음이 더 중요해',
      typeA: 'T',
      typeB: 'F',
    ),
    MBTIQuestion(
      id: 4,
      question: '약속을 잡을 때',
      optionA: '○시 ○분에 정확히 만나자',
      optionB: '그때쯤 보면 되지 뭐~',
      typeA: 'J',
      typeB: 'P',
    ),
  ];

  /// MBTI 계산 로직
  String calculateMBTI(BuildContext context, Map<int, String> answers) {
    int iCount = 0, eCount = 0;
    int sCount = 0, nCount = 0;
    int tCount = 0, fCount = 0;
    int jCount = 0, pCount = 0;

    final mbtiQuestions = getMBTIQuestions(context);
    for (final entry in answers.entries) {
      final question = mbtiQuestions.firstWhere((q) => q.id == entry.key);
      final answer = entry.value;

      if (answer == 'A') {
        switch (question.typeA) {
          case 'I': iCount++; break;
          case 'E': eCount++; break;
          case 'S': sCount++; break;
          case 'N': nCount++; break;
          case 'T': tCount++; break;
          case 'F': fCount++; break;
          case 'J': jCount++; break;
          case 'P': pCount++; break;
        }
      } else {
        switch (question.typeB) {
          case 'I': iCount++; break;
          case 'E': eCount++; break;
          case 'S': sCount++; break;
          case 'N': nCount++; break;
          case 'T': tCount++; break;
          case 'F': fCount++; break;
          case 'J': jCount++; break;
          case 'P': pCount++; break;
        }
      }
    }

    return '${iCount > eCount ? 'I' : 'E'}'
           '${sCount > nCount ? 'S' : 'N'}'
           '${tCount > fCount ? 'T' : 'F'}'
           '${jCount > pCount ? 'J' : 'P'}';
  }

  /// 페르소나 생성 (메인 메서드)
  Future<String?> createCustomPersona({
    required BuildContext context,
    required String name,
    required int age,
    required String gender,
    required String description,
    required Map<int, String> mbtiAnswers,
    required String speechStyle, // 친근한/정중한/시크한/활발한
    required List<String> interests, // 관심 분야
    required String conversationStyle, // 수다스러운/과묵한/공감적/논리적
    File? mainImage,
    List<File>? additionalImages,
    required bool isShare, // 공유 여부
  }) async {
    return await executeWithLoading<String?>(() async {
      try {
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          throw Exception('로그인이 필요합니다');
        }

        // 1. MBTI 계산
        final mbti = calculateMBTI(context, mbtiAnswers);
        debugPrint('📊 Calculated MBTI: $mbti');

        // 2. 이미지 업로드
        final personaId = 'custom_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint('🆔 Generated Persona ID: $personaId');
        
        // 메인 이미지 처리
        String? mainImageUrl;
        if (mainImage != null) {
          debugPrint('📸 Processing main image...');
          mainImageUrl = await _uploadPersonaImage(personaId, mainImage, 'main');
          debugPrint('✅ Main image uploaded: $mainImageUrl');
        }

        // 추가 이미지 처리
        List<String> additionalImageUrls = [];
        if (additionalImages != null && additionalImages.isNotEmpty) {
          debugPrint('📸 Processing ${additionalImages.length} additional images...');
          for (int i = 0; i < additionalImages.length; i++) {
            final url = await _uploadPersonaImage(personaId, additionalImages[i], 'additional_$i');
            if (url != null) {
              additionalImageUrls.add(url);
              debugPrint('✅ Additional image $i uploaded: $url');
            }
          }
        }

        // 3. 성격 설명 생성
        final personality = _generatePersonalityDescription(
          mbti: mbti,
          speechStyle: speechStyle,
          conversationStyle: conversationStyle,
          interests: interests,
        );

        // 4. 페르소나 데이터 생성
        final personaData = {
          'name': name,
          'age': age,
          'gender': gender,
          'description': description,
          'mbti': mbti,
          'personality': personality,
          'speechStyle': speechStyle,
          'conversationStyle': conversationStyle,
          'interests': interests,
          'photoUrls': [mainImageUrl, ...additionalImageUrls].where((url) => url != null).toList(),
          'likes': 0,
          'preferences': {
            'speechStyle': speechStyle,
            'conversationStyle': conversationStyle,
          },
          // 커스텀 페르소나 필드
          'isCustom': true,
          'createdBy': currentUser.uid,
          'isShare': isShare,
          'isConfirm': false, // 초기값은 미승인
          'isDeleted': false, // 명시적으로 삭제되지 않음 표시
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          // 추가 필드
          'topics': interests,
          'keywords': _generateKeywords(name, description, interests),
        };

        // 5. Firestore에 저장
        debugPrint('📝 Saving persona to Firebase: $personaId');
        debugPrint('📋 Persona data: ${personaData.keys.join(', ')}');
        
        await _firestore
            .collection(AppConstants.personasCollection)
            .doc(personaId)
            .set(personaData);
        
        debugPrint('✅ Persona saved to Firebase successfully');

        // 6. 공유 요청 시 관리자에게 알림
        if (isShare) {
          await _notifyAdminForReview(personaId, name, currentUser.uid);
        }

        debugPrint('✅ Custom persona created successfully: $personaId');
        return personaId;
        
      } catch (e) {
        debugPrint('❌ Error creating custom persona: $e');
        throw e;
      }
    }, errorContext: 'createCustomPersona');
  }

  /// 성격 설명 생성
  String _generatePersonalityDescription({
    required String mbti,
    required String speechStyle,
    required String conversationStyle,
    required List<String> interests,
  }) {
    final mbtiDesc = _getMBTIDescription(mbti);
    final interestText = interests.join(', ');
    
    return '''
$mbtiDesc
말투는 $speechStyle 스타일이며, 대화할 때는 $conversationStyle 편입니다.
관심사는 $interestText 등이 있습니다.
    '''.trim();
  }

  /// MBTI 별 기본 설명
  String _getMBTIDescription(String mbti) {
    final descriptions = {
      'INTJ': '전략적이고 독립적인 사고를 가진 완벽주의자',
      'INTP': '논리적이고 창의적인 사고를 즐기는 분석가',
      'ENTJ': '대담하고 리더십이 강한 지휘관',
      'ENTP': '논쟁을 즐기고 창의적인 혁신가',
      'INFJ': '통찰력 있고 이상주의적인 옹호자',
      'INFP': '창의적이고 이상주의적인 중재자',
      'ENFJ': '카리스마 있고 영감을 주는 리더',
      'ENFP': '열정적이고 창의적인 활동가',
      'ISTJ': '실용적이고 사실을 중시하는 현실주의자',
      'ISFJ': '헌신적이고 따뜻한 수호자',
      'ESTJ': '실용적이고 현실적인 관리자',
      'ESFJ': '친절하고 사교적인 집정관',
      'ISTP': '융통성 있고 관대한 장인',
      'ISFP': '유연하고 매력적인 예술가',
      'ESTP': '활동적이고 현실적인 사업가',
      'ESFP': '자발적이고 열정적인 연예인',
    };
    
    return descriptions[mbti] ?? '독특한 개성을 가진 사람';
  }

  /// 키워드 생성
  List<String> _generateKeywords(String name, String description, List<String> interests) {
    final keywords = <String>[name];
    
    // 설명에서 주요 단어 추출 (간단한 구현)
    final descWords = description.split(' ')
        .where((word) => word.length > 2)
        .take(5)
        .toList();
    keywords.addAll(descWords);
    
    // 관심사 추가
    keywords.addAll(interests);
    
    return keywords.take(10).toList(); // 최대 10개
  }

  /// 이미지 업로드 헬퍼 메서드 (R2 전용)
  Future<String?> _uploadPersonaImage(String personaId, File imageFile, String imageType) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      debugPrint('📸 Uploading $imageType image for persona $personaId...');
      
      if (imageType == 'main') {
        // 메인 이미지는 CloudflareR2Service 사용
        final result = await CloudflareR2Service.uploadPersonaImages(
          personaId: personaId,
          mainImage: bytes,
          includeOriginal: false,
        );
        
        // 중간 크기 URL 반환 (프로필용)
        final url = result.getMainUrl(ImageSize.medium) ?? 
                   result.getMainUrl(ImageSize.small);
        
        if (url != null) {
          debugPrint('✅ Main image uploaded to R2: $url');
          return url;
        }
      } else {
        // 추가 이미지는 최적화 후 업로드
        final optimized = await ImageOptimizationService.optimizeImage(
          bytes,
          includeOriginal: false,
        );
        
        final optimizedBytes = optimized.images[ImageSize.medium] ?? 
                               optimized.images[ImageSize.small] ?? 
                               bytes;
        
        final path = 'personas/$personaId/${personaId}_$imageType.jpg';
        final success = await CloudflareR2Service.uploadToR2(path, optimizedBytes);
        
        if (success) {
          final url = CloudflareR2Service.generatePublicUrl(path);
          debugPrint('✅ Additional image uploaded to R2: $url');
          return url;
        }
      }
      
      debugPrint('❌ R2 upload failed. Image will not be available.');
      return null;
    } catch (e) {
      debugPrint('❌ Error uploading image: $e');
      return null;
    }
  }

  /// 관리자에게 검토 알림
  Future<void> _notifyAdminForReview(String personaId, String personaName, String creatorId) async {
    try {
      await _firestore.collection('admin_notifications').add({
        'type': 'persona_review',
        'personaId': personaId,
        'personaName': personaName,
        'creatorId': creatorId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('📮 Admin notified for persona review: $personaId');
    } catch (e) {
      debugPrint('❌ Error notifying admin: $e');
    }
  }

  /// 내가 만든 페르소나 목록 조회
  Future<List<Persona>> getMyPersonas() async {
    return await executeWithLoading<List<Persona>>(() async {
      try {
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          return [];
        }

        final querySnapshot = await _firestore
            .collection(AppConstants.personasCollection)
            .where('createdBy', isEqualTo: currentUser.uid)
            .where('isDeleted', isNotEqualTo: true)
            .orderBy('isDeleted')
            .orderBy('createdAt', descending: true)
            .get();

        return querySnapshot.docs
            .map((doc) => Persona.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
      } catch (e) {
        debugPrint('❌ Error getting my personas: $e');
        return [];
      }
    }, errorContext: 'getMyPersonas') ?? [];
  }

  /// 페르소나 업데이트
  Future<bool> updateCustomPersona({
    required String personaId,
    String? name,
    String? description,
    bool? isShare,
  }) async {
    return await executeWithLoading<bool>(() async {
      try {
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          throw Exception('로그인이 필요합니다');
        }

        final updates = <String, dynamic>{
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (name != null) updates['name'] = name;
        if (description != null) updates['description'] = description;
        if (isShare != null) {
          updates['isShare'] = isShare;
          if (isShare) {
            // 공유로 변경 시 재승인 필요
            updates['isConfirm'] = false;
            await _notifyAdminForReview(personaId, name ?? 'Unknown', currentUser.uid);
          }
        }

        await _firestore
            .collection(AppConstants.personasCollection)
            .doc(personaId)
            .update(updates);

        return true;
      } catch (e) {
        debugPrint('❌ Error updating persona: $e');
        return false;
      }
    }, errorContext: 'updateCustomPersona') ?? false;
  }

  /// 페르소나 삭제 (Soft Delete)
  Future<bool> deleteCustomPersona(String personaId) async {
    return await executeWithLoading<bool>(() async {
      try {
        await _firestore
            .collection(AppConstants.personasCollection)
            .doc(personaId)
            .update({
          'isDeleted': true,
          'deletedAt': FieldValue.serverTimestamp(),
        });

        return true;
      } catch (e) {
        debugPrint('❌ Error deleting persona: $e');
        return false;
      }
    }, errorContext: 'deleteCustomPersona') ?? false;
  }
}