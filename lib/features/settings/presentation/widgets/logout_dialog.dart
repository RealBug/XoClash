import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/router_helper.dart';
import 'package:tictac/features/history/presentation/providers/history_providers.dart';
import 'package:tictac/features/score/presentation/providers/score_providers.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  static void show(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmation),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(gameHistoryProvider.notifier).clearHistory();
              await ref.read(scoresProvider.notifier).resetScores();
              ref.read(sessionScoresProvider.notifier).reset();
              await ref.read(userProvider.notifier).deleteUser();
              if (context.mounted) {
                RouterHelper.popAllAndPush(context, const AuthRoute());
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget is only used via the static show method
    return const SizedBox.shrink();
  }
}

