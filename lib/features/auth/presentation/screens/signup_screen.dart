import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigationServiceProvider;
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/branding/clickable_logo.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/features/auth/presentation/widgets/auth_button.dart';
import 'package:tictac/features/auth/presentation/widgets/auth_helper.dart';
import 'package:tictac/features/auth/presentation/widgets/email_signup_dialog.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

@RoutePage()
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _usernameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.l10n.signup),
        elevation: 0,
        backgroundColor: AppTheme.transparent,
      ),
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
                          padding: AppSpacing.paddingAll(AppSpacing.xl),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Gap(AppSpacing.lg),
                                const ClickableLogo(),
                                Gap(AppSpacing.xxl),
                                Text(
                                  context.l10n.createAccount,
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
                                Gap(AppSpacing.xxl + AppSpacing.md),
                                AuthButton(
                                  icon: Icons.email,
                                  label: context.l10n.signupWithEmail,
                                  onPressed: () {
                                    EmailSignupDialog.show(
                                      context: context,
                                      isDarkMode: isDarkMode,
                                    );
                                  },
                                ),
                                Gap(AppSpacing.sm),
                                AuthButton(
                                  icon: Icons.g_mobiledata,
                                  label: context.l10n.signupWithGoogle,
                                  onPressed: () async {
                                    await AuthHelper.handleSocialAuth(
                                      context: context,
                                      authMethod: () => ref
                                          .read(userProvider.notifier)
                                          .signInWithGoogle(),
                                      onSuccess: () => ref.read(navigationServiceProvider).popAllAndNavigateToAvatarSelection(),
                                    );
                                  },
                                ),
                                Gap(AppSpacing.sm),
                                AuthButton(
                                  icon: Icons.apple,
                                  label: context.l10n.signupWithApple,
                                  onPressed: () async {
                                    await AuthHelper.handleSocialAuth(
                                      context: context,
                                      authMethod: () => ref
                                          .read(userProvider.notifier)
                                          .signInWithApple(),
                                      onSuccess: () => ref.read(navigationServiceProvider).popAllAndNavigateToAvatarSelection(),
                                    );
                                  },
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
