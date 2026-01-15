import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/home/navigation/home_coordinator.dart';

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockNavigationService mockNavigation;
  late HomeCoordinator coordinator;

  setUp(() {
    mockNavigation = MockNavigationService();
    coordinator = HomeCoordinator(mockNavigation);
  });

  group('canHandle', () {
    test('returns true for RequestNewGame', () {
      expect(coordinator.canHandle(RequestNewGame()), isTrue);
    });

    test('returns true for RequestStatistics', () {
      expect(coordinator.canHandle(RequestStatistics()), isTrue);
    });

    test('returns true for RequestSettings', () {
      expect(coordinator.canHandle(RequestSettings()), isTrue);
    });

    test('returns true for RequestPlaybook', () {
      expect(coordinator.canHandle(RequestPlaybook()), isTrue);
    });

    test('returns false for auth events', () {
      expect(coordinator.canHandle(RequestLogin()), isFalse);
      expect(coordinator.canHandle(LoginCompleted()), isFalse);
    });
  });

  group('handle', () {
    test('navigates to game mode on RequestNewGame', () {
      coordinator.handle(RequestNewGame());
      verify(() => mockNavigation.toGameMode()).called(1);
    });

    test('navigates to game on JoinGameCompleted', () {
      coordinator.handle(JoinGameCompleted());
      verify(() => mockNavigation.toGame()).called(1);
    });

    test('navigates to statistics on RequestStatistics', () {
      coordinator.handle(RequestStatistics());
      verify(() => mockNavigation.toStatistics()).called(1);
    });

    test('navigates to settings on RequestSettings', () {
      coordinator.handle(RequestSettings());
      verify(() => mockNavigation.toSettings()).called(1);
    });

    test('navigates to settings with hideProfile on RequestSettings', () {
      coordinator.handle(RequestSettings(hideProfile: true));
      verify(() => mockNavigation.toSettings(hideProfile: true)).called(1);
    });

    test('navigates to playbook on RequestPlaybook', () {
      coordinator.handle(RequestPlaybook());
      verify(() => mockNavigation.toPlaybook()).called(1);
    });

    test('handles unhandled events gracefully', () {
      coordinator.handle(RequestLogin());
      verifyNever(() => mockNavigation.toGameMode());
      verifyNever(() => mockNavigation.toStatistics());
    });
  });
}
