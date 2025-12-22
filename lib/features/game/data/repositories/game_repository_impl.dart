import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/data/datasources/remote_game_datasource.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';

@Injectable(as: GameRepository)
class GameRepositoryImpl implements GameRepository {

  GameRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required LoggerService logger,
  }) : _logger = logger;
  final LocalGameDataSource localDataSource;
  final RemoteGameDataSource remoteDataSource;
  final LoggerService _logger;

  @override
  Future<GameState> createGame() async {
    _logger.info('Creating new game');
    final gameState = GameState(
      board: 3.createEmptyBoard(),
      status: GameStatus.playing,
      gameId: _generateGameId(),
      playerId: _generatePlayerId(),
    );

    _logger.debug('Game created with ID: ${gameState.gameId}');
    await localDataSource.saveGame(gameState);
    return gameState;
  }

  @override
  Future<GameState> joinGame(String gameId) async {
    _logger.info('Joining game: $gameId');
    try {
      final gameState = await remoteDataSource.joinGame(gameId);
      await localDataSource.saveGame(gameState);
      _logger.debug('Successfully joined game: $gameId');
      return gameState;
    } catch (e, stackTrace) {
      final localGame = await localDataSource.getGame(gameId);
      if (localGame != null) {
        _logger.info('Using local game fallback for: $gameId');
        return localGame.copyWith(isOnline: false);
      }
      _logger.error('No local game found for: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<GameState> makeMove(GameState gameState, int row, int col) async {
    _logger.debug('Making move: gameId=${gameState.gameId}, player=${gameState.currentPlayer}, row=$row, col=$col');
    final newBoard = gameState.board.deepCopy();
    newBoard[row][col] = gameState.currentPlayer;

    final updatedState = gameState.copyWith(board: newBoard);

    if (gameState.isOnline) {
      try {
        final remoteState = await remoteDataSource.makeMove(
          gameState.gameId!,
          row,
          col,
          gameState.currentPlayer,
        );
        await localDataSource.saveGame(remoteState);
        _logger.debug('Move saved remotely for game: ${gameState.gameId}');
        return remoteState;
      } catch (e, stackTrace) {
        _logger.error('Remote move error details', e, stackTrace);
        await localDataSource.saveGame(updatedState);
        return updatedState;
      }
    }

    await localDataSource.saveGame(updatedState);
    return updatedState;
  }

  @override
  Future<GameState> getGameState(String gameId) async {
    _logger.debug('Getting game state: $gameId');
    if (await localDataSource.hasGame(gameId)) {
      final localGame = await localDataSource.getGame(gameId);
      if (localGame != null) {
        _logger.debug('Game state found locally: $gameId');
        return localGame;
      }
    }
    _logger.debug('Fetching game state from remote: $gameId');
    return await remoteDataSource.getGameState(gameId);
  }

  @override
  Stream<GameState> watchGame(String gameId) {
    return remoteDataSource.watchGame(gameId);
  }

  @override
  Future<void> leaveGame(String gameId) async {
    _logger.info('Leaving game: $gameId');
    await localDataSource.deleteGame(gameId);
    await remoteDataSource.leaveGame(gameId);
  }

  String _generateGameId() {
    final random = Random();
    final code =
        List<String>.generate(AppConstants.gameIdLength, (_) => AppConstants.gameIdChars[random.nextInt(AppConstants.gameIdChars.length)]).join();
    return code;
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}';
  }
}
