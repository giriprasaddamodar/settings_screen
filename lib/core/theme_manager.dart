import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/settings/settings_controller.dart';

class ThemeManager {

  /// Builds the full app theme based on:
  /// - system brightness
  /// - user-selected color
  /// - user-selected font
  static ThemeData buildTheme(Brightness brightness, bool tablet) {

    // Access settings stored using GetX
    final c = Get.find<SettingsController>();

    // Check if app is in dark mode
    final bool isDark = brightness == Brightness.dark;

    // Allow black theme ONLY in dark mode
    final bool isBlack = c.colorKey.value == "black" && isDark;

    final Color primaryColor = isBlack
        ? Colors.black
        : seedColor(c.colorKey.value); // blue, red, etc

    // Decide seed color
    final Color resolvedSeedColor =
    isBlack ? Colors.black : _seedFromKey(c.colorKey.value);

    // Base theme without colors/fonts
    final ThemeData baseTheme = ThemeData(
      useMaterial3: false, // M2 gives solid colors (no pastel fade)
      brightness: brightness,
    );

    // Apply Google font selected by user
    final TextTheme fontTheme =
    _applyFont(c.fontFamily.value, baseTheme.textTheme);

    // Fix text colors based on mode
    final TextTheme textTheme =
    _fixTextColors(fontTheme, isDark || isBlack);

    // -------------------------------------------------
    // ✅ ONLY FIX: prevent black → pink in LIGHT MODE
    // -------------------------------------------------
    final ColorScheme scheme =
    (c.colorKey.value == "black" && !isDark)
        ? const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    )
        : isBlack
        ? _blackScheme()
        : ColorScheme.fromSeed(
      seedColor: resolvedSeedColor,
      brightness: brightness,
    );

    // Final theme
    return baseTheme.copyWith(
      colorScheme: scheme,
      textTheme: textTheme,

      // Screen background
      scaffoldBackgroundColor:
      isBlack ? Colors.black : baseTheme.scaffoldBackgroundColor,

      // AppBar styling
      appBarTheme: AppBarTheme(
        backgroundColor: resolvedSeedColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: resolvedSeedColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }

  // -------------------- COLOR SCHEMES --------------------

  /// Pure black color scheme (OLED friendly)
  static ColorScheme _blackScheme() {
    return const ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.black,
      surface: Colors.black,
      background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    );
  }

  /// Converts stored color key into actual Color
  static Color _seedFromKey(String key) {
    const map = {
      "blue": Colors.blue,
      "green": Colors.green,
      "purple": Colors.purple,
      "orange": Colors.orange,
      "pink": Colors.pink,
      "teal": Colors.teal,
      "amber": Colors.amber,
      "indigo": Colors.indigo,
      "brown": Colors.brown,
      "red": Colors.red,
      "black": Colors.black,
    };

    return map[key] ?? Colors.blue;
  }

  static Color seedColor(String key) {
    switch (key) {
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "purple":
        return Colors.purple;
      case "orange":
        return Colors.orange;
      case "pink":
        return Colors.pink;
      case "teal":
        return Colors.teal;
      case "amber":
        return Colors.amber;
      case "indigo":
        return Colors.indigo;
      case "red":
        return Colors.red;
      case "brown":
        return Colors.brown;
      case "black":
        return Colors.black;
      default:
        return Colors.blue; // fallback safety
    }
  }

  // -------------------- TEXT & FONTS --------------------

  /// Applies Google Font based on user selection
  static TextTheme _applyFont(String font, TextTheme base) {
    switch (font) {
      case "Poppins":
        return GoogleFonts.poppinsTextTheme(base);
      case "Inter":
        return GoogleFonts.interTextTheme(base);
      case "Lato":
        return GoogleFonts.latoTextTheme(base);
      case "Nunito":
        return GoogleFonts.nunitoTextTheme(base);
      case "Merriweather":
        return GoogleFonts.merriweatherTextTheme(base);
      default:
        return GoogleFonts.robotoTextTheme(base);
    }
  }

  /// Forces all text colors to white (dark) or black (light)
  static TextTheme _fixTextColors(TextTheme base, bool whiteText) {
    final Color color = whiteText ? Colors.white : Colors.black87;

    TextStyle? apply(TextStyle? s) =>
        s == null ? null : s.copyWith(color: color);

    return base.copyWith(
      displayLarge: apply(base.displayLarge),
      displayMedium: apply(base.displayMedium),
      displaySmall: apply(base.displaySmall),
      headlineLarge: apply(base.headlineLarge),
      headlineMedium: apply(base.headlineMedium),
      headlineSmall: apply(base.headlineSmall),
      titleLarge: apply(base.titleLarge),
      titleMedium: apply(base.titleMedium),
      titleSmall: apply(base.titleSmall),
      bodyLarge: apply(base.bodyLarge),
      bodyMedium: apply(base.bodyMedium),
      bodySmall: apply(base.bodySmall),
      labelLarge: apply(base.labelLarge),
      labelMedium: apply(base.labelMedium),
      labelSmall: apply(base.labelSmall),
    );
  }
}
