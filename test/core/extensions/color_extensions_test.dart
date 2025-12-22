import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/theme/app_theme.dart';

void main() {
  group('ColorExtensions on bool', () {
    group('textColorSecondary', () {
      test('should return darkTextSecondary for true (dark mode)', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.textColorSecondary();

        expect(color, AppTheme.darkTextSecondary);
      });

      test('should return lightTextSecondary for false (light mode)', () {
        const bool isDarkMode = false;
        final Color color = isDarkMode.textColorSecondary();

        expect(color, AppTheme.lightTextSecondary);
      });

      test('should apply alpha value correctly', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.textColorSecondary(0.5);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(128, 1));
      });

      test('should use default alpha of 1.0 when not specified', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.textColorSecondary();

        expect((color.a * 255.0).round().clamp(0, 255), 255);
      });
    });

    group('textColorPrimary', () {
      test('should return darkTextPrimary for true (dark mode)', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.textColorPrimary();

        expect(color, AppTheme.darkTextPrimary);
      });

      test('should return lightTextPrimary for false (light mode)', () {
        const bool isDarkMode = false;
        final Color color = isDarkMode.textColorPrimary();

        expect(color, AppTheme.lightTextPrimary);
      });

      test('should apply alpha value correctly', () {
        const bool isDarkMode = false;
        final Color color = isDarkMode.textColorPrimary(0.75);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(191, 1));
      });
    });

    group('textColorHint', () {
      test('should return less opaque color than textColorSecondary for dark mode', () {
        const bool isDarkMode = true;
        final Color hintColor = isDarkMode.textColorHint();
        final Color secondaryColor = isDarkMode.textColorSecondary();

        expect((hintColor.a * 255.0).round(), lessThan((secondaryColor.a * 255.0).round()));
        expect((hintColor.r * 255.0).round(), (AppTheme.darkTextSecondary.r * 255.0).round());
      });

      test('should return less opaque color than textColorSecondary for light mode', () {
        const bool isDarkMode = false;
        final Color hintColor = isDarkMode.textColorHint();
        final Color secondaryColor = isDarkMode.textColorSecondary();

        expect((hintColor.a * 255.0).round(), lessThan((secondaryColor.a * 255.0).round()));
        expect((hintColor.r * 255.0).round(), (AppTheme.lightTextSecondary.r * 255.0).round());
      });

      test('should apply custom alpha with reduced opacity', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.textColorHint(0.5);
        final int expectedAlpha = (0.5 * 0.6 * 255.0).round();

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(expectedAlpha, 1));
      });
    });

    group('cardBackground', () {
      test('should return darkCardColor for true (dark mode)', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.cardBackground();

        expect(color, AppTheme.darkCardColor);
      });

      test('should return lightCardColor for false (light mode)', () {
        const bool isDarkMode = false;
        final Color color = isDarkMode.cardBackground();

        expect(color, AppTheme.lightCardColor);
      });

      test('should apply alpha value correctly', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.cardBackground(0.8);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(204, 1));
      });
    });

    group('borderColor', () {
      test('should return very transparent color for dark mode', () {
        const bool isDarkMode = true;
        final Color borderColor = isDarkMode.borderColor();
        final Color secondaryColor = isDarkMode.textColorSecondary();

        expect((borderColor.a * 255.0).round(), lessThan((secondaryColor.a * 255.0).round()));
        expect((borderColor.r * 255.0).round(), (AppTheme.darkTextSecondary.r * 255.0).round());
      });

      test('should return very transparent color for light mode', () {
        const bool isDarkMode = false;
        final Color borderColor = isDarkMode.borderColor();
        final Color secondaryColor = isDarkMode.textColorSecondary();

        expect((borderColor.a * 255.0).round(), lessThan((secondaryColor.a * 255.0).round()));
        expect((borderColor.r * 255.0).round(), (AppTheme.lightTextSecondary.r * 255.0).round());
      });

      test('should apply custom alpha with reduced opacity', () {
        const bool isDarkMode = true;
        final Color color = isDarkMode.borderColor(0.5);
        final int expectedAlpha = (0.5 * 0.2 * 255.0).round();

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(expectedAlpha, 1));
      });
    });
  });
}

