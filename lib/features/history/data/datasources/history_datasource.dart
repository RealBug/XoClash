import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';

abstract class HistoryDataSource {
  Future<void> saveGameHistory(GameHistory history);
  Future<List<GameHistory>> getGameHistory({int? limit});
  Future<void> clearHistory();
}

class HistoryDataSourceImpl implements HistoryDataSource {
  static const String _historyKey = AppConstants.storageKeyHistory;
  static const int _maxHistorySize = AppConstants.maxHistorySize;

  @override
  Future<void> saveGameHistory(GameHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    final historyList = historyJson != null
        ? List<dynamic>.from(jsonDecode(historyJson))
        : <dynamic>[];

    historyList.insert(0, history.toJson());

    if (historyList.length > _maxHistorySize) {
      historyList.removeRange(_maxHistorySize, historyList.length);
    }

    await prefs.setString(_historyKey, jsonEncode(historyList));
  }

  @override
  Future<List<GameHistory>> getGameHistory({int? limit}) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    if (historyJson == null) {
      return <GameHistory>[];
    }

    final historyList = List<dynamic>.from(jsonDecode(historyJson));
    final histories = historyList
        .map<GameHistory>((json) => GameHistory.fromJson(json as Map<String, dynamic>))
        .whereType<GameHistory>()
        .toList();

    if (limit != null && limit > 0) {
      return histories.take(limit).toList();
    }

    return histories;
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
