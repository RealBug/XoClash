import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/score/presentation/widgets/history_card.dart';
import 'package:tictac/features/score/presentation/widgets/statistics_helpers.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class HistoryTabWidget extends StatelessWidget {

  const HistoryTabWidget({
    super.key,
    required this.history,
    required this.settings,
    required this.scrollController,
  });
  final List<GameHistory> history;
  final Settings settings;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.history,
              size: 80,
              color: settings.isDarkMode
                  ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                  : AppTheme.lightTextSecondary.withValues(alpha: 0.6),
            ),
            Gap(AppSpacing.md),
            Text(
              context.l10n.noHistory,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: settings.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(4),
      thickness: 6,
      interactive: true,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: UIConstants.widgetSizeMaxWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Gap(AppSpacing.md),
                        ...history.map((GameHistory game) {
                          final resultText = StatisticsHelpers.getResultText(context, game.result, game.winnerName, game);
                          final resultColor = StatisticsHelpers.getResultColor(game.result, settings);
                          final playerNamesText = StatisticsHelpers.getPlayerNamesText(context, game);
                          final modeIcon = game.gameMode != null ? StatisticsHelpers.getModeIcon(game.gameMode!) : null;
                          final modeText = game.gameMode != null ? StatisticsHelpers.getModeText(game.gameMode!, context) : null;
                          return HistoryCard(
                            game: game,
                            settings: settings,
                            playerNamesText: playerNamesText,
                            resultText: resultText,
                            resultColor: resultColor,
                            modeIcon: modeIcon,
                            modeText: modeText,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


