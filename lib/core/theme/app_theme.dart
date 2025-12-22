import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFFE63946);
  static const Color primaryColorLight = Color(0xFFE63946);
  static const Color secondaryColor = Color(0xFFFF6B35);
  static const Color errorColor = Color(0xFFE63946);

  static const double appIconSize = 140.0;
  static const double appIconBorderRadius = 28.0;

  static const Color darkBackgroundColor = Color(0xFF0F0A1F);
  static const Color darkSurfaceColor = Color(0xFF1A1230);
  static const Color darkCardColor = Color(0xFF221835);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB8A9D9);

  static const Color lightBackgroundColor = Color(0xFFF5F7FA);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A2332);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static const Color pinkAccent = Color(0xFFFF6B9D);
  static const Color orangeAccent = Color(0xFFFF8C42);
  static const Color tealAccent = Color(0xFF4ECDC4);
  static const Color greenAccent = Color(0xFF4CAF50);
  static const Color yellowAccent = Color(0xFFFFD93D);
  static const Color redAccent = Color(0xFFFF3B5C);

  // Utility colors for borders, overlays, etc.
  static const Color purpleAccent = Color(0xFF9C27B0);
  static const Color blueAccent = Color(0xFF2196F3);
  static const Color transparent = Color(0x00000000);

  static Color getPrimaryColor(bool isDarkMode) {
    return isDarkMode ? primaryColor : primaryColorLight;
  }

  static Color getTextColor(bool isDarkMode, {double opacity = 1.0}) {
    return isDarkMode
        ? darkTextPrimary.withValues(alpha: opacity)
        : lightTextPrimary.withValues(alpha: opacity);
  }

  static Color getSecondaryTextColor(bool isDarkMode, {double opacity = 1.0}) {
    return isDarkMode
        ? darkTextSecondary.withValues(alpha: opacity)
        : lightTextSecondary.withValues(alpha: opacity);
  }

  static Color getBorderColor(bool isDarkMode, {double opacity = 0.12}) {
    return isDarkMode
        ? darkTextPrimary.withValues(alpha: opacity)
        : lightTextSecondary.withValues(alpha: opacity);
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurfaceColor,
        error: errorColor,
        onPrimary: darkBackgroundColor,
        onSecondary: darkTextPrimary,
        onError: darkTextPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: darkTextPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: darkTextPrimary,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: darkTextPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: darkTextPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: darkTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: darkTextSecondary,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackgroundColor.withValues(alpha: 0.0),
        elevation: 0,
        surfaceTintColor: darkBackgroundColor.withValues(alpha: 0.0),
        iconTheme: const IconThemeData(color: darkTextPrimary),
        titleTextStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: darkBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkSurfaceColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: darkTextSecondary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return darkTextPrimary.withValues(alpha: 0.3);
        }),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return darkTextPrimary.withValues(alpha: 0.1);
        }),
        overlayColor:
            WidgetStateProperty.all(darkBackgroundColor.withValues(alpha: 0.0)),
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        trackOutlineColor:
            WidgetStateProperty.all(darkBackgroundColor.withValues(alpha: 0.0)),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        onPrimary: lightBackgroundColor,
        onSecondary: lightTextPrimary,
        onSurface: lightTextPrimary,
        onError: lightTextPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: lightTextPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: lightTextPrimary,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: lightTextPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: lightTextPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: lightTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: lightTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: lightTextSecondary,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackgroundColor.withValues(alpha: 0.0),
        elevation: 0,
        surfaceTintColor: lightBackgroundColor.withValues(alpha: 0.0),
        iconTheme: const IconThemeData(color: lightTextPrimary),
        titleTextStyle: const TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 1,
        shadowColor: lightTextSecondary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: lightBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: lightTextSecondary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return lightTextSecondary.withValues(alpha: 0.6);
        }),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return lightTextSecondary.withValues(alpha: 0.3);
        }),
        overlayColor:
            WidgetStateProperty.all(darkBackgroundColor.withValues(alpha: 0.0)),
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        trackOutlineColor:
            WidgetStateProperty.all(darkBackgroundColor.withValues(alpha: 0.0)),
      ),
    );
  }
}
