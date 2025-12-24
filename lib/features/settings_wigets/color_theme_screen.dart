import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme_manager.dart';
import '../../widgets/preview_appbar.dart';
import '../settings/settings_controller.dart';

class ColorThemeScreen extends StatefulWidget {
  const ColorThemeScreen({super.key});

  @override
  State<ColorThemeScreen> createState() => _ColorThemeScreenState();
}

class _ColorThemeScreenState extends State<ColorThemeScreen> {
  final SettingsController c = Get.find();

  @override
  void initState() {
    super.initState();

    //  SAFE: runs once, outside build
    c.startEditing();
  }


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
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Color previewColor = _currentColor;

      return Scaffold(
        appBar: const PreviewAppBar(title: "Color Theme"),

        body: Column(
          children: [
            const SizedBox(height: 10),

            // ================= PREVIEW BOX =================
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: c.tempColorKey.value == "black"
                    ? Colors.black
                    : previewColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Color Preview",
                style: TextStyle(
                  fontFamily: c.tempFontFamily.value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.tempColorKey.value == "black"
                      ? Colors.white
                      : previewColor,
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
                    title: Text(entry.key.capitalizeFirst!),
                    trailing: c.tempColorKey.value == entry.key
                        ? Icon(
                      Icons.check,
                      color: entry.key == "black"
                          ? Colors.white
                          : entry.value,
                    )
                        : null,
                    onTap: () => c.updateTempColor(entry.key),
                  );
                }).toList(),
              ),
            ),

            _actionButtons(previewColor),
          ],
        ),
      );
    });
  }

  // ================= COMMON COLOR GETTER =================
  // Keeps color logic in one place
  Color get _currentColor {
    return c.tempColorKey.value == "black"
        ? Colors.black
        : ThemeManager.seedColor(c.tempColorKey.value);
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons(Color previewColor) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: previewColor, width: 2),
                backgroundColor: previewColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                c.cancelPreview();
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: previewColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
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
