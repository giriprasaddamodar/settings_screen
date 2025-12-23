// Settings drawer UI
// ----------------------------------------------------
// PURPOSE:
// - Only displays settings options
// - Does NOT directly apply theme / font / color changes
// - Each option navigates to its own settings screen
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Individual setting screens
import '../settings_wigets/theme_mode_screen.dart';
import '../settings_wigets/color_theme_screen.dart';
import '../settings_wigets/font_family_screen.dart';

// Controller that holds app settings (GetX)
import 'settings_controller.dart';

// Extra packages for app info & sharing
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  // GetX controller gives access to stored settings
  final SettingsController c = Get.find<SettingsController>();

  // App version text (loaded asynchronously)
  String _version = "...";

  @override
  void initState() {
    super.initState();
    _loadVersion(); // Load version once when drawer opens
  }

  // -------------------------
  // LOAD APP VERSION
  // -------------------------
  // WHY:
  // - package_info_plus gives version & build number
  // - shown in "About" section
  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = "${info.version} (${info.buildNumber})";
      });
    } catch (_) {
      _version = "Unknown";
    }
  }

  // -------------------------
  // OPEN EXTERNAL LINKS
  // -------------------------
  // WHY:
  // - used for Play Store, feedback email, etc.
  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Unable to open link");
    }
  }

  // -------------------------
  // SHARE APP
  // -------------------------
  // WHY:
  // - share_plus opens native share sheet
  void _shareApp() {
    Share.share(
      "Check this app:\nhttps://play.google.com/store/apps/details?id=com.example.app",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Obx(() {
          // WHY:
          // - Wait until SharedPreferences are loaded
          // - Prevents showing wrong default values
          if (!c.ready.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _header(context),

              _section("Appearance"),

              _navTile(
                title: "Theme Mode",
                subtitle: c.themeMode.value.name.capitalizeFirst!,
                onTap: () => Get.to(() => ThemeModeScreen()),
              ),

              _navTile(
                title: "Color Theme",
                subtitle: c.colorKey.value.capitalizeFirst!,
                onTap: () => Get.to(() => ColorThemeScreen()),
              ),

              _navTile(
                title: "Font Family",
                subtitle: c.fontFamily.value,
                onTap: () => Get.to(() => FontFamilyScreen()),
              ),

              // WHY SwitchListTile:
              // - inline toggle (no separate screen needed)
              Obx(() => SwitchListTile(
                title: const Text("Notifications"),
                value: c.tempNotificationsEnabled.value, // ✅ TEMP value
                onChanged: c.updateTempNotifications,     // ✅ TEMP updater
              )),


              _section("About"),

              _simpleTile(
                title: "About App",
                onTap: () => _showTextDialog(
                  "About",
                  "Your app description goes here.",
                ),
              ),

              ListTile(
                title: const Text("Version"),
                subtitle: Text(_version),
              ),

              _section("Support"),

              _iconTile(
                icon: Icons.share,
                title: "Share App",
                onTap: _shareApp,
              ),

              _iconTile(
                icon: Icons.star,
                title: "Rate Us",
                onTap: () => _openUrl(
                  "https://play.google.com/store/apps/details?id=com.example.app",
                ),
              ),

              _iconTile(
                icon: Icons.feedback_outlined,
                title: "Feedback",
                onTap: () => _openUrl("mailto:support@example.com"),
              ),

              _section("Legal"),

              _simpleTile(
                title: "Terms & Conditions",
                onTap: () => _showTextDialog(
                  "Terms & Conditions",
                  "Add your terms here.",
                ),
              ),

              _simpleTile(
                title: "Disclaimer",
                onTap: () => _showTextDialog(
                  "Disclaimer",
                  "Add your disclaimer here.",
                ),
              ),

              _section("System"),

              _iconTile(
                icon: Icons.restore,
                title: "Reset Settings",
                onTap: _confirmReset,
              ),

              _iconTile(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {},
              ),

              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }

  // -------------------------
  // REUSABLE UI HELPERS
  // -------------------------

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        "Settings",
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _navTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _simpleTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _iconTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // -------------------------
  // RESET CONFIRMATION
  // -------------------------
  void _confirmReset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reset Settings"),
        content: const Text("Reset all settings to default values?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              c.reset(); // Controller resets SharedPreferences
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // SIMPLE TEXT DIALOG
  // -------------------------
  void _showTextDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
