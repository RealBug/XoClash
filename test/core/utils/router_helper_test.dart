import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/app_route.dart';
import 'package:tictac/core/services/router_service.dart';
import 'package:tictac/core/utils/router_helper.dart';

class MockRouterService extends Mock implements RouterService {}

class FakeAppRoute extends Fake implements AppRoute {
  @override
  String get routeName => 'HomeRoute';
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAppRoute());
  });

  group('RouterHelper', () {
    late MockRouterService mockRouterService;

    setUp(() {
      mockRouterService = MockRouterService();
      RouterHelper.testRouterService = mockRouterService;
    });

    tearDown(() {
      RouterHelper.testRouterService = null;
    });

    testWidgets('navigateToHome should delegate to RouterService', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

      final Element context = tester.element(find.byType(MaterialApp));

      RouterHelper.navigateToHome(context);

      verify(() => mockRouterService.navigateToHome()).called(1);
    });

    testWidgets('popUntilHome should delegate to RouterService', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

      final Element context = tester.element(find.byType(MaterialApp));

      RouterHelper.popUntilHome(context);

      verify(() => mockRouterService.popUntilHome()).called(1);
    });

    testWidgets('popAllAndPush should delegate to RouterService with AppRoute', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

      final Element context = tester.element(find.byType(MaterialApp));
      const HomeRoute route = HomeRoute();

      RouterHelper.popAllAndPush(context, route);

      verify(() => mockRouterService.popAllAndPush(any(that: isA<AppRoute>()))).called(1);
    });
  });
}
