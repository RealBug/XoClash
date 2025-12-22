import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/score/presentation/widgets/info_chip.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class HistoryCard extends StatelessWidget {

  const HistoryCard({
    super.key,
    required this.game,
    required this.settings,
    required this.playerNamesText,
    required this.resultText,
    required this.resultColor,
    this.modeIcon,
    this.modeText,
  });
  final GameHistory game;
  final Settings settings;
  final String playerNamesText;
  final String resultText;
  final Color resultColor;
  final IconData? modeIcon;
  final String? modeText;

  @override
  Widget build(BuildContext context) {
    final textColor = settings.isDarkMode
        ? AppTheme.darkTextPrimary
        : AppTheme.lightTextPrimary;
    final secondaryTextColor = settings.isDarkMode
        ? AppTheme.darkTextSecondary
        : AppTheme.lightTextSecondary;

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        playerNamesText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(AppSpacing.xxs),
                      Text(
                        dateFormat.format(game.date),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: resultColor.withValues(
                        alpha: settings.isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    resultText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                  ),
                ),
              ],
            ),
            Gap(AppSpacing.sm),
            Row(
              children: <Widget>[
                InfoChip(
                  icon: Icons.grid_view,
                  text: '${game.boardSize}×${game.boardSize}',
                  color: secondaryTextColor,
                  settings: settings,
                ),
                Gap(AppSpacing.xs),
                if (modeIcon != null && modeText != null)
                  InfoChip(
                    icon: modeIcon!,
                    text: modeText!,
                    color: secondaryTextColor,
                    settings: settings,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


