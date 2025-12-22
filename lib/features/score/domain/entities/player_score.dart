import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_score.freezed.dart';
part 'player_score.g.dart';

class PlayerScoreJsonKeys {
  PlayerScoreJsonKeys._();

  static const String playerName = 'playerName';
  static const String wins = 'wins';
  static const String losses = 'losses';
  static const String draws = 'draws';
  static const String totalGames = 'totalGames';
}

@Freezed(toJson: true)
abstract class PlayerScore with _$PlayerScore {
  const factory PlayerScore({
    @JsonKey(name: PlayerScoreJsonKeys.playerName)
    required String playerName,
    @Default(0)
    @JsonKey(name: PlayerScoreJsonKeys.wins)
    int wins,
    @Default(0)
    @JsonKey(name: PlayerScoreJsonKeys.losses)
    int losses,
    @Default(0)
    @JsonKey(name: PlayerScoreJsonKeys.draws)
    int draws,
    @Default(0)
    @JsonKey(name: PlayerScoreJsonKeys.totalGames)
    int totalGames,
  }) = _PlayerScore;

  const PlayerScore._();

  factory PlayerScore.fromJson(Map<String, dynamic> json) =>
      _$PlayerScoreFromJson(json);

  double get winRate {
    if (totalGames == 0) {
      return 0.0;
    }
    return wins / totalGames;
  }
}
