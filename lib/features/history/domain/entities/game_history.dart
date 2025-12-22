import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/features/game/domain/entities/enum_json_converters.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

class GameHistoryJsonKeys {
  GameHistoryJsonKeys._();

  static const String id = 'id';
  static const String date = 'date';
  static const String playerXName = 'playerXName';
  static const String playerOName = 'playerOName';
  static const String result = 'result';
  static const String gameMode = 'gameMode';
  static const String boardSize = 'boardSize';
  static const String computerDifficulty = 'computerDifficulty';
}

@Freezed(toJson: true)
abstract class GameHistory with _$GameHistory {
  const factory GameHistory({
    @JsonKey(name: GameHistoryJsonKeys.id)
    required String id,
    @JsonKey(name: GameHistoryJsonKeys.date)
    required DateTime date,
    @JsonKey(name: GameHistoryJsonKeys.playerXName)
    String? playerXName,
    @JsonKey(name: GameHistoryJsonKeys.playerOName)
    String? playerOName,
    @JsonKey(name: GameHistoryJsonKeys.result)
    @GameStatusExactJsonConverter()
    required GameStatus result,
    @JsonKey(name: GameHistoryJsonKeys.gameMode)
    @GameModeTypeExactJsonConverter()
    GameModeType? gameMode,
    @JsonKey(name: GameHistoryJsonKeys.boardSize)
    required int boardSize,
    @JsonKey(name: GameHistoryJsonKeys.computerDifficulty)
    int? computerDifficulty,
  }) = _GameHistory;

  const GameHistory._();

  factory GameHistory.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryFromJson(json);

  String? get winnerName {
    if (result == GameStatus.xWon) {
      return playerXName;
    }
    if (result == GameStatus.oWon) {
      return playerOName;
    }
    return null;
  }
}
