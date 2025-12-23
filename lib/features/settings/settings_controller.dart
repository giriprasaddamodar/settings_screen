import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../notification_service.dart';

class SettingsController extends GetxController {
  /// -------------------------------
  /// ACTUAL ACTIVE SETTINGS
  /// -------------------------------
  final themeMode = ThemeMode.system.obs;
  final fontFamily = "Roboto".obs;
  final colorKey = "blue".obs;
  final notificationsEnabled = true.obs;

  /// Indicates prefs are loaded
  final ready = false.obs;

  late SharedPreferences _prefs;

  /// -------------------------------
  /// TEMP / PREVIEW SETTINGS
  /// -------------------------------
  final tempThemeMode = ThemeMode.system.obs;
  final tempFontFamily = "Roboto".obs;
  final tempColorKey = "blue".obs;
  final tempNotificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  /// -------------------------------
  /// LOAD SAVED SETTINGS
  /// -------------------------------
  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    themeMode.value =
        _stringToTheme(_prefs.getString("theme_mode") ?? "system");
    fontFamily.value =
        _prefs.getString("font_family") ?? "Roboto";
    colorKey.value =
        _prefs.getString("color_key") ?? "blue";
    notificationsEnabled.value =
        _prefs.getBool("notifications_enabled") ?? true;

    _syncToTemp();
    ready.value = true;
  }

  /// -------------------------------
  /// SAVE SETTINGS
  /// -------------------------------
  Future<void> savePrefs() async {
    await _prefs.setString(
        "theme_mode", _themeToString(themeMode.value));
    await _prefs.setString("font_family", fontFamily.value);
    await _prefs.setString("color_key", colorKey.value);
    await _prefs.setBool(
        "notifications_enabled", notificationsEnabled.value);
  }

  /// -------------------------------
  /// APPLY PREVIEW → REAL
  /// -------------------------------
  Future<void> applyChanges() async {
    final bool wasEnabled = notificationsEnabled.value;

    themeMode.value = tempThemeMode.value;
    fontFamily.value = tempFontFamily.value;
    colorKey.value = tempColorKey.value;
    notificationsEnabled.value = tempNotificationsEnabled.value;

    //  NOTIFICATION LOGIC
    if (!wasEnabled && notificationsEnabled.value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        notificationsEnabled.value = false;
        tempNotificationsEnabled.value = false;
      }
    }

    if (wasEnabled && !notificationsEnabled.value) {
      await NotificationService.cancelAll();
    }

    await savePrefs();
  }


  /// -------------------------------
  /// PREVIEW CONTROL
  /// -------------------------------
  void startEditing() => _syncToTemp();

  void cancelPreview() => _syncToTemp();

  /// -------------------------------
  /// RESET TO DEFAULT
  /// -------------------------------
  Future<void> reset() async {
    await _prefs.clear();

    themeMode.value = ThemeMode.system;
    fontFamily.value = "Roboto";
    colorKey.value = "blue";
    notificationsEnabled.value = true;

    _syncToTemp();
  }

  /// -------------------------------
  /// TEMP UPDATERS (UI)
  /// -------------------------------
  void updateTempTheme(ThemeMode v) => tempThemeMode.value = v;
  void updateTempFont(String v) => tempFontFamily.value = v;
  void updateTempColor(String v) => tempColorKey.value = v;
  void updateTempNotifications(bool v) =>
      tempNotificationsEnabled.value = v;

  /// -------------------------------
  /// APP-WIDE TEXT THEME
  /// -------------------------------
  TextTheme get textTheme {
    switch (fontFamily.value) {
      case "Poppins":
        return GoogleFonts.poppinsTextTheme();
      case "Inter":
        return GoogleFonts.interTextTheme();
      case "Lato":
        return GoogleFonts.latoTextTheme();
      case "Nunito":
        return GoogleFonts.nunitoTextTheme();
      case "Merriweather":
        return GoogleFonts.merriweatherTextTheme();
      default:
        return GoogleFonts.robotoTextTheme();
    }
  }

  /// -------------------------------
  /// HELPERS
  /// -------------------------------
  void _syncToTemp() {
    tempThemeMode.value = themeMode.value;
    tempFontFamily.value = fontFamily.value;
    tempColorKey.value = colorKey.value;
    tempNotificationsEnabled.value = notificationsEnabled.value;
  }

  ThemeMode _stringToTheme(String v) {
    switch (v) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeToString(ThemeMode v) {
    switch (v) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }
}
