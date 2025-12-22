import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/emojis/emoji_categories.dart';

class EmojiSectionWidget extends StatelessWidget {
  const EmojiSectionWidget({
    super.key,
    required this.isX,
    required this.selectedEmoji,
    required this.otherPlayerEmoji,
    required this.color,
    required this.onSelected,
    this.isDarkMode = true,
  });
  final bool isX;
  final String? selectedEmoji;
  final String? otherPlayerEmoji;
  final Color color;
  final Function(String) onSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isX ? context.l10n.emojiX : context.l10n.emojiO,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Gap(AppSpacing.sm),
        ...EmojiCategories.all(context).map((EmojiCategory category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(category.icon, style: Theme.of(context).textTheme.titleLarge),
                    Gap(AppSpacing.xs),
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppTheme.darkTextPrimary.withValues(alpha: 0.8)
                            : AppTheme.lightTextPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.xs),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: category.emojis.map((String emoji) {
                    final isSelected = selectedEmoji == emoji;
                    final isDisabled = otherPlayerEmoji != null && otherPlayerEmoji == emoji && !isSelected;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isDisabled ? null : () => onSelected(emoji),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.3)
                                : isDisabled
                                ? (isDarkMode ? AppTheme.darkCardColor.withValues(alpha: 0.3) : AppTheme.lightSurfaceColor)
                                : (isDarkMode
                                      ? AppTheme.darkCardColor.withValues(alpha: 0.5)
                                      : AppTheme.lightSurfaceColor.withValues(alpha: 0.8)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? color : AppTheme.getBorderColor(isDarkMode, opacity: 0.1),
                              width: isSelected ? 3.0 : 1,
                            ),
                            boxShadow: isSelected
                                ? <BoxShadow>[BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)]
                                : null,
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: isDisabled ? 0.3 : 1.0,
                              child: Text(emoji, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: isSelected ? 26 : 24)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
