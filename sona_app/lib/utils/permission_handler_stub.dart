// Stub file for web platform where permission_handler is not available

class Permission {
  static const Permission camera = Permission._('camera');
  static const Permission photos = Permission._('photos');
  static const Permission storage = Permission._('storage');
  static const Permission notification = Permission._('notification');

  final String value;
  const Permission._(this.value);

  Future<PermissionStatus> get status async => PermissionStatus.granted;
  Future<PermissionStatus> request() async => PermissionStatus.granted;
}

class PermissionStatus {
  static const PermissionStatus granted = PermissionStatus._('granted');
  static const PermissionStatus denied = PermissionStatus._('denied');
  static const PermissionStatus permanentlyDenied =
      PermissionStatus._('permanentlyDenied');
  static const PermissionStatus restricted = PermissionStatus._('restricted');
  static const PermissionStatus limited = PermissionStatus._('limited');

  final String value;
  const PermissionStatus._(this.value);

  bool get isGranted => this == granted;
  bool get isDenied => this == denied;
  bool get isPermanentlyDenied => this == permanentlyDenied;
  bool get isRestricted => this == restricted;
  bool get isLimited => this == limited;
}

Future<bool> openAppSettings() async {
  // On web, we can't open app settings
  return false;
}
