import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/features/game/domain/entities/enum_json_converters.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

class GameStateJsonKeys {
  GameStateJsonKeys._();

  static const String board = 'board';
  static const String currentPlayer = 'currentPlayer';
  static const String status = 'status';
  static const String gameId = 'gameId';
  static const String playerId = 'playerId';
  static const String isOnline = 'isOnline';
  static const String gameMode = 'gameMode';
  static const String computerDifficulty = 'computerDifficulty';
  static const String playerXName = 'playerXName';
  static const String playerOName = 'playerOName';
}

enum Player { x, o, none }

enum GameStatus { waiting, playing, xWon, oWon, draw }

enum GameModeType { online, offlineFriend, offlineComputer }

@Freezed(toJson: false)
abstract class WinningLine with _$WinningLine {
  const factory WinningLine({
    required int startRow,
    required int startCol,
    required int endRow,
    required int endCol,
  }) = _WinningLine;
}

@Freezed(toJson: true)
abstract class GameState with _$GameState {
  const factory GameState({
    @JsonKey(name: GameStateJsonKeys.board)
    @BoardJsonConverter()
    required List<List<Player>> board,
    @Default(Player.x)
    @JsonKey(name: GameStateJsonKeys.currentPlayer)
    @PlayerJsonConverter()
    Player currentPlayer,
    @Default(GameStatus.waiting)
    @JsonKey(name: GameStateJsonKeys.status)
    @GameStatusJsonConverter()
    GameStatus status,
    @JsonKey(name: GameStateJsonKeys.gameId)
    String? gameId,
    @JsonKey(name: GameStateJsonKeys.playerId)
    String? playerId,
    @Default(false)
    @JsonKey(name: GameStateJsonKeys.isOnline)
    bool isOnline,
    @JsonKey(name: GameStateJsonKeys.gameMode)
    @GameModeTypeJsonConverter()
    GameModeType? gameMode,
    @JsonKey(name: GameStateJsonKeys.computerDifficulty)
    int? computerDifficulty,
    @JsonKey(name: GameStateJsonKeys.playerXName)
    String? playerXName,
    @JsonKey(name: GameStateJsonKeys.playerOName)
    String? playerOName,
    @JsonKey(includeFromJson: false, includeToJson: false)
    WinningLine? winningLine,
  }) = _GameState;

  const GameState._();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  bool get isGameOver =>
      status == GameStatus.xWon ||
      status == GameStatus.oWon ||
      status == GameStatus.draw;
}
