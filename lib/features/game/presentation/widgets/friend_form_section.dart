import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/avatars/avatar_selector.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/inputs/username_text_field.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class FriendFormSection extends StatefulWidget {

  const FriendFormSection({
    super.key,
    required this.nameController,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    required this.settings,
  });
  final TextEditingController nameController;
  final String? selectedAvatar;
  final Function(String?) onAvatarSelected;
  final Settings settings;

  @override
  State<FriendFormSection> createState() => _FriendFormSectionState();
}

class _FriendFormSectionState extends State<FriendFormSection> {
  void _showFriendAvatarSelector() {
    final isDarkMode = widget.settings.isDarkMode;
    String? selectedAvatar = widget.selectedAvatar;

    ModalBottomSheet.show(
      context: context,
      title: context.l10n.friendAvatar,
      isDarkMode: isDarkMode,
      child: StatefulBuilder(
        builder: (BuildContext modalContext, StateSetter modalSetState) => Column(
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
                      color: isDarkMode
                          ? AppTheme.getPrimaryColor(isDarkMode)
                          : AppTheme.lightTextPrimary,
                    ),
                    Gap(AppSpacing.xxl),
                    Text(
                      context.l10n.chooseAvatarForFriend,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(AppSpacing.xxl),
                    AvatarSelector(
                      selectedAvatar: selectedAvatar,
                      onAvatarSelected: (String avatar) {
                        modalSetState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            Gap(AppSpacing.xl),
            GameButton(
              text: context.l10n.save,
              onPressed: () {
                widget.onAvatarSelected(selectedAvatar);
                Navigator.of(modalContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.settings.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Gap(AppSpacing.sm),
        Padding(
          padding: AppSpacing.paddingOnly(left: AppSpacing.xxs),
          child: Text(
            context.l10n.enterFriendName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Gap(AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: UsernameTextField(
                controller: widget.nameController,
                labelText: context.l10n.friendName,
                hintText: context.l10n.enterFriendNameHint,
                isDarkMode: isDarkMode,
                autofocus: true,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Gap(AppSpacing.sm),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                _showFriendAvatarSelector();
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? AppTheme.darkSurfaceColor.withValues(alpha: 0.5)
                      : AppTheme.lightSurfaceColor,
                  border: Border.all(
                    color: widget.selectedAvatar != null
                        ? AppTheme.getPrimaryColor(isDarkMode)
                        : (isDarkMode
                            ? Colors.white.withValues(alpha: 0.2)
                            : const Color(0xFF6B7280)),
                    width: widget.selectedAvatar != null ? 2.5 : 1.5,
                  ),
                ),
                child: Center(
                  child: widget.selectedAvatar != null
                      ? Text(
                          widget.selectedAvatar!,
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                      : Icon(
                          Icons.face,
                          color: isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                          size: 28,
                        ),
                ),
              ),
            ),
          ],
        ),
        Gap(AppSpacing.md),
      ],
    );
  }
}

