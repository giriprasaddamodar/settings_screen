import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme_manager.dart';
import '../settings/settings_controller.dart';

class ThemeModeScreen extends StatelessWidget {
  ThemeModeScreen({super.key});

  // Single source of truth for settings
  final SettingsController c = Get.find<SettingsController>();

  // Display name → actual ThemeMode
  final Map<String, ThemeMode> modes = const {
    "System": ThemeMode.system,
    "Light": ThemeMode.light,
    "Dark": ThemeMode.dark,
  };

  @override
  Widget build(BuildContext context) {
    // Load real values into temporary preview values
    // Called once when screen opens
    c.startEditing();

    return Scaffold(
      appBar: AppBar(title: const Text("Theme Mode")),

      // Obx rebuilds UI whenever tempThemeMode changes
      body: Obx(() {
        final bool isDarkPreview =
            c.tempThemeMode.value == ThemeMode.dark;

        return Column(
          children: [

            // ---------- PREVIEW ----------
            _previewBox(isDarkPreview),

            const Divider(),

            // ---------- OPTIONS ----------
            Expanded(child: _themeList()),

            // ---------- ACTION BUTTONS ----------
            _actionButtons(),
          ],
        );
      }),
    );
  }

  // ================= PREVIEW BOX =================
  Widget _previewBox(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),

      // Background switches based on selected preview mode
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      // Text color & font preview
      child: Text(
        "Theme preview text",
        style: TextStyle(
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black,
          fontFamily: c.tempFontFamily.value,
        ),
      ),
    );
  }

  // ================= THEME OPTIONS =================
  Widget _themeList() {
    return ListView(
      children: modes.entries.map((entry) {
        final bool selected =
            c.tempThemeMode.value == entry.value;

        return ListTile(
          title: Text(entry.key),

          // Show check icon for selected item


          trailing: selected
              ? Icon(
            Icons.check,
            color: Get.theme.colorScheme.primary == Colors.black
                ? Colors.white
                : Get.theme.colorScheme.primary,
          )
              : null,

          // Update temp value only (no real change yet)
          onTap: () => c.updateTempTheme(entry.value),
        );
      }).toList(),
    );
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons() {
    // Use pure color (Material2 style – no fading)
    final Color actionColor =
    c.tempColorKey.value == "black"
        ? Colors.black
        : ThemeManager.seedColor(c.tempColorKey.value);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          // -------- CANCEL --------
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: actionColor, width: 2),
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Revert temp values to actual saved values
                c.cancelPreview();
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ),

          const SizedBox(width: 12),

          // -------- APPLY --------
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Commit temp values to real settings
                c.applyChanges();
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
