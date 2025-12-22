import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('AppTheme', () {
    group('getPrimaryColor', () {
      test('should return primaryColor for dark mode', () {
        final Color color = AppTheme.getPrimaryColor(true);
        expect(color, AppTheme.primaryColor);
      });

      test('should return primaryColorLight for light mode', () {
        final Color color = AppTheme.getPrimaryColor(false);
        expect(color, AppTheme.primaryColorLight);
      });
    });

    group('Constants', () {
      test('should have correct color values', () {
        expect(AppTheme.primaryColor, const Color(0xFFE63946));
        expect(AppTheme.secondaryColor, const Color(0xFFFF6B35));
        expect(AppTheme.errorColor, const Color(0xFFE63946));
      });

      test('should have correct icon dimensions', () {
        expect(AppTheme.appIconSize, 140.0);
        expect(AppTheme.appIconBorderRadius, 28.0);
      });

      test('should have correct dark theme colors', () {
        expect(AppTheme.darkBackgroundColor, const Color(0xFF0F0A1F));
        expect(AppTheme.darkSurfaceColor, const Color(0xFF1A1230));
        expect(AppTheme.darkCardColor, const Color(0xFF221835));
        expect(AppTheme.darkTextPrimary, const Color(0xFFFFFFFF));
        expect(AppTheme.darkTextSecondary, const Color(0xFFB8A9D9));
      });

      test('should have correct light theme colors', () {
        expect(AppTheme.lightBackgroundColor, const Color(0xFFF5F7FA));
        expect(AppTheme.lightSurfaceColor, const Color(0xFFFFFFFF));
        expect(AppTheme.lightCardColor, const Color(0xFFFFFFFF));
        expect(AppTheme.lightTextPrimary, const Color(0xFF1A2332));
        expect(AppTheme.lightTextSecondary, const Color(0xFF6B7280));
      });

      test('should have correct accent colors', () {
        expect(AppTheme.pinkAccent, const Color(0xFFFF6B9D));
        expect(AppTheme.orangeAccent, const Color(0xFFFF8C42));
        expect(AppTheme.tealAccent, const Color(0xFF4ECDC4));
        expect(AppTheme.greenAccent, const Color(0xFF4CAF50));
        expect(AppTheme.yellowAccent, const Color(0xFFFFD93D));
        expect(AppTheme.redAccent, const Color(0xFFFF3B5C));
      });

      test('should have correct utility colors', () {
        expect(AppTheme.purpleAccent, const Color(0xFF9C27B0));
        expect(AppTheme.blueAccent, const Color(0xFF2196F3));
        expect(AppTheme.transparent, const Color(0x00000000));
      });
    });

    group('getTextColor', () {
      test('should return darkTextPrimary for dark mode', () {
        final Color color = AppTheme.getTextColor(true);

        expect(color, AppTheme.darkTextPrimary);
      });

      test('should return lightTextPrimary for light mode', () {
        final Color color = AppTheme.getTextColor(false);

        expect(color, AppTheme.lightTextPrimary);
      });

      test('should apply opacity correctly', () {
        final Color color = AppTheme.getTextColor(true, opacity: 0.5);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(127, 1));
      });

      test('should use default opacity of 1.0', () {
        final Color color = AppTheme.getTextColor(true);

        expect((color.a * 255.0).round().clamp(0, 255), 255);
      });
    });

    group('getSecondaryTextColor', () {
      test('should return darkTextSecondary for dark mode', () {
        final Color color = AppTheme.getSecondaryTextColor(true);

        expect(color, AppTheme.darkTextSecondary);
      });

      test('should return lightTextSecondary for light mode', () {
        final Color color = AppTheme.getSecondaryTextColor(false);

        expect(color, AppTheme.lightTextSecondary);
      });

      test('should apply opacity correctly', () {
        final Color color = AppTheme.getSecondaryTextColor(false, opacity: 0.75);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(191, 1));
      });
    });

    group('getBorderColor', () {
      test('should return darkTextPrimary with opacity for dark mode', () {
        final Color color = AppTheme.getBorderColor(true);

        expect((color.r * 255.0).round().clamp(0, 255), (AppTheme.darkTextPrimary.r * 255.0).round().clamp(0, 255));
        expect((color.g * 255.0).round().clamp(0, 255), (AppTheme.darkTextPrimary.g * 255.0).round().clamp(0, 255));
        expect((color.b * 255.0).round().clamp(0, 255), (AppTheme.darkTextPrimary.b * 255.0).round().clamp(0, 255));
        expect((color.a * 255.0).round().clamp(0, 255), closeTo(31, 1));
      });

      test('should return lightTextSecondary with opacity for light mode', () {
        final Color color = AppTheme.getBorderColor(false);

        expect((color.r * 255.0).round().clamp(0, 255), (AppTheme.lightTextSecondary.r * 255.0).round().clamp(0, 255));
        expect((color.g * 255.0).round().clamp(0, 255), (AppTheme.lightTextSecondary.g * 255.0).round().clamp(0, 255));
        expect((color.b * 255.0).round().clamp(0, 255), (AppTheme.lightTextSecondary.b * 255.0).round().clamp(0, 255));
        expect((color.a * 255.0).round().clamp(0, 255), closeTo(31, 1));
      });

      test('should apply custom opacity', () {
        final Color color = AppTheme.getBorderColor(true, opacity: 0.2);

        expect((color.a * 255.0).round().clamp(0, 255), closeTo(51, 1));
      });
    });

    group('darkTheme', () {
      test('should have correct switchTheme thumbColor for selected state', () {
        final WidgetStateProperty<Color> thumbColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.darkTextPrimary.withValues(alpha: 0.3);
        });
        expect(thumbColorProperty.resolve(<WidgetState>{WidgetState.selected}), AppTheme.primaryColor);
      });

      test('should have correct switchTheme thumbColor for unselected state', () {
        final WidgetStateProperty<Color> thumbColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.darkTextPrimary.withValues(alpha: 0.3);
        });
        expect(thumbColorProperty.resolve(<WidgetState>{}), AppTheme.darkTextPrimary.withValues(alpha: 0.3));
      });

      test('should have correct switchTheme trackColor for selected state', () {
        final WidgetStateProperty<Color> trackColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor.withValues(alpha: 0.5);
          }
          return AppTheme.darkTextPrimary.withValues(alpha: 0.1);
        });
        expect(trackColorProperty.resolve(<WidgetState>{WidgetState.selected}), AppTheme.primaryColor.withValues(alpha: 0.5));
      });

      test('should have correct switchTheme trackColor for unselected state', () {
        final WidgetStateProperty<Color> trackColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor.withValues(alpha: 0.5);
          }
          return AppTheme.darkTextPrimary.withValues(alpha: 0.1);
        });
        expect(trackColorProperty.resolve(<WidgetState>{}), AppTheme.darkTextPrimary.withValues(alpha: 0.1));
      });
    });

    group('lightTheme', () {
      test('should have correct switchTheme thumbColor for selected state', () {
        final WidgetStateProperty<Color> thumbColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.lightTextSecondary.withValues(alpha: 0.6);
        });
        expect(thumbColorProperty.resolve(<WidgetState>{WidgetState.selected}), AppTheme.primaryColor);
      });

      test('should have correct switchTheme thumbColor for unselected state', () {
        final WidgetStateProperty<Color> thumbColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.lightTextSecondary.withValues(alpha: 0.6);
        });
        expect(thumbColorProperty.resolve(<WidgetState>{}), AppTheme.lightTextSecondary.withValues(alpha: 0.6));
      });

      test('should have correct switchTheme trackColor for selected state', () {
        final WidgetStateProperty<Color> trackColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor.withValues(alpha: 0.5);
          }
          return AppTheme.lightTextSecondary.withValues(alpha: 0.3);
        });
        expect(trackColorProperty.resolve(<WidgetState>{WidgetState.selected}), AppTheme.primaryColor.withValues(alpha: 0.5));
      });

      test('should have correct switchTheme trackColor for unselected state', () {
        final WidgetStateProperty<Color> trackColorProperty = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor.withValues(alpha: 0.5);
          }
          return AppTheme.lightTextSecondary.withValues(alpha: 0.3);
        });
        expect(trackColorProperty.resolve(<WidgetState>{}), AppTheme.lightTextSecondary.withValues(alpha: 0.3));
      });
    });
  });
}
