import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigate;
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/formatters/username_formatter.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/features/auth/presentation/providers/auth_providers.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

@RoutePage()
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitUsername() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(userProvider.notifier).saveUser(
              _usernameController.text,
            );
        if (mounted) {
          navigate(ref, OnboardingUsernameCompleted());
        }
      } catch (e) {
        if (mounted) {
          ErrorSnackbar.showFromError(context, e);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      body: CosmicBackground(
        isDarkMode: isDarkMode,
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(4),
            thickness: 6,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person_add,
                                  size: 80,
                                  color: isDarkMode
                                      ? AppTheme.getPrimaryColor(isDarkMode)
                                      : const Color(0xFF1A2332),
                                ),
                                Gap(AppSpacing.xxl),
                                Text(
                                  context.l10n.welcome,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Gap(AppSpacing.md),
                                Text(
                                  context.l10n.chooseUsername,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Gap(AppSpacing.xxl),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.username,
                                    hintText: context.l10n.enterUsername,
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: <TextInputFormatter>[UsernameTextFormatter()],
                                  autofocus: true,
                                  validator: (String? value) =>
                                      ref.read(validateUsernameUseCaseProvider).execute(
                                          value, context.l10n),
                                  onFieldSubmitted: (_) => _submitUsername(),
                                ),
                                Gap(AppSpacing.xxl),
                                GameButton(
                                  text: context.l10n.start,
                                  onPressed:
                                      _isLoading ? null : _submitUsername,
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
