import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme_manager.dart';      // Provides pure seed colors
import '../features/settings/settings_controller.dart';

class BottomNav extends StatelessWidget {
  /// Currently selected tab index
  final int currentIndex;

  /// Callback when user taps a bottom nav item
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get app settings (theme color selected by user)
    final SettingsController c = Get.find();

    return BottomNavigationBar(
      /// We use a pure color instead of Material3 faded colors
      backgroundColor: _navColor(c.colorKey.value),

      /// Which tab is active
      currentIndex: currentIndex,

      /// Notify parent when tab changes
      onTap: onTap,

      /// White looks best on strong colors & black theme
      selectedItemColor: Colors.white,

      /// Slightly faded for inactive items
      unselectedItemColor: Colors.white70,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
      ],
    );
  }

  /// Converts saved color key into an actual Color
  Color _navColor(String colorKey) {
    // Black theme should stay fully black
    if (colorKey == "black") return Colors.black;

    // Other colors come from ThemeManager
    return ThemeManager.seedColor(colorKey);
  }
}
