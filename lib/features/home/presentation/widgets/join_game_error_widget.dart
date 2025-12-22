import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';

class JoinGameErrorWidget extends ConsumerWidget {

  const JoinGameErrorWidget({
    super.key,
    required this.error,
  });
  final String error;

  String _getErrorMessage(BuildContext context, String error) {
    if (error.contains('not found') || error.contains('timeout')) {
      return context.l10n.gameNotFound;
    }
    return context.l10n.failedToJoinGame;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: AppSpacing.paddingAll(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
        border: Border.all(
          color: AppTheme.errorColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: UIConstants.iconSizeMedium,
          ),
          Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              _getErrorMessage(context, error),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: AppTheme.errorColor,
            iconSize: UIConstants.iconSizeSmall,
            onPressed: () =>
                ref.read(joinGameUIStateProvider.notifier).clearError(),
          ),
        ],
      ),
    );
  }
}
