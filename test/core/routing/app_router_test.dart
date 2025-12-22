import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/routing/app_router.dart';

void main() {
  group('AppRouter', () {
    late AppRouter appRouter;

    setUp(() {
      appRouter = AppRouter();
    });

    test('should extend RootStackRouter', () {
      expect(appRouter, isA<RootStackRouter>());
    });

    test('should have routes defined', () {
      expect(appRouter.routes, isNotEmpty);
      expect(appRouter.routes.length, greaterThan(0));
    });

    test('should have initial route configured', () {
      final AutoRoute initialRoute = appRouter.routes.firstWhere(
        (AutoRoute route) => route.initial == true,
      );
      expect(initialRoute, isNotNull);
      expect(initialRoute.path, equals('/'));
    });

    test('should have all expected routes', () {
      final Set<String> routePaths = appRouter.routes.map((AutoRoute r) => r.path).toSet();
      
      expect(routePaths, contains('/'));
      expect(routePaths, contains('/auth'));
      expect(routePaths, contains('/login'));
      expect(routePaths, contains('/signup'));
      expect(routePaths, contains('/home'));
      expect(routePaths, contains('/game-mode'));
      expect(routePaths, contains('/board-size'));
      expect(routePaths, contains('/game'));
      expect(routePaths, contains('/settings'));
      expect(routePaths, contains('/statistics'));
      expect(routePaths, contains('/onboarding'));
      expect(routePaths, contains('/avatar-selection'));
      expect(routePaths, contains('/playbook'));
    });

    testWidgets('config() should return a valid router configuration', (WidgetTester tester) async {
      final RouterConfig<UrlState> Function({Clip clipBehavior, DeepLinkBuilder? deepLinkBuilder, DeepLinkTransformer? deepLinkTransformer, bool includePrefixMatches, String? navRestorationScopeId, NavigatorObserversBuilder navigatorObservers, bool Function(String? location)? neglectWhen, WidgetBuilder? placeholder, bool rebuildStackOnDeepLink, Listenable? reevaluateListenable}) configFunction = appRouter.config;
      expect(configFunction, isNotNull);
      expect(configFunction, isA<Function>());
      
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: configFunction(),
        ),
      );
      
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    test('should have only one initial route', () {
      final Iterable<AutoRoute> initialRoutes = appRouter.routes.where((AutoRoute r) => r.initial == true);
      expect(initialRoutes.length, equals(1));
    });
  });
}

