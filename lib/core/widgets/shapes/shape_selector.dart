import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/shapes/shape_section_widget.dart';

enum SymbolShape {
  classic,
  rounded,
  bold,
  outline,
}

extension SymbolShapeExtension on SymbolShape {
  static final Map<String, SymbolShape> _nameMap = <String, SymbolShape>{
    for (final SymbolShape shape in SymbolShape.values) shape.name: shape,
  };

  static SymbolShape? fromString(String? name) {
    if (name == null) {
      return null;
    }
    return _nameMap[name];
  }

  static SymbolShape fromStringOrDefault(String? name, [SymbolShape defaultValue = SymbolShape.classic]) {
    return fromString(name) ?? defaultValue;
  }
}

class ShapeSelector extends StatelessWidget {

  const ShapeSelector({
    super.key,
    required this.selectedXShape,
    required this.selectedOShape,
    required this.onShapeSelected,
    this.isDarkMode = true,
  });
  final SymbolShape? selectedXShape;
  final SymbolShape? selectedOShape;
  final Function(SymbolShape, bool) onShapeSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShapeSectionWidget(
          isX: true,
          selectedShape: selectedXShape,
          color: AppTheme.redAccent,
          onSelected: (SymbolShape shape) => onShapeSelected(shape, true),
          isDarkMode: isDarkMode,
        ),
        Gap(AppSpacing.xl),
        ShapeSectionWidget(
          isX: false,
          selectedShape: selectedOShape,
          color: AppTheme.yellowAccent,
          onSelected: (SymbolShape shape) => onShapeSelected(shape, false),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}
