import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigationServiceProvider;
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/branding/clickable_logo.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/auth/presentation/widgets/guest_dialog.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
        surfaceTintColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
        shadowColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 26,
              color: isDarkMode
                  ? AppTheme.darkTextPrimary
                  : AppTheme.lightTextSecondary,
            ),
            onPressed: () => ref.read(navigationServiceProvider).toSettings(hideProfile: true),
          ),
          Gap(AppSpacing.xs),
        ],
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
                        constraints: const BoxConstraints(
                          maxWidth: UIConstants.widgetSizeMaxWidth,
                        ),
                        child: Padding(
                          padding: AppSpacing.paddingAll(AppSpacing.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Gap(AppSpacing.xl * 2),
                              const ClickableLogo(),
                              Gap(AppSpacing.xl * 2.5),
                              Text(
                                context.l10n.welcomeMessage,
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
                              Gap(AppSpacing.xl * 2),
                              GameButton(
                                text: context.l10n.signup,
                                onPressed: () => ref.read(navigationServiceProvider).toSignup(),
                              ),
                              Gap(AppSpacing.sm),
                              GameButton(
                                text: context.l10n.login,
                                isOutlined: true,
                                onPressed: () => ref.read(navigationServiceProvider).toLogin(),
                              ),
                              Gap(AppSpacing.xl),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color: AppTheme.getBorderColor(isDarkMode,
                                          opacity: 0.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: AppSpacing.paddingSymmetric(
                                        horizontal: AppSpacing.md),
                                    child: Text(
                                      context.l10n.or,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: AppTheme.getBorderColor(isDarkMode,
                                          opacity: 0.2),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(AppSpacing.xl),
                              GameButton(
                                text: context.l10n.playAsGuest,
                                icon: Icons.person_outline,
                                isOutlined: true,
                                onPressed: () {
                                  ModalBottomSheet.show(
                                    context: context,
                                    title: context.l10n.playAsGuest,
                                    isDarkMode: isDarkMode,
                                    child: GuestDialog(isDarkMode: isDarkMode),
                                  );
                                },
                              ),
                            ],
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
