import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/image_preload_screen.dart';
import 'screens/refresh_download_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_service_screen.dart';
import 'screens/admin_quality_dashboard_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/privacy_settings_screen.dart';
import 'screens/purchase_screen.dart';
import 'screens/purchase_policy_screen.dart';

import 'services/auth/auth_service.dart';
import 'services/auth/user_service.dart';
import 'services/persona/persona_service.dart';
import 'services/chat/core/chat_service.dart';
import 'services/purchase/purchase_service.dart';
import 'services/storage/cache_manager.dart';
import 'services/theme/theme_service.dart';
import 'services/ui/haptic_service.dart';
import 'theme/app_theme.dart';
import 'core/preferences_manager.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_service.dart';
import 'services/app_info_service.dart';
import 'services/retention/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print('Warning: .env file not found. Using default configuration.');
    }
  }

  // Firebase 중복 초기화 방지
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Firebase Auth 디버그 모드 활성화
    if (kDebugMode) {
      debugPrint('🔐 [Main] Firebase Auth Debug Mode Enabled');
      
      // Auth 상태 변경 리스너로 디버깅
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        debugPrint('🔐 [Main] Auth State Changed:');
        debugPrint('  - User UID: ${user?.uid ?? "null"}');
        debugPrint('  - Is Anonymous: ${user?.isAnonymous ?? false}');
        debugPrint('  - Provider: ${user?.providerData.map((p) => p.providerId).join(', ') ?? "none"}');
      });
      
      // ID 토큰 변경 리스너
      FirebaseAuth.instance.idTokenChanges().listen((User? user) {
        debugPrint('🔑 [Main] ID Token Changed for user: ${user?.uid ?? "null"}');
      });
      
      // User changes listener for more detailed info
      FirebaseAuth.instance.userChanges().listen((User? user) {
        debugPrint('👤 [Main] User Changes Detected:');
        debugPrint('  - Display Name: ${user?.displayName ?? "null"}');
        debugPrint('  - Email: ${user?.email ?? "null"}');
        debugPrint('  - Email Verified: ${user?.emailVerified ?? false}');
      });
    }
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      if (kDebugMode) {
        print('Firebase already initialized');
      }
    } else {
      rethrow;
    }
  }

  // Crashlytics 설정 (웹에서는 제한적으로 지원)
  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Dart 예외 처리 (웹에서는 PlatformDispatcher가 제대로 지원되지 않음)
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    // 웹에서는 기본 Flutter 에러 핸들링만 사용
    FlutterError.onError = (errorDetails) {
      debugPrint('Flutter Error: ${errorDetails.exception}');
      if (kDebugMode) {
        FlutterError.presentError(errorDetails);
      }
    };
  }

  // 병렬 초기화로 성능 개선
  final initFutures = <Future>[
    CacheManager.instance.initialize(),
    PreferencesManager.initialize(),
    HapticService.initialize(),
    AppInfoService.instance.initialize(),
  ];
  
  // 푸시 알림 서비스 초기화 (웹이 아닌 경우만)
  if (!kIsWeb) {
    try {
      await PushNotificationService().initialize();
      debugPrint('🔔 Push notification service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize push notifications: $e');
    }
  }

  // ThemeService와 LocaleService는 의존성이 있으므로 별도 처리
  final themeService = ThemeService();
  final localeService = LocaleService();
  
  // 병렬 실행
  await Future.wait([
    ...initFutures,
    themeService.initialize(),
    localeService.initialize(),
  ]);

  debugPrint('🌐 [Main] All services initialized');
  debugPrint('🌐 [Main] Locale: ${localeService.locale}, UseSystem: ${localeService.useSystemLanguage}');
  AppInfoService.instance.printDebugInfo();

  runApp(SonaApp(
    themeService: themeService,
    localeService: localeService,
  ));
}

class SonaApp extends StatelessWidget {
  final ThemeService themeService;
  final LocaleService localeService;

  const SonaApp({
    super.key,
    required this.themeService,
    required this.localeService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: localeService),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => PersonaService()),
        // 실제 PurchaseService 사용
        ChangeNotifierProvider<PurchaseService>(
          create: (_) => PurchaseService(),
        ),
        ChangeNotifierProxyProvider3<PersonaService, UserService, LocaleService, ChatService>(
          create: (_) => ChatService(),
          update: (_, personaService, userService, localeService, chatService) {
            if (chatService != null) {
              chatService.setPersonaService(personaService);
              chatService.setUserService(userService);
              chatService.setLocaleService(localeService);
            }
            return chatService ?? ChatService();
          },
        ),
      ],
      child: Consumer2<ThemeService, LocaleService>(
        builder: (context, themeService, localeService, child) => MaterialApp(
          title: 'SONA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeService.themeMode,
          // 다국어 지원 설정
          locale: localeService.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            // 로케일 변경 감지
            final currentLocale = Localizations.localeOf(context);
            debugPrint('🌐 MaterialApp locale: $currentLocale');
            return child!;
          },
          initialRoute: '/',
          onGenerateRoute: (settings) {
            // /chat 라우트에 대해 플랫폼별 처리
            if (settings.name == '/chat') {
              // iOS는 CupertinoPageRoute로 네이티브 백 스와이프 지원
              if (Platform.isIOS) {
                return CupertinoPageRoute(
                  builder: (context) => const ChatScreen(),
                  settings: settings,
                );
              } else {
                // Android는 기존 커스텀 애니메이션 유지
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    // ChatScreen은 arguments를 ModalRoute를 통해 받음
                    return const ChatScreen();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              }
            }
            
            // 다른 라우트는 기본 설정 사용
            return null;
          },
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/image-preload': (context) => const ImagePreloadScreen(),
            '/main': (context) {
              final args = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
              return MainNavigationScreen(
                  initialIndex: args?['initialIndex'] ?? 0);
            },
            '/persona-selection': (context) => const MainNavigationScreen(),
            '/refresh-download': (context) => const RefreshDownloadScreen(),
            // '/chat' 라우트는 onGenerateRoute에서 처리
            '/chat-list': (context) =>
                const MainNavigationScreen(initialIndex: 1),
            '/profile': (context) => const MainNavigationScreen(),
            '/privacy-policy': (context) => const PrivacyPolicyScreen(),
            '/terms-of-service': (context) => const TermsOfServiceScreen(),
            '/admin/quality-dashboard': (context) =>
                const AdminQualityDashboardScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/theme-settings': (context) => const ThemeSettingsScreen(),
            '/privacy-settings': (context) => const PrivacySettingsScreen(),
            '/purchase': (context) => const PurchaseScreen(),
            '/purchase-policy': (context) => const PurchasePolicyScreen(),
          },
        ),
      ),
    );
  }
}
