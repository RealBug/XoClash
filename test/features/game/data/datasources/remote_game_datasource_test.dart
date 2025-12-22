import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/remote_game_datasource.dart';
import 'package:tictac/features/game/data/services/game_backend_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class MockGameBackendService extends Mock implements GameBackendService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockGameBackendService mockBackendService;
  late MockLoggerService mockLogger;
  late RemoteGameDataSourceImpl dataSource;

  const String testGameId = 'test-game-123';
  const GameState testGameState = GameState(
    board: <List<Player>>[
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.none, Player.x, Player.o],
      <Player>[Player.none, Player.none, Player.x],
    ],
    currentPlayer: Player.o,
    status: GameStatus.playing,
    gameId: testGameId,
    playerId: 'player-456',
    isOnline: true,
  );

  setUp(() {
    mockBackendService = MockGameBackendService();
    mockLogger = MockLoggerService();
    dataSource = RemoteGameDataSourceImpl(mockBackendService, mockLogger);
  });

  group('joinGame', () {
    test('should return GameState when backend succeeds', () async {
      when(() => mockBackendService.joinGame(testGameId))
          .thenAnswer((_) async => testGameState);

      final GameState result = await dataSource.joinGame(testGameId);

      expect(result, testGameState);
      expect(result.gameId, testGameId);
      expect(result.board.length, 3);
      verify(() => mockBackendService.joinGame(testGameId)).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.joinGame(testGameId))
          .thenThrow(Exception('Backend error'));

      expect(
        () => dataSource.joinGame(testGameId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.joinGame(testGameId)).called(1);
    });
  });

  group('makeMove', () {
    test('should return updated GameState when backend succeeds', () async {
      when(() => mockBackendService.makeMove(testGameId, 1, 0, Player.o))
          .thenAnswer((_) async => testGameState);

      final GameState result = await dataSource.makeMove(testGameId, 1, 0, Player.o);

      expect(result, testGameState);
      verify(() => mockBackendService.makeMove(testGameId, 1, 0, Player.o))
          .called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.makeMove(testGameId, 0, 0, Player.x))
          .thenThrow(Exception('Backend error'));

      expect(
        () => dataSource.makeMove(testGameId, 0, 0, Player.x),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.makeMove(testGameId, 0, 0, Player.x))
          .called(1);
    });
  });

  group('getGameState', () {
    test('should return GameState when backend succeeds', () async {
      when(() => mockBackendService.getGameState(testGameId))
          .thenAnswer((_) async => testGameState);

      final GameState result = await dataSource.getGameState(testGameId);

      expect(result, testGameState);
      expect(result.gameId, testGameId);
      verify(() => mockBackendService.getGameState(testGameId)).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.getGameState(testGameId))
          .thenThrow(Exception('Backend error'));

      expect(
        () => dataSource.getGameState(testGameId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.getGameState(testGameId)).called(1);
    });
  });

  group('watchGame', () {
    test('should return stream from backend service', () async {
      final StreamController<GameState> controller = StreamController<GameState>();
      when(() => mockBackendService.watchGame(testGameId))
          .thenAnswer((_) => controller.stream);

      final Stream<GameState> stream = dataSource.watchGame(testGameId);

      expect(stream, emits(testGameState));

      controller.add(testGameState);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verify(() => mockBackendService.watchGame(testGameId)).called(1);
      await controller.close();
    });

    test('should propagate errors from backend stream', () async {
      final StreamController<GameState> controller = StreamController<GameState>();
      when(() => mockBackendService.watchGame(testGameId))
          .thenAnswer((_) => controller.stream);

      final Stream<GameState> stream = dataSource.watchGame(testGameId);

      expect(stream, emitsError(isA<Exception>()));

      controller.addError(Exception('Backend stream error'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.close();
    });
  });

  group('leaveGame', () {
    test('should call backend service leaveGame', () async {
      when(() => mockBackendService.leaveGame(testGameId))
          .thenAnswer((_) async {});

      await dataSource.leaveGame(testGameId);

      verify(() => mockBackendService.leaveGame(testGameId)).called(1);
    });

    test('should propagate backend errors', () async {
      when(() => mockBackendService.leaveGame(testGameId))
          .thenThrow(Exception('Backend error'));

      expect(
        () => dataSource.leaveGame(testGameId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.leaveGame(testGameId)).called(1);
    });
  });
}
