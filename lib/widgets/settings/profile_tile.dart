import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  final Color themeColor; // ✅ ADD THIS

  const ProfileTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.onTap,
    required this.themeColor, // ✅ REQUIRE IT
  });

  Color readableOn(Color bg) {
    return bg.computeLuminance() < 0.5
        ? Colors.white
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: themeColor,
        foregroundColor: readableOn(themeColor), // ✅ auto contrast
        child: const Icon(Icons.person),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
