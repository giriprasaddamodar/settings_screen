import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme_manager.dart';
import '../features/settings/settings_controller.dart';

class PreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TextStyle? style;
  const PreviewAppBar({super.key, required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();

    return Obx(() {
      final bg = ThemeManager.previewColor(
        c.tempColorKey.value,
        dark: Theme.of(context).brightness == Brightness.dark,
      );

      return AppBar(
        title: Text(title),
        backgroundColor: bg,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
