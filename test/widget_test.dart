import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/logger_service.dart';

void main() {
  testWidgets('App dependencies are configured', (WidgetTester tester) async {
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Test'),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(container.read(loggerServiceProvider), isA<LoggerService>());
  });
}
