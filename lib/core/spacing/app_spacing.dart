import 'package:flutter/material.dart';
import 'package:tictac/core/constants/ui_constants.dart';

class AppSpacing {
  AppSpacing._();

  static double get xxs => UIConstants.spacingXSmall * 0.5;
  static double get xs => UIConstants.spacingXSmall;
  static double get sm => UIConstants.spacingSmall;
  static double get md => UIConstants.spacingMedium;
  static double get lg => UIConstants.spacingLarge;
  static double get xl => UIConstants.spacingXLarge;
  static double get xxl => UIConstants.spacingXXLarge;
  static double get xxxl => UIConstants.spacingHuge;

  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value);

  static EdgeInsets paddingSymmetric({
    double? horizontal,
    double? vertical,
  }) =>
      EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );

  static EdgeInsets paddingOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      EdgeInsets.only(
        top: top ?? 0,
        bottom: bottom ?? 0,
        left: left ?? 0,
        right: right ?? 0,
      );
}
