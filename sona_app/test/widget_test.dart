// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/main.dart';
import 'package:sona_app/services/theme/theme_service.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Create a mock theme service
    final themeService = ThemeService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(SonaApp(themeService: themeService));

    // Verify that the app launches (splash screen should be shown)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
