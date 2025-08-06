import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
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
import 'screens/purchase_screen.dart';
import 'screens/purchase_policy_screen.dart';

import 'services/auth/auth_service.dart';
import 'services/auth/user_service.dart';
import 'services/persona/persona_service.dart';
import 'services/chat/chat_service.dart';
import 'services/purchase/purchase_service.dart';
import 'services/storage/cache_manager.dart';
import 'services/theme/theme_service.dart';
import 'theme/app_theme.dart';
import 'core/preferences_manager.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_service.dart';
import 'services/app_info_service.dart';

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

  // 캐시 매니저 초기화
  await CacheManager.instance.initialize();
  
  // PreferencesManager 초기화
  await PreferencesManager.initialize();
  
  // ThemeService 초기화
  final themeService = ThemeService();
  await themeService.initialize();
  
  // LocaleService 초기화
  debugPrint('🌐 [Main] Initializing LocaleService...');
  final localeService = LocaleService();
  await localeService.initialize();
  debugPrint('🌐 [Main] LocaleService initialized. Locale: ${localeService.locale}, UseSystem: ${localeService.useSystemLanguage}');
  
  // AppInfoService 초기화
  await AppInfoService.instance.initialize();
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
        ChangeNotifierProxyProvider2<PersonaService, UserService, ChatService>(
          create: (_) => ChatService(),
          update: (_, personaService, userService, chatService) {
            if (chatService != null) {
              chatService.setPersonaService(personaService);
              chatService.setUserService(userService);
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
          routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/image-preload': (context) => const ImagePreloadScreen(),
          '/main': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            return MainNavigationScreen(initialIndex: args?['initialIndex'] ?? 0);
          },
          '/persona-selection': (context) => const MainNavigationScreen(),
          '/refresh-download': (context) => const RefreshDownloadScreen(),
          '/chat': (context) => const ChatScreen(),
          '/chat-list': (context) => const MainNavigationScreen(initialIndex: 1),
          '/profile': (context) => const MainNavigationScreen(),
          '/privacy-policy': (context) => const PrivacyPolicyScreen(),
          '/terms-of-service': (context) => const TermsOfServiceScreen(),
          '/admin/quality-dashboard': (context) => const AdminQualityDashboardScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/theme-settings': (context) => const ThemeSettingsScreen(),
          '/purchase': (context) => const PurchaseScreen(),
          '/purchase-policy': (context) => const PurchasePolicyScreen(),
          },
        ),
      ),
    );
  }
}