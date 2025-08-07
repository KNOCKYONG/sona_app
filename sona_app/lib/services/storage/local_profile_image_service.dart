import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// 로컬 프로필 이미지 저장 서비스
/// Firebase Storage 대신 기기 로컬에 프로필 이미지를 저장
class LocalProfileImageService {
  static const String _profileImagesDirName = 'profile_images';

  /// 프로필 이미지 저장
  /// 기존 이미지가 있으면 삭제하고 새 이미지 저장
  static Future<String?> saveProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Documents 디렉토리 가져오기
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir =
          Directory('${appDocDir.path}/$_profileImagesDirName');

      // 디렉토리가 없으면 생성
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // 기존 이미지 삭제
      await deleteProfileImage(userId);

      // 이미지 파일 확장자 가져오기
      final extension = path.extension(imageFile.path);
      final fileName = 'profile_$userId$extension';
      final destinationPath = '${profileImagesDir.path}/$fileName';

      // 이미지 복사
      final savedFile = await imageFile.copy(destinationPath);

      debugPrint('✅ Profile image saved: $destinationPath');
      return savedFile.path;
    } catch (e) {
      debugPrint('❌ Failed to save profile image: $e');
      return null;
    }
  }

  /// 프로필 이미지 가져오기
  static Future<File?> getProfileImage(String userId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir =
          Directory('${appDocDir.path}/$_profileImagesDirName');

      if (!await profileImagesDir.exists()) {
        return null;
      }

      // 해당 사용자의 프로필 이미지 찾기
      final files = await profileImagesDir.list().toList();
      for (final entity in files) {
        if (entity is File) {
          final fileName = path.basename(entity.path);
          if (fileName.startsWith('profile_$userId')) {
            debugPrint('✅ Profile image found: ${entity.path}');
            return entity;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('❌ Failed to get profile image: $e');
      return null;
    }
  }

  /// 프로필 이미지 경로 가져오기
  static Future<String?> getProfileImagePath(String userId) async {
    final file = await getProfileImage(userId);
    return file?.path;
  }

  /// 프로필 이미지 삭제
  static Future<bool> deleteProfileImage(String userId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir =
          Directory('${appDocDir.path}/$_profileImagesDirName');

      if (!await profileImagesDir.exists()) {
        return true;
      }

      // 해당 사용자의 모든 프로필 이미지 삭제
      final files = await profileImagesDir.list().toList();
      for (final entity in files) {
        if (entity is File) {
          final fileName = path.basename(entity.path);
          if (fileName.startsWith('profile_$userId')) {
            await entity.delete();
            debugPrint('✅ Profile image deleted: ${entity.path}');
          }
        }
      }

      return true;
    } catch (e) {
      debugPrint('❌ Failed to delete profile image: $e');
      return false;
    }
  }

  /// 모든 프로필 이미지 삭제 (캐시 정리용)
  static Future<bool> clearAllProfileImages() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir =
          Directory('${appDocDir.path}/$_profileImagesDirName');

      if (await profileImagesDir.exists()) {
        await profileImagesDir.delete(recursive: true);
        debugPrint('✅ All profile images cleared');
      }

      return true;
    } catch (e) {
      debugPrint('❌ Failed to clear profile images: $e');
      return false;
    }
  }

  /// 프로필 이미지 디렉토리 크기 가져오기
  static Future<int> getProfileImagesDirSize() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final profileImagesDir =
          Directory('${appDocDir.path}/$_profileImagesDirName');

      if (!await profileImagesDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in profileImagesDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('❌ Failed to calculate profile images size: $e');
      return 0;
    }
  }
}
