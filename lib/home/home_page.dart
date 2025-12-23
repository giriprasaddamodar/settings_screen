import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_screen/home/saved_page.dart';
import 'package:settings_screen/home/search_page.dart';
import '../widgets/bottom_nav.dart';
import '../features/settings/settings_drawer.dart';
import '../features/settings/settings_controller.dart';
import '../../core/theme_manager.dart';

/// Root layout of the app
/// Handles:
/// - AppBar
/// - Drawer
/// - Bottom Navigation
/// - Page switching
class RootLayout extends StatefulWidget {
  const RootLayout({super.key});

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  /// Index of selected bottom navigation item
  int index = 0;

  /// GetX controller that stores theme & app settings
  final SettingsController c = Get.find();

  /// Pages linked to bottom navigation tabs
  final List<Widget> pages = [
    HomeScreen(),
    SearchScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Top AppBar shown on all pages
      appBar: AppBar(
        title: Text(
          "Disease Dictionary",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,         // Ensures visibility on dark colors
            fontWeight: FontWeight.bold,
          ),
        ),

        /// AppBar color comes from user-selected theme color
        backgroundColor: _appBarColor(),

        /// Icon and text color inside AppBar
        foregroundColor: Colors.white,
      ),

      /// Settings drawer opened from left side
      drawer: const SettingsDrawer(),

      /// Displays current page based on bottom nav index
      body: pages[index],

      /// Bottom navigation used for page switching
      bottomNavigationBar: BottomNav(
        currentIndex: index,

        /// Updates page when user taps a tab
        onTap: (i) => setState(() => index = i),
      ),
    );
  }

  /// Returns pure AppBar color based on selected theme
  Color _appBarColor() {
    final colorKey = c.colorKey.value;

    /// Black theme uses true black
    if (colorKey == "black") return Colors.black;

    /// Other themes use their pure seed color
    return ThemeManager.seedColor(colorKey);
  }
}

/// Sample Home screen content
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          "Home Page Content Here",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
