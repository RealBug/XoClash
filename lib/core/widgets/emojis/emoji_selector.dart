import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/emojis/emoji_section_widget.dart';

class EmojiSelector extends StatelessWidget {

  const EmojiSelector({
    super.key,
    required this.selectedXEmoji,
    required this.selectedOEmoji,
    required this.onEmojiSelected,
    this.isDarkMode = true,
  });
  final String? selectedXEmoji;
  final String? selectedOEmoji;
  final Function(String, bool) onEmojiSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        EmojiSectionWidget(
          isX: true,
          selectedEmoji: selectedXEmoji,
          otherPlayerEmoji: selectedOEmoji,
          color: AppTheme.redAccent,
          onSelected: (String emoji) => onEmojiSelected(emoji, true),
          isDarkMode: isDarkMode,
        ),
        Gap(AppSpacing.xl),
        EmojiSectionWidget(
          isX: false,
          selectedEmoji: selectedOEmoji,
          otherPlayerEmoji: selectedXEmoji,
          color: AppTheme.yellowAccent,
          onSelected: (String emoji) => onEmojiSelected(emoji, false),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}
