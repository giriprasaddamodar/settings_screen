import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_screen/widgets/preview_appbar.dart';

import '../../core/theme_manager.dart';
import '../settings/settings_controller.dart';

class ThemeModeScreen extends StatefulWidget {
  const ThemeModeScreen({super.key});

  @override
  State<ThemeModeScreen> createState() => _ThemeModeScreenState();
}

class _ThemeModeScreenState extends State<ThemeModeScreen> {
  final SettingsController c = Get.find<SettingsController>();

  /// Display name → actual ThemeMode
  final Map<String, ThemeMode> modes = const {
    "System": ThemeMode.system,
    "Light": ThemeMode.light,
    "Dark": ThemeMode.dark,
  };

  @override
  void initState() {
    super.initState();
    // ✅ Load real values into temp values ONCE
    c.startEditing();
  }

  /// 🔹 Preview color based on COLOR THEME (same as AppBar)
  Color get _previewColor {
    return c.tempColorKey.value == "black"
        ? Colors.black
        : ThemeManager.seedColor(c.tempColorKey.value);
  }

  /// 🔹 Text color for contrast (white works for all your themes)
  Color get _previewTextColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDarkPreview =
          c.tempThemeMode.value == ThemeMode.dark;

      final Color screenBg =
      isDarkPreview ? Colors.black : Colors.white;

      final Color screenText =
      isDarkPreview ? Colors.white : Colors.black;

      return Scaffold(
        backgroundColor: screenBg,

        ///  AppBar already reacts to tempColorKey internally
        appBar: const PreviewAppBar(title: "Theme Mode"),

        body: Column(
          children: [
            const SizedBox(height: 12),

            // // ================= PREVIEW TEXT =================
            // Padding(
            //   padding: const EdgeInsets.all(20),
            //   child: Text(
            //     "Theme preview text",
            //     style: TextStyle(
            //       fontSize: 18,
            //       color: screenText,
            //       fontFamily: c.tempFontFamily.value,
            //     ),
            //   ),
            // ),
            //
            // const Divider(),

            // ================= THEME MODE OPTIONS =================
            Expanded(
              child: ListView(
                children: modes.entries.map((e) {
                  return RadioListTile<ThemeMode>(
                    title: Text(
                      e.key,
                      style: TextStyle(color: screenText),
                    ),
                    value: e.value,
                    groupValue: c.tempThemeMode.value,
                    onChanged: (v) =>
                    c.tempThemeMode.value = v!,
                  );
                }).toList(),
              ),
            ),

            // ================= ACTION BUTTONS =================
            _actionButtons(),
          ],
        ),
      );
    });
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons() {
    final Color bgColor = _previewColor;
    final Color fgColor = _previewTextColor;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          /// CANCEL → discard preview changes
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                side: BorderSide(color: bgColor, width: 2),
              ),
              onPressed: () {
                c.cancelPreview(); // restore original values
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ),

          const SizedBox(width: 12),

          /// APPLY → commit preview changes
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor,
              ),
              onPressed: () {
                c.applyChanges(); // save temp → real
                Get.back();
              },
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}
