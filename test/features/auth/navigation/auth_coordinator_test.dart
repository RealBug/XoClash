import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/auth/navigation/auth_coordinator.dart';

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockNavigationService mockNavigation;
  late AuthCoordinator coordinator;

  setUp(() {
    mockNavigation = MockNavigationService();
    coordinator = AuthCoordinator(mockNavigation);
  });

  group('canHandle', () {
    test('returns true for RequestLogin', () {
      expect(coordinator.canHandle(RequestLogin()), isTrue);
    });

    test('returns true for RequestSignup', () {
      expect(coordinator.canHandle(RequestSignup()), isTrue);
    });

    test('returns true for LoginCompleted', () {
      expect(coordinator.canHandle(LoginCompleted()), isTrue);
    });

    test('returns true for SignupCompleted', () {
      expect(coordinator.canHandle(SignupCompleted()), isTrue);
    });

    test('returns true for GuestLoginCompleted', () {
      expect(coordinator.canHandle(GuestLoginCompleted()), isTrue);
    });

    test('returns true for LogoutCompleted', () {
      expect(coordinator.canHandle(LogoutCompleted()), isTrue);
    });

    test('returns false for unhandled events', () {
      expect(coordinator.canHandle(RequestNewGame()), isFalse);
      expect(coordinator.canHandle(RequestHome()), isFalse);
    });
  });

  group('handle', () {
    test('navigates to login on RequestLogin', () {
      coordinator.handle(RequestLogin());
      verify(() => mockNavigation.toLogin()).called(1);
    });

    test('navigates to signup on RequestSignup', () {
      coordinator.handle(RequestSignup());
      verify(() => mockNavigation.toSignup()).called(1);
    });

    test('navigates to home after login', () {
      coordinator.handle(LoginCompleted());
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
    });

    test('navigates to avatar selection after signup', () {
      coordinator.handle(SignupCompleted());
      verify(
        () => mockNavigation.popAllAndNavigateToAvatarSelection(),
      ).called(1);
    });

    test('navigates to home after guest login', () {
      coordinator.handle(GuestLoginCompleted());
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
    });

    test('navigates to auth after logout', () {
      coordinator.handle(LogoutCompleted());
      verify(() => mockNavigation.popAllAndNavigateToAuth()).called(1);
    });
  });
}
