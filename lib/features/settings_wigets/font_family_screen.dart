import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme_manager.dart';
import '../settings/settings_controller.dart';

class FontFamilyScreen extends StatefulWidget {
  const FontFamilyScreen({super.key});

  @override
  State<FontFamilyScreen> createState() => _FontFamilyScreenState();
}

class _FontFamilyScreenState extends State<FontFamilyScreen> {

  /// Settings controller (single source of truth)
  final SettingsController c = Get.find<SettingsController>();

  /// Fonts exposed to user
  final List<String> fonts = const [
    "Roboto",
    "Poppins",
    "Inter",
    "Lato",
    "Nunito",
    "Merriweather",
  ];

  @override
  void initState() {
    super.initState();

    /// Load current saved values into TEMP variables
    /// so user can preview changes without applying
    c.startEditing();
  }

  /// Returns preview text style for each font
  /// Using switch keeps it readable & explicit
  TextStyle _fontStyle(String font) {
    const size = 18.0;

    switch (font) {
      case "Poppins":
        return GoogleFonts.poppins(fontSize: size);
      case "Inter":
        return GoogleFonts.inter(fontSize: size);
      case "Lato":
        return GoogleFonts.lato(fontSize: size);
      case "Nunito":
        return GoogleFonts.nunito(fontSize: size);
      case "Merriweather":
        return GoogleFonts.merriweather(fontSize: size);
      default:
        return GoogleFonts.roboto(fontSize: size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Font Family")),

      /// Obx rebuilds UI whenever tempFontFamily changes
      body: Obx(() {
        return Column(
          children: [

            const SizedBox(height: 12),

            /// 🔹 PREVIEW AREA
            /// Shows how the selected font looks before applying
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "The quick brown fox jumps over the lazy dog.",
                style: _fontStyle(c.tempFontFamily.value),
              ),
            ),

            const Divider(),

            /// 🔹 FONT SELECTION LIST
            Expanded(
              child: ListView.builder(
                itemCount: fonts.length,
                itemBuilder: (_, index) {
                  final font = fonts[index];

                  return ListTile(
                    title: Text(font, style: _fontStyle(font)),

                    /// Check icon shows currently selected TEMP font
                    trailing: c.tempFontFamily.value == font
                        ? Icon(Icons.check,
                        color: Get.theme.colorScheme.primary == Colors.black
                             ? Colors.white
                             : Get.theme.colorScheme.primary)
                        : null,

                    /// Updates TEMP value only (not saved yet)
                    onTap: () => c.updateTempFont(font),
                  );
                },
              ),
            ),

            /// 🔹 ACTION BUTTONS
            _actionButtons(),
          ],
        );
      }),
    );
  }

  /// Cancel / Apply buttons
  /// Kept separate to avoid cluttering build()
  Widget _actionButtons() {

    /// Resolve pure theme color (black is special case)
    final Color themeColor =
    c.tempColorKey.value == "black"
        ? Colors.black
        : ThemeManager.seedColor(c.tempColorKey.value);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          /// CANCEL → discard preview changes
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: themeColor, width: 2),
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                c.applyChanges();
                c.cancelPreview(); // revert temp values
                Get.back();
              },
              child: Text("Cancel",
                style: _fontStyle(c.tempFontFamily.value),),
            ),
          ),

          const SizedBox(width: 12),

          /// APPLY → commit preview changes permanently
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
               c.applyChanges(); // save temp → real values
                Get.back();
              },
              child: Text("Apply",
                style: _fontStyle(c.tempFontFamily.value),
              ),

            ),
          ),
        ],
      ),
    );
  }
}
