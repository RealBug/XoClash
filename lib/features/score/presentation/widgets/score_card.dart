import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/presentation/widgets/stat_chip.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class ScoreCard extends StatelessWidget {

  const ScoreCard({
    super.key,
    required this.score,
    required this.rank,
    required this.settings,
    required this.displayPlayerName,
  });
  final PlayerScore score;
  final int rank;
  final Settings settings;
  final String displayPlayerName;

  @override
  Widget build(BuildContext context) {
    final textColor = settings.isDarkMode
        ? AppTheme.darkTextPrimary
        : AppTheme.lightTextPrimary;
    final secondaryTextColor = settings.isDarkMode
        ? AppTheme.darkTextSecondary
        : AppTheme.lightTextSecondary;
    final primaryColor = AppTheme.getPrimaryColor(settings.isDarkMode);

    String rankEmoji;
    if (rank == 1) {
      rankEmoji = '🥇';
    } else if (rank == 2) {
      rankEmoji = '🥈';
    } else if (rank == 3) {
      rankEmoji = '🥉';
    } else {
      rankEmoji = '';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: settings.isDarkMode ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.getBorderColor(settings.isDarkMode),
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            if (rankEmoji.isNotEmpty)
              Text(
                rankEmoji,
                style: Theme.of(context).textTheme.displayLarge,
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: settings.isDarkMode
                      ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                      : AppTheme.lightTextSecondary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                  ),
                ),
              ),
            Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    displayPlayerName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(AppSpacing.xxs * 1.5),
                  Text(
                    '${context.l10n.totalGames}: ${score.totalGames}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StatChip(
                      icon: Icons.emoji_events,
                      value: '${score.wins}',
                      color: AppTheme.tealAccent,
                      settings: settings,
                    ),
                    Gap(AppSpacing.xs),
                    StatChip(
                      icon: Icons.close,
                      value: '${score.losses}',
                      color: AppTheme.redAccent,
                      settings: settings,
                    ),
                    Gap(AppSpacing.xs),
                    StatChip(
                      icon: Icons.remove,
                      value: '${score.draws}',
                      color: AppTheme.yellowAccent,
                      settings: settings,
                    ),
                  ],
                ),
                Gap(AppSpacing.xs),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(
                        alpha: settings.isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(score.winRate * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


