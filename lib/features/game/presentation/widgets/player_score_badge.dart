import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';

class PlayerScoreBadge extends StatelessWidget {

  const PlayerScoreBadge({
    super.key,
    required this.sessionScore,
    required this.color,
    required this.isDarkMode,
  });
  final SessionScore? sessionScore;
  final Color color;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    if (sessionScore == null || sessionScore!.totalGames == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDarkMode ? color.withValues(alpha: 0.25) : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Center(
        child: Text(
          '${sessionScore!.wins}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.0,
                color: AppTheme.getPrimaryColor(isDarkMode),
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
