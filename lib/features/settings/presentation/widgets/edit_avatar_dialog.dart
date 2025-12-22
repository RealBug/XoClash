import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/avatars/avatar_selector.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class EditAvatarDialog extends ConsumerStatefulWidget {
  const EditAvatarDialog({super.key, this.currentAvatar});
  final String? currentAvatar;

  static void show(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider).value;
    final settings = ref.read(settingsValueProvider);
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.editAvatar,
      isDarkMode: settings.isDarkMode,
      child: EditAvatarDialog(currentAvatar: user?.avatar),
    );
  }

  @override
  ConsumerState<EditAvatarDialog> createState() => _EditAvatarDialogState();
}

class _EditAvatarDialogState extends ConsumerState<EditAvatarDialog> {
  String? _selectedAvatar;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  Future<void> _saveAvatar() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update avatar using use case
      await ref.read(userProvider.notifier).updateAvatar(_selectedAvatar);

      if (mounted) {
        Navigator.of(context).pop();
        final settings = ref.read(settingsValueProvider);
        SuccessSnackbar.show(context, context.l10n.avatarUpdated, isDarkMode: settings.isDarkMode);
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.showFromError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsValueProvider);
    final user = ref.watch(userProvider).value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.face,
                  size: 80,
                  color: settings.isDarkMode ? AppTheme.getPrimaryColor(settings.isDarkMode) : AppTheme.lightTextPrimary,
                ),
                Gap(AppSpacing.xxl),
                Text(context.l10n.chooseAvatar, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                Gap(AppSpacing.md),
                if (user != null)
                  Text(
                    context.l10n.chooseAvatarMessage(user.username),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: settings.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                    textAlign: TextAlign.center,
                  ),
                Gap(AppSpacing.xxl),
                AvatarSelector(
                  selectedAvatar: _selectedAvatar,
                  onAvatarSelected: (String avatar) {
                    setState(() {
                      _selectedAvatar = avatar;
                    });
                  },
                  isDarkMode: settings.isDarkMode,
                ),
              ],
            ),
          ),
        ),
        Gap(AppSpacing.xl),
        GameButton(text: context.l10n.save, onPressed: _isLoading ? null : _saveAvatar, isLoading: _isLoading),
      ],
    );
  }
}
