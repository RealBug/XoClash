import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/formatters/username_formatter.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/auth/presentation/providers/auth_providers.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class EditUsernameDialog extends ConsumerStatefulWidget {
  const EditUsernameDialog({super.key, this.currentUsername});
  final String? currentUsername;

  static void show(BuildContext context, WidgetRef ref, String? currentUsername) {
    final settings = ref.read(settingsValueProvider);
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.editUsername,
      isDarkMode: settings.isDarkMode,
      child: EditUsernameDialog(currentUsername: currentUsername),
    );
  }

  @override
  ConsumerState<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends ConsumerState<EditUsernameDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(userProvider).value;
      final oldUsername = currentUser?.username;
      final newUsername = _controller.text.trim();

      // Migrate session scores if username changed
      if (oldUsername != null && oldUsername != newUsername) {
        ref.read(sessionScoresProvider.notifier).migrateScore(oldUsername, newUsername);
      }

      // Update username using use case
      await ref.read(userProvider.notifier).updateUsername(newUsername);

      if (mounted) {
        Navigator.of(context).pop();
        final settings = ref.read(settingsValueProvider);
        SuccessSnackbar.show(context, context.l10n.usernameUpdated, isDarkMode: settings.isDarkMode);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: context.l10n.username,
              hintText: context.l10n.enterUsername,
              prefixIcon: const Icon(Icons.person),
            ),
            textCapitalization: TextCapitalization.words,
            inputFormatters: <TextInputFormatter>[UsernameTextFormatter()],
            autofocus: true,
            validator: (String? value) => ref.read(validateUsernameUseCaseProvider).execute(value, context.l10n),
            onFieldSubmitted: (_) => _saveUsername(),
          ),
        ),
        Gap(AppSpacing.xl),
        GameButton(text: context.l10n.save, onPressed: _isLoading ? null : _saveUsername, isLoading: _isLoading),
      ],
    );
  }
}
