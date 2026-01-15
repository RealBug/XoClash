import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';

abstract class ScoreDataSource {
  Future<PlayerScore?> getPlayerScore(String playerName);
  Future<void> savePlayerScore(PlayerScore score);
  Future<List<PlayerScore>> getAllScores();
  Future<void> resetScores();
}

class ScoreDataSourceImpl implements ScoreDataSource {
  static const String _scoresKey = AppConstants.storageKeyScores;

  @override
  Future<PlayerScore?> getPlayerScore(String playerName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(_scoresKey);
    if (scoresJson == null) {
      return null;
    }

    final Map<String, dynamic> scores = Map<String, dynamic>.from(jsonDecode(scoresJson));
    final dynamic scoreData = scores[playerName];
    if (scoreData == null) {
      return null;
    }

    final Map<String, dynamic> json = scoreData as Map<String, dynamic>;
    json[PlayerScoreJsonKeys.playerName] = playerName;
    return PlayerScore.fromJson(json);
  }

  @override
  Future<void> savePlayerScore(PlayerScore score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(_scoresKey);
    final Map<String, dynamic> scores = scoresJson != null ? Map<String, dynamic>.from(jsonDecode(scoresJson)) : <String, dynamic>{};

    scores[score.playerName] = score.toJson();
    await prefs.setString(_scoresKey, jsonEncode(scores));
  }

  @override
  Future<List<PlayerScore>> getAllScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(_scoresKey);
    if (scoresJson == null) {
      return <PlayerScore>[];
    }

    final Map<String, dynamic> scores = Map<String, dynamic>.from(jsonDecode(scoresJson));
    return scores.entries.map((MapEntry<String, dynamic> entry) {
      final Map<String, dynamic> json = entry.value as Map<String, dynamic>;
      json[PlayerScoreJsonKeys.playerName] = entry.key;
      return PlayerScore.fromJson(json);
    }).toList();
  }

  @override
  Future<void> resetScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoresKey);
  }
}
