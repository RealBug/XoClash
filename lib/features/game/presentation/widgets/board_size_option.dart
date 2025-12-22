import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/game/presentation/widgets/board_visual.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class BoardSizeOption extends ConsumerWidget {

  const BoardSizeOption({
    super.key,
    required this.size,
    required this.label,
    required this.gameMode,
    this.difficulty,
    this.friendName,
    this.friendAvatar,
  });
  final int size;
  final String label;
  final GameModeType gameMode;
  final int? difficulty;
  final String? friendName;
  final String? friendAvatar;

  String _getWinConditionShortText(BuildContext context, int boardSize) {
    final int winCondition = boardSize.getWinCondition();
    if (winCondition == 3) {
      return context.l10n.threeInARow;
    } else if (winCondition == 4) {
      return context.l10n.fourInARow;
    }
    return context.l10n.threeInARow;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    return GestureDetector(
      onTap: () async {
        final AudioService audioService = ref.read(audioServiceProvider);
        await audioService.playMoveSound();

        final GameStateNotifier notifier = ref.read(gameStateProvider.notifier);
        notifier.resetGameCompletely();

        ref.read(sessionScoresProvider.notifier).reset();

        final User? user = ref.read(userProvider).value;

        if (gameMode == GameModeType.online) {
          await notifier.createGame(boardSize: size);
        } else if (gameMode == GameModeType.offlineFriend) {
          await notifier.createOfflineGame(
            boardSize: size,
            mode: gameMode,
            difficulty: difficulty,
            playerXName: user?.username,
            playerOName: friendName,
          );
        } else {
          await notifier.createOfflineGame(
            boardSize: size,
            mode: gameMode,
            difficulty: difficulty,
            playerXName: user?.username,
          );
        }

        if (!context.mounted) {
          return;
        }
        context.router.replace(GameRoute(friendAvatar: friendAvatar));
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.getBorderColor(isDarkMode),
          ),
        ),
        child: Padding(
          padding: AppSpacing.paddingSymmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding:
                    AppSpacing.paddingAll(AppSpacing.sm + AppSpacing.xxs * 2),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.darkSurfaceColor.withValues(alpha: 0.3)
                      : AppTheme.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BoardVisual(size: size, isSelected: false),
              ),
              Gap(AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$size×$size - $label',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(AppSpacing.xxs * 1.5),
                    Text(
                      _getWinConditionShortText(context, size),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
