import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/formatters/username_formatter.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/auth/presentation/providers/auth_providers.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class EmailSignupDialog extends ConsumerStatefulWidget {
  const EmailSignupDialog({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  ConsumerState<EmailSignupDialog> createState() => _EmailSignupDialogState();

  static void show({required BuildContext context, required bool isDarkMode}) {
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.signupWithEmail,
      isDarkMode: isDarkMode,
      child: EmailSignupDialog(isDarkMode: isDarkMode),
    );
  }
}

class _EmailSignupDialogState extends ConsumerState<EmailSignupDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final logger = ref.read(loggerServiceProvider);
      logger.info('Email signup attempt: ${_usernameController.text.trim()}');
      await ref.read(userProvider.notifier).saveUser(_usernameController.text.trim(), email: _emailController.text.trim());
      logger.debug('Email signup successful: ${_usernameController.text.trim()}');
      if (mounted) {
        Navigator.of(context).pop();
        if (context.mounted) {
          ref.read(navigationServiceProvider).popAllAndNavigateToAvatarSelection();
        }
      }
    } catch (e, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.error('Email signup failed', e, stackTrace);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: context.l10n.username, prefixIcon: const Icon(Icons.person)),
              textCapitalization: TextCapitalization.words,
              inputFormatters: <TextInputFormatter>[UsernameTextFormatter()],
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autofocus: true,
              validator: (String? value) => ref.read(validateUsernameUseCaseProvider).execute(value, context.l10n),
            ),
            Gap(AppSpacing.md),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: context.l10n.email, prefixIcon: const Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) => ref.read(validateEmailUseCaseProvider).execute(value, context.l10n),
            ),
            Gap(AppSpacing.md),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: context.l10n.password, prefixIcon: const Icon(Icons.lock)),
              obscureText: true,
              validator: (String? value) => ref.read(validatePasswordUseCaseProvider).execute(value, context.l10n),
            ),
            Gap(AppSpacing.xl),
            GameButton(text: context.l10n.signup, onPressed: _isLoading ? null : _handleSignup, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}
