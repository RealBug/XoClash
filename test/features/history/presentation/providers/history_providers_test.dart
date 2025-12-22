import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/get_game_history_usecase.dart';
import 'package:tictac/features/history/domain/usecases/save_game_history_usecase.dart';
import 'package:tictac/features/history/presentation/providers/history_providers.dart';

import '../../../../helpers/test_setup.dart';

class MockGetGameHistoryUseCase extends Mock implements GetGameHistoryUseCase {}

class MockSaveGameHistoryUseCase extends Mock implements SaveGameHistoryUseCase {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(
    GameHistory(
      id: 'test-id',
      date: DateTime.now(),
      playerXName: 'PlayerX',
      playerOName: 'PlayerO',
      result: GameStatus.draw,
      gameMode: GameModeType.offlineFriend,
      boardSize: 3,
    ),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
    setupTestGetIt();
  });

  tearDownAll(() {
    tearDownTestGetIt();
  });

  late MockGetGameHistoryUseCase mockGetGameHistoryUseCase;
  late MockSaveGameHistoryUseCase mockSaveGameHistoryUseCase;
  late MockHistoryRepository mockHistoryRepository;
  late ProviderContainer container;

  setUp(() {
    mockGetGameHistoryUseCase = MockGetGameHistoryUseCase();
    mockSaveGameHistoryUseCase = MockSaveGameHistoryUseCase();
    mockHistoryRepository = MockHistoryRepository();

    when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => <GameHistory>[]);

    container = ProviderContainer(
      overrides: [
        getGameHistoryUseCaseProvider.overrideWithValue(mockGetGameHistoryUseCase),
        saveGameHistoryUseCaseProvider.overrideWithValue(mockSaveGameHistoryUseCase),
        historyRepositoryProvider.overrideWithValue(mockHistoryRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GameHistoryNotifier', () {
    test('build() returns empty list initially and loads history', () async {
      final List<GameHistory> history = <GameHistory>[];

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      // With AsyncNotifier, we need to wait for the build() to complete
      await container.read(gameHistoryProvider.future);

      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, isEmpty);

      verify(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).called(greaterThanOrEqualTo(1));
    });

    test('_loadHistory() loads history without limit', () async {
      final List<GameHistory> history = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
      ];

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((Invocation invocation) async {
        final int? limit = invocation.namedArguments[#limit] as int?;
        expect(limit, isNull);
        return history;
      });

      // Wait for initial build
      await container.read(gameHistoryProvider.future);

      reset(mockGetGameHistoryUseCase);
      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.refreshHistory();

      verify(() => mockGetGameHistoryUseCase.execute()).called(greaterThanOrEqualTo(1));
      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, history);
    });

    test('_loadHistory() loads history with limit', () async {
      final List<GameHistory> history = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
      ];

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      await Future<void>.microtask(() {});
      reset(mockGetGameHistoryUseCase);
      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.refreshHistory(limit: 10);

      verify(() => mockGetGameHistoryUseCase.execute(limit: 10)).called(1);
      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, history);
    });

    test('addGameHistory() saves and reloads history', () async {
      final List<GameHistory> existingHistory = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
      ];

      final GameHistory newHistory = GameHistory(
        id: 'id2',
        date: DateTime.now(),
        playerXName: 'NewPlayerX',
        playerOName: 'NewPlayerO',
        result: GameStatus.oWon,
        gameMode: GameModeType.offlineFriend,
        boardSize: 3,
      );

      when(() => mockSaveGameHistoryUseCase.execute(any())).thenAnswer((_) async => Future<void>.value());

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => existingHistory);

      await Future<void>.microtask(() {});
      reset(mockGetGameHistoryUseCase);
      reset(mockSaveGameHistoryUseCase);
      when(() => mockSaveGameHistoryUseCase.execute(any())).thenAnswer((_) async => Future<void>.value());
      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => existingHistory);

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.addGameHistory(newHistory);

      verify(() => mockSaveGameHistoryUseCase.execute(newHistory)).called(1);
      verify(() => mockGetGameHistoryUseCase.execute()).called(greaterThanOrEqualTo(1));
    });

    test('refreshHistory() reloads history', () async {
      final List<GameHistory> history = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
      ];

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      await Future<void>.microtask(() {});
      reset(mockGetGameHistoryUseCase);
      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.refreshHistory();

      verify(() => mockGetGameHistoryUseCase.execute()).called(greaterThanOrEqualTo(1));
      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, history);
    });

    test('refreshHistory() with limit reloads history with limit', () async {
      final List<GameHistory> history = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
      ];

      when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit'))).thenAnswer((_) async => history);

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.refreshHistory(limit: 5);

      verify(() => mockGetGameHistoryUseCase.execute(limit: 5)).called(1);
      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, history);
    });

    test('clearHistory() clears repository and resets state', () async {
      when(() => mockHistoryRepository.clearHistory()).thenAnswer((_) async => Future<void>.value());

      final GameHistoryNotifier notifier = container.read(gameHistoryProvider.notifier);
      await notifier.clearHistory();

      verify(() => mockHistoryRepository.clearHistory()).called(1);
      final List<GameHistory>? state = container.read(gameHistoryProvider).value;
      expect(state, isEmpty);
    });
  });
}
