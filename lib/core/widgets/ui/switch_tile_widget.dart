import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';

class SwitchTileWidget extends StatelessWidget {

  const SwitchTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
    required this.isDarkMode,
  });
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? AppTheme.getBorderColor(true)
              : AppTheme.getBorderColor(false, opacity: 0.5),
        ),
      ),
      child: SwitchListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
        title: Row(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            Gap(AppSpacing.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        subtitle: Padding(
          padding: AppSpacing.paddingOnly(left: AppSpacing.xxl + AppSpacing.sm),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.primary,
        inactiveThumbColor: isDarkMode
            ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
            : AppTheme.lightTextSecondary.withValues(alpha: 0.6),
        inactiveTrackColor: isDarkMode
            ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
            : AppTheme.getBorderColor(false, opacity: 0.3),
      ),
    );
  }
}

