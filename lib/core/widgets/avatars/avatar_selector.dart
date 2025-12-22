import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/avatars/avatar_option_widget.dart';

class AvatarSelector extends StatelessWidget {

  const AvatarSelector({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    required this.isDarkMode,
  });
  final String? selectedAvatar;
  final Function(String) onAvatarSelected;
  final bool isDarkMode;

  static const List<String> avatars = <String>[
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃',
    '😉',
    '😊',
    '😇',
    '🥰',
    '😍',
    '🤩',
    '😘',
    '😗',
    '😚',
    '😙',
    '😋',
    '😛',
    '😜',
    '🤪',
    '😝',
    '🤑',
    '🤗',
    '🤭',
    '🤫',
    '🤔',
    '🤐',
    '🤨',
    '😐',
    '😑',
    '😶',
    '😏',
    '😒',
    '🙄',
    '😬',
    '🤥',
    '😌',
    '😔',
    '😪',
    '🤤',
    '😴',
    '😷',
    '🤒',
    '🤕',
    '🤢',
    '🤮',
    '🤧',
    '🥵',
    '🥶',
    '😶‍🌫️',
    '😵',
    '😵‍💫',
    '🤯',
    '🤠',
    '🥳',
    '😎',
    '🤓',
    '🧐',
    '😕',
    '😟',
    '🙁',
    '☹️',
    '😮',
    '😯',
    '😲',
    '😳',
    '🥺',
    '😦',
    '😧',
    '😨',
    '😰',
    '😥',
    '😢',
    '😭',
    '😱',
    '😖',
    '😣',
    '😞',
    '😓',
    '😩',
    '😫',
    '🥱',
    '😤',
    '😡',
    '😠',
    '🤬',
    '😈',
    '👿',
    '💀',
    '☠️',
    '💩',
    '🤡',
    '👹',
    '👺',
    '👻',
    '👽',
    '👾',
    '🤖',
    '😺',
    '😸',
    '😹',
    '😻',
    '😼',
    '😽',
    '🙀',
    '😿',
    '😾',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.l10n.chooseAvatar,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Gap(AppSpacing.md),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double crossAxisSpacing = 8.0;
                const double mainAxisSpacing = 8.0;
                const double minCellSize = 50.0;

                final double availableWidth = constraints.maxWidth;
                final int crossAxisCount = ((availableWidth + crossAxisSpacing) /
                        (minCellSize + crossAxisSpacing))
                    .floor()
                    .clamp(6, 12);

                // Calculate the number of rows needed
                final int rowCount = (avatars.length / crossAxisCount).ceil();
                final double cellHeight =
                    (availableWidth / crossAxisCount) - crossAxisSpacing;
                final double totalHeight =
                    (rowCount * (cellHeight + mainAxisSpacing)) -
                        mainAxisSpacing;

                // Use available height if constrained, otherwise use calculated height
                // If maxHeight is infinite, use a reasonable default (e.g., 400px)
                final double maxHeight =
                    constraints.maxHeight.isFinite && constraints.maxHeight > 0
                        ? constraints.maxHeight -
                            100 // Reserve space for title and padding
                        : 400.0; // Default max height
                // Add extra space for bottom padding to prevent cropping
                const double bottomPadding = 16.0;
                final double gridHeight = totalHeight > maxHeight
                    ? maxHeight
                    : totalHeight +
                        bottomPadding; // Add padding to calculated height

                return SizedBox(
                  height: gridHeight,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: gridHeight < totalHeight
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        bottom:
                            bottomPadding), // Add bottom padding to prevent cropping
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
                    ),
                    itemCount: avatars.length,
                    itemBuilder: (BuildContext context, int index) {
                      final avatar = avatars[index];
                      final isSelected = selectedAvatar == avatar;
                      return AvatarOptionWidget(
                        avatar: avatar,
                        isSelected: isSelected,
                        onTap: () => onAvatarSelected(avatar),
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
