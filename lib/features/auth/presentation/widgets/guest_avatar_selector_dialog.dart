import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/avatars/avatar_selector.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';

class GuestAvatarSelectorDialog extends StatefulWidget {

  const GuestAvatarSelectorDialog({
    super.key,
    required this.isDarkMode,
    required this.currentAvatar,
    required this.onAvatarSelected,
  });
  final bool isDarkMode;
  final String? currentAvatar;
  final Function(String) onAvatarSelected;

  @override
  State<GuestAvatarSelectorDialog> createState() => _GuestAvatarSelectorDialogState();

  static void show({
    required BuildContext context,
    required bool isDarkMode,
    String? currentAvatar,
    required Function(String) onAvatarSelected,
  }) {
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.chooseAvatar,
      isDarkMode: isDarkMode,
      child: GuestAvatarSelectorDialog(
        isDarkMode: isDarkMode,
        currentAvatar: currentAvatar,
        onAvatarSelected: onAvatarSelected,
      ),
    );
  }
}

class _GuestAvatarSelectorDialogState extends State<GuestAvatarSelectorDialog> {
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  color: widget.isDarkMode
                      ? AppTheme.getPrimaryColor(widget.isDarkMode)
                      : AppTheme.lightTextPrimary,
                ),
                Gap(AppSpacing.xxl),
                Text(
                  context.l10n.chooseAvatar,
                  style: Theme.of(context).textTheme.displayMedium,
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
                  isDarkMode: widget.isDarkMode,
                ),
              ],
            ),
          ),
        ),
        Gap(AppSpacing.xl),
        GameButton(
          text: context.l10n.save,
          onPressed: () {
            if (_selectedAvatar != null) {
              widget.onAvatarSelected(_selectedAvatar!);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
