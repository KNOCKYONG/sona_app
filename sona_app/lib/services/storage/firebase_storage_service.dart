import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../base/base_service.dart';

/// Firebase Storage 서비스
class FirebaseStorageService extends BaseService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  
  /// 이미지 업로드 (File 객체)
  static Future<String?> uploadImage({
    required File file,
    required String path,
    Map<String, String>? metadata,
  }) async {
    try {
      debugPrint('📤 Uploading image to: $path');
      
      // Reference 생성
      final ref = _storage.ref().child(path);
      
      // Metadata 설정
      final settableMetadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: metadata,
      );
      
      // 업로드
      final uploadTask = ref.putFile(file, settableMetadata);
      
      // 업로드 진행상황 모니터링
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('📊 Upload progress: ${progress.toStringAsFixed(1)}%');
      });
      
      // 업로드 완료 대기
      final snapshot = await uploadTask;
      
      // 다운로드 URL 가져오기
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('✅ Upload complete: $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      return null;
    }
  }
  
  /// 이미지 업로드 (Uint8List)
  static Future<String?> uploadImageBytes({
    required Uint8List bytes,
    required String path,
    Map<String, String>? metadata,
  }) async {
    try {
      debugPrint('📤 Uploading image bytes to: $path');
      
      // Reference 생성
      final ref = _storage.ref().child(path);
      
      // Metadata 설정
      final settableMetadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: metadata,
      );
      
      // 업로드
      final uploadTask = ref.putData(bytes, settableMetadata);
      
      // 업로드 진행상황 모니터링
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('📊 Upload progress: ${progress.toStringAsFixed(1)}%');
      });
      
      // 업로드 완료 대기
      final snapshot = await uploadTask;
      
      // 다운로드 URL 가져오기
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('✅ Upload complete: $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      return null;
    }
  }
  
  /// 여러 이미지 업로드
  static Future<List<String>> uploadMultipleImages({
    required List<File> files,
    required String basePath,
    Map<String, String>? metadata,
  }) async {
    final urls = <String>[];
    
    for (int i = 0; i < files.length; i++) {
      final path = '$basePath/image_$i.jpg';
      final url = await uploadImage(
        file: files[i],
        path: path,
        metadata: metadata,
      );
      
      if (url != null) {
        urls.add(url);
      }
    }
    
    return urls;
  }
  
  /// 이미지 삭제
  static Future<bool> deleteImage(String path) async {
    try {
      debugPrint('🗑️ Deleting image: $path');
      
      final ref = _storage.ref().child(path);
      await ref.delete();
      
      debugPrint('✅ Image deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Delete failed: $e');
      return false;
    }
  }
  
  /// URL에서 Storage 경로 추출
  static String? getPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.pathSegments.join('/');
      
      // Firebase Storage URL 패턴에서 경로 추출
      final pattern = RegExp(r'o\/(.*?)\?');
      final match = pattern.firstMatch(path);
      
      if (match != null) {
        return Uri.decodeComponent(match.group(1)!);
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Failed to extract path from URL: $e');
      return null;
    }
  }
  
  /// 이미지 메타데이터 가져오기
  static Future<FullMetadata?> getMetadata(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = await ref.getMetadata();
      return metadata;
    } catch (e) {
      debugPrint('❌ Failed to get metadata: $e');
      return null;
    }
  }
}