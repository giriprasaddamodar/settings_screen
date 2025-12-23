import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme_manager.dart';
import 'features/settings/settings_controller.dart';
import 'home/home_page.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  // Register SettingsController globally (used across the app)
  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();

    return Obx(() {
      if (!c.ready.value) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,

        // 🔥 THIS LINE IS THE KEY
        themeMode: c.themeMode.value,

        theme: ThemeManager.buildTheme(
          Brightness.light,
          MediaQuery.of(context).size.width > 600,
        ),

        darkTheme: ThemeManager.buildTheme(
          Brightness.dark,
          MediaQuery.of(context).size.width > 600,
        ),

        home: const RootLayout(),
      );
    });
  }
}
