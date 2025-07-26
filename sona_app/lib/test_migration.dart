import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/data_migration_service.dart';
import 'services/firebase_persona_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase 초기화 성공');

    // 마이그레이션 상태 확인
    print('\n📊 마이그레이션 상태 확인...');
    final migrationStatus = await DataMigrationService.getMigrationStatus();
    print('마이그레이션 상태: $migrationStatus');

    if (migrationStatus['needsMigration'] == true) {
      print('\n🚀 데이터 마이그레이션 시작...');
      
      // 테스트용 단일 페르소나 마이그레이션 먼저 실행
      print('테스트 페르소나 마이그레이션...');
      final testSuccess = await DataMigrationService.migrateTestPersona();
      
      if (testSuccess) {
        print('✅ 테스트 페르소나 마이그레이션 성공!');
        
        // 전체 마이그레이션 실행
        print('\n전체 페르소나 마이그레이션...');
        final fullSuccess = await DataMigrationService.migrateDefaultPersonasToFirebase();
        
        if (fullSuccess) {
          print('✅ 전체 마이그레이션 성공!');
        } else {
          print('❌ 전체 마이그레이션 실패');
        }
      } else {
        print('❌ 테스트 마이그레이션 실패');
      }
    } else {
      print('✅ 이미 마이그레이션이 완료되었습니다.');
    }

    // 결과 확인
    print('\n📋 마이그레이션 후 상태 확인...');
    final firebaseService = FirebasePersonaService();
    await firebaseService.loadAllPersonas();
    
    print('Firebase에 저장된 페르소나 수: ${firebaseService.allPersonas.length}');
    for (final persona in firebaseService.allPersonas) {
      print('- ${persona.name} (${persona.age}세): ${persona.description}');
    }

    print('\n🎉 마이그레이션 테스트 완료!');
    
  } catch (e) {
    print('❌ 오류 발생: $e');
    print('스택트레이스: ${e.toString()}');
  }
}