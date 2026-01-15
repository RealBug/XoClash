import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/auth/presentation/widgets/forgot_password_dialog.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class EmailLoginDialog extends ConsumerStatefulWidget {

  const EmailLoginDialog({
    super.key,
    required this.isDarkMode,
  });
  final bool isDarkMode;

  @override
  ConsumerState<EmailLoginDialog> createState() => _EmailLoginDialogState();

  static void show({
    required BuildContext context,
    required bool isDarkMode,
  }) {
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.loginWithEmail,
      isDarkMode: isDarkMode,
      child: EmailLoginDialog(isDarkMode: isDarkMode),
    );
  }
}

class _EmailLoginDialogState extends ConsumerState<EmailLoginDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final String username = _emailController.text.split('@')[0];
      final LoggerService logger = ref.read(loggerServiceProvider);
      logger.info('Email login attempt: $username');
      await ref.read(userProvider.notifier).saveUser(
            username,
            email: _emailController.text.trim(),
          );
      logger.debug('Email login successful: $username');
      if (mounted) {
        Navigator.of(context).pop();
        if (context.mounted) {
          navigate(ref, LoginCompleted());
        }
      }
    } catch (e, stackTrace) {
      final LoggerService logger = ref.read(loggerServiceProvider);
      logger.error('Email login failed', e, stackTrace);
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.l10n.email,
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
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
          Gap(AppSpacing.md),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: context.l10n.password,
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.pleaseEnterPassword;
              }
              return null;
            },
          ),
          Gap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ForgotPasswordDialog.show(
                  context: context,
                  isDarkMode: widget.isDarkMode,
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                context.l10n.forgotPassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          Gap(AppSpacing.xl),
          GameButton(
            text: context.l10n.login,
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
