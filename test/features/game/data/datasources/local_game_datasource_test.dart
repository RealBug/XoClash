import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late LocalGameDataSourceImpl dataSource;
  late MockLoggerService mockLogger;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockLogger = MockLoggerService();
    dataSource = LocalGameDataSourceImpl(mockLogger);
  });

  test('should save and retrieve a game', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
      playerId: 'test-player-id',
      status: GameStatus.playing,
    );

    await dataSource.saveGame(gameState);
    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved, isNotNull);
    expect(retrieved!.gameId, equals(gameState.gameId));
    expect(retrieved.playerId, equals(gameState.playerId));
    expect(retrieved.currentPlayer, equals(gameState.currentPlayer));
    expect(retrieved.status, equals(gameState.status));
  });

  test('should return null when game does not exist', () async {
    final GameState? retrieved = await dataSource.getGame('non-existent-id');

    expect(retrieved, isNull);
  });

  test('should save game with all optional fields', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
      playerId: 'test-player-id',
      status: GameStatus.xWon,
      gameMode: GameModeType.offlineComputer,
      computerDifficulty: 2,
      playerXName: 'Alice',
      playerOName: 'Bob',
    );

    await dataSource.saveGame(gameState);
    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved, isNotNull);
    expect(retrieved!.gameMode, equals(GameModeType.offlineComputer));
    expect(retrieved.computerDifficulty, equals(2));
    expect(retrieved.playerXName, equals('Alice'));
    expect(retrieved.playerOName, equals('Bob'));
    expect(retrieved.isOnline, isFalse);
  });

  test('should parse all GameModeType values', () async {
    final List<GameModeType> modes = <GameModeType>[
      GameModeType.online,
      GameModeType.offlineFriend,
      GameModeType.offlineComputer,
    ];

    for (final GameModeType mode in modes) {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-$mode',
        status: GameStatus.playing,
        gameMode: mode,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-$mode');

      expect(retrieved, isNotNull);
      expect(retrieved!.gameMode, equals(mode));
    }
  });

  test('should parse all GameStatus values', () async {
    final List<GameStatus> statuses = <GameStatus>[
      GameStatus.xWon,
      GameStatus.oWon,
      GameStatus.draw,
      GameStatus.playing,
      GameStatus.waiting,
    ];

    for (final GameStatus status in statuses) {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-$status',
        status: status,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-$status');

      expect(retrieved, isNotNull);
      expect(retrieved!.status, equals(status));
    }
  });

  test('should parse all Player values', () async {
    final List<Player> players = <Player>[Player.x, Player.o, Player.none];

    for (final Player player in players) {
      final List<List<Player>> board = <List<Player>>[
        <Player>[player, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final GameState gameState = GameState(
        board: board,
        gameId: 'test-$player',
        currentPlayer: player,
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-$player');

      expect(retrieved, isNotNull);
      expect(retrieved!.board[0][0], equals(player));
      expect(retrieved.currentPlayer, equals(player));
    }
  });

  test('should generate offline game ID when gameId is null', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      status: GameStatus.playing,
      gameMode: GameModeType.offlineFriend,
    );

    await dataSource.saveGame(gameState);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gamesJson = prefs.getString(AppConstants.storageKeyGames);
    expect(gamesJson, isNotNull);

    final Map<String, dynamic> games = Map<String, dynamic>.from(jsonDecode(gamesJson!));
    expect(games.keys.any((String key) => key.startsWith('offline_')), isTrue);
  });

  test('should handle gameState without gameMode', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-no-mode',
      status: GameStatus.playing,
    );

    await dataSource.saveGame(gameState);
    final GameState? retrieved = await dataSource.getGame('test-no-mode');

    expect(retrieved, isNotNull);
    expect(retrieved!.gameMode, isNull);
  });

  test('should return true when game exists', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
    );

    await dataSource.saveGame(gameState);
    final bool exists = await dataSource.hasGame('test-game-id');

    expect(exists, isTrue);
  });

  test('should return false when game does not exist', () async {
    final bool exists = await dataSource.hasGame('non-existent-id');

    expect(exists, isFalse);
  });

  test('should delete a game', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
    );

    await dataSource.saveGame(gameState);
    await dataSource.deleteGame('test-game-id');
    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved, isNull);
  });

  test('should save multiple games', () async {
    final GameState gameState1 = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'game-1',
    );
    final GameState gameState2 = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'game-2',
    );

    await dataSource.saveGame(gameState1);
    await dataSource.saveGame(gameState2);

    final GameState? retrieved1 = await dataSource.getGame('game-1');
    final GameState? retrieved2 = await dataSource.getGame('game-2');

    expect(retrieved1, isNotNull);
    expect(retrieved2, isNotNull);
    expect(retrieved1!.gameId, equals('game-1'));
    expect(retrieved2!.gameId, equals('game-2'));
  });

  test('should update existing game', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
    );

    await dataSource.saveGame(gameState);

    final GameState updatedState = gameState.copyWith(status: GameStatus.playing);
    await dataSource.saveGame(updatedState);

    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved!.status, equals(GameStatus.playing));
  });

  test('should generate offline game ID when gameId is null', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameMode: GameModeType.offlineComputer,
    );

    await dataSource.saveGame(gameState);
    final SharedPreferences allGames = await SharedPreferences.getInstance();
    final String? gamesJson = allGames.getString(AppConstants.storageKeyGames);
    expect(gamesJson, isNotNull);
    final bool hasOfflineId =
        gamesJson!.contains('offline_') || gamesJson.contains('offline');
    expect(hasOfflineId, isTrue);
  });

  test('should save and retrieve game with all fields', () async {
    const GameState gameState = GameState(
      board: <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.x, Player.o],
        <Player>[Player.o, Player.none, Player.x],
      ],
      gameId: 'test-game-id',
      playerId: 'test-player-id',
      currentPlayer: Player.o,
      status: GameStatus.playing,
      isOnline: true,
      gameMode: GameModeType.online,
      computerDifficulty: 2,
      playerXName: 'Player X',
      playerOName: 'Player O',
    );

    await dataSource.saveGame(gameState);
    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved, isNotNull);
    expect(retrieved!.board, equals(gameState.board));
    expect(retrieved.gameId, equals(gameState.gameId));
    expect(retrieved.playerId, equals(gameState.playerId));
    expect(retrieved.currentPlayer, equals(gameState.currentPlayer));
    expect(retrieved.status, equals(gameState.status));
    expect(retrieved.isOnline, equals(gameState.isOnline));
    expect(retrieved.gameMode, equals(gameState.gameMode));
    expect(retrieved.computerDifficulty, equals(gameState.computerDifficulty));
    expect(retrieved.playerXName, equals(gameState.playerXName));
    expect(retrieved.playerOName, equals(gameState.playerOName));
  });

  test('should handle game with null optional fields', () async {
    final GameState gameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
    );

    await dataSource.saveGame(gameState);
    final GameState? retrieved = await dataSource.getGame('test-game-id');

    expect(retrieved, isNotNull);
    expect(retrieved!.gameMode, isNull);
    expect(retrieved.computerDifficulty, isNull);
    expect(retrieved.playerXName, isNull);
    expect(retrieved.playerOName, isNull);
  });

  test('should handle different game modes in serialization', () async {
    final GameState offlineFriendGame = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-friend',
      gameMode: GameModeType.offlineFriend,
    );

    final GameState offlineComputerGame = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-computer',
      gameMode: GameModeType.offlineComputer,
    );

    final GameState onlineGame = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-online',
      gameMode: GameModeType.online,
    );

    await dataSource.saveGame(offlineFriendGame);
    await dataSource.saveGame(offlineComputerGame);
    await dataSource.saveGame(onlineGame);

    final GameState? retrievedFriend = await dataSource.getGame('test-friend');
    final GameState? retrievedComputer = await dataSource.getGame('test-computer');
    final GameState? retrievedOnline = await dataSource.getGame('test-online');

    expect(retrievedFriend!.gameMode, equals(GameModeType.offlineFriend));
    expect(retrievedComputer!.gameMode, equals(GameModeType.offlineComputer));
    expect(retrievedOnline!.gameMode, equals(GameModeType.online));
  });

  test('should handle all game statuses in serialization', () async {
    final List<GameStatus> statuses = <GameStatus>[
      GameStatus.waiting,
      GameStatus.playing,
      GameStatus.xWon,
      GameStatus.oWon,
      GameStatus.draw,
    ];

    for (final GameStatus status in statuses) {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-$status',
        status: status,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-$status');

      expect(retrieved!.status, equals(status));
    }
  });
}
