import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ai/ai_character.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/game/presentation/widgets/player_indicator.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart'
    show isDarkModeProvider, xEmojiProvider, oEmojiProvider, xShapeProvider, oShapeProvider;
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class GameInfo extends ConsumerWidget {
  const GameInfo({super.key, required this.gameState, this.friendAvatar, this.animationsEnabled = true});
  final GameState gameState;
  final String? friendAvatar;
  final bool animationsEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final xEmoji = ref.watch(xEmojiProvider);
    final oEmoji = ref.watch(oEmojiProvider);
    final xShape = ref.watch(xShapeProvider);
    final oShape = ref.watch(oShapeProvider);
    final user = ref.watch(userProvider.select((asyncValue) => asyncValue.value));
    final sessionScores = ref.watch(sessionScoresProvider);
    final getPlayerNameUseCase = ref.read(getPlayerNameUseCaseProvider);
    final updatedAvatar = user?.avatar;
    final currentUsername = user?.username;

    final playerXNameRaw = getPlayerNameUseCase.getPlayerXName(gameState, currentUsername);
    final playerONameRaw = getPlayerNameUseCase.getPlayerOName(gameState, gameState.computerDifficulty);

    // Convert names for display (handle default cases and localization)
    final displayPlayerXName = playerXNameRaw.isNotEmpty ? playerXNameRaw : context.l10n.playerX;
    final displayPlayerOName = playerONameRaw.isNotEmpty
        ? (playerONameRaw.startsWith(AppConstants.aiPlayerNamePrefix) && gameState.computerDifficulty != null
              ? AICharacter.getCharacter(gameState.computerDifficulty!).getDisplayName(context)
              : playerONameRaw)
        : null;

    var playerOScoreKey = gameState.playerOName;
    if (playerOScoreKey == null && gameState.gameMode == GameModeType.offlineComputer && gameState.computerDifficulty != null) {
      playerOScoreKey = AICharacter.getComputerPlayerId(gameState.computerDifficulty!);
    }

    final playerXScore = sessionScores[displayPlayerXName];
    final playerOScore = playerOScoreKey != null ? sessionScores[playerOScoreKey] : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PlayerIndicator(
            key: ValueKey<String>('${currentUsername}_$updatedAvatar'),
            context: context,
            label: currentUsername ?? displayPlayerXName,
            isActive: gameState.currentPlayer == Player.x && !gameState.isGameOver,
            color: AppTheme.redAccent,
            animationsEnabled: animationsEnabled,
            emoji: _getPlayerXAvatar(context, gameState, updatedAvatar, currentUsername),
            symbol: AppConstants.defaultPlayerSymbolX,
            gameEmoji: (xEmoji != null && xEmoji.isNotEmpty) ? xEmoji : null,
            gameShape: (xEmoji == null || xEmoji.isEmpty) ? xShape : null,
            isWinner: gameState.status == GameStatus.xWon,
            isLoser: gameState.status == GameStatus.oWon,
            isDarkMode: isDarkMode,
            sessionScore: playerXScore,
          ),
          Gap(AppSpacing.sm),
          PlayerIndicator(
            key: ValueKey<String>(
              '${displayPlayerOName ?? context.l10n.playerO}_${_getPlayerOAvatar(context, gameState, updatedAvatar, currentUsername)}',
            ),
            context: context,
            label: displayPlayerOName ?? context.l10n.playerO,
            isActive: gameState.currentPlayer == Player.o && !gameState.isGameOver,
            color: AppTheme.yellowAccent,
            animationsEnabled: animationsEnabled,
            emoji: _getPlayerOAvatar(context, gameState, updatedAvatar, currentUsername),
            symbol: AppConstants.defaultPlayerSymbolO,
            gameEmoji: (oEmoji != null && oEmoji.isNotEmpty) ? oEmoji : null,
            gameShape: (oEmoji == null || oEmoji.isEmpty) ? oShape : null,
            isWinner: gameState.status == GameStatus.oWon,
            isLoser: gameState.status == GameStatus.xWon,
            isDarkMode: isDarkMode,
            isComputer: gameState.gameMode == GameModeType.offlineComputer && gameState.computerDifficulty != null,
            sessionScore: playerOScore,
          ),
        ],
      ),
    );
  }

  String? _getPlayerXAvatar(BuildContext context, GameState gameState, String? updatedAvatar, String? currentUsername) {
    if (_isOfflineGame(gameState)) {
      return updatedAvatar;
    }
    if (_isCurrentUserPlayerX(gameState, currentUsername) && updatedAvatar != null) {
      return updatedAvatar;
    }
    return null;
  }

  bool _isOfflineGame(GameState gameState) {
    return !gameState.isOnline && gameState.gameMode != null;
  }

  bool _isCurrentUserPlayerX(GameState gameState, String? currentUsername) {
    return gameState.playerXName == currentUsername;
  }

  String? _getPlayerOAvatar(BuildContext context, GameState gameState, String? updatedAvatar, String? currentUsername) {
    if (gameState.gameMode == GameModeType.offlineComputer && gameState.computerDifficulty != null) {
      final character = AICharacter.getCharacter(gameState.computerDifficulty!);
      return character.emoji;
    }
    final playerONameToCheck = gameState.playerOName;
    if (friendAvatar != null && playerONameToCheck != null && playerONameToCheck != currentUsername) {
      return friendAvatar;
    }
    if (updatedAvatar != null && playerONameToCheck == currentUsername) {
      return updatedAvatar;
    }
    if (friendAvatar != null && gameState.gameMode == GameModeType.offlineFriend && playerONameToCheck != null) {
      return friendAvatar;
    }
    return null;
  }
}

