import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/persona.dart';
import '../persona/firebase_persona_service.dart';
import '../storage/firebase_storage_service.dart';

class DataMigrationService {
  static final FirebasePersonaService _personaService = FirebasePersonaService();
  
  /// 기본 페르소나 데이터를 Firebase로 마이그레이션
  static Future<bool> migrateDefaultPersonasToFirebase() async {
    try {
      debugPrint('Starting persona migration to Firebase...');
      
      final defaultPersonas = _getDefaultPersonas();
      
      for (final persona in defaultPersonas) {
        debugPrint('Migrating persona: ${persona.name}');
        
        // 1. 사진들을 Firebase Storage에 업로드
        List<String> firebasePhotoUrls = [];
        
        for (int i = 0; i < persona.photoUrls.length; i++) {
          try {
            final photoUrl = persona.photoUrls[i];
            final imageData = await _downloadImageFromUrl(photoUrl);
            
            if (imageData != null) {
              final fileName = 'photo_${i + 1}.jpg';
              final uploadedUrl = await FirebaseStorageService.uploadPersonaPhoto(
                personaId: persona.id,
                imageData: imageData,
                fileName: fileName,
              );
              firebasePhotoUrls.add(uploadedUrl);
            }
          } catch (e) {
            debugPrint('Failed to upload photo for ${persona.name}: $e');
            // 실패한 경우 원본 URL 유지 (fallback)
            firebasePhotoUrls.add(persona.photoUrls[i]);
          }
        }
        
        // 2. 페르소나 정보를 Firestore에 저장
        try {
          await _personaService.createPersona(
            name: persona.name,
            age: persona.age,
            description: persona.description,
            personality: persona.personality,
            photoUrls: firebasePhotoUrls,
            preferences: persona.preferences,
          );
          debugPrint('Successfully migrated persona: ${persona.name}');
        } catch (e) {
          debugPrint('Failed to create persona ${persona.name}: $e');
        }
      }
      
      debugPrint('Persona migration completed');
      return true;
    } catch (e) {
      debugPrint('Migration failed: $e');
      return false;
    }
  }
  
  /// URL에서 이미지 다운로드
  static Future<Uint8List?> _downloadImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Failed to download image from $url: $e');
    }
    return null;
  }
  
  /// 기본 페르소나 데이터 정의 (기존 하드코딩된 데이터)
  static List<Persona> _getDefaultPersonas() {
    return [
      Persona(
        id: 'persona_001',
        name: '지민',
        age: 22,
        description: '밝고 활발한 대학생입니다. 카페에서 일하며 사진 찍는 것을 좋아해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1494790108755-2616b64d4b6c?w=400',
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
        personality: '발랄하고 긍정적이며 대화를 즐깁니다. 가끔 장난기 있는 모습을 보이기도 해요.',
      ),
      Persona(
        id: 'persona_002',
        name: '서준',
        age: 26,
        description: '조용하지만 따뜻한 마음을 가진 개발자입니다. 책과 음악을 좋아해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        ],
        personality: '차분하고 신중한 성격입니다. 깊이 있는 대화를 선호하며 상대방을 배려합니다.',
      ),
      Persona(
        id: 'persona_003',
        name: '하은',
        age: 24,
        description: '예술을 사랑하는 감성적인 디자이너입니다. 여행과 새로운 경험을 추구해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
        ],
        personality: '창의적이고 감성적입니다. 예술과 아름다운 것들에 관심이 많아요.',
      ),
      Persona(
        id: 'persona_004',
        name: '민수',
        age: 28,
        description: '운동을 좋아하는 활동적인 트레이너입니다. 건강한 라이프스타일을 추구해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        ],
        personality: '에너지 넘치고 긍정적입니다. 건강과 운동에 대한 열정이 있어요.',
      ),
      Persona(
        id: 'persona_005',
        name: '수빈',
        age: 25,
        description: '독서를 사랑하는 조용한 성격의 도서관 사서입니다. 고양이를 좋아해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
        personality: '조용하고 사려깊습니다. 책과 동물을 사랑하며 깊은 대화를 즐겨요.',
      ),
      Persona(
        id: 'persona_006',
        name: '태현',
        age: 27,
        description: '음악을 하는 밴드 멤버입니다. 기타와 작곡을 좋아해요.',
        photoUrls: [
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
        personality: '자유로운 영혼의 뮤지션입니다. 감성적이고 예술적인 대화를 좋아해요.',
      ),
    ];
  }
  
  /// 마이그레이션 상태 확인
  static Future<Map<String, dynamic>> getMigrationStatus() async {
    try {
      await _personaService.loadAllPersonas();
      
      final firebasePersonaCount = _personaService.allPersonas.length;
      final defaultPersonaCount = _getDefaultPersonas().length;
      
      return {
        'isCompleted': firebasePersonaCount >= defaultPersonaCount,
        'firebaseCount': firebasePersonaCount,
        'defaultCount': defaultPersonaCount,
        'needsMigration': firebasePersonaCount < defaultPersonaCount,
      };
    } catch (e) {
      return {
        'isCompleted': false,
        'firebaseCount': 0,
        'defaultCount': _getDefaultPersonas().length,
        'needsMigration': true,
        'error': e.toString(),
      };
    }
  }
  
  /// 테스트용 단일 페르소나 마이그레이션
  static Future<bool> migrateTestPersona() async {
    try {
      final testPersona = _getDefaultPersonas().first;
      
      debugPrint('Migrating test persona: ${testPersona.name}');
      
      // 첫 번째 사진만 업로드
      final imageData = await _downloadImageFromUrl(testPersona.photoUrls.first);
      
      List<String> firebasePhotoUrls = [];
      if (imageData != null) {
        final uploadedUrl = await FirebaseStorageService.uploadPersonaPhoto(
          personaId: testPersona.id,
          imageData: imageData,
          fileName: 'test_photo.jpg',
        );
        firebasePhotoUrls.add(uploadedUrl);
      }
      
      await _personaService.createPersona(
        name: '${testPersona.name} (Test)',
        age: testPersona.age,
        description: testPersona.description,
        personality: testPersona.personality,
        photoUrls: firebasePhotoUrls,
      );
      
      debugPrint('Test persona migration completed');
      return true;
    } catch (e) {
      debugPrint('Test persona migration failed: $e');
      return false;
    }
  }
}