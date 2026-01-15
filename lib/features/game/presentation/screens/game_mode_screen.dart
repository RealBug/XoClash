import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart'
    show audioServiceProvider, navigate;
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/widgets/difficulty_option_card.dart';
import 'package:tictac/features/game/presentation/widgets/friend_form_section.dart';
import 'package:tictac/features/game/presentation/widgets/mode_option_card.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

enum GameMode { online, offlineFriend, offlineComputer }

@RoutePage()
class GameModeScreen extends ConsumerStatefulWidget {
  const GameModeScreen({super.key});

  @override
  ConsumerState<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends ConsumerState<GameModeScreen> {
  GameModeType? _selectedMode;
  int? _selectedDifficulty;
  final TextEditingController _friendNameController = TextEditingController();
  final FocusNode _friendNameFocusNode = FocusNode();
  String? _friendAvatar;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _localFriendKey = GlobalKey();
  final GlobalKey _computerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _friendNameController.addListener(() {
      setState(() {});
    });
  }

  void _handleModeSelection(GameModeType mode) {
    setState(() {
      _selectedMode = mode;
      if (mode != GameModeType.offlineComputer) {
        _selectedDifficulty = null;
      }
      if (mode != GameModeType.offlineFriend) {
        _friendNameController.clear();
        _friendAvatar = null;
      }
    });
  }

  void _scrollToKey(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || !_scrollController.hasClients) {
          return;
        }
        final RenderObject? renderObject = key.currentContext?.findRenderObject();
        if (renderObject is RenderBox) {
          final Offset position = renderObject.localToGlobal(Offset.zero);
          final double scrollPosition = _scrollController.offset + position.dy - 100;
          _scrollController.animateTo(
            scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = ref.watch(settingsValueProvider);
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    SystemUIHelper.setStatusBarStyle(context, isDarkMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () => navigate(ref, RequestBack()),
        ),
        title: Text(context.l10n.newGame),
        elevation: 0,
        backgroundColor: AppTheme.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppTheme.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      body: CosmicBackground(
        isDarkMode: isDarkMode,
        child: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.dragDetails != null) {
                FocusScope.of(context).unfocus();
              }
              return false;
            },
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
                            padding: AppSpacing.paddingAll(AppSpacing.lg),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  context.l10n.chooseGameMode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Gap(AppSpacing.xs),
                                Text(
                                  context.l10n.gameModeDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 13,
                                        color: isDarkMode
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary,
                                      ),
                                ),
                                Gap(AppSpacing.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ModeOptionCard(
                                      mode: GameModeType.online,
                                      icon: Icons.cloud,
                                      title: context.l10n.onlineMode,
                                      description: context.l10n.onlineModeDescription,
                                      isSelected: _selectedMode == GameModeType.online,
                                      isNotSelected: _selectedMode != null && _selectedMode != GameModeType.online,
                                      isDarkMode: isDarkMode,
                                      onTap: () => _handleModeSelection(GameModeType.online),
                                    ),
                                    ModeOptionCard(
                                      cardKey: _localFriendKey,
                                      mode: GameModeType.offlineFriend,
                                      icon: Icons.people,
                                      title: context.l10n.offlineFriendMode,
                                      description: context.l10n.offlineFriendModeDescription,
                                      isSelected: _selectedMode == GameModeType.offlineFriend,
                                      isNotSelected: _selectedMode != null && _selectedMode != GameModeType.offlineFriend,
                                      isDarkMode: isDarkMode,
                                      onTap: () {
                                        _handleModeSelection(GameModeType.offlineFriend);
                                        _scrollToKey(_localFriendKey);
                                      },
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: _selectedMode == GameModeType.offlineFriend
                                          ? FriendFormSection(
                                              nameController: _friendNameController,
                                              selectedAvatar: _friendAvatar,
                                              onAvatarSelected: (String? avatar) {
                                                setState(() {
                                                  _friendAvatar = avatar;
                                                });
                                              },
                                              settings: settings,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    ModeOptionCard(
                                      cardKey: _computerKey,
                                      mode: GameModeType.offlineComputer,
                                      icon: Icons.computer,
                                      title: context.l10n.offlineComputerMode,
                                      description: context.l10n.offlineComputerModeDescription,
                                      isSelected: _selectedMode == GameModeType.offlineComputer,
                                      isNotSelected: _selectedMode != null && _selectedMode != GameModeType.offlineComputer,
                                      isDarkMode: isDarkMode,
                                      onTap: () {
                                        _handleModeSelection(GameModeType.offlineComputer);
                                        _scrollToKey(_computerKey);
                                      },
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: _selectedMode == GameModeType.offlineComputer
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Gap(AppSpacing.sm),
                                                Padding(
                                                  padding: AppSpacing.paddingOnly(left: AppSpacing.xxs),
                                                  child: Text(
                                                    context.l10n.chooseDifficulty,
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                Gap(AppSpacing.xs),
                                                DifficultyOptionCard(
                                                  difficulty: 1,
                                                  isSelected: _selectedDifficulty == 1,
                                                  isDarkMode: isDarkMode,
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedDifficulty = 1;
                                                    });
                                                    _navigateToBoardSize();
                                                  },
                                                ),
                                                Gap(AppSpacing.xs),
                                                DifficultyOptionCard(
                                                  difficulty: 2,
                                                  isSelected: _selectedDifficulty == 2,
                                                  isDarkMode: isDarkMode,
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedDifficulty = 2;
                                                    });
                                                    _navigateToBoardSize();
                                                  },
                                                ),
                                                Gap(AppSpacing.xs),
                                                DifficultyOptionCard(
                                                  difficulty: 3,
                                                  isSelected: _selectedDifficulty == 3,
                                                  isDarkMode: isDarkMode,
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedDifficulty = 3;
                                                    });
                                                    _navigateToBoardSize();
                                                  },
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                                if (_selectedMode != null &&
                                    _selectedMode !=
                                        GameModeType.offlineComputer &&
                                    (_selectedMode == GameModeType.online ||
                                        (_selectedMode ==
                                                GameModeType.offlineFriend &&
                                            _friendNameController.text
                                                .trim()
                                                .isNotEmpty))) ...<Widget>[
                                  Gap(AppSpacing.md),
                                  GameButton(
                                    text: context.l10n.start,
                                    onPressed: () => _navigateToBoardSize(),
                                  ),
                                ],
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
      ),
    );
  }

  void _navigateToBoardSize() {
    if (_selectedMode == null) {
      return;
    }
    if (_selectedMode == GameModeType.offlineComputer &&
        _selectedDifficulty == null) {
      return;
    }
    if (_selectedMode == GameModeType.offlineFriend &&
        _friendNameController.text.trim().isEmpty) {
      return;
    }

    final AudioService audioService = ref.read(audioServiceProvider);
    audioService.playMoveSound();

    navigate(
      ref,
      GameModeSelected(
        mode: _selectedMode!,
        difficulty: _selectedDifficulty,
        friendName: _selectedMode == GameModeType.offlineFriend
            ? _friendNameController.text.trim()
            : null,
        friendAvatar:
            _selectedMode == GameModeType.offlineFriend ? _friendAvatar : null,
      ),
    );
  }

  @override
  void dispose() {
    _friendNameController.dispose();
    _friendNameFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
