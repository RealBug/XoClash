import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/navigation/game_coordinator.dart';

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockNavigationService mockNavigation;
  late GameCoordinator coordinator;

  setUp(() {
    mockNavigation = MockNavigationService();
    coordinator = GameCoordinator(mockNavigation);
  });

  group('canHandle', () {
    test('returns true for GameModeSelected', () {
      expect(
        coordinator.canHandle(GameModeSelected(mode: GameModeType.offlineComputer)),
        isTrue,
      );
    });

    test('returns true for GameStarted', () {
      expect(coordinator.canHandle(GameStarted()), isTrue);
    });

    test('returns false for home events', () {
      expect(coordinator.canHandle(RequestNewGame()), isFalse);
    });
  });

  group('handle', () {
    test('navigates to board size on GameModeSelected', () {
      coordinator.handle(
        GameModeSelected(
          mode: GameModeType.offlineComputer,
          difficulty: 2,
          friendName: 'Bob',
          friendAvatar: 'avatar1',
        ),
      );

      verify(
        () => mockNavigation.toBoardSize(
          gameMode: GameModeType.offlineComputer,
          difficulty: 2,
          friendName: 'Bob',
          friendAvatar: 'avatar1',
        ),
      ).called(1);
    });

    test('replaces with game on GameStarted', () {
      coordinator.handle(GameStarted(friendAvatar: 'avatar2'));
      verify(() => mockNavigation.replaceWithGame(friendAvatar: 'avatar2'))
          .called(1);
    });
  });
}
