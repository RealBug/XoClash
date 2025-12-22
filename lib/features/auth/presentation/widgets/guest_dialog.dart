import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/router_helper.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/inputs/username_text_field.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/features/auth/presentation/providers/auth_providers.dart';
import 'package:tictac/features/auth/presentation/widgets/guest_avatar_selector_dialog.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class GuestDialog extends ConsumerStatefulWidget {

  const GuestDialog({
    super.key,
    required this.isDarkMode,
  });
  final bool isDarkMode;

  @override
  ConsumerState<GuestDialog> createState() => _GuestDialogState();
}

class _GuestDialogState extends ConsumerState<GuestDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _isLoading = false;
  String? _selectedAvatar;

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInAsGuest() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(userProvider.notifier).signInAsGuest(
            _usernameController.text.trim(),
            avatar: _selectedAvatar,
          );
      if (mounted) {
        Navigator.of(context).pop();
        if (context.mounted) {
          RouterHelper.popAllAndPush(context, const HomeRoute());
        }
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

  void _showAvatarSelector() {
    _usernameFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    GuestAvatarSelectorDialog.show(
      context: context,
      isDarkMode: widget.isDarkMode,
      currentAvatar: _selectedAvatar,
      onAvatarSelected: (String avatar) {
        setState(() {
          _selectedAvatar = avatar;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.chooseUsername,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Gap(AppSpacing.xl),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: UsernameTextField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  labelText: context.l10n.username,
                  hintText: context.l10n.enterUsername,
                  isDarkMode: widget.isDarkMode,
                  autofocus: true,
                  validator: (String? value) => ref.read(validateUsernameUseCaseProvider).execute(value, context.l10n),
                  onFieldSubmitted: (_) => _signInAsGuest(),
                ),
              ),
              Gap(AppSpacing.sm),
              GestureDetector(
                onTap: _showAvatarSelector,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isDarkMode
                        ? AppTheme.darkSurfaceColor.withValues(alpha: 0.5)
                        : AppTheme.lightSurfaceColor,
                    border: Border.all(
                      color: _selectedAvatar != null
                          ? AppTheme.getPrimaryColor(widget.isDarkMode)
                          : AppTheme.getBorderColor(widget.isDarkMode, opacity: 0.3),
                      width: _selectedAvatar != null ? 2.5 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: _selectedAvatar != null
                        ? Text(
                            _selectedAvatar!,
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        : Icon(
                            Icons.face,
                            color: widget.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(AppSpacing.xl),
        GameButton(
          text: context.l10n.start,
          onPressed: _isLoading ? null : _signInAsGuest,
          isLoading: _isLoading,
        ),
      ],
    );
  }

}
