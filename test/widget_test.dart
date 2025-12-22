import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/core/services/logger_service.dart';

void main() {
  setUpAll(() async {
    await getIt.reset();
    configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('App dependencies are configured', (WidgetTester tester) async {
    // Simple test to verify DI is properly set up
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(getIt.isRegistered<LoggerService>(), isTrue);
  });
}
