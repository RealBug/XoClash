import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/router_helper.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/presentation/widgets/board_size_option.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart' show isDarkModeProvider;

@RoutePage()
class BoardSizeScreen extends ConsumerStatefulWidget {
  const BoardSizeScreen({super.key, this.gameMode, this.difficulty, this.friendName, this.friendAvatar});
  final GameModeType? gameMode;
  final int? difficulty;
  final String? friendName;
  final String? friendAvatar;

  @override
  ConsumerState<BoardSizeScreen> createState() => _BoardSizeScreenState();
}

class _BoardSizeScreenState extends ConsumerState<BoardSizeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.gameMode == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          while (context.router.canPop()) {
            context.router.pop();
          }
          context.router.push(const HomeRoute());
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getWinConditionText(BuildContext context, int boardSize) {
    final int winCondition = boardSize.getWinCondition();
    if (winCondition == 3) {
      return context.l10n.winCondition;
    } else if (winCondition == 4) {
      return context.l10n.winCondition4;
    }
    return context.l10n.winCondition;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameMode == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isDarkMode = ref.watch(isDarkModeProvider);

    SystemUIHelper.setStatusBarStyle(context, isDarkMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            if (context.router.canPop()) {
              context.router.pop();
            } else {
              RouterHelper.navigateToHome(context);
            }
          },
        ),
        title: Text(context.l10n.newGame),
        elevation: 0,
        backgroundColor: AppTheme.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      body: CosmicBackground(
        isDarkMode: isDarkMode,
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(4),
            thickness: 6,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: UIConstants.widgetSizeMaxWidth),
                        child: Padding(
                          padding: AppSpacing.paddingAll(AppSpacing.lg),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Gap(AppSpacing.lg),
                              Text(
                                context.l10n.chooseBoardSize,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Gap(AppSpacing.xxs * 1.5),
                              Text(
                                _getWinConditionText(context, 3),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                ),
                              ),
                              Gap(AppSpacing.lg),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  BoardSizeOption(
                                    size: 3,
                                    label: context.l10n.classic,
                                    gameMode: widget.gameMode!,
                                    difficulty: widget.difficulty,
                                    friendName: widget.friendName,
                                    friendAvatar: widget.friendAvatar,
                                  ),
                                  Gap(AppSpacing.md),
                                  BoardSizeOption(
                                    size: 4,
                                    label: context.l10n.medium,
                                    gameMode: widget.gameMode!,
                                    difficulty: widget.difficulty,
                                    friendName: widget.friendName,
                                    friendAvatar: widget.friendAvatar,
                                  ),
                                  Gap(AppSpacing.md),
                                  BoardSizeOption(
                                    size: 5,
                                    label: context.l10n.large,
                                    gameMode: widget.gameMode!,
                                    difficulty: widget.difficulty,
                                    friendName: widget.friendName,
                                    friendAvatar: widget.friendAvatar,
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
