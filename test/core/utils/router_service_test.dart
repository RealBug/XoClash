import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/app_route.dart';
import 'package:tictac/core/utils/router_service_impl.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakeAppRoute extends Fake implements AppRoute {
  @override
  String get routeName => 'SettingsRoute';
}

class FakePageRouteInfo extends Fake implements PageRouteInfo {
  @override
  String get routeName => 'FakeRoute';
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAppRoute());
    registerFallbackValue(FakePageRouteInfo());
  });

  group('RouterServiceImpl', () {
    late MockStackRouter mockRouter;
    late RouterServiceImpl routerService;

    setUp(() {
      mockRouter = MockStackRouter();
      routerService = RouterServiceImpl(mockRouter);
    });

    group('navigateToHome', () {
      test('should pop all routes and push HomeRoute when canPop returns true', () {
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 1);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.navigateToHome();

        verify(() => mockRouter.canPop()).called(greaterThan(1));
        verify(() => mockRouter.pop()).called(1);
        verify(() => mockRouter.push(const HomeRoute())).called(1);
      });

      test('should push HomeRoute directly when canPop returns false', () {
        when(() => mockRouter.canPop()).thenReturn(false);
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.navigateToHome();

        verify(() => mockRouter.canPop()).called(1);
        verifyNever(() => mockRouter.pop());
        verify(() => mockRouter.push(const HomeRoute())).called(1);
      });

      test('should pop multiple routes when stack has multiple routes', () {
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 2);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.navigateToHome();

        verify(() => mockRouter.canPop()).called(greaterThan(2));
        verify(() => mockRouter.pop()).called(2);
        verify(() => mockRouter.push(const HomeRoute())).called(1);
      });
    });

    group('popUntilHome', () {
      test('should pop all routes when canPop returns true', () {
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 1);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());

        routerService.popUntilHome();

        verify(() => mockRouter.canPop()).called(greaterThan(1));
        verify(() => mockRouter.pop()).called(1);
        verifyNever(() => mockRouter.push(any()));
      });

      test('should not pop when canPop returns false', () {
        when(() => mockRouter.canPop()).thenReturn(false);

        routerService.popUntilHome();

        verify(() => mockRouter.canPop()).called(1);
        verifyNever(() => mockRouter.pop());
        verifyNever(() => mockRouter.push(any()));
      });

      test('should pop multiple routes when stack has multiple routes', () {
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 3);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());

        routerService.popUntilHome();

        verify(() => mockRouter.canPop()).called(greaterThan(3));
        verify(() => mockRouter.pop()).called(3);
        verifyNever(() => mockRouter.push(any()));
      });
    });

    group('popAllAndPush', () {
      test('should pop all routes and push specified route when canPop returns true', () {
        const _TestAppRoute appRoute = _TestAppRoute('SettingsRoute');
        final SettingsRoute pageRoute = SettingsRoute();
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 1);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.popAllAndPush(appRoute);

        verify(() => mockRouter.canPop()).called(greaterThan(1));
        verify(() => mockRouter.pop()).called(1);
        verify(() => mockRouter.push(pageRoute)).called(1);
      });

      test('should push route directly when canPop returns false', () {
        const _TestAppRoute appRoute = _TestAppRoute('SettingsRoute');
        final SettingsRoute pageRoute = SettingsRoute();
        when(() => mockRouter.canPop()).thenReturn(false);
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.popAllAndPush(appRoute);

        verify(() => mockRouter.canPop()).called(1);
        verifyNever(() => mockRouter.pop());
        verify(() => mockRouter.push(pageRoute)).called(1);
      });

      test('should pop multiple routes and push specified route', () {
        const _TestAppRoute appRoute = _TestAppRoute('StatisticsRoute');
        const StatisticsRoute pageRoute = StatisticsRoute();
        int callCount = 0;
        when(() => mockRouter.canPop()).thenAnswer((_) => callCount++ < 2);
        when(() => mockRouter.pop()).thenAnswer((_) async => Future<void>.value());
        when(() => mockRouter.push(any())).thenAnswer((_) async => Future<void>.value());

        routerService.popAllAndPush(appRoute);

        verify(() => mockRouter.canPop()).called(greaterThan(2));
        verify(() => mockRouter.pop()).called(2);
        verify(() => mockRouter.push(pageRoute)).called(1);
      });
    });
  });
}

class _TestAppRoute implements AppRoute {

  const _TestAppRoute(this.routeName);
  @override
  final String routeName;
}

