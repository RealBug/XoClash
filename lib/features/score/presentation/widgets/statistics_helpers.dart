import 'package:flutter/material.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ai/ai_character.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class StatisticsHelpers {
  StatisticsHelpers._();

  static String getResultText(BuildContext context, GameStatus result, String? winnerName, GameHistory? game) {
    String? displayWinnerName = winnerName;

    if (game != null &&
        game.gameMode == GameModeType.offlineComputer &&
        game.computerDifficulty != null &&
        winnerName == game.playerOName) {
      final AICharacter character = AICharacter.getCharacter(game.computerDifficulty!);
      displayWinnerName = character.getDisplayName(context);
    }

    switch (result) {
      case GameStatus.xWon:
        return displayWinnerName != null ? context.l10n.playerWon(displayWinnerName) : context.l10n.xWon;
      case GameStatus.oWon:
        return displayWinnerName != null ? context.l10n.playerWon(displayWinnerName) : context.l10n.oWon;
      case GameStatus.draw:
        return context.l10n.draw;
      default:
        return context.l10n.playing;
    }
  }

  static Color getResultColor(GameStatus result, Settings settings) {
    switch (result) {
      case GameStatus.xWon:
      case GameStatus.oWon:
        return AppTheme.tealAccent;
      case GameStatus.draw:
        return AppTheme.yellowAccent;
      default:
        return AppTheme.getPrimaryColor(settings.isDarkMode);
    }
  }

  static IconData getModeIcon(GameModeType mode) {
    switch (mode) {
      case GameModeType.online:
        return Icons.cloud;
      case GameModeType.offlineFriend:
        return Icons.people;
      case GameModeType.offlineComputer:
        return Icons.computer;
    }
  }

  static String getModeText(GameModeType mode, BuildContext context) {
    switch (mode) {
      case GameModeType.online:
        return context.l10n.online;
      case GameModeType.offlineFriend:
        return context.l10n.offlineFriend;
      case GameModeType.offlineComputer:
        return context.l10n.offlineComputer;
    }
  }

  static String getPlayerNamesText(BuildContext context, GameHistory game) {
    String playerXName;
    String playerOName;

    if (game.playerXName != null && game.playerXName!.isNotEmpty) {
      playerXName = game.playerXName!;
    } else {
      playerXName = context.l10n.playerX;
    }

    if (game.gameMode == GameModeType.offlineComputer && game.computerDifficulty != null) {
      final AICharacter character = AICharacter.getCharacter(game.computerDifficulty!);
      playerOName = character.getDisplayName(context);
    } else if (game.playerOName != null && game.playerOName!.isNotEmpty) {
      playerOName = game.playerOName!;
    } else {
      playerOName = context.l10n.playerO;
    }

    return '$playerXName ${context.l10n.vs} $playerOName';
  }

  static String getDisplayPlayerName(BuildContext context, String playerName) {
    if (playerName == 'AI_Easy') {
      final AICharacter character = AICharacter.getCharacter(1);
      return character.getDisplayName(context);
    } else if (playerName == 'AI_Medium') {
      final AICharacter character = AICharacter.getCharacter(2);
      return character.getDisplayName(context);
    } else if (playerName == 'AI_Hard') {
      final AICharacter character = AICharacter.getCharacter(3);
      return character.getDisplayName(context);
    }
    return playerName;
  }
}


