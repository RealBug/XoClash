import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/avatars/avatar_selector.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class AvatarSelectionContent extends ConsumerWidget {

  const AvatarSelectionContent({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });
  final String? selectedAvatar;
  final Function(String) onAvatarSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currentUser = ref.watch(userProvider.select((AsyncValue<User?> asyncValue) => asyncValue.value));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.face,
          size: 80,
          color: isDarkMode
              ? AppTheme.getPrimaryColor(isDarkMode)
              : const Color(0xFF1A2332),
        ),
        Gap(AppSpacing.xxl),
        Text(
          context.l10n.chooseAvatar,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Gap(AppSpacing.md),
        if (currentUser != null)
          Text(
            context.l10n.chooseAvatarMessage(currentUser.username),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        Gap(AppSpacing.xxl),
        AvatarSelector(
          selectedAvatar: selectedAvatar,
          onAvatarSelected: onAvatarSelected,
          isDarkMode: isDarkMode,
        ),
        Gap(AppSpacing.md),
      ],
    );
  }
}

