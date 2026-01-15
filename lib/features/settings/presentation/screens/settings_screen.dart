import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart' show audioServiceProvider, navigationServiceProvider;
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/ui/section_header.dart';
import 'package:tictac/core/widgets/ui/switch_tile_widget.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart'
    show settingsProvider, settingsValueProvider, isDarkModeProvider, SettingsNotifier;
import 'package:tictac/features/settings/presentation/widgets/appearance_tile.dart';
import 'package:tictac/features/settings/presentation/widgets/info_card.dart';
import 'package:tictac/features/settings/presentation/widgets/language_tile.dart';
import 'package:tictac/features/settings/presentation/widgets/playbook_tile.dart';
import 'package:tictac/features/settings/presentation/widgets/user_tile.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.hideProfile = false});
  final bool hideProfile;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = ref.watch(settingsValueProvider);
    final SettingsNotifier settingsNotifier = ref.read(settingsProvider.notifier);
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    SystemUIHelper.setStatusBarStyle(context, isDarkMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            final navigation = ref.read(navigationServiceProvider);
            if (navigation.canPop()) {
              navigation.pop();
            } else {
              navigation.popAllAndNavigateToHome();
            }
          },
        ),
        title: Text(context.l10n.settings),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        backgroundColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
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
                        constraints: const BoxConstraints(maxWidth: UIConstants.widgetSizeMaxWidth),
                        child: Padding(
                          padding: AppSpacing.paddingOnly(
                            left: AppSpacing.md,
                            top: AppSpacing.md,
                            right: AppSpacing.md,
                            bottom: AppSpacing.xxl,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (!widget.hideProfile) ...<Widget>[
                                SectionHeader(title: context.l10n.profile),
                                Gap(AppSpacing.xs),
                                const UserTile(),
                                Gap(AppSpacing.xl),
                              ],
                              SectionHeader(title: context.l10n.appearance),
                              Gap(AppSpacing.xs),
                              const AppearanceTile(),
                              Gap(AppSpacing.xl),
                              SectionHeader(title: context.l10n.audio),
                              Gap(AppSpacing.xs),
                              SwitchTileWidget(
                                title: context.l10n.soundFx,
                                subtitle: context.l10n.soundFxSubtitle,
                                value: settings.soundFxEnabled,
                                icon: Icons.graphic_eq,
                                onChanged: (bool value) async {
                                  await settingsNotifier.toggleSoundFx();
                                  if (value) {
                                    final AudioService audioService = ref.read(audioServiceProvider);
                                    await audioService.playMoveSound();
                                  }
                                },
                                isDarkMode: isDarkMode,
                              ),
                              Gap(AppSpacing.xl),
                              SectionHeader(title: context.l10n.animations),
                              Gap(AppSpacing.xs),
                              SwitchTileWidget(
                                title: context.l10n.animations,
                                subtitle: context.l10n.animationsSubtitle,
                                value: settings.animationsEnabled,
                                icon: Icons.animation,
                                onChanged: (bool value) => settingsNotifier.toggleAnimations(),
                                isDarkMode: isDarkMode,
                              ),
                              Gap(AppSpacing.xl),
                              SectionHeader(title: context.l10n.language),
                              Gap(AppSpacing.xs),
                              LanguageTile(settings: settings, settingsNotifier: settingsNotifier),
                              Gap(AppSpacing.xl),
                              if (const bool.fromEnvironment('dart.vm.product') == false) ...<Widget>[
                                const SectionHeader(title: 'Development'),
                                Gap(AppSpacing.xs),
                                PlaybookTile(settings: settings),
                                Gap(AppSpacing.xl),
                              ],
                              const InfoCard(),
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
