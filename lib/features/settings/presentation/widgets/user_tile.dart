import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/settings/presentation/widgets/edit_avatar_dialog.dart';
import 'package:tictac/features/settings/presentation/widgets/edit_username_dialog.dart';
import 'package:tictac/features/settings/presentation/widgets/logout_dialog.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class UserTile extends ConsumerWidget {
  const UserTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(userProvider.select((AsyncValue<User?> asyncValue) => asyncValue.value));
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? AppTheme.getBorderColor(true) : AppTheme.getBorderColor(false, opacity: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              context.l10n.username,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              user?.username ?? context.l10n.undefined,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDarkMode ? AppTheme.darkTextPrimary.withValues(alpha: 0.7) : AppTheme.lightTextSecondary,
            ),
            onTap: () => EditUsernameDialog.show(context, ref, user?.username),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
          ),
          ListTile(
            contentPadding: AppSpacing.paddingSymmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            leading: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode
                    ? AppTheme.darkBackgroundColor.withValues(alpha: 0.0)
                    : AppTheme.lightTextSecondary.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: user?.avatar != null
                  ? Text(
                      user!.avatar!,
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      user?.username != null && user!.username.isNotEmpty
                          ? user.username.substring(0, 1).toUpperCase()
                          : '?',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.getPrimaryColor(isDarkMode),
                          ),
                      textAlign: TextAlign.center,
                    ),
            ),
            title: Text(
              context.l10n.avatar,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDarkMode ? AppTheme.darkTextPrimary.withValues(alpha: 0.7) : AppTheme.lightTextSecondary,
            ),
            onTap: () => EditAvatarDialog.show(context, ref),
          ),
          if (user?.email != null && user!.email!.isNotEmpty) ...<Widget>[
            Divider(
              height: 1,
              thickness: 0.5,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
            ),
            ListTile(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                context.l10n.email,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                user.email!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
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
              Icons.logout,
              color: AppTheme.errorColor.withValues(alpha: 0.8),
            ),
            title: Text(
              context.l10n.logout,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.errorColor.withValues(alpha: 0.9),
                  ),
            ),
            subtitle: Text(
              context.l10n.logoutSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => LogoutDialog.show(context, ref),
          ),
        ],
      ),
    );
  }
}

