import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/auth/presentation/widgets/auth_button.dart';
import 'package:tictac/features/auth/presentation/widgets/auth_helper.dart';
import 'package:tictac/l10n/app_localizations.dart';

void main() {
  group('AuthButton', () {
    testWidgets('should return a GameButton widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              icon: Icons.email,
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when button is tapped', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              icon: Icons.email,
              label: 'Test Button',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });

  group('AuthHelper', () {

    group('handleSocialAuth', () {
      testWidgets('should execute authMethod successfully', (WidgetTester tester) async {
        bool authCompleted = false;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await AuthHelper.handleSocialAuth(
                          context: context,
                          authMethod: () async {
                            authCompleted = true;
                          },
                          onSuccess: () {},
                        );
                      },
                      child: const Text('Test'),
                    );
                  },
                ),
              ),
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const <Locale>[
                Locale('en'),
                Locale('fr'),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        expect(authCompleted, isTrue);
      });

      testWidgets('should show error snackbar on authentication failure', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await AuthHelper.handleSocialAuth(
                          context: context,
                          authMethod: () async {
                            throw Exception('Authentication failed');
                          },
                          onSuccess: () {},
                        );
                      },
                      child: const Text('Test'),
                    );
                  },
                ),
              ),
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const <Locale>[
                Locale('en'),
                Locale('fr'),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
  });
}
