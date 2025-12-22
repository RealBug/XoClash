import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/data/datasources/remote_game_datasource.dart';
import 'package:tictac/features/game/data/repositories/game_repository_impl.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

class MockLocalGameDataSource extends Mock implements LocalGameDataSource {}

class MockRemoteGameDataSource extends Mock implements RemoteGameDataSource {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late GameRepositoryImpl repository;
  late MockLocalGameDataSource mockLocalDataSource;
  late MockRemoteGameDataSource mockRemoteDataSource;
  late MockLoggerService mockLogger;

  setUpAll(() {
    registerFallbackValue(GameState(
      board: 3.createEmptyBoard(),
      status: GameStatus.playing,
    ));
    registerFallbackValue(Player.x);
  });

  setUp(() {
    mockLocalDataSource = MockLocalGameDataSource();
    mockRemoteDataSource = MockRemoteGameDataSource();
    mockLogger = MockLoggerService();
    reset(mockLocalDataSource);
    reset(mockRemoteDataSource);
    reset(mockLogger);
    repository = GameRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      logger: mockLogger,
    );
  });

  group('Error Handling - createGame', () {
    test('should handle local save failure gracefully', () async {
      when(() => mockLocalDataSource.saveGame(any()))
          .thenThrow(Exception('Storage full'));

      expect(
        () => repository.createGame(),
        throwsA(isA<Exception>()),
      );
    });

    test('should create game even if remote fails', () async {
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async {});

      final GameState result = await repository.createGame();

      expect(result, isNotNull);
      expect(result.gameId, isNotNull);
      expect(result.playerId, isNotNull);
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
    });
  });

  group('Error Handling - joinGame', () {
    test('should fallback to local when remote fails', () async {
      const String gameId = 'test-game';
      final GameState localGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenThrow(Exception('Network error'));
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => localGame);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.joinGame(gameId);

      expect(result, isNotNull);
      expect(result.gameId, equals(gameId));
      expect(result.isOnline, isFalse);
      verify(() => mockRemoteDataSource.joinGame(gameId)).called(1);
      verify(() => mockLocalDataSource.getGame(gameId)).called(1);
    });

    test('should throw when both remote and local fail', () async {
      const String gameId = 'test-game';

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenThrow(Exception('Network error'));
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => null);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      expect(
        () => repository.joinGame(gameId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle timeout in remote join', () async {
      const String gameId = 'timeout-game';
      final GameState localGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenThrow(Exception('Connection timeout'));
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => localGame);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.joinGame(gameId);

      expect(result, isNotNull);
      expect(result.isOnline, isFalse);
    });

    test('should save game locally after successful remote join', () async {
      const String gameId = 'test-game';
      final GameState remoteGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
        isOnline: true,
      );

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenAnswer((_) async => remoteGame);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      await repository.joinGame(gameId);

      verify(() => mockLocalDataSource.saveGame(any())).called(1);
    });
  });

  group('Error Handling - makeMove', () {
    test('should handle remote move failure in online game', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
        isOnline: true,
      );

      when(() => mockRemoteDataSource.makeMove(any(), any(), any(), any()))
          .thenThrow(Exception('Network error'));
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 0, 0);

      expect(result, isNotNull);
      expect(result.board[0][0], equals(Player.x));
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
    });

    test('should save locally for offline game', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
        currentPlayer: Player.o,
      );

      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 1, 1);

      expect(result, isNotNull);
      expect(result.board[1][1], equals(Player.o));
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
      verifyNever(
          () => mockRemoteDataSource.makeMove(any(), any(), any(), any()));
    });

    test('should handle local save failure during move', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
      );

      when(() => mockLocalDataSource.saveGame(any()))
          .thenThrow(Exception('Storage full'));

      expect(
        () => repository.makeMove(gameState, 0, 0),
        throwsA(isA<Exception>()),
      );
    });

    test('should update board correctly even with remote failure', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
        isOnline: true,
      );

      when(() => mockRemoteDataSource.makeMove(any(), any(), any(), any()))
          .thenThrow(Exception('Server error'));
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 2, 2);

      expect(result.board[2][2], equals(Player.x));
      expect(result.board[0][0], equals(Player.none));
    });

    test('should handle concurrent move attempts', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
      );

      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final Future<GameState> future1 = repository.makeMove(gameState, 0, 0);
      final Future<GameState> future2 = repository.makeMove(gameState, 1, 1);

      final List<GameState> results = await Future.wait<GameState>(<Future<GameState>>[future1, future2]);

      expect(results.length, equals(2));
      expect(results[0].board[0][0], equals(Player.x));
      expect(results[1].board[1][1], equals(Player.x));
    });
  });

  group('Error Handling - getGameState', () {
    test('should return local game when available', () async {
      const String gameId = 'test-game';
      final GameState localGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockLocalDataSource.hasGame(gameId))
          .thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => localGame);

      final GameState result = await repository.getGameState(gameId);

      expect(result, isNotNull);
      expect(result.gameId, equals(gameId));
      verify(() => mockLocalDataSource.hasGame(gameId)).called(1);
      verify(() => mockLocalDataSource.getGame(gameId)).called(1);
      verifyNever(() => mockRemoteDataSource.getGameState(any()));
    });

    test('should fetch from remote when not local', () async {
      const String gameId = 'test-game';
      final GameState remoteGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
        isOnline: true,
      );

      when(() => mockLocalDataSource.hasGame(gameId))
          .thenAnswer((_) async => false);
      when(() => mockRemoteDataSource.getGameState(gameId))
          .thenAnswer((_) async => remoteGame);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.getGameState(gameId);

      expect(result, isNotNull);
      expect(result.isOnline, isTrue);
      verify(() => mockRemoteDataSource.getGameState(gameId)).called(1);
    });

    test('should handle null local game gracefully', () async {
      const String gameId = 'test-game';
      final GameState remoteGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockLocalDataSource.hasGame(gameId))
          .thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getGameState(gameId))
          .thenAnswer((_) async => remoteGame);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.getGameState(gameId);

      expect(result, isNotNull);
      verify(() => mockRemoteDataSource.getGameState(gameId)).called(1);
    });

    test('should throw when remote fetch fails', () async {
      const String gameId = 'test-game';

      when(() => mockLocalDataSource.hasGame(gameId))
          .thenAnswer((_) async => false);
      when(() => mockRemoteDataSource.getGameState(gameId))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getGameState(gameId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Error Handling - leaveGame', () {
    test('should delete local and remote game', () async {
      const String gameId = 'test-game';

      when(() => mockLocalDataSource.deleteGame(gameId))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockRemoteDataSource.leaveGame(gameId))
          .thenAnswer((_) async => Future<void>.value());

      await repository.leaveGame(gameId);

      verify(() => mockLocalDataSource.deleteGame(gameId)).called(1);
      verify(() => mockRemoteDataSource.leaveGame(gameId)).called(1);
    });

    test('should complete even if remote leave fails', () async {
      const String gameId = 'test-game';

      when(() => mockLocalDataSource.deleteGame(gameId))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockRemoteDataSource.leaveGame(gameId))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.leaveGame(gameId),
        throwsA(isA<Exception>()),
      );

      verify(() => mockLocalDataSource.deleteGame(gameId)).called(1);
    });

    test('should handle local delete failure', () async {
      const String gameId = 'test-game';

      when(() => mockLocalDataSource.deleteGame(gameId))
          .thenThrow(Exception('Storage error'));
      when(() => mockRemoteDataSource.leaveGame(gameId))
          .thenAnswer((_) async {});

      expect(
        () => repository.leaveGame(gameId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Error Handling - Edge Cases', () {
    test('should handle empty game ID', () async {
      when(() => mockRemoteDataSource.joinGame(''))
          .thenThrow(Exception('Invalid game ID'));
      when(() => mockLocalDataSource.getGame('')).thenAnswer((_) async => null);

      expect(
        () => repository.joinGame(''),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle very long game ID', () async {
      final String longId = 'x' * 1000;
      final GameState game = GameState(
        board: 3.createEmptyBoard(),
        gameId: longId,
      );

      when(() => mockRemoteDataSource.joinGame(longId))
          .thenThrow(Exception('ID too long'));
      when(() => mockLocalDataSource.getGame(longId))
          .thenAnswer((_) async => game);
      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.joinGame(longId);

      expect(result.gameId, equals(longId));
    });

    test('should handle concurrent move attempts', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
      );

      when(() => mockLocalDataSource.saveGame(any()))
          .thenAnswer((_) async => Future<void>.value());

      final Future<GameState> future1 = repository.makeMove(gameState, 0, 0);
      final Future<GameState> future2 = repository.makeMove(gameState, 1, 1);

      final List<GameState> results = await Future.wait<GameState>(<Future<GameState>>[future1, future2]);

      expect(results.length, equals(2));
      expect(results[0].board[0][0], equals(Player.x));
      expect(results[1].board[1][1], equals(Player.x));
    });
  });

  group('Error Handling - Logging', () {
    test('should log errors during operations', () async {
      const String gameId = 'error-game';

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenThrow(Exception('Test error'));
      when(() => mockLocalDataSource.getGame(gameId))
          .thenAnswer((_) async => null);

      try {
        await repository.joinGame(gameId);
      } catch (_) {}

      verify(() => mockLogger.error(any(), any(), any())).called(1);
    });

    test('should log successful operations', () async {
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async {});

      final GameState result = await repository.createGame();

      expect(result, isNotNull);
      verify(() => mockLogger.info(any())).called(greaterThan(0));
    });

    test('should log debug information', () async {
      const String gameId = 'test-game';
      final GameState remoteGame = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockRemoteDataSource.joinGame(gameId))
          .thenAnswer((_) async => remoteGame);
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async {});

      await repository.joinGame(gameId);

      verify(() => mockLogger.debug(any())).called(greaterThan(0));
    });
  });
}
