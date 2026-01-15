import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/domain/entities/enum_json_converters.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

abstract class LocalGameDataSource {
  Future<void> saveGame(GameState gameState);
  Future<GameState?> getGame(String gameId);
  Future<bool> hasGame(String gameId);
  Future<void> deleteGame(String gameId);
}

class LocalGameDataSourceImpl implements LocalGameDataSource {
  LocalGameDataSourceImpl(this._logger);
  final LoggerService _logger;
  static const String _gamesKey = AppConstants.storageKeyGames;

  @override
  Future<void> saveGame(GameState gameState) async {
    final gameId = gameState.gameId ?? _generateOfflineGameId(gameState);
    _logger.debug('Saving game locally: $gameId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final games = await _getAllGames(prefs);
      games[gameId] = gameState.toJson();
      await prefs.setString(_gamesKey, jsonEncode(games));
      _logger.debug('Game saved successfully: $gameId');
    } catch (e, stackTrace) {
      _logger.error('Failed to save game locally: $gameId', e, stackTrace);
      rethrow;
    }
  }

  String _generateOfflineGameId(GameState gameState) {
    return '${AppConstants.offlineGameIdPrefix}${gameState.gameMode?.toString() ?? EnumPatterns.gameModeLocal}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<GameState?> getGame(String gameId) async {
    _logger.debug('Getting game from local storage: $gameId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final games = await _getAllGames(prefs);
      final gameJson = games[gameId];
      if (gameJson == null) {
        _logger.debug('Game not found locally: $gameId');
        return null;
      }
      _logger.debug('Game found locally: $gameId');
      return GameState.fromJson(gameJson as Map<String, dynamic>);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to get game from local storage: $gameId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<bool> hasGame(String gameId) async {
    _logger.debug('Checking if game exists locally: $gameId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final games = await _getAllGames(prefs);
      return games.containsKey(gameId);
    } catch (e, stackTrace) {
      _logger.error('Failed to check if game exists: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteGame(String gameId) async {
    _logger.info('Deleting game from local storage: $gameId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final games = await _getAllGames(prefs);
      games.remove(gameId);
      await prefs.setString(_gamesKey, jsonEncode(games));
      _logger.debug('Game deleted successfully: $gameId');
    } catch (e, stackTrace) {
      _logger.error('Failed to delete game: $gameId', e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getAllGames(SharedPreferences prefs) async {
    final gamesJson = prefs.getString(_gamesKey);
    if (gamesJson == null) {
      return <String, dynamic>{};
    }
    return Map<String, dynamic>.from(jsonDecode(gamesJson));
  }
}
