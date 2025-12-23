import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme_manager.dart';
import '../settings/settings_controller.dart';

class ColorThemeScreen extends StatelessWidget {
  ColorThemeScreen({super.key});

  // SettingsController holds actual + temp (preview) values
  final SettingsController c = Get.find<SettingsController>();

  // Centralized list of selectable colors (key used for storage)
  final Map<String, Color> colors = {
    "blue": Colors.blue,
    "green": Colors.green,
    "purple": Colors.purple,
    "orange": Colors.orange,
    "pink": Colors.pink,
    "teal": Colors.teal,
    "amber": Colors.amber,
    "indigo": Colors.indigo,
    "red": Colors.red,
    "brown": Colors.brown,
    "black": Colors.black,
  };

  @override
  Widget build(BuildContext context) {
    // Load current saved settings into temp variables for preview
    c.startEditing();

    return Scaffold(
      appBar: AppBar(title: const Text("Color Theme")),

      // Obx rebuilds UI automatically when tempColorKey changes
      body: Obx(() {
        final Color selectedColor = _currentColor;

        return Column(
          children: [
            const SizedBox(height: 10),

            // ================= PREVIEW BOX =================
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),

              // Light background preview for colors, full black for black theme
              decoration: BoxDecoration(
                color: c.tempColorKey.value == "black"
                    ? Colors.black
                    : selectedColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),

              // Shows live preview text style
              child: Text(
                "Color Preview",
                style: TextStyle(
                  fontFamily: c.tempFontFamily.value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  c.tempColorKey.value == "black"
                      ? Colors.white
                      : selectedColor,
                ),
              ),
            ),

            const Divider(),

            // ================= COLOR LIST =================
            Expanded(
              child: ListView(
                children: colors.entries.map((entry) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.value,
                    ),

                    // Capitalize label for UI clarity
                    title: Text(entry.key.capitalizeFirst!),


                    // Tick shows which color is currently selected
                    trailing: c.tempColorKey.value == entry.key
                        ? Icon(
                      Icons.check,
                      color: entry.key == "black"
                          ? Colors.white   //  contrast
                          : entry.value,
                    )
                        : null,


                    // Updates only temp value (preview)
                    onTap: () => c.updateTempColor(entry.key),
                  );
                }).toList(),
              ),
            ),

            _actionButtons(),
          ],
        );
      }),
    );
  }

  // ================= COMMON COLOR GETTER =================
  // Keeps color logic in one place
  Color get _currentColor {
    return c.tempColorKey.value == "black"
        ? Colors.black
        : ThemeManager.seedColor(c.tempColorKey.value);
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons() {
    final Color btnColor = _currentColor;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Cancel → revert temp changes
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: btnColor, width: 2),
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                c.cancelPreview(); // restore original value
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ),

          const SizedBox(width: 12),

          // Apply → save temp value permanently
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                c.applyChanges(); // commit changes
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
