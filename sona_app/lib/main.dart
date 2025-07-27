import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/persona_selection_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_service_screen.dart';
import 'screens/admin_quality_dashboard_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/purchase_screen.dart';
import 'screens/purchase_policy_screen.dart';

import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/persona_service.dart';
import 'services/chat_service.dart';
import 'services/subscription_service.dart';
import 'services/purchase_service.dart';
import 'services/mock_purchase_service.dart';
import 'theme/app_theme.dart';

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

  runApp(const SonaApp());
}

class SonaApp extends StatelessWidget {
  const SonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => PersonaService()),
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
        // 개발 환경에서는 Mock 서비스 사용
        ChangeNotifierProvider<PurchaseService>(
          create: (_) => const bool.fromEnvironment('dart.vm.product') 
              ? PurchaseService() 
              : MockPurchaseService(),
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
      child: MaterialApp(
        title: 'SONA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/persona-selection': (context) => const MainNavigationScreen(),
          '/chat': (context) => const ChatScreen(),
          '/chat-list': (context) => const MainNavigationScreen(),
          '/profile': (context) => const MainNavigationScreen(),
          '/privacy-policy': (context) => const PrivacyPolicyScreen(),
          '/terms-of-service': (context) => const TermsOfServiceScreen(),
          '/admin/quality-dashboard': (context) => const AdminQualityDashboardScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/purchase': (context) => const PurchaseScreen(),
          '/purchase-policy': (context) => const PurchasePolicyScreen(),
        },
      ),
    );
  }
}