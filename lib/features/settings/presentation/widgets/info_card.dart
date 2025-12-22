import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class InfoCard extends ConsumerWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final AsyncValue<String> versionAsync = ref.watch(appVersionProvider);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? AppTheme.getBorderColor(true) : AppTheme.getBorderColor(false, opacity: 0.3),
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Gap(AppSpacing.xs),
                Text(
                  context.l10n.about,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Gap(AppSpacing.xs),
            Text(
              context.l10n.collaborativeTicTacToe,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            versionAsync.when(
              data: (String version) {
                if (version.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: <Widget>[
                    Gap(AppSpacing.xs),
                    Text(
                      version,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            Gap(AppSpacing.sm),
            Text(
              context.l10n.developedBy,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
            ),
            Gap(AppSpacing.sm),
            Text(
              context.l10n.thanksTestersMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
