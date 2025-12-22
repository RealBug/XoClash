import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {

  const ForgotPasswordDialog({
    super.key,
    required this.isDarkMode,
  });
  final bool isDarkMode;

  @override
  ConsumerState<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();

  static void show({
    required BuildContext context,
    required bool isDarkMode,
  }) {
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.forgotPassword,
      isDarkMode: isDarkMode,
      child: ForgotPasswordDialog(isDarkMode: isDarkMode),
    );
  }
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
        if (context.mounted) {
          final bool isDarkMode = ref.read(isDarkModeProvider);
          SuccessSnackbar.show(
            context,
            context.l10n.passwordResetEmailSent,
            isDarkMode: isDarkMode,
          );
        }
      }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.forgotPasswordMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
        ),
        Gap(AppSpacing.xl),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.l10n.email,
              hintText: context.l10n.enterEmail,
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.pleaseEnterEmail;
              }
              if (!value.contains('@')) {
                return context.l10n.invalidEmail;
              }
              return null;
            },
          ),
        ),
        Gap(AppSpacing.xl),
        GameButton(
          text: context.l10n.sendResetLink,
          onPressed: _isLoading ? null : _handleSendResetLink,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}

