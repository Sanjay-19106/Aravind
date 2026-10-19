import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Monochrome Brutalist Palette
  static const Color background = Color(0xFF131313);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceLowest = Color(0xFF0E0E0E);
  static const Color surfaceLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceHigh = Color(0xFF2A2A2A);
  static const Color surfaceHighest = Color(0xFF353534);
  static const Color surfaceBright = Color(0xFF3A3939);

  // High contrast & Accents
  static const Color primary = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFF131313);
  static const Color secondary = Color(0xFFC7C6C6);
  static const Color outline = Color(0xFF8E9192);
  static const Color outlineVariant = Color(0xFF444748);
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFC4C7C8);

  // System Warning / Penalty Colors
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color hunterCyan = Color(0xFF00F0FF);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        error: error,
        outline: outline,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
          color: primary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
          color: onSurface,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: outline,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: outline,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: outline,
        ),
      ),
      dividerColor: surfaceHighest,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
