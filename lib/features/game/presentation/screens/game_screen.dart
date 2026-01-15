import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/effects/confetti_widget.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/ui/scrollable_section.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/entities/game_board_settings.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/game/presentation/widgets/game_board.dart';
import 'package:tictac/features/game/presentation/widgets/game_id_card.dart';
import 'package:tictac/features/game/presentation/widgets/game_info.dart';
import 'package:tictac/features/game/presentation/widgets/game_result_helper.dart';
import 'package:tictac/features/game/presentation/widgets/game_result_snackbar.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart'
    show
        isDarkModeProvider,
        animationsEnabledProvider,
        xShapeProvider,
        oShapeProvider,
        xEmojiProvider,
        oEmojiProvider,
        useEmojisProvider;
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

@RoutePage()
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key, this.friendAvatar});
  final String? friendAvatar;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _shouldShowConfetti = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkGameResult(GameState gameState) {
    if (!mounted || !gameState.isGameOver) {
      return;
    }

    final User? user = ref.read(userProvider).value;

    Future<void>.delayed(GameConstants.gameResultDelay, () {
      if (!mounted) {
        return;
      }

      final resultData = GameResultHelper.buildGameResultData(context, ref, gameState, user?.username);
      GameResultSnackBar.show(context, resultData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final animationsEnabled = ref.watch(animationsEnabledProvider);
    final user = ref.watch(
      userProvider.select((asyncValue) => asyncValue.value),
    );

    final gameResultInfoUseCase = ref.read(getGameResultInfoUseCaseProvider);

    ref.listen<GameState>(gameStateProvider, (previous, next) {
      if (previous != null && next.isGameOver && !previous.isGameOver) {
        _checkGameResult(next);
      } else if (previous != null && !next.isGameOver && previous.isGameOver) {
        _shouldShowConfetti = false;
      }
    });

    final resultInfo = gameResultInfoUseCase.execute(gameState, user?.username);
    final shouldShowConfetti = resultInfo.shouldShowConfetti;
    final confettiColor1 = gameState.status == GameStatus.xWon ? AppTheme.getPrimaryColor(isDarkMode) : const Color(0xFFFF6B35);
    final confettiColor2 = gameState.status == GameStatus.xWon
        ? AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.8)
        : const Color(0xFFFF8C42);

    final gameBoardSettings = GameBoardSettings(
      xShape: ref.watch(xShapeProvider),
      oShape: ref.watch(oShapeProvider),
      xEmoji: ref.watch(xEmojiProvider),
      oEmoji: ref.watch(oEmojiProvider),
      useEmojis: ref.watch(useEmojisProvider),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, size: 26, color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextSecondary),
            onPressed: () {
              context.router.push(SettingsRoute());
            },
          ),
          Gap(AppSpacing.xs),
          TextButton.icon(
            onPressed: () {
              ref.read(gameStateProvider.notifier).resetGame();
            },
            icon: Icon(Icons.refresh, color: AppTheme.getPrimaryColor(isDarkMode)),
            label: Text(
              context.l10n.reset,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.getPrimaryColor(isDarkMode)),
            ),
          ),
          Gap(AppSpacing.xs),
        ],
      ),
      body: Stack(
        children: <Widget>[
          CosmicBackground(
            isDarkMode: isDarkMode,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ScrollableSection(
                      controller: _scrollController,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: UIConstants.widgetSizeMaxWidth),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Gap(AppSpacing.lg),
                                      GameInfo(
                                        gameState: gameState,
                                        friendAvatar: widget.friendAvatar,
                                        animationsEnabled: animationsEnabled,
                                      ),
                                      Gap(AppSpacing.xxxl),
                                      GameBoard(
                                        gameState: gameState,
                                        isDarkMode: isDarkMode,
                                        animationsEnabled: animationsEnabled,
                                        xShape: gameBoardSettings.xShape,
                                        oShape: gameBoardSettings.oShape,
                                        xEmoji: gameBoardSettings.xEmoji,
                                        oEmoji: gameBoardSettings.oEmoji,
                                        useEmojis: gameBoardSettings.useEmojis,
                                        onCellTap: (int row, int col) async {
                                          await ref.read(gameStateProvider.notifier).makeMove(row, col);
                                        },
                                        onWinningLineAnimationComplete: () {
                                          if (mounted && shouldShowConfetti && animationsEnabled) {
                                            setState(() {
                                              _shouldShowConfetti = true;
                                            });
                                          }
                                        },
                                      ),
                                      Gap(AppSpacing.xxxl),
                                      if (gameState.gameId != null && gameState.isOnline) GameIdCard(gameState: gameState),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (animationsEnabled && shouldShowConfetti)
            ConfettiWidget(isActive: _shouldShowConfetti, color1: confettiColor1, color2: confettiColor2),
        ],
      ),
    );
  }
}
