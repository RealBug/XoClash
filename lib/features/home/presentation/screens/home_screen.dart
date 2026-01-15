import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigate;
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';
import 'package:tictac/core/widgets/branding/clickable_logo.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/ui/scrollable_section.dart';
import 'package:tictac/features/home/presentation/widgets/home_divider.dart';
import 'package:tictac/features/home/presentation/widgets/home_subtitle.dart';
import 'package:tictac/features/home/presentation/widgets/home_title.dart';
import 'package:tictac/features/home/presentation/widgets/join_game_section.dart';
import 'package:tictac/features/home/presentation/widgets/new_game_button.dart';
import 'package:tictac/features/home/presentation/widgets/statistics_button.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _gameIdController = TextEditingController();
  final FocusNode _gameIdFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _gameIdController.dispose();
    _gameIdFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    SystemUIHelper.setStatusBarStyle(context, isDarkMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.transparent,
        surfaceTintColor: AppTheme.transparent,
        shadowColor: AppTheme.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, size: 26, color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextSecondary),
            onPressed: () => navigate(ref, RequestSettings()),
          ),
          Gap(AppSpacing.sm),
        ],
      ),
      body: CosmicBackground(
        isDarkMode: isDarkMode,
        child: SafeArea(
          top: false,
          child: ScrollableSection(
            controller: _scrollController,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: UIConstants.widgetSizeMaxWidth),
                child: Padding(
                  padding: AppSpacing.paddingOnly(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
                    left: AppSpacing.xl,
                    right: AppSpacing.xl,
                    bottom: AppSpacing.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Gap(AppSpacing.xl * 2),
                      const ClickableLogo(),
                      Gap(AppSpacing.xl * 2.5),
                      const HomeTitle(),
                      Gap(AppSpacing.sm),
                      const HomeSubtitle(),
                      Gap(AppSpacing.xl * 2),
                      const NewGameButton(),
                      Gap(AppSpacing.lg),
                      const StatisticsButton(),
                      Gap(AppSpacing.xl),
                      const HomeDivider(),
                      Gap(AppSpacing.xl),
                      JoinGameSection(
                        gameIdController: _gameIdController,
                        gameIdFocusNode: _gameIdFocusNode,
                        onGameIdChanged: () => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
