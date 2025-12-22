import 'package:json_annotation/json_annotation.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class EnumPatterns {
  EnumPatterns._();

  static const String playerX = 'x';
  static const String playerO = 'o';
  static const String statusXWon = 'xWon';
  static const String statusOWon = 'oWon';
  static const String statusDraw = 'draw';
  static const String statusPlaying = 'playing';
  static const String statusWaiting = 'waiting';
  static const String gameModeOnline = 'online';
  static const String gameModeOfflineFriend = 'offlineFriend';
  static const String gameModeOfflineComputer = 'offlineComputer';
  static const String gameModeLocal = 'local';
}

class EnumSerializedValues {
  EnumSerializedValues._();

  static const String gameStatusXWon = 'GameStatus.xWon';
  static const String gameStatusOWon = 'GameStatus.oWon';
  static const String gameStatusDraw = 'GameStatus.draw';
  static const String gameStatusWaiting = 'GameStatus.waiting';
  static const String gameStatusPlaying = 'GameStatus.playing';

  static const String gameModeTypeOnline = 'GameModeType.online';
  static const String gameModeTypeOfflineFriend = 'GameModeType.offlineFriend';
  static const String gameModeTypeOfflineComputer = 'GameModeType.offlineComputer';
}

class BoardJsonConverter implements JsonConverter<List<List<Player>>, List<dynamic>> {
  const BoardJsonConverter();

  @override
  List<List<Player>> fromJson(List<dynamic> json) {
    return json
        .map((dynamic row) => (row as List<dynamic>)
            .map((dynamic p) => const PlayerJsonConverter().fromJson(p as String))
            .toList())
        .toList()
        .cast<List<Player>>();
  }

  @override
  List<dynamic> toJson(List<List<Player>> object) {
    return object
        .map((List<Player> row) => row
            .map((Player p) => const PlayerJsonConverter().toJson(p))
            .toList())
        .toList();
  }
}

class PlayerJsonConverter implements JsonConverter<Player, String> {
  const PlayerJsonConverter();

  @override
  Player fromJson(String json) {
    if (json.contains('none')) {
      return Player.none;
    }
    if (json.contains(EnumPatterns.playerX)) {
      return Player.x;
    }
    if (json.contains(EnumPatterns.playerO)) {
      return Player.o;
    }
    return Player.none;
  }

  @override
  String toJson(Player object) => object.toString();
}

class GameStatusJsonConverter implements JsonConverter<GameStatus, String> {
  const GameStatusJsonConverter();

  @override
  GameStatus fromJson(String json) {
    if (json.contains(EnumPatterns.statusXWon)) {
      return GameStatus.xWon;
    }
    if (json.contains(EnumPatterns.statusOWon)) {
      return GameStatus.oWon;
    }
    if (json.contains(EnumPatterns.statusDraw)) {
      return GameStatus.draw;
    }
    if (json.contains(EnumPatterns.statusPlaying)) {
      return GameStatus.playing;
    }
    return GameStatus.waiting;
  }

  @override
  String toJson(GameStatus object) => object.toString();
}

class GameStatusExactJsonConverter implements JsonConverter<GameStatus, String> {
  const GameStatusExactJsonConverter();

  @override
  GameStatus fromJson(String json) {
    switch (json) {
      case EnumSerializedValues.gameStatusXWon:
        return GameStatus.xWon;
      case EnumSerializedValues.gameStatusOWon:
        return GameStatus.oWon;
      case EnumSerializedValues.gameStatusDraw:
        return GameStatus.draw;
      case EnumSerializedValues.gameStatusWaiting:
        return GameStatus.waiting;
      case EnumSerializedValues.gameStatusPlaying:
        return GameStatus.playing;
      default:
        return GameStatus.waiting;
    }
  }

  @override
  String toJson(GameStatus object) => object.toString();
}

class GameModeTypeJsonConverter implements JsonConverter<GameModeType?, String?> {
  const GameModeTypeJsonConverter();

  @override
  GameModeType? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    if (json.contains(EnumPatterns.gameModeOnline)) {
      return GameModeType.online;
    } else if (json.contains(EnumPatterns.gameModeOfflineFriend)) {
      return GameModeType.offlineFriend;
    } else if (json.contains(EnumPatterns.gameModeOfflineComputer)) {
      return GameModeType.offlineComputer;
    }
    return null;
  }

  @override
  String? toJson(GameModeType? object) => object?.toString();
}

class GameModeTypeExactJsonConverter implements JsonConverter<GameModeType?, String?> {
  const GameModeTypeExactJsonConverter();

  @override
  GameModeType? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    switch (json) {
      case EnumSerializedValues.gameModeTypeOnline:
        return GameModeType.online;
      case EnumSerializedValues.gameModeTypeOfflineFriend:
        return GameModeType.offlineFriend;
      case EnumSerializedValues.gameModeTypeOfflineComputer:
        return GameModeType.offlineComputer;
      default:
        return null;
    }
  }

  @override
  String? toJson(GameModeType? object) => object?.toString();
}

