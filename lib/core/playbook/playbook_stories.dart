import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:playbook/playbook.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/playbook/playbook_helpers.dart';
import 'package:tictac/core/playbook/playbook_strings.dart';
import 'package:tictac/core/playbook/widgets/emoji_selector_scenario.dart';
import 'package:tictac/core/playbook/widgets/optimized_scenario.dart';
import 'package:tictac/core/playbook/widgets/themed_scaffold.dart';
import 'package:tictac/core/playbook/widgets/themed_scaffold_with_localizations.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/avatars/avatar_selector.dart';
import 'package:tictac/core/widgets/branding/app_logo.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/effects/confetti_widget.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/emojis/emoji_selector.dart';
import 'package:tictac/core/widgets/formatters/game_id_formatter.dart';
import 'package:tictac/core/widgets/inputs/username_text_field.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/home/presentation/widgets/join_game_section.dart';
import 'package:tictac/l10n/app_localizations.dart';

// ============================================================================
// STORIES
// ============================================================================

/// Playbook instance containing all widget stories
final Playbook playbook = Playbook(
  stories: <Story>[
    _gameButtonStory(),
    _appLogoStory(),
    _cosmicBackgroundStory(),
    _avatarSelectorStory(),
    _modalBottomSheetStory(),
    _emojiSelectorStory(),
    _shapeSelectorStory(),
    _confettiWidgetStory(),
    _textFieldStory(),
    _usernameTextFieldStory(),
    _cardsStory(),
    _gameIdFormatterStory(),
    _joinGameSectionStory(),
  ],
);

Story _gameButtonStory() {
  return Story(
    PlaybookStrings.gameButton,
    scenarios: <Scenario>[
      const Scenario(
        PlaybookStrings.defaultButton,
        layout: ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.playGame),
      ),
      Scenario(
        PlaybookStrings.primaryButton,
        layout: const ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.startGame, onPressed: () {}),
      ),
      Scenario(
        PlaybookStrings.outlinedButton,
        layout: const ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.settings, onPressed: () {}, isOutlined: true),
      ),
      Scenario(
        PlaybookStrings.buttonWithIcon,
        layout: const ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.signIn, onPressed: () {}, icon: Icons.login, isOutlined: true),
      ),
      const Scenario(
        PlaybookStrings.loadingButton,
        layout: ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.loading, isLoading: true),
      ),
      const Scenario(
        PlaybookStrings.disabledButton,
        layout: ScenarioLayout.fixed(400, 80),
        child: GameButton(text: PlaybookStrings.disabled),
      ),
      Scenario(
        PlaybookStrings.customColors,
        layout: const ScenarioLayout.fixed(400, 80),
        child: GameButton(
          text: PlaybookStrings.custom,
          onPressed: () {},
          backgroundColor: AppTheme.purpleAccent,
          textColor: AppTheme.darkTextPrimary,
        ),
      ),
    ],
  );
}

Story _appLogoStory() {
  return const Story(
    PlaybookStrings.appLogo,
    scenarios: <Scenario>[
      Scenario(PlaybookStrings.darkMode, layout: ScenarioLayout.fixed(200, 200), child: AppLogo(isDarkMode: true)),
      Scenario(PlaybookStrings.lightMode, layout: ScenarioLayout.fixed(200, 200), child: AppLogo(isDarkMode: false)),
      Scenario(PlaybookStrings.customSize, layout: ScenarioLayout.fixed(150, 150), child: AppLogo(isDarkMode: true, fontSize: 36)),
    ],
  );
}

Story _cosmicBackgroundStory() {
  return Story(
    PlaybookStrings.cosmicBackground,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.darkMode,
        layout: const ScenarioLayout.fill(),
        child: OptimizedScenario(
          child: CosmicBackground(
            child: Center(
              child: Builder(
                builder: (BuildContext context) => Text(PlaybookStrings.darkBackground, style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fill(),
        child: OptimizedScenario(
          child: CosmicBackground(
            isDarkMode: false,
            child: Center(
              child: Builder(
                builder: (BuildContext context) => Text(
                  PlaybookStrings.lightBackground,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextPrimary),
                ),
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.withContent,
        layout: const ScenarioLayout.fill(),
        child: OptimizedScenario(
          child: CosmicBackground(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const AppLogo(isDarkMode: true),
                  Gap(AppSpacing.xxl),
                  GameButton(text: 'Start Game', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Story _avatarSelectorStory() {
  return Story(
    PlaybookStrings.avatarSelector,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.darkMode,
        layout: const ScenarioLayout.fixed(400, 600),
        child: OptimizedScenario(
          child: AvatarSelector(selectedAvatar: '😀', onAvatarSelected: (_) {}, isDarkMode: true),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fixed(400, 600),
        child: OptimizedScenario(
          child: AvatarSelector(selectedAvatar: '😊', onAvatarSelected: (_) {}, isDarkMode: false),
        ),
      ),
      Scenario(
        PlaybookStrings.noSelection,
        layout: const ScenarioLayout.fixed(400, 600),
        child: OptimizedScenario(child: AvatarSelector(selectedAvatar: null, onAvatarSelected: (_) {}, isDarkMode: true)),
      ),
    ],
  );
}

Story _modalBottomSheetStory() {
  return Story(
    PlaybookStrings.modalBottomSheet,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.darkMode,
        layout: const ScenarioLayout.fill(),
        child: Scaffold(
          body: Center(
            child: ElevatedButton(onPressed: () {}, child: const Text(PlaybookStrings.openModal)),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fill(),
        child: Scaffold(
          body: Center(
            child: ElevatedButton(onPressed: () {}, child: const Text(PlaybookStrings.openModal)),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.withContent,
        layout: const ScenarioLayout.fill(),
        child: ModalBottomSheet(
          title: PlaybookStrings.settings,
          isDarkMode: true,
          child: Padding(padding: AppSpacing.paddingAll(AppSpacing.md), child: const Text(PlaybookStrings.modalContent)),
        ),
      ),
    ],
  );
}

Story _emojiSelectorStory() {
  return Story(
    PlaybookStrings.emojiSelector,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.darkMode,
        layout: const ScenarioLayout.fixed(400, 800),
        child: EmojiSelectorScenario(
          child: EmojiSelector(selectedXEmoji: '😀', selectedOEmoji: '😊', onEmojiSelected: (_, _) {}),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fixed(400, 800),
        child: EmojiSelectorScenario(
          isDarkMode: false,
          child: EmojiSelector(selectedXEmoji: '🎮', selectedOEmoji: '🎯', onEmojiSelected: (_, _) {}, isDarkMode: false),
        ),
      ),
      Scenario(
        PlaybookStrings.noSelection,
        layout: const ScenarioLayout.fixed(400, 800),
        child: EmojiSelectorScenario(child: EmojiSelector(selectedXEmoji: null, selectedOEmoji: null, onEmojiSelected: (_, _) {})),
      ),
    ],
  );
}

Story _shapeSelectorStory() {
  return Story(
    PlaybookStrings.shapeSelector,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.darkMode,
        layout: const ScenarioLayout.fixed(400, 400),
        child: OptimizedScenario(
          child: Scaffold(
            backgroundColor: const Color(0xFF1A0D2E),
            body: Padding(
              padding: AppSpacing.paddingAll(AppSpacing.md),
              child: ShapeSelector(selectedXShape: SymbolShape.classic, selectedOShape: SymbolShape.rounded, onShapeSelected: (_, _) {}),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fixed(400, 400),
        child: OptimizedScenario(
          child: Scaffold(
            backgroundColor: AppTheme.lightSurfaceColor,
            body: Padding(
              padding: AppSpacing.paddingAll(AppSpacing.md),
              child: ShapeSelector(
                selectedXShape: SymbolShape.bold,
                selectedOShape: SymbolShape.outline,
                onShapeSelected: (_, _) {},
                isDarkMode: false,
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.allShapesSelected,
        layout: const ScenarioLayout.fixed(400, 400),
        child: OptimizedScenario(
          child: Scaffold(
            backgroundColor: const Color(0xFF1A0D2E),
            body: Padding(
              padding: AppSpacing.paddingAll(AppSpacing.md),
              child: ShapeSelector(selectedXShape: SymbolShape.outline, selectedOShape: SymbolShape.bold, onShapeSelected: (_, _) {}),
            ),
          ),
        ),
      ),
    ],
  );
}

Story _confettiWidgetStory() {
  return Story(
    PlaybookStrings.confettiWidget,
    scenarios: <Scenario>[
      const Scenario(
        PlaybookStrings.activeConfetti,
        layout: ScenarioLayout.fill(),
        child: OptimizedScenario(child: _ConfettiDemo(isActive: false)),
      ),
      const Scenario(
        PlaybookStrings.customColors,
        layout: ScenarioLayout.fill(),
        child: OptimizedScenario(
          child: _ConfettiDemo(isActive: false, color1: AppTheme.greenAccent, color2: AppTheme.blueAccent, color3: AppTheme.purpleAccent),
        ),
      ),
      Scenario(
        PlaybookStrings.inactive,
        layout: const ScenarioLayout.fill(),
        child: OptimizedScenario(
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.md),
            child: Stack(
              children: <Widget>[
                Container(
                  color: AppTheme.darkSurfaceColor,
                  child: Center(
                    child: Builder(
                      builder: (BuildContext context) => Text(
                        PlaybookStrings.noConfetti,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const ConfettiWidget(isActive: false),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _ConfettiDemo extends StatefulWidget {
  const _ConfettiDemo({
    required this.isActive,
    this.color1 = AppTheme.redAccent,
    this.color2 = AppTheme.secondaryColor,
    this.color3 = AppTheme.yellowAccent,
  });

  final bool isActive;
  final Color color1;
  final Color color2;
  final Color color3;

  @override
  State<_ConfettiDemo> createState() => _ConfettiDemoState();
}

class _ConfettiDemoState extends State<_ConfettiDemo> {
  bool _isConfettiActive = false;
  bool _isButtonEnabled = true;

  void _launchConfetti() {
    if (!_isButtonEnabled || _isConfettiActive) {
      return;
    }
    setState(() {
      _isConfettiActive = true;
      _isButtonEnabled = false;
    });
  }

  void _onConfettiAnimationComplete() {
    if (mounted) {
      setState(() {
        _isConfettiActive = false;
        _isButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppTheme.darkSurfaceColor,
          child: Center(
            child: Padding(
              padding: AppSpacing.paddingAll(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) => Text(
                      PlaybookStrings.victory,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(AppSpacing.lg),
                  Padding(
                    padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.xl),
                    child: GameButton(text: 'Launch Confetti', onPressed: _isButtonEnabled ? _launchConfetti : null),
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: ConfettiWidget(
            isActive: _isConfettiActive,
            color1: widget.color1,
            color2: widget.color2,
            color3: widget.color3,
            onAnimationComplete: _onConfettiAnimationComplete,
          ),
        ),
      ],
    );
  }
}

Story _textFieldStory() {
  return Story(
    PlaybookStrings.textFieldWithEmoji,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.usernameFieldDark,
        layout: const ScenarioLayout.fixed(400, 200),
        child: Builder(
          builder: (BuildContext context) =>
              const DarkScaffold(withLocalizations: true, child: UsernameWithAvatar(emoji: '😀', isDarkMode: true)),
        ),
      ),
      Scenario(
        PlaybookStrings.usernameFieldLight,
        layout: const ScenarioLayout.fixed(400, 200),
        child: Builder(
          builder: (BuildContext context) =>
              const LightScaffold(withLocalizations: true, child: UsernameWithAvatar(emoji: '🎮', isDarkMode: false)),
        ),
      ),
      Scenario(
        PlaybookStrings.gameIdField,
        layout: const ScenarioLayout.fixed(400, 200),
        child: ThemedScaffold(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final controller = TextEditingController();
              const isDarkMode = true;
              final primaryColor = AppTheme.getPrimaryColor(isDarkMode);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: controller,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter game code',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode.textColorHint(0.4)),
                      prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: isDarkMode.textColorHint(0.6)),
                              onPressed: () {
                                controller.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDarkMode.borderColor(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.searchField,
        layout: const ScenarioLayout.fixed(400, 200),
        child: ThemedScaffoldWithLocalizations(
          locale: const Locale('fr'),
          child: Builder(
            builder: (BuildContext context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchComponents,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(icon: const Icon(Icons.clear), onPressed: () {}),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Story _usernameTextFieldStory() {
  return Story(
    PlaybookStrings.usernameTextField,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.defaultStateDark,
        layout: const ScenarioLayout.fixed(400, 100),
        child: Builder(
          builder: (BuildContext context) => const DarkScaffold(child: UsernameWithAvatar(emoji: '😀', isDarkMode: true)),
        ),
      ),
      Scenario(
        PlaybookStrings.defaultStateLight,
        layout: const ScenarioLayout.fixed(400, 100),
        child: Builder(
          builder: (BuildContext context) => const LightScaffold(child: UsernameWithAvatar(emoji: '😊', isDarkMode: false)),
        ),
      ),
      Scenario(
        PlaybookStrings.withTextDark,
        layout: const ScenarioLayout.fixed(400, 100),
        child: DarkScaffold(
          child: UsernameTextField(
            controller: TextEditingController(text: 'Jean Dupont'),
            labelText: 'Nom de l\'ami',
            hintText: 'Entre le nom de ton ami',
            isDarkMode: true,
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.focusedState,
        layout: const ScenarioLayout.fixed(400, 100),
        child: DarkScaffold(
          child: UsernameTextField(
            controller: TextEditingController(),
            labelText: 'Pseudo',
            hintText: 'Entre ton pseudo',
            isDarkMode: true,
            autofocus: true,
          ),
        ),
      ),
    ],
  );
}

Story _cardsStory() {
  return Story(
    PlaybookStrings.cards,
    scenarios: <Scenario>[
      const Scenario(
        PlaybookStrings.standardCardDark,
        layout: ScenarioLayout.fixed(400, 150),
        child: SimpleCard(title: PlaybookStrings.cardTitle, description: PlaybookStrings.cardDescDark, isDarkMode: true),
      ),
      const Scenario(
        PlaybookStrings.standardCardLight,
        layout: ScenarioLayout.fixed(400, 150),
        child: SimpleCard(title: PlaybookStrings.cardTitle, description: PlaybookStrings.cardDescLight, isDarkMode: false, elevation: 1),
      ),
      Scenario(
        PlaybookStrings.cardWithElevation,
        layout: const ScenarioLayout.fixed(400, 150),
        child: SimpleCard(
          title: PlaybookStrings.elevatedCard,
          description: PlaybookStrings.cardElevationDesc,
          isDarkMode: false,
          elevation: 4,
          shadowColor: AppTheme.lightTextSecondary.withValues(alpha: 0.3),
          side: BorderSide.none,
        ),
      ),
      Scenario(
        PlaybookStrings.activeGameInfo,
        layout: const ScenarioLayout.fixed(400, 120),
        child: Card(
          elevation: 1,
          shadowColor: AppTheme.redAccent.withValues(alpha: 0.15),
          color: AppTheme.redAccent.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.redAccent.withValues(alpha: 0.6), width: 2),
          ),
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.lg),
            child: Builder(
              builder: (BuildContext context) => Row(
                children: <Widget>[
                  const Icon(Icons.person, color: AppTheme.redAccent, size: 32),
                  Gap(AppSpacing.md),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(PlaybookStrings.player1, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Gap(AppSpacing.xs / 2),
                      Text(PlaybookStrings.yourTurn, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.statisticsCard,
        layout: const ScenarioLayout.fixed(400, 100),
        child: Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.getBorderColor(true)),
          ),
          color: AppTheme.darkCardColor,
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.lg),
            child: Builder(
              builder: (BuildContext context) => Row(
                children: <Widget>[
                  Text('🥇', style: Theme.of(context).textTheme.headlineMedium),
                  Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          PlaybookStrings.playerName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap(AppSpacing.xs / 2),
                        Text(PlaybookStrings.winsLosses, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Gap(AppSpacing.md),
                  Text(
                    '83%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.redAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.gameIdCard,
        layout: const ScenarioLayout.fixed(400, 120),
        child: Card(
          color: AppTheme.darkCardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.getBorderColor(true)),
          ),
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.lg),
            child: Builder(
              builder: (BuildContext context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.share, color: AppTheme.redAccent, size: 20),
                      Gap(AppSpacing.xs),
                      Text(
                        PlaybookStrings.gameCodeLabel,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Gap(AppSpacing.sm),
                  Text(
                    'ABC123',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.inactiveCard,
        layout: const ScenarioLayout.fixed(400, 120),
        child: Card(
          elevation: 0,
          color: AppTheme.darkCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.getBorderColor(true, opacity: 0.05), width: 0.5),
          ),
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.lg),
            child: Builder(
              builder: (BuildContext context) => Row(
                children: <Widget>[
                  Icon(Icons.person_outline, color: AppTheme.darkTextPrimary.withValues(alpha: 0.54), size: 32),
                  Gap(AppSpacing.md),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        PlaybookStrings.player2,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkTextPrimary.withValues(alpha: 0.54),
                        ),
                      ),
                      Gap(AppSpacing.xs / 2),
                      Text(
                        PlaybookStrings.waiting,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.darkTextPrimary.withValues(alpha: 0.38)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.infoCard,
        layout: const ScenarioLayout.fixed(400, 150),
        child: Card(
          color: AppTheme.darkCardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.getBorderColor(true)),
          ),
          child: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.lg),
            child: Builder(
              builder: (BuildContext context) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.info_outline, color: AppTheme.tealAccent, size: 24),
                      Gap(AppSpacing.sm),
                      Text(
                        PlaybookStrings.information,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Gap(AppSpacing.sm),
                  Text(PlaybookStrings.infoCardDesc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Story _gameIdFormatterStory() {
  return Story(
    PlaybookStrings.gameIdFormatter,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.formatterDemo,
        layout: const ScenarioLayout.fixed(400, 200),
        child: ThemedScaffold(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final controller = TextEditingController();
              const isDarkMode = true;
              final primaryColor = AppTheme.getPrimaryColor(isDarkMode);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    PlaybookStrings.gameIdFormatterTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(AppSpacing.md),
                  TextField(
                    controller: controller,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: PlaybookStrings.enterGameCode,
                      hintText: PlaybookStrings.typeExample,
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode.textColorHint(0.4)),
                      prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDarkMode.borderColor(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    inputFormatters: <TextInputFormatter>[GameIdTextFormatter()],
                    textCapitalization: TextCapitalization.characters,
                  ),
                  Gap(AppSpacing.md),
                  Text('${PlaybookStrings.formatted} ${controller.text}', style: Theme.of(context).textTheme.bodyMedium),
                  Gap(AppSpacing.xs),
                  Text(
                    PlaybookStrings.formatterDesc,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.darkTextPrimary.withValues(alpha: 0.54)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ],
  );
}

Story _joinGameSectionStory() {
  return Story(
    PlaybookStrings.joinGameSection,
    scenarios: <Scenario>[
      Scenario(
        PlaybookStrings.defaultState,
        layout: const ScenarioLayout.fixed(400, 350),
        child: ThemedScenario(
          isDarkMode: true,
          child: JoinGameSection(gameIdController: TextEditingController(), gameIdFocusNode: FocusNode(), onGameIdChanged: () {}),
        ),
      ),
      Scenario(
        PlaybookStrings.withValidGameId,
        layout: const ScenarioLayout.fixed(400, 350),
        child: ThemedScenario(
          isDarkMode: true,
          child: JoinGameSection(
            gameIdController: TextEditingController(text: 'ABCD23'),
            gameIdFocusNode: FocusNode(),
            onGameIdChanged: () {},
          ),
        ),
      ),
      Scenario(
        PlaybookStrings.lightMode,
        layout: const ScenarioLayout.fixed(400, 350),
        child: ThemedScenario(
          isDarkMode: false,
          child: JoinGameSection(gameIdController: TextEditingController(), gameIdFocusNode: FocusNode(), onGameIdChanged: () {}),
        ),
      ),
    ],
  );
}
