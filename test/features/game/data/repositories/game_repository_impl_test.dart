import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/data/datasources/remote_game_datasource.dart';
import 'package:tictac/features/game/data/repositories/game_repository_impl.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

class MockLocalDataSource extends Mock implements LocalGameDataSource {}

class MockRemoteDataSource extends Mock implements RemoteGameDataSource {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late GameRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLoggerService mockLogger;

  setUpAll(() {
    registerFallbackValue(
      GameState(
        board: 3.createEmptyBoard(),
      ),
    );
    registerFallbackValue(Player.x);
  });

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLogger = MockLoggerService();
    repository = GameRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      logger: mockLogger,
    );
  });

  group('createGame', () {
    test('should create a new game and save it locally', () async {
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.createGame();

      expect(result.gameId, isNotNull);
      expect(result.playerId, isNotNull);
      expect(result.board.length, equals(3));
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
    });
  });

  group('joinGame', () {
    test('should join game via remote and save locally', () async {
      const String gameId = 'test-game-id';
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
        status: GameStatus.playing,
      );

      when(() => mockRemoteDataSource.joinGame(gameId)).thenAnswer((_) async => gameState);
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.joinGame(gameId);

      expect(result, equals(gameState));
      verify(() => mockRemoteDataSource.joinGame(gameId)).called(1);
      verify(() => mockLocalDataSource.saveGame(gameState)).called(1);
    });

    test('should fallback to local game if remote fails', () async {
      const String gameId = 'test-game-id';
      final GameState localGameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockRemoteDataSource.joinGame(gameId)).thenThrow(Exception('Connection failed'));
      when(() => mockLocalDataSource.getGame(gameId)).thenAnswer((_) async => localGameState);

      final GameState result = await repository.joinGame(gameId);

      expect(result.isOnline, isFalse);
      verify(() => mockRemoteDataSource.joinGame(gameId)).called(1);
      verify(() => mockLocalDataSource.getGame(gameId)).called(1);
    });
  });

  group('makeMove', () {
    test('should make move locally when not online', () async {
      final List<List<Player>> board = 3.createEmptyBoard();
      final GameState gameState = GameState(
        board: board,
        status: GameStatus.playing,
      );

      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 0, 0);

      expect(result.board[0][0], equals(Player.x));
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
      verifyNever(() => mockRemoteDataSource.makeMove(any(), any(), any(), any()));
    });

    test('should make move via remote when online', () async {
      final List<List<Player>> board = 3.createEmptyBoard();
      final GameState gameState = GameState(
        board: board,
        status: GameStatus.playing,
        gameId: 'test-game-id',
        isOnline: true,
      );

      final GameState remoteState = gameState.copyWith(
        board: <List<Player>>[
          <Player>[Player.x, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
      );

      when(() => mockRemoteDataSource.makeMove(
            any(),
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => remoteState);
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 0, 0);

      expect(result.board[0][0], equals(Player.x));
      verify(() => mockRemoteDataSource.makeMove(
            'test-game-id',
            0,
            0,
            Player.x,
          )).called(1);
      verify(() => mockLocalDataSource.saveGame(remoteState)).called(1);
    });

    test('should fallback to local when remote fails', () async {
      final List<List<Player>> board = 3.createEmptyBoard();
      final GameState gameState = GameState(
        board: board,
        status: GameStatus.playing,
        gameId: 'test-game-id',
        isOnline: true,
      );

      when(() => mockRemoteDataSource.makeMove(
            any(),
            any(),
            any(),
            any(),
          )).thenThrow(Exception('Connection failed'));
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState result = await repository.makeMove(gameState, 0, 0);

      expect(result.board[0][0], equals(Player.x));
      verify(() => mockLocalDataSource.saveGame(any())).called(1);
    });
  });

  group('getGameState', () {
    test('should return local game if exists', () async {
      const String gameId = 'test-game-id';
      final GameState localGameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockLocalDataSource.hasGame(gameId)).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getGame(gameId)).thenAnswer((_) async => localGameState);

      final GameState result = await repository.getGameState(gameId);

      expect(result, equals(localGameState));
      verify(() => mockLocalDataSource.hasGame(gameId)).called(1);
      verify(() => mockLocalDataSource.getGame(gameId)).called(1);
      verifyNever(() => mockRemoteDataSource.getGameState(any()));
    });

    test('should return remote game if local does not exist', () async {
      const String gameId = 'test-game-id';
      final GameState remoteGameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockLocalDataSource.hasGame(gameId)).thenAnswer((_) async => false);
      when(() => mockRemoteDataSource.getGameState(gameId)).thenAnswer((_) async => remoteGameState);

      final GameState result = await repository.getGameState(gameId);

      expect(result, equals(remoteGameState));
      verify(() => mockLocalDataSource.hasGame(gameId)).called(1);
      verify(() => mockRemoteDataSource.getGameState(gameId)).called(1);
    });
  });

  group('watchGame', () {
    test('should return stream from remote data source', () {
      const String gameId = 'test-game-id';
      final Stream<GameState> stream = Stream<GameState>.value(
        GameState(
          board: 3.createEmptyBoard(),
          gameId: gameId,
        ),
      );

      when(() => mockRemoteDataSource.watchGame(gameId)).thenAnswer((_) => stream);

      final Stream<GameState> result = repository.watchGame(gameId);

      expect(result, equals(stream));
      verify(() => mockRemoteDataSource.watchGame(gameId)).called(1);
    });
  });

  group('leaveGame', () {
    test('should delete local game and leave remote game', () async {
      const String gameId = 'test-game-id';

      when(() => mockLocalDataSource.deleteGame(gameId)).thenAnswer((_) async => Future<void>.value());
      when(() => mockRemoteDataSource.leaveGame(gameId)).thenAnswer((_) async => Future<void>.value());

      await repository.leaveGame(gameId);

      verify(() => mockLocalDataSource.deleteGame(gameId)).called(1);
      verify(() => mockRemoteDataSource.leaveGame(gameId)).called(1);
    });
  });

  group('_generateGameId', () {
    test('should generate unique game IDs', () async {
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState game1 = await repository.createGame();
      final GameState game2 = await repository.createGame();

      expect(game1.gameId, isNotNull);
      expect(game2.gameId, isNotNull);
      expect(game1.gameId, isNot(equals(game2.gameId)));
      expect(game1.gameId!.length, greaterThan(0));
      expect(game2.gameId!.length, greaterThan(0));
    });
  });

  group('_generatePlayerId', () {
    test('should generate unique player IDs', () async {
      when(() => mockLocalDataSource.saveGame(any())).thenAnswer((_) async => Future<void>.value());

      final GameState game1 = await repository.createGame();
      await Future<void>.delayed(const Duration(milliseconds: 1));
      final GameState game2 = await repository.createGame();

      expect(game1.playerId, isNotNull);
      expect(game2.playerId, isNotNull);
      expect(game1.playerId, isNot(equals(game2.playerId)));
      expect(game1.playerId!.startsWith('player_'), isTrue);
      expect(game2.playerId!.startsWith('player_'), isTrue);
    });
  });

  group('getGameState', () {
    test('should handle case when local hasGame returns true but getGame returns null', () async {
      const String gameId = 'test-game-id';
      final GameState remoteGameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: gameId,
      );

      when(() => mockLocalDataSource.hasGame(gameId)).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getGame(gameId)).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getGameState(gameId)).thenAnswer((_) async => remoteGameState);

      final GameState result = await repository.getGameState(gameId);

      expect(result, equals(remoteGameState));
      verify(() => mockLocalDataSource.hasGame(gameId)).called(1);
      verify(() => mockLocalDataSource.getGame(gameId)).called(1);
      verify(() => mockRemoteDataSource.getGameState(gameId)).called(1);
    });
  });
}
