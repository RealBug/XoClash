import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/l10n/app_localizations.dart';

void main() {
  group('ErrorSnackbar', () {
    testWidgets('should display error message in snackbar', (WidgetTester tester) async {
      const AppException exception = AppException.network(
        translationKey: ErrorTranslationKeys.networkTimeout,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.show(context, exception);
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show retry button for retryable errors', (WidgetTester tester) async {
      const AppException exception = AppException.network(
        translationKey: ErrorTranslationKeys.networkTimeout,
      );
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.show(
                    context,
                    exception,
                    onRetry: () => retryCalled = true,
                  );
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Finder retryButton = find.byType(SnackBarAction);
      expect(retryButton, findsOneWidget);
      
      await tester.tap(retryButton);
      await tester.pumpAndSettle();

      expect(retryCalled, isTrue);
    });

    testWidgets('should not show retry button for non-retryable errors', (WidgetTester tester) async {
      const AppException exception = AppException.storage(
        translationKey: ErrorTranslationKeys.storagePermission,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.show(
                    context,
                    exception,
                    onRetry: () {},
                  );
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBarAction), findsNothing);
    });

    testWidgets('should not show retry button when onRetry is null', (WidgetTester tester) async {
      const AppException exception = AppException.network(
        translationKey: ErrorTranslationKeys.networkTimeout,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.show(context, exception);
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBarAction), findsNothing);
    });

    testWidgets('showFromError should convert regular error to UnknownException', (WidgetTester tester) async {
      final Exception error = Exception('Regular error');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.showFromError(context, error);
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showFromError should use AppException directly if provided', (WidgetTester tester) async {
      const AppException exception = AppException.network(
        translationKey: ErrorTranslationKeys.networkTimeout,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorSnackbar.showFromError(context, exception);
                });
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

