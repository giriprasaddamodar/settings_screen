import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../widgets/settings/profile_tile.dart';
import '../../widgets/settings/settings_header.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tiles.dart';
import 'settings_controller.dart';
import '../settings_wigets/theme_mode_screen.dart';
import '../settings_wigets/color_theme_screen.dart';
import '../settings_wigets/font_family_screen.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final SettingsController c = Get.find();
  String _version = "...";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  // -------------------------
  // LOAD VERSION
  // -------------------------
  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${info.version} (${info.buildNumber})";
    });
  }

  // -------------------------
  // OPEN URL
  // -------------------------
  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Unable to open link");
    }
  }

  // -------------------------
  // SHARE
  // -------------------------
  void _shareApp() {
    Share.share(
      "Check this app:\nhttps://play.google.com/store/apps/details?id=com.example.app",
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
              c.reset(); // clears SharedPreferences
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

  // -------------------------
  // LOGOUT
  // -------------------------
  void _logout() {
    // Example:
    // authController.logout();
    Get.snackbar("Logout", "User logged out");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Obx(() {
          if (!c.ready.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const SettingsHeader(),

              // =========================
              // PROFILE
              // =========================
              ProfileTile(
                name: "John",
                subtitle: "View profile",
                themeColor: Theme.of(context).colorScheme.primary,
                onTap: () {},
              ),

              const Divider(),

              // =========================
              // APPEARANCE
              // =========================
              const SettingsSection("Appearance"),

              NavTile(
                title: "Theme Mode",
                subtitle: c.themeMode.value.name.capitalizeFirst!,
                onTap: () => Get.to(() => ThemeModeScreen()),
              ),

              NavTile(
                title: "Color Theme",
                subtitle: c.colorKey.value.capitalizeFirst!,
                onTap: () => Get.to(() => ColorThemeScreen()),
              ),

              NavTile(
                title: "Font Family",
                subtitle: c.fontFamily.value,
                onTap: () => Get.to(() => FontFamilyScreen()),
              ),

              Obx(() => SwitchListTile(
                title: const Text("Notifications"),
                value: c.tempNotificationsEnabled.value,
                onChanged: c.updateTempNotifications,
              )),

              // =========================
              // ABOUT
              // =========================
              const SettingsSection("About"),

              SimpleTile(
                title: "About Us",
                onTap: () => _showTextDialog(
                  "About",
                  "Your app description goes here.",
                ),
              ),

              ListTile(
                title: const Text("Version"),
                subtitle: Text(_version),
              ),

              // =========================
              // SUPPORT
              // =========================
              const SettingsSection("Support"),

              IconTile(
                icon: Icons.share,
                title: "Share App",
                onTap: _shareApp,
              ),

              IconTile(
                icon: Icons.feedback_outlined,
                title: "Feedback",
                onTap: () => _openUrl("mailto:support@example.com"),
              ),

              IconTile(
                icon: Icons.star,
                title: "Rate Us",
                onTap: () => _openUrl(
                  "https://play.google.com/store/apps/details?id=com.example.app",
                ),
              ),

              // =========================
              // LEGAL
              // =========================
              const SettingsSection("Legal"),

              SimpleTile(
                title: "Privacy Policy",
                onTap: () => _showTextDialog(
                  "Privacy Policy",
                  "Add your privacy policy here.",
                ),
              ),

              SimpleTile(
                title: "Terms & Conditions",
                onTap: () => _showTextDialog(
                  "Terms & Conditions",
                  "Add your terms & conditions here.",
                ),
              ),

              SimpleTile(
                title: "Disclaimer",
                onTap: () => _showTextDialog(
                  "Disclaimer",
                  "Add your disclaimer here.",
                ),
              ),

              // =========================
              // SYSTEM
              // =========================
              const SettingsSection("System"),

              IconTile(
                icon: Icons.restore,
                title: "Reset Settings",
                onTap: _confirmReset,
              ),

              IconTile(
                icon: Icons.logout,
                title: "Logout",
                onTap: _logout,
              ),

              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }
}
