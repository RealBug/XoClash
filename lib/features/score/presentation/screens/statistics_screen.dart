import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/router_helper.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/presentation/providers/history_providers.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/presentation/providers/score_providers.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/score/presentation/widgets/history_tab_widget.dart';
import 'package:tictac/features/score/presentation/widgets/scores_tab_widget.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

@RoutePage()
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scoresScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scoresScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = ref.watch(settingsValueProvider);
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final List<PlayerScore> scores = ref.watch(scoresProvider.select((AsyncValue<List<PlayerScore>> asyncValue) => asyncValue.value ?? <PlayerScore>[]));
    final List<GameHistory> history = ref.watch(gameHistoryProvider.select((AsyncValue<List<GameHistory>> asyncValue) => asyncValue.value ?? <GameHistory>[]));
    final Map<String, SessionScore> sessionScores = ref.watch(sessionScoresProvider);

    final bool hasDataToDelete = scores.isNotEmpty || history.isNotEmpty || sessionScores.isNotEmpty;

    SystemUIHelper.setStatusBarStyle(context, isDarkMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            if (context.router.canPop()) {
              context.router.pop();
            } else {
              RouterHelper.navigateToHome(context);
            }
          },
        ),
        title: Text(context.l10n.statistics),
        elevation: 0,
        backgroundColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        actions: <Widget>[
          if (hasDataToDelete)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 24,
                color: settings.isDarkMode ? AppTheme.darkTextPrimary.withValues(alpha: 0.8) : AppTheme.lightTextSecondary,
              ),
              onPressed: () async {
                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text(context.l10n.confirmSessionResetTitle),
                      content: Text(context.l10n.confirmSessionResetMessage),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                          child: Text(context.l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                          child: Text(
                            context.l10n.confirm,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.getPrimaryColor(settings.isDarkMode),
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed ?? false) {
                  ref.read(sessionScoresProvider.notifier).reset();
                  await ref.read(scoresProvider.notifier).resetScores();
                  await ref.read(gameHistoryProvider.notifier).clearHistory();

                  if (context.mounted) {
                    final bool isDarkMode = ref.read(isDarkModeProvider);
                    SuccessSnackbar.show(
                      context,
                      context.l10n.allDataDeleted,
                      isDarkMode: isDarkMode,
                    );
                  }
                }
              },
            ),
          Gap(AppSpacing.xs),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  context.l10n.scores,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Tab(
                child: Text(
                  context.l10n.history,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
            indicatorColor: AppTheme.getPrimaryColor(settings.isDarkMode),
            labelColor: AppTheme.getPrimaryColor(settings.isDarkMode),
            dividerColor: AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
          ),
        ),
      ),
      body: CosmicBackground(
        isDarkMode: settings.isDarkMode,
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ScoresTabWidget(
                scores: scores,
                settings: settings,
                scrollController: _scoresScrollController,
              ),
              HistoryTabWidget(
                history: history,
                settings: settings,
                scrollController: _historyScrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
