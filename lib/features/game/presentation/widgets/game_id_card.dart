import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class GameIdCard extends ConsumerWidget {

  const GameIdCard({
    super.key,
    required this.gameState,
  });
  final GameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final cardColor =
        isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor;
    final textColor =
        isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Card(
      color: cardColor,
      elevation: isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.getBorderColor(isDarkMode),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.share,
                  color: AppTheme.getPrimaryColor(isDarkMode),
                  size: 20,
                ),
                Gap(AppSpacing.xs),
                Text(
                  context.l10n.gameCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                      ),
                ),
              ],
            ),
            Gap(AppSpacing.sm),
            SelectableText(
              gameState.gameId!,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getPrimaryColor(isDarkMode),
                    letterSpacing: 4,
                  ),
            ),
            Gap(AppSpacing.sm),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: gameState.gameId!));
                SuccessSnackbar.show(
                  context,
                  context.l10n.copied,
                  isDarkMode: isDarkMode,
                  duration: const Duration(seconds: 2),
                );
              },
              icon: Icon(
                Icons.copy,
                color: AppTheme.getPrimaryColor(isDarkMode),
              ),
              label: Text(
                context.l10n.copy,
                style: TextStyle(
                  color: AppTheme.getPrimaryColor(isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

