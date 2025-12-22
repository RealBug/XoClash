import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/presentation/widgets/score_card.dart';
import 'package:tictac/features/score/presentation/widgets/statistics_helpers.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class ScoresTabWidget extends StatelessWidget {

  const ScoresTabWidget({
    super.key,
    required this.scores,
    required this.settings,
    required this.scrollController,
  });
  final List<PlayerScore> scores;
  final Settings settings;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: settings.isDarkMode
                  ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                  : AppTheme.lightTextSecondary.withValues(alpha: 0.6),
            ),
            Gap(AppSpacing.md),
            Text(
              context.l10n.noScores,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: settings.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    // Trier par nombre de victoires, puis par taux de victoire
    final List<PlayerScore> sortedScores = List<PlayerScore>.from(scores)
      ..sort((PlayerScore a, PlayerScore b) {
        if (b.wins != a.wins) {
          return b.wins.compareTo(a.wins);
        }
        return b.winRate.compareTo(a.winRate);
      });

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
                        ...sortedScores.asMap().entries.map((entry) {
                          final index = entry.key;
                          final score = entry.value;
                          return ScoreCard(
                            score: score,
                            rank: index + 1,
                            settings: settings,
                            displayPlayerName: StatisticsHelpers.getDisplayPlayerName(context, score.playerName),
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


