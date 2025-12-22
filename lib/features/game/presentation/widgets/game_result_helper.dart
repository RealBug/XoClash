import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ai/ai_character.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/get_player_name_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_win_message_usecase.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

part 'game_result_helper.freezed.dart';

@freezed
abstract class GameResultData with _$GameResultData {
  const factory GameResultData({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required bool showTrophy,
  }) = _GameResultData;
}

class GameResultHelper {
  GameResultHelper._();

  static GameResultData buildGameResultData(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    String? currentUsername,
  ) {
    switch (gameState.status) {
      case GameStatus.xWon:
        return _buildXWonResult(context, ref, gameState, currentUsername);
      case GameStatus.oWon:
        return _buildOWonResult(context, ref, gameState, currentUsername);
      case GameStatus.draw:
        return _buildDrawResult(context);
      default:
        return _buildDefaultResult(context, ref);
    }
  }

  static GameResultData _buildXWonResult(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    String? currentUsername,
  ) {
    final GetPlayerNameUseCase getPlayerNameUseCase = ref.read(getPlayerNameUseCaseProvider);
    return _buildWonResult(
      context: context,
      ref: ref,
      gameState: gameState,
      currentUsername: currentUsername,
      getPlayerName: () =>
          getPlayerNameUseCase.getPlayerXName(gameState, currentUsername),
      playerLabel: context.l10n.playerX,
      backgroundColor: AppTheme.redAccent,
      textColor: AppTheme.darkTextPrimary,
    );
  }

  static GameResultData _buildOWonResult(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    String? currentUsername,
  ) {
    final GetPlayerNameUseCase getPlayerNameUseCase = ref.read(getPlayerNameUseCaseProvider);
    return _buildWonResult(
      context: context,
      ref: ref,
      gameState: gameState,
      currentUsername: currentUsername,
      getPlayerName: () => getPlayerNameUseCase.getPlayerOName(
          gameState, gameState.computerDifficulty),
      playerLabel: context.l10n.playerO,
      backgroundColor: AppTheme.yellowAccent,
      textColor: AppTheme.darkBackgroundColor,
    );
  }

  static GameResultData _buildWonResult({
    required BuildContext context,
    required WidgetRef ref,
    required GameState gameState,
    required String? currentUsername,
    required String Function() getPlayerName,
    required String playerLabel,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final String playerNameRaw = getPlayerName();
    final String displayName = _getDisplayPlayerName(context, playerNameRaw, gameState);
    final bool isCurrentUser = currentUsername == playerNameRaw;
    final String message =
        _buildWinMessage(context, ref, displayName, playerLabel, gameState, isCurrentUser);

    return GameResultData(
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showTrophy: true,
    );
  }

  static String _getDisplayPlayerName(
    BuildContext context,
    String playerName,
    GameState gameState,
  ) {
    if (playerName.startsWith(AppConstants.aiPlayerNamePrefix) &&
        gameState.computerDifficulty != null) {
      return AICharacter.getCharacter(gameState.computerDifficulty!)
          .getDisplayName(context);
    }
    return playerName;
  }

  static GameResultData _buildDrawResult(BuildContext context) {
    return GameResultData(
      message: context.l10n.matchDraw,
      backgroundColor: AppTheme.lightTextSecondary.withValues(alpha: 0.5),
      textColor: AppTheme.lightTextPrimary,
      showTrophy: false,
    );
  }

  static GameResultData _buildDefaultResult(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.read(isDarkModeProvider);
    return GameResultData(
      message: context.l10n.gameOver,
      backgroundColor: AppTheme.getPrimaryColor(isDarkMode),
      textColor: AppTheme.darkTextPrimary,
      showTrophy: false,
    );
  }

  static String _buildWinMessage(
    BuildContext context,
    WidgetRef ref,
    String? playerName,
    String defaultName,
    GameState gameState,
    bool isCurrentUser,
  ) {
    final GetWinMessageUseCase getWinMessageUseCase = ref.read(getWinMessageUseCaseProvider);
    final WinMessageData messageData = getWinMessageUseCase.execute(
      playerName: playerName,
      defaultName: defaultName,
      gameState: gameState,
      isCurrentUser: isCurrentUser,
    );

    if (messageData.useYouWon) {
      return context.l10n.youWon;
    }
    return context.l10n.playerWon(messageData.displayName);
  }
}


