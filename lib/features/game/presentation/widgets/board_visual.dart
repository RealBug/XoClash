import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/presentation/widgets/board_visual_cell.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class BoardVisual extends ConsumerWidget {

  const BoardVisual({
    super.key,
    required this.size,
    required this.isSelected,
  });
  final int size;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    const availableSize = 32.0;
    const padding = 4.0;

    final spacing = size == 3
        ? 1.0
        : size == 4
            ? 0.8
            : 0.6;

    return Container(
      width: availableSize,
      height: availableSize,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF2C1B58)
            : AppTheme.lightBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final maxSize = constraints.maxWidth;
          final adjustedCellSize =
              (maxSize - (spacing * (size - 1) * 2)) / size;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(size, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(size, (col) {
                  return BoardVisualCell(
                    size: adjustedCellSize,
                    spacing: spacing,
                    isSelected: isSelected,
                    isDarkMode: isDarkMode,
                    isLastInRow: col == size - 1,
                    isLastInColumn: row == size - 1,
                  );
                }),
              );
            }),
          );
        },
      ),
    );
  }
}
