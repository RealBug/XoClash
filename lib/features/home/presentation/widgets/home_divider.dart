import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class HomeDivider extends ConsumerWidget {
  const HomeDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final dividerColor =
        isDarkMode.textColorSecondary(0.2).withValues(alpha: 0.3);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  AppTheme.transparent,
                  dividerColor,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.or,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: dividerColor,
                  letterSpacing: 2,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  dividerColor,
                  AppTheme.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
