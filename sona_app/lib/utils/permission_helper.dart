import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import '../l10n/app_localizations.dart';

// Only import permission_handler for non-web platforms
import 'package:permission_handler/permission_handler.dart'
    if (dart.library.html) 'permission_handler_stub.dart';

class PermissionHelper {
  /// 카메라/갤러리 권한 요청 및 이미지 선택
  static Future<File?> requestAndPickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      // Web에서는 권한 체크가 필요없음
      if (kIsWeb) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        // Web에서는 File 객체를 생성할 수 없으므로 null 반환
        // 실제 웹 구현에서는 XFile을 직접 사용해야 함
        if (pickedFile != null) {
          debugPrint('Image picked on web: ${pickedFile.path}');
          // Web에서는 File을 생성할 수 없으므로 null 반환
          return null;
        }
        return null;
      }
      // 권한 요청
      Permission permission;
      String permissionName;
      String permissionDescription;
      
      if (source == ImageSource.camera) {
        permission = Permission.camera;
        permissionName = AppLocalizations.of(context)!.cameraPermission;
        permissionDescription = AppLocalizations.of(context)!.cameraPermissionDesc;
      } else {
        // Platform check using defaultTargetPlatform for web compatibility
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          permission = Permission.photos;
        } else {
          permission = Permission.storage;
        }
        permissionName = AppLocalizations.of(context)!.galleryPermission;
        permissionDescription = AppLocalizations.of(context)!.galleryPermissionDesc;
      }
      
      // 권한 상태 확인
      final status = await permission.status;
      
      if (status.isDenied) {
        // 권한 요청 다이얼로그 표시
        final shouldRequest = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.permissionRequired),
            content: Text(permissionDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.grantPermission),
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
        title: Text(AppLocalizations.of(context)!.permissionDenied),
        content: Text(
          AppLocalizations.of(context)!.permissionDeniedMessage(permissionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(AppLocalizations.of(context)!.goToSettings),
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
          title: Text(AppLocalizations.of(context)!.notificationPermissionRequired),
          content: Text(
            AppLocalizations.of(context)!.notificationPermissionDesc,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.later),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.allowPermission),
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