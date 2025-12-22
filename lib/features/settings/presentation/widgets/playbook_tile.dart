import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class PlaybookTile extends StatelessWidget {

  const PlaybookTile({
    super.key,
    required this.settings,
  });
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: settings.isDarkMode
              ? AppTheme.getBorderColor(true)
              : AppTheme.getBorderColor(false, opacity: 0.3),
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Icon(
          Icons.style,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          context.l10n.componentLibrary,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          context.l10n.viewReusableComponents,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: settings.isDarkMode
              ? AppTheme.darkTextPrimary.withValues(alpha: 0.7)
              : AppTheme.lightTextSecondary,
        ),
        onTap: () {
          context.router.push(const PlaybookRoute());
        },
      ),
    );
  }
}
