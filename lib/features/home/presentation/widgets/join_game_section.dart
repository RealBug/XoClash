import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/formatters/game_id_formatter.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/home/presentation/widgets/join_game_error_widget.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class JoinGameSection extends ConsumerStatefulWidget {

  const JoinGameSection({
    super.key,
    required this.gameIdController,
    required this.gameIdFocusNode,
    required this.onGameIdChanged,
  });
  final TextEditingController gameIdController;
  final FocusNode gameIdFocusNode;
  final VoidCallback onGameIdChanged;

  @override
  ConsumerState<JoinGameSection> createState() => _JoinGameSectionState();
}

class _JoinGameSectionState extends ConsumerState<JoinGameSection> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final primaryColor = AppTheme.getPrimaryColor(isDarkMode);
    final joinGameState = ref.watch(joinGameUIStateProvider);

    return Container(
      padding: AppSpacing.paddingAll(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A1230).withValues(alpha: 0.7)
            : AppTheme.lightCardColor,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(
          color: AppTheme.getBorderColor(isDarkMode, opacity: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.qr_code_scanner,
                color: primaryColor,
                size: UIConstants.iconSizeMedium,
              ),
              Gap(AppSpacing.sm),
              Text(
                context.l10n.joinGame,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          Gap(AppSpacing.md),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.gameIdController,
            builder: (BuildContext context, TextEditingValue value, Widget? child) {
              final hasText = value.text.isNotEmpty;

              return TextField(
                controller: widget.gameIdController,
                focusNode: widget.gameIdFocusNode,
                decoration: InputDecoration(
                  labelText: context.l10n.enterGameCode,
                  hintText: context.l10n.enterGameCode,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode.textColorHint(0.4),
                      ),
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: primaryColor,
                  ),
                  suffixIcon: hasText
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDarkMode
                                .textColorHint(UIConstants.alphaVeryHigh),
                          ),
                          onPressed: _unfocusAndClearInput,
                        )
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(UIConstants.borderRadiusMedium),
                    borderSide: BorderSide(
                      color: AppTheme.getBorderColor(isDarkMode, opacity: 0.15),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(UIConstants.borderRadiusMedium),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(AppConstants.gameIdLength),
                  GameIdTextFormatter(),
                ],
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => widget.onGameIdChanged(),
              );
            },
          ),
          Gap(AppSpacing.md),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.gameIdController,
            builder: (BuildContext context, TextEditingValue value, Widget? child) {
              final hasText = value.text.isNotEmpty;
              final gameId = value.text.trim().toUpperCase();
              final validationError =
                  ref.read(validateGameIdUseCaseProvider).execute(gameId, context.l10n);
              final canJoin = hasText &&
                  validationError == null &&
                  !joinGameState.isLoading;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: canJoin
                      ? <BoxShadow>[
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: GameButton(
                  text: context.l10n.joinGame,
                  isLoading: joinGameState.isLoading,
                  onPressed: canJoin ? () => _handleJoinGame(gameId) : null,
                ),
              );
            },
          ),
          if (joinGameState.error != null) ...<Widget>[
            Gap(AppSpacing.sm),
            JoinGameErrorWidget(error: joinGameState.error!),
          ],
        ],
      ),
    );
  }

  void _unfocusAndClearInput() {
    widget.gameIdFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    widget.gameIdController.clear();
    widget.onGameIdChanged();
  }

  Future<void> _handleJoinGame(String gameId) async {
    _unfocusAndClearInput();

    final audioService = ref.read(audioServiceProvider);
    await audioService.playMoveSound();

    await ref.read(joinGameUIStateProvider.notifier).joinGame(gameId);

    if (!mounted) {
      return;
    }

    final joinGameState = ref.read(joinGameUIStateProvider);
    if (joinGameState.error == null) {
      navigate(ref, JoinGameCompleted());
    }
  }
}
