import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File, Platform;
import 'package:device_info_plus/device_info_plus.dart';
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
        permissionDescription =
            AppLocalizations.of(context)!.cameraPermissionDesc;
      } else {
        // Platform check using defaultTargetPlatform for web compatibility
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          permission = Permission.photos;
        } else {
          // Android 버전별 권한 처리
          if (Platform.isAndroid) {
            final deviceInfo = DeviceInfoPlugin();
            final androidInfo = await deviceInfo.androidInfo;
            
            debugPrint('📸 Android SDK Version: ${androidInfo.version.sdkInt}');
            
            if (androidInfo.version.sdkInt >= 33) {
              // Android 13 (API 33) 이상: READ_MEDIA_IMAGES 권한 사용
              permission = Permission.photos;
              debugPrint('📸 Using READ_MEDIA_IMAGES permission for Android 13+');
            } else {
              // Android 12 (API 32) 이하: READ_EXTERNAL_STORAGE 권한 사용
              permission = Permission.storage;
              debugPrint('📸 Using READ_EXTERNAL_STORAGE permission for Android 12-');
            }
          } else {
            // 기본값 (Android가 아닌 경우)
            permission = Permission.photos;
          }
        }
        permissionName = AppLocalizations.of(context)!.galleryPermission;
        permissionDescription =
            AppLocalizations.of(context)!.galleryPermissionDesc;
      }

      // 권한 상태 확인
      final status = await permission.status;
      debugPrint('📸 Current permission status: $status');

      // 권한이 이미 허용된 경우 - 다시 묻지 않고 바로 진행
      if (status.isGranted || status.isLimited) {
        debugPrint('✅ Permission already granted');
        // 바로 이미지 선택으로 진행
      }
      // 권한이 거부된 경우 (처음 요청하거나 이전에 거부한 경우)
      else if (status.isDenied) {
        debugPrint('🚫 Permission denied, requesting permission');

        // 권한 요청 (시스템 다이얼로그만 표시)
        debugPrint('📲 Requesting permission...');
        final newStatus = await permission.request();
        debugPrint('📸 New permission status: $newStatus');

        if (!newStatus.isGranted && !newStatus.isLimited) {
          if (context.mounted) {
            debugPrint('🚫 Permission not granted after request');
            _showPermissionDeniedDialog(
                context, permissionName, newStatus.isPermanentlyDenied);
          }
          return null;
        }
      }
      // 권한이 영구적으로 거부된 경우
      else if (status.isPermanentlyDenied) {
        debugPrint('🔒 Permission permanently denied');
        if (context.mounted) {
          _showPermissionDeniedDialog(context, permissionName, true);
        }
        return null;
      }
      // 제한된 권한 (iOS 14+)
      else if (status.isRestricted) {
        debugPrint('🔐 Permission restricted by system');
        if (context.mounted) {
          _showPermissionDeniedDialog(context, permissionName, false);
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
  static void _showPermissionDeniedDialog(
      BuildContext context, String permissionName, bool isPermanentlyDenied) {
    final localizations = AppLocalizations.of(context)!;
    
    // 플랫폼별 안내 메시지 선택
    final bool isIOS = !kIsWeb && Platform.isIOS;
    final String permissionGuideText = isIOS 
        ? localizations.permissionGuideIOS 
        : localizations.permissionGuideAndroid;
    
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖을 클릭해도 닫히지 않음
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.photo_camera,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(localizations.permissionDenied),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.permissionDeniedMessage(permissionName),
              style: const TextStyle(fontSize: 16),
            ),
            if (isPermanentlyDenied) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        permissionGuideText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            icon: Icon(
              isIOS ? Icons.settings_applications : Icons.settings,
              size: 18,
            ),
            label: Text(localizations.goToSettings),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  /// 알림 권한 요청
  static Future<bool> requestNotificationPermission(
      BuildContext context) async {
    final permission = Permission.notification;
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.notificationPermissionRequired),
          content: Text(
            AppLocalizations.of(context)!.notificationPermissionDesc,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.allowPermission),
            ),
          ],
        ),
      );

      final newStatus = await permission.request();
      return newStatus.isGranted;
    }

    return false;
  }
}
