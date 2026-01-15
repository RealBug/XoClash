import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/coordinators/navigation_coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockNavigationService mockNavigation;
  late NavigationCoordinator coordinator;

  setUp(() {
    mockNavigation = MockNavigationService();
    coordinator = NavigationCoordinator(mockNavigation);
  });

  group('canHandle', () {
    test('returns true for RequestBack', () {
      expect(coordinator.canHandle(RequestBack()), isTrue);
    });

    test('returns true for RequestHome', () {
      expect(coordinator.canHandle(RequestHome()), isTrue);
    });

    test('returns true for SplashCompleted', () {
      expect(coordinator.canHandle(SplashCompleted(hasUser: true)), isTrue);
      expect(coordinator.canHandle(SplashCompleted(hasUser: false)), isTrue);
    });

    test('returns false for unhandled events', () {
      expect(coordinator.canHandle(RequestNewGame()), isFalse);
      expect(coordinator.canHandle(RequestLogin()), isFalse);
    });
  });

  group('handle', () {
    test('pops when canPop is true on RequestBack', () {
      when(() => mockNavigation.canPop()).thenReturn(true);
      coordinator.handle(RequestBack());
      verify(() => mockNavigation.canPop()).called(1);
      verify(() => mockNavigation.pop()).called(1);
      verifyNever(() => mockNavigation.popAllAndNavigateToHome());
    });

    test('navigates to home when canPop is false on RequestBack', () {
      when(() => mockNavigation.canPop()).thenReturn(false);
      coordinator.handle(RequestBack());
      verify(() => mockNavigation.canPop()).called(1);
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
      verifyNever(() => mockNavigation.pop());
    });

    test('navigates to home on RequestHome', () {
      coordinator.handle(RequestHome());
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
    });

    test('navigates to home when hasUser is true on SplashCompleted', () {
      coordinator.handle(SplashCompleted(hasUser: true));
      verify(() => mockNavigation.toHome()).called(1);
      verifyNever(() => mockNavigation.toAuth());
    });

    test('navigates to auth when hasUser is false on SplashCompleted', () {
      coordinator.handle(SplashCompleted(hasUser: false));
      verify(() => mockNavigation.toAuth()).called(1);
      verifyNever(() => mockNavigation.toHome());
    });
  });
}
