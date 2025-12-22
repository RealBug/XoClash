import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionScore {

  SessionScore({
    required this.playerName,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  });
  final String playerName;
  int wins;
  int losses;
  int draws;

  int get totalGames => wins + losses + draws;
}

class SessionScoresNotifier extends Notifier<Map<String, SessionScore>> {
  @override
  Map<String, SessionScore> build() => <String, SessionScore>{};

  void updateScore(String playerName, bool isWin, bool isDraw) {
    final SessionScore currentScore = state[playerName] ?? SessionScore(playerName: playerName);

    final SessionScore updatedScore = SessionScore(
      playerName: playerName,
      wins: isWin ? currentScore.wins + 1 : currentScore.wins,
      losses: !isWin && !isDraw ? currentScore.losses + 1 : currentScore.losses,
      draws: isDraw ? currentScore.draws + 1 : currentScore.draws,
    );

    state = <String, SessionScore>{...state, playerName: updatedScore};
  }

  SessionScore? getPlayerScore(String playerName) {
    return state[playerName];
  }

  void migrateScore(String oldName, String newName) {
    final SessionScore? oldScore = state[oldName];
    if (oldScore != null) {
      final SessionScore migratedScore = SessionScore(
        playerName: newName,
        wins: oldScore.wins,
        losses: oldScore.losses,
        draws: oldScore.draws,
      );
      final Map<String, SessionScore> newState = <String, SessionScore>{...state};
      newState.remove(oldName);
      newState[newName] = migratedScore;
      state = newState;
    }
  }

  void reset() {
    state = <String, SessionScore>{};
  }
}

final NotifierProvider<SessionScoresNotifier, Map<String, SessionScore>> sessionScoresProvider = NotifierProvider<SessionScoresNotifier, Map<String, SessionScore>>(
  SessionScoresNotifier.new,
);
