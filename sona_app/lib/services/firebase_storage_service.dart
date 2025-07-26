import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  
  /// 페르소나 프로필 사진 업로드
  static Future<String> uploadPersonaPhoto({
    required String personaId,
    required Uint8List imageData,
    required String fileName,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child('personas')
          .child(personaId)
          .child('photos')
          .child(fileName);
      
      final uploadTask = ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload persona photo: $e');
    }
  }
  
  /// 여러 사진 업로드 (배치)
  static Future<List<String>> uploadPersonaPhotos({
    required String personaId,
    required List<Uint8List> imageDataList,
    required List<String> fileNames,
  }) async {
    if (imageDataList.length != fileNames.length) {
      throw Exception('Image data and file names count mismatch');
    }
    
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < imageDataList.length; i++) {
      try {
        final url = await uploadPersonaPhoto(
          personaId: personaId,
          imageData: imageDataList[i],
          fileName: fileNames[i],
        );
        uploadedUrls.add(url);
      } catch (e) {
        debugPrint('Failed to upload photo ${fileNames[i]}: $e');
        // 실패한 경우 기본 이미지 URL 사용
        uploadedUrls.add('https://via.placeholder.com/400?text=Photo+Error');
      }
    }
    
    return uploadedUrls;
  }
  
  /// 사진 삭제
  static Future<bool> deletePersonaPhoto(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint('Failed to delete photo: $e');
      return false;
    }
  }
  
  /// 페르소나의 모든 사진 삭제
  static Future<bool> deleteAllPersonaPhotos(String personaId) async {
    try {
      final folderRef = _storage
          .ref()
          .child('personas')
          .child(personaId)
          .child('photos');
      
      final listResult = await folderRef.listAll();
      
      for (final item in listResult.items) {
        await item.delete();
      }
      
      return true;
    } catch (e) {
      debugPrint('Failed to delete all persona photos: $e');
      return false;
    }
  }
  
  /// URL에서 이미지 다운로드
  static Future<Uint8List?> downloadImage(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      final data = await ref.getData();
      return data;
    } catch (e) {
      debugPrint('Failed to download image: $e');
      return null;
    }
  }
  
  /// 스토리지 사용량 확인
  static Future<Map<String, dynamic>> getStorageUsage(String personaId) async {
    try {
      final folderRef = _storage
          .ref()
          .child('personas')
          .child(personaId);
      
      final listResult = await folderRef.listAll();
      int totalSize = 0;
      int photoCount = 0;
      
      for (final item in listResult.items) {
        final metadata = await item.getMetadata();
        totalSize += metadata.size ?? 0;
        photoCount++;
      }
      
      return {
        'totalSize': totalSize,
        'photoCount': photoCount,
        'personaId': personaId,
      };
    } catch (e) {
      return {
        'totalSize': 0,
        'photoCount': 0,
        'personaId': personaId,
        'error': e.toString(),
      };
    }
  }
}