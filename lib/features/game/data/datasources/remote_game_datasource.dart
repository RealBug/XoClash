import 'package:injectable/injectable.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/services/game_backend_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

abstract class RemoteGameDataSource {
  Future<GameState> joinGame(String gameId);
  Future<GameState> makeMove(String gameId, int row, int col, Player player);
  Future<GameState> getGameState(String gameId);
  Stream<GameState> watchGame(String gameId);
  Future<void> leaveGame(String gameId);
}

@Injectable(as: RemoteGameDataSource)
class RemoteGameDataSourceImpl implements RemoteGameDataSource {

  RemoteGameDataSourceImpl(
    this._backendService,
    this._logger,
  );
  final GameBackendService _backendService;
  final LoggerService _logger;

  @override
  Future<GameState> joinGame(String gameId) async {
    _logger.info('Joining game: $gameId');
    try {
      final GameState result = await _backendService.joinGame(gameId);
      _logger.debug('Successfully joined game: $gameId');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Failed to join game: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<GameState> makeMove(
    String gameId,
    int row,
    int col,
    Player player,
  ) async {
    _logger.debug(
        'Making move in game $gameId: player=$player, row=$row, col=$col');

    try {
      final GameState result = await _backendService.makeMove(gameId, row, col, player);
      _logger.debug('Move successful in game: $gameId');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Failed to make move in game: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<GameState> getGameState(String gameId) async {
    _logger.debug('Getting game state: $gameId');
    try {
      return await _backendService.getGameState(gameId);
    } catch (e, stackTrace) {
      _logger.error('Failed to get game state: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<GameState> watchGame(String gameId) {
    _logger.info('Watching game: $gameId');
    return _backendService.watchGame(gameId);
  }

  @override
  Future<void> leaveGame(String gameId) async {
    _logger.info('Leaving game: $gameId');
    await _backendService.leaveGame(gameId);
  }
}
