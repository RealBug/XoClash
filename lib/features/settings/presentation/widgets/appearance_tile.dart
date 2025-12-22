import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/settings/presentation/widgets/symbols_dialog.dart';

class AppearanceTile extends ConsumerWidget {
  const AppearanceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Settings settings = ref.watch(settingsValueProvider);
    final SettingsNotifier settingsNotifier = ref.read(settingsProvider.notifier);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: settings.isDarkMode ? AppTheme.getBorderColor(true) : AppTheme.getBorderColor(false, opacity: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          SwitchListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            tileColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
            title: Row(
              children: <Widget>[
                Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.primary),
                Gap(AppSpacing.sm),
                Text(
                  context.l10n.darkMode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            subtitle: Padding(
              padding: AppSpacing.paddingOnly(left: AppSpacing.xxl + AppSpacing.sm),
              child: Text(
                context.l10n.darkModeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            value: settings.isDarkMode,
            onChanged: (bool value) => settingsNotifier.toggleDarkMode(),
            activeThumbColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: settings.isDarkMode
                ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                : AppTheme.lightTextSecondary.withValues(alpha: 0.6),
            inactiveTrackColor: settings.isDarkMode
                ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                : AppTheme.getBorderColor(false, opacity: 0.3),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
          ),
          ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            leading: Icon(
              Icons.shape_line,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              context.l10n.symbolShapes,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              context.l10n.customizeXAndO,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: settings.isDarkMode
                  ? AppTheme.darkTextPrimary.withValues(alpha: 0.7)
                  : AppTheme.lightTextSecondary,
            ),
            onTap: () => SymbolsDialog.show(context, ref, settings, settingsNotifier),
          ),
        ],
      ),
    );
  }
}

