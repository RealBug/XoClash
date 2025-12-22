import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/buttons/tab_button_widget.dart';
import 'package:tictac/core/widgets/emojis/emoji_selector.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class SymbolsDialog extends ConsumerWidget {

  const SymbolsDialog({
    super.key,
    required this.settings,
    required this.settingsNotifier,
  });
  final Settings settings;
  final SettingsNotifier settingsNotifier;

  static void show(BuildContext context, WidgetRef ref, Settings settings, SettingsNotifier settingsNotifier) {
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.symbolsXAndO,
      isDarkMode: settings.isDarkMode,
      child: SymbolsDialog(
        settings: settings,
        settingsNotifier: settingsNotifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Settings updatedSettings = ref.watch(settingsValueProvider);
    final bool useEmojis = updatedSettings.useEmojis;
    
    final SymbolShape? localXShape = (updatedSettings.xEmoji == null || updatedSettings.xEmoji!.isEmpty)
        ? SymbolShapeExtension.fromStringOrDefault(updatedSettings.xShape)
        : null;
    final SymbolShape? localOShape = (updatedSettings.oEmoji == null || updatedSettings.oEmoji!.isEmpty)
        ? SymbolShapeExtension.fromStringOrDefault(updatedSettings.oShape)
        : null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TabButtonWidget(
                  label: context.l10n.shapes,
                  isSelected: !useEmojis,
                  isDarkMode: updatedSettings.isDarkMode,
                  onTap: () {
                    settingsNotifier.setUseEmojis(false);
                  },
                ),
              ),
              Gap(AppSpacing.xs),
              Expanded(
                child: TabButtonWidget(
                  label: context.l10n.emojis,
                  isSelected: useEmojis,
                  isDarkMode: updatedSettings.isDarkMode,
                  onTap: () {
                    settingsNotifier.setUseEmojis(true);
                  },
                ),
              ),
            ],
          ),
          Gap(AppSpacing.md),
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: AppSpacing.paddingAll(AppSpacing.md),
                child: useEmojis
                    ? EmojiSelector(
                        selectedXEmoji: (updatedSettings.xEmoji != null && updatedSettings.xEmoji!.isNotEmpty)
                            ? updatedSettings.xEmoji
                            : null,
                        selectedOEmoji: (updatedSettings.oEmoji != null && updatedSettings.oEmoji!.isNotEmpty)
                            ? updatedSettings.oEmoji
                            : null,
                        isDarkMode: updatedSettings.isDarkMode,
                        onEmojiSelected: (String emoji, bool isX) {
                          if (isX) {
                            settingsNotifier.setXEmoji(emoji);
                          } else {
                            settingsNotifier.setOEmoji(emoji);
                          }
                          // Ensure we stay on the emojis tab
                          if (!updatedSettings.useEmojis) {
                            settingsNotifier.setUseEmojis(true);
                          }
                        },
                      )
                    : ShapeSelector(
                        selectedXShape: localXShape,
                        selectedOShape: localOShape,
                        isDarkMode: updatedSettings.isDarkMode,
                        onShapeSelected: (SymbolShape shape, bool isX) {
                          if (isX) {
                            settingsNotifier.setXShapeAndClearEmoji(shape.name);
                          } else {
                            settingsNotifier.setOShapeAndClearEmoji(shape.name);
                          }
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

