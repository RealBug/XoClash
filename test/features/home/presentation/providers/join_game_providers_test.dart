import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/join_game_usecase.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';

class MockJoinGameUseCase extends Mock implements JoinGameUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class FakeGameStateNotifier extends GameStateNotifier {
  FakeGameStateNotifier(this._initialState);

  final GameState _initialState;

  @override
  GameState build() => _initialState;
}

void main() {
  group('JoinGameUINotifier', () {
    late ProviderContainer container;
    late MockJoinGameUseCase mockJoinGameUseCase;
    late MockLoggerService mockLoggerService;

    setUp(() {
      mockJoinGameUseCase = MockJoinGameUseCase();
      mockLoggerService = MockLoggerService();
      container = ProviderContainer(
        overrides: [
          joinGameUseCaseProvider.overrideWithValue(mockJoinGameUseCase),
          loggerServiceProvider.overrideWithValue(mockLoggerService),
          gameStateProvider.overrideWith(() => FakeGameStateNotifier(GameState(board: 3.createEmptyBoard(), status: GameStatus.playing))),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is not loading and has no error', () {
      final JoinGameUIState state = container.read(joinGameUIStateProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('sets loading to true when joining game', () async {
      final GameState gameState = GameState(board: 3.createEmptyBoard(), gameId: 'TEST12', status: GameStatus.playing);
      when(() => mockJoinGameUseCase.execute('TEST12')).thenAnswer((_) async => gameState);

      final JoinGameUINotifier notifier = container.read(joinGameUIStateProvider.notifier);
      final Future<void> future = notifier.joinGame('TEST12');

      final JoinGameUIState loadingState = container.read(joinGameUIStateProvider);
      expect(loadingState.isLoading, true);
      expect(loadingState.error, isNull);

      await future;

      final JoinGameUIState finalState = container.read(joinGameUIStateProvider);
      expect(finalState.isLoading, false);
      expect(finalState.error, isNull);
    });

    test('sets error when join game fails', () async {
      when(() => mockJoinGameUseCase.execute('INVALID')).thenThrow(Exception('Game not found'));

      final JoinGameUINotifier notifier = container.read(joinGameUIStateProvider.notifier);
      await notifier.joinGame('INVALID');

      final JoinGameUIState state = container.read(joinGameUIStateProvider);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);
      expect(state.error, contains('Exception'));
    });

    test('clears error when clearError is called', () async {
      when(() => mockJoinGameUseCase.execute('ERROR')).thenThrow(Exception('Test error'));

      final JoinGameUINotifier notifier = container.read(joinGameUIStateProvider.notifier);
      await notifier.joinGame('ERROR');

      final JoinGameUIState stateWithError = container.read(joinGameUIStateProvider);
      expect(stateWithError.error, isNotNull);
      expect(stateWithError.error, contains('Exception'));

      notifier.clearError();

      // Riverpod updates state synchronously, no need to wait
      final JoinGameUIState state = container.read(joinGameUIStateProvider);
      expect(state.error, isNull);
    });
  });
}
