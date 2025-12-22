import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/branding/app_logo.dart';

void main() {
  group('AppLogo', () {
    testWidgets('renders AppLogo in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppLogo(isDarkMode: true),
          ),
        ),
      );

      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders AppLogo in light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppLogo(isDarkMode: false),
          ),
        ),
      );

      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders with custom fontSize', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppLogo(
              isDarkMode: true,
              fontSize: 60,
            ),
          ),
        ),
      );

      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders with custom blurRadius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppLogo(
              isDarkMode: true,
              blurRadius: 30,
            ),
          ),
        ),
      );

      expect(find.byType(AppLogo), findsOneWidget);
    });
  });
}


