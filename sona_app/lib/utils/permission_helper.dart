import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionHelper {
  /// 카메라/갤러리 권한 요청 및 이미지 선택
  static Future<File?> requestAndPickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      // 권한 요청
      Permission permission;
      String permissionName;
      String permissionDescription;
      
      if (source == ImageSource.camera) {
        permission = Permission.camera;
        permissionName = '카메라';
        permissionDescription = '프로필 사진 촬영을 위해 카메라 접근이 필요합니다.';
      } else {
        if (Platform.isIOS) {
          permission = Permission.photos;
        } else {
          permission = Permission.storage;
        }
        permissionName = '사진 라이브러리';
        permissionDescription = '프로필 사진 선택을 위해 갤러리 접근이 필요합니다.';
      }
      
      // 권한 상태 확인
      final status = await permission.status;
      
      if (status.isDenied) {
        // 권한 요청 다이얼로그 표시
        final shouldRequest = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('$permissionName 권한 필요'),
            content: Text(permissionDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('권한 허용'),
              ),
            ],
          ),
        );
        
        if (shouldRequest != true) {
          return null;
        }
        
        // 권한 요청
        final newStatus = await permission.request();
        
        if (newStatus.isDenied || newStatus.isPermanentlyDenied) {
          if (context.mounted) {
            _showPermissionDeniedDialog(context, permissionName);
          }
          return null;
        }
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(context, permissionName);
        }
        return null;
      }
      
      // 이미지 선택
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
  
  /// 권한 거부 시 설정 안내 다이얼로그
  static void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName 권한 거부됨'),
        content: Text(
          '$permissionName 권한이 거부되었습니다.\n'
          '설정에서 권한을 허용해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('설정으로 이동'),
          ),
        ],
      ),
    );
  }
  
  /// 알림 권한 요청
  static Future<bool> requestNotificationPermission(BuildContext context) async {
    final permission = Permission.notification;
    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림 권한 필요'),
          content: const Text(
            '새로운 메시지와 매칭 알림을 받으시려면\n'
            '알림 권한이 필요합니다.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('나중에'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('권한 허용'),
            ),
          ],
        ),
      );
      
      if (shouldRequest == true) {
        final newStatus = await permission.request();
        return newStatus.isGranted;
      }
    }
    
    return false;
  }
}